import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanem_mobile/app/routes.dart';
import 'package:nanem_mobile/core/theme/app_theme.dart';
import 'package:nanem_mobile/features/catalog/models/plant.dart';
import 'package:nanem_mobile/features/catalog/screens/manage_plants_page.dart';
import 'package:nanem_mobile/features/catalog/screens/plant_form_page.dart';
import 'package:nanem_mobile/features/catalog/service/catalog_service.dart';
import 'package:nanem_mobile/features/catalog/widgets/catalog_widgets.dart';

import 'catalog_test_support.dart';

void main() {
  late FakeCatalogService service;
  setUp(() => service = FakeCatalogService());

  Future<void> viewport(WidgetTester tester, {double width = 390}) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> openForm(WidgetTester tester, {int? id}) async {
    await viewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<bool>(
                  builder: (_) => PlantFormPage(plantId: id, service: service),
                ),
              ),
              child: const Text('Buka form'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka form'));
    await tester.pumpAndSettle();
  }

  Finder textInput(String field) => find.descendant(
    of: find.byKey(ValueKey(field)),
    matching: find.byType(TextField),
  );

  Future<void> select(WidgetTester tester, String label, String choice) async {
    final field = find.descendant(
      of: find.byWidgetPredicate(
        (widget) => widget is PlantSelect && widget.label == label,
      ),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.tap(field);
    await tester.pumpAndSettle();
    await tester.tap(find.text(choice).last);
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan tanaman'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan tanaman'));
    await tester.pumpAndSettle();
  }

  Future<void> openManage(WidgetTester tester) async {
    await viewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ManagePlantsPage(service: service),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Empty create form shows required errors without sending a request',
    (tester) async {
      await openForm(tester);
      await submit(tester);
      expect(find.text('Nama tanaman wajib diisi.'), findsOneWidget);
      expect(find.text('Pilih kategori tanaman.'), findsOneWidget);
      expect(find.text('Pilih kebutuhan ruang.'), findsOneWidget);
      expect(service.saves, isEmpty);
    },
  );

  testWidgets(
    'Create sends selections, list and explicit unknown values then returns',
    (tester) async {
      await openForm(tester);
      await tester.enterText(textInput('name'), 'Pakcoy');
      await select(tester, 'Kategori', 'Sayur');
      await select(tester, 'Kebutuhan ruang', 'Kecil');
      await submit(tester);
      expect(service.saves, hasLength(1));
      final payload = service.saves.single.$1;
      expect(payload['name'], 'Pakcoy');
      expect(payload['category'], 'sayur');
      expect(payload['space_needed'], 'small');
      expect(payload['sunlight'], isEmpty);
      expect(payload['indoor'], isNull);
      expect(payload['humidity_min'], isNull);
      expect(payload, isNot(contains('perenual_id')));
      expect(find.byType(PlantFormPage), findsNothing);
    },
  );

  testWidgets(
    'Edit preloads data and does not erase optional unknown or sunlight',
    (tester) async {
      await openForm(tester, id: 7);
      expect(
        tester.widget<TextField>(textInput('name')).controller!.text,
        'Kangkung',
      );
      await tester.enterText(textInput('name'), 'Kangkung Hijau');
      await submit(tester);
      expect(service.saves.single.$2, 7);
      final payload = service.saves.single.$1;
      expect(payload['sunlight'], ['full_sun', 'partial_shade']);
      expect(payload['temp_min'], 18.0);
      expect(payload['indoor'], isNull);
      expect(payload['humidity_min'], isNull);
    },
  );

  testWidgets(
    'Server field errors stay on the form and preserve entered data',
    (tester) async {
      service.onSave = (_, _) async => throw const CatalogApiException(
        'Periksa kembali data tanaman.',
        statusCode: 400,
        fields: {
          'name': ['Nama sudah digunakan.'],
        },
      );
      await openForm(tester, id: 7);
      await submit(tester);
      expect(find.text('Nama sudah digunakan.'), findsOneWidget);
      expect(
        tester.widget<TextField>(textInput('name')).controller!.text,
        'Kangkung',
      );
      expect(find.byType(PlantFormPage), findsOneWidget);
    },
  );

  testWidgets('Invalid percentage is blocked before save', (tester) async {
    await openForm(tester, id: 7);
    await tester.ensureVisible(textInput('humidity_max'));
    await tester.pumpAndSettle();
    await tester.enterText(textInput('humidity_max'), '101');
    await submit(tester);
    expect(service.saves, isEmpty);
    expect(find.text('Kelembapan harus 0 sampai 100 persen.'), findsOneWidget);
  });

  testWidgets('A missing edit target never displays an empty editable form', (
    tester,
  ) async {
    service.onDetail = (_) async => throw const CatalogApiException(
      'Data tanaman tidak ditemukan.',
      statusCode: 404,
    );
    await openForm(tester, id: 7);
    expect(find.text('Data tanaman tidak ditemukan.'), findsOneWidget);
    expect(find.text('Simpan tanaman'), findsNothing);
  });

  testWidgets('Canceling deletion never calls DELETE', (tester) async {
    await openManage(tester);
    final delete = find.byKey(const ValueKey('delete-7'));
    await tester.ensureVisible(delete);
    await tester.pumpAndSettle();
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(service.deletes, isEmpty);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(service.deletes, isEmpty);
  });

  testWidgets('Confirmed deletion reloads the last page safely', (
    tester,
  ) async {
    var deleted = false;
    service.onList = (_, page) async => PlantPage(
      count: deleted ? 6 : 7,
      results: deleted
          ? const [
              Plant(
                id: 8,
                name: 'Mint',
                category: 'herbal',
                spaceNeeded: 'small',
              ),
            ]
          : const [testPlant],
      next: !deleted && page == 1 ? '?page=2' : null,
      previous: page == 2 ? '?page=1' : null,
    );
    service.onDelete = (_) async {
      deleted = true;
    };
    await openManage(tester);
    await tester.ensureVisible(find.text('Berikutnya'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Berikutnya'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('delete-7')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('delete-7')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, hapus'));
    await tester.pumpAndSettle();
    expect(service.deletes, [7]);
    expect(service.lists.last.$2, 1);
    expect(find.text('Mint'), findsOneWidget);
  });

  testWidgets(
    'Editing from management passes the ID and reloads the changed plant',
    (tester) async {
      var current = testPlant;
      service.onList = (_, _) async => PlantPage(count: 1, results: [current]);
      service.onSave = (values, id) async {
        current = Plant.fromJson({'id': id!, ...values});
        return current;
      };
      await viewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: ManagePlantsPage(service: service),
          onGenerateRoute: (settings) => MaterialPageRoute<bool>(
            settings: settings,
            builder: (_) => PlantFormPage(
              plantId: settings.arguments as int?,
              service: service,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('edit-7')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('edit-7')));
      await tester.pumpAndSettle();
      await tester.enterText(textInput('name'), 'Kangkung Hijau');
      await submit(tester);
      expect(service.saves.single.$2, 7);
      expect(service.lists.length, greaterThanOrEqualTo(2));
      expect(find.text('Kangkung Hijau'), findsOneWidget);
      expect(find.byType(PlantFormPage), findsNothing);
    },
  );

  testWidgets('Team route guard still protects admin screens from guests', (
    tester,
  ) async {
    await viewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        onGenerateRoute: Routes.onGenerateRoute,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(Routes.adminPlants),
              child: const Text('Buka kelola'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka kelola'));
    await tester.pumpAndSettle();
    expect(find.text('Masuk dulu, ya'), findsOneWidget);
    expect(find.text('Tambah tanaman'), findsNothing);
  });
}
