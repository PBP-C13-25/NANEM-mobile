import 'package:flutter_test/flutter_test.dart';
import 'package:nanem_mobile/features/catalog/models/plant_validation.dart';

import 'catalog_test_support.dart';

void main() {
  test('Optional unknown data is valid and remains null in the payload', () {
    final input = testPlant.toFormData();
    expect(validatePlantInput(input), isEmpty);
    final payload = plantInputPayload({
      ...input,
      'humidity_min': '',
      'temp_min': '18,5',
    });
    expect(payload['humidity_min'], isNull);
    expect(payload['temp_min'], 18.5);
    expect(payload['indoor'], isNull);
    expect(payload, isNot(contains('id')));
  });

  test('Required fields and unsupported empty media are rejected', () {
    final errors = validatePlantInput({
      ...testPlant.toFormData(),
      'name': ' ',
      'category': '',
      'space_needed': '',
      'supports_soil': false,
      'supports_hydroponic': false,
    });
    expect(
      errors.keys,
      containsAll(['name', 'category', 'space_needed', '__all__']),
    );
  });

  test('Range, percentage, rainfall and non-finite numeric validation', () {
    for (final entry in <(Map<String, dynamic>, String)>[
      ({'temp_min': 35, 'temp_max': 20}, 'temp_max'),
      ({'humidity_min': -1}, 'humidity_min'),
      ({'humidity_max': 101}, 'humidity_max'),
      ({'humidity_min': 80, 'humidity_max': 50}, 'humidity_max'),
      ({'rainfall_min': -1}, 'rainfall_min'),
      ({'rainfall_min': 5, 'rainfall_max': 2}, 'rainfall_max'),
      ({'temp_min': 'abc'}, 'temp_min'),
      ({'temp_min': 'NaN'}, 'temp_min'),
      ({'temp_min': 'Infinity'}, 'temp_min'),
      ({'image_url': 'javascript:alert(1)'}, 'image_url'),
    ]) {
      expect(
        validatePlantInput({...testPlant.toFormData(), ...entry.$1}),
        contains(entry.$2),
      );
    }
  });
}
