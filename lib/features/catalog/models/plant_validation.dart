import 'plant.dart';

/// Pemeriksaan cepat di UI; server tetap menjadi sumber validasi akhir.
Map<String, String> validatePlantInput(Map<String, dynamic> values) {
  final errors = <String, String>{};
  final name = (values['name'] as String? ?? '').trim();
  if (name.isEmpty) {
    errors['name'] = 'Nama tanaman wajib diisi.';
  } else if (name.length > 200) {
    errors['name'] = 'Nama tanaman maksimal 200 karakter.';
  }
  if (!plantCategories.containsKey(values['category'])) {
    errors['category'] = 'Pilih kategori tanaman.';
  }
  if (!plantSpaces.containsKey(values['space_needed'])) {
    errors['space_needed'] = 'Pilih kebutuhan ruang.';
  }
  if ((values['scientific_name'] as String? ?? '').length > 200) {
    errors['scientific_name'] = 'Nama ilmiah maksimal 200 karakter.';
  }
  if (values['supports_soil'] != true &&
      values['supports_hydroponic'] != true) {
    errors['__all__'] = 'Pilih minimal satu media tanam.';
  }
  final image = (values['image_url'] as String? ?? '').trim();
  final uri = Uri.tryParse(image);
  if (image.isNotEmpty &&
      (image.length > 2048 ||
          uri == null ||
          !['http', 'https'].contains(uri.scheme) ||
          uri.host.isEmpty)) {
    errors['image_url'] = 'Masukkan URL gambar http atau https yang valid.';
  }
  final numbers = <String, double>{};
  for (final field in plantClimateLabels.keys) {
    final text = (values[field]?.toString() ?? '').trim();
    if (text.isEmpty) continue;
    final value = double.tryParse(text.replaceAll(',', '.'));
    if (value == null || !value.isFinite) {
      errors[field] = 'Masukkan angka yang valid.';
    } else {
      numbers[field] = value;
      if (field.startsWith('humidity') && (value < 0 || value > 100)) {
        errors[field] = 'Kelembapan harus 0 sampai 100 persen.';
      }
      if (field.startsWith('rainfall') && value < 0) {
        errors[field] = 'Curah hujan tidak boleh negatif.';
      }
    }
  }
  for (final prefix in ['temp', 'humidity', 'rainfall']) {
    final minimum = numbers['${prefix}_min'];
    final maximum = numbers['${prefix}_max'];
    if (minimum != null && maximum != null && minimum > maximum) {
      errors['${prefix}_max'] =
          'Maksimum tidak boleh lebih kecil dari minimum.';
    }
  }
  return errors;
}

Map<String, dynamic> plantInputPayload(Map<String, dynamic> values) => {
  for (final entry in values.entries)
    entry.key: plantClimateLabels.containsKey(entry.key)
        ? (entry.value == null || entry.value.toString().trim().isEmpty
              ? null
              : double.parse(
                  entry.value.toString().trim().replaceAll(',', '.'),
                ))
        : entry.value is String
        ? (entry.value as String).trim()
        : entry.value,
};
