import 'package:flutter_test/flutter_test.dart';
import 'package:nanem_mobile/features/catalog/models/plant.dart';

void main() {
  final json = <String, dynamic>{
    'id': 7,
    'name': 'Kangkung',
    'category': 'sayur',
    'space_needed': 'small',
    'supports_soil': true,
    'supports_hydroponic': false,
    'sunlight': ['full_sun', 'partial_shade'],
    'temp_min': 18,
    'temp_max': 30.5,
    'indoor': null,
    'drought_tolerant': false,
  };

  test('JSON numbers, nullable booleans and sunlight retain their meaning', () {
    final plant = Plant.fromJson(json);
    expect(plant.tempMin, 18.0);
    expect(plant.tempMax, 30.5);
    expect(plant.indoor, isNull);
    expect(plant.droughtTolerant, false);
    expect(plant.sunlight, ['full_sun', 'partial_shade']);
    expect(plant.categoryLabel, 'Sayur');
    expect(plant.mediaLabel, 'Tanah');
  });

  test(
    'Form data preserves missing values and excludes server-owned fields',
    () {
      final values = Plant.fromJson({...json, 'perenual_id': 123}).toFormData();
      expect(values['humidity_min'], isNull);
      expect(values['indoor'], isNull);
      expect(values['drought_tolerant'], false);
      expect(values, isNot(contains('id')));
      expect(values, isNot(contains('perenual_id')));
      expect(values, isNot(contains('created_at')));
    },
  );

  test('Pagination uses the DRF results envelope', () {
    final page = PlantPage.fromJson({
      'count': 51,
      'next': '/api/plants/?page=2',
      'previous': null,
      'results': [json],
    });
    expect(page.count, 51);
    expect(page.next, isNotNull);
    expect(page.previous, isNull);
    expect(page.results.single.id, 7);
  });

  test(
    'Unknown and one-sided ranges are not turned into invented intervals',
    () {
      expect(plantRangeLabel(null, null, '°C'), 'Belum diketahui');
      expect(plantRangeLabel(18, null, '°C'), 'Minimum 18 °C');
      expect(plantRangeLabel(null, 30, '°C'), 'Maksimum 30 °C');
      expect(plantRangeLabel(18, 30.5, '°C'), '18–30.5 °C');
      expect(plantBooleanLabel(false), 'Tidak');
      expect(plantBooleanLabel(null), 'Belum diketahui');
    },
  );
}
