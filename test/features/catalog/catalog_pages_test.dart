import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanem_mobile/core/theme/app_theme.dart';
import 'package:nanem_mobile/core/widgets/widgets.dart';
import 'package:nanem_mobile/features/catalog/models/plant.dart';
import 'package:nanem_mobile/features/catalog/screens/catalog_page.dart';
import 'package:nanem_mobile/features/catalog/screens/plant_detail_page.dart';
import 'package:nanem_mobile/features/catalog/service/catalog_service.dart';
import 'package:nanem_mobile/features/guide/widgets/guide_section.dart';

import 'catalog_test_support.dart';

void main() {
  late FakeCatalogService service;
  setUp(() => service = FakeCatalogService());

  Future<void> open(
    WidgetTester tester,
    Widget page, {
    double width = 390,
    double scale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: page,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
    );
  }

  testWidgets('Loading becomes a plant card with image fallback', (
    tester,
  ) async {
    final pending = Completer<PlantPage>();
    service.onList = (_, _) => pending.future;
    await open(tester, CatalogPage(service: service));
    expect(find.byType(AppSpinner), findsOneWidget);
    pending.complete(const PlantPage(count: 1, results: [testPlant]));
    await tester.pumpAndSettle();
    expect(find.text('Kangkung'), findsOneWidget);
    expect(find.text('Gambar belum tersedia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Search is debounced and category remains in the request', (
    tester,
  ) async {
    await open(tester, CatalogPage(service: service));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Sayur'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  kangkung  ');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    expect(service.lists.last.$1['q'], 'kangkung');
    expect(service.lists.last.$1['category'], 'sayur');
    expect(service.lists.last.$2, 1);
  });

  testWidgets('Bottom sheet applies media filter with existing category', (
    tester,
  ) async {
    await open(tester, CatalogPage(service: service));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Sayur'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filter & urutan'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hidroponik').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terapkan filter'));
    await tester.pumpAndSettle();
    expect(service.lists.last.$1['medium'], 'hydroponic');
    expect(service.lists.last.$1['category'], 'sayur');
  });

  testWidgets('Pagination sends the next page and search parameters', (
    tester,
  ) async {
    service.onList = (_, page) async => PlantPage(
      count: 7,
      results: const [testPlant],
      next: page == 1 ? '?page=2' : null,
      previous: page == 2 ? '?page=1' : null,
    );
    await open(tester, CatalogPage(service: service));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'kangkung');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Berikutnya'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Berikutnya'));
    await tester.pumpAndSettle();
    expect(service.lists.last.$2, 2);
    expect(service.lists.last.$1['q'], 'kangkung');
    expect(find.text('Halaman 2'), findsOneWidget);
  });

  testWidgets('Empty results and failed requests have different states', (
    tester,
  ) async {
    service.onList = (_, _) async => const PlantPage(count: 0, results: []);
    await open(tester, CatalogPage(service: service));
    await tester.pumpAndSettle();
    expect(find.text('Tanaman tidak ditemukan'), findsOneWidget);
    service.onList = (_, _) async =>
        throw const CatalogApiException('Koneksi terputus.');
    await tester.tap(find.text('Atur ulang'));
    await tester.pumpAndSettle();
    expect(find.text('Data belum bisa dimuat'), findsOneWidget);
    service.onList = null;
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Kangkung'), findsOneWidget);
  });

  testWidgets('Detail passes the actual plant ID into Nicholas guide section', (
    tester,
  ) async {
    await open(tester, PlantDetailPage(plantId: 7, service: service));
    await tester.pumpAndSettle();
    expect(find.text('Kangkung'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(GuideSection),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.widget<GuideSection>(find.byType(GuideSection)).plantId, 7);
    expect(tester.takeException(), isNull);
  });

  testWidgets('A deleted plant shows a clear 404 instead of a blank detail', (
    tester,
  ) async {
    service.onDetail = (_) async =>
        throw const CatalogApiException('Missing', statusCode: 404);
    await open(tester, PlantDetailPage(plantId: 7, service: service));
    await tester.pumpAndSettle();
    expect(find.text('Tanaman tidak ditemukan'), findsOneWidget);
    expect(find.byType(GuideSection), findsNothing);
  });

  testWidgets('Narrow catalog with larger text does not overflow', (
    tester,
  ) async {
    await open(tester, CatalogPage(service: service), width: 320, scale: 1.5);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Berikutnya'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
