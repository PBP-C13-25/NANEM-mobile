const plantCategories = {
  'sayur': 'Sayur',
  'buah': 'Buah',
  'herbal': 'Herbal',
  'hias': 'Hias',
};
const plantSpaces = {'small': 'Kecil', 'medium': 'Sedang', 'large': 'Besar'};
const plantSunlight = {
  'full_sun': 'Matahari penuh',
  'partial_shade': 'Teduh sebagian',
  'shade': 'Teduh',
};
const plantWatering = {
  'Minimum': 'Jarang',
  'Average': 'Sedang',
  'Frequent': 'Sering',
};
const plantCareLevels = {'Low': 'Mudah', 'Medium': 'Sedang', 'High': 'Sulit'};
const plantClimateLabels = {
  'temp_min': 'Suhu minimum (°C)',
  'temp_max': 'Suhu maksimum (°C)',
  'humidity_min': 'Kelembapan minimum (%)',
  'humidity_max': 'Kelembapan maksimum (%)',
  'rainfall_min': 'Curah hujan minimum (mm/hari)',
  'rainfall_max': 'Curah hujan maksimum (mm/hari)',
};

class Plant {
  const Plant({
    required this.id,
    required this.name,
    required this.category,
    required this.spaceNeeded,
    this.scientificName = '',
    this.description = '',
    this.imageUrl = '',
    this.supportsSoil = true,
    this.supportsHydroponic = false,
    this.sunlight = const [],
    this.watering = '',
    this.careLevel = '',
    this.indoor,
    this.droughtTolerant,
    this.tempMin,
    this.tempMax,
    this.humidityMin,
    this.humidityMax,
    this.rainfallMin,
    this.rainfallMax,
  });

  final int id;
  final String name,
      scientificName,
      description,
      imageUrl,
      category,
      spaceNeeded;
  final bool supportsSoil, supportsHydroponic;
  final List<String> sunlight;
  final String watering, careLevel;
  final bool? indoor, droughtTolerant;
  final double? tempMin,
      tempMax,
      humidityMin,
      humidityMax,
      rainfallMin,
      rainfallMax;

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
    id: json['id'] as int,
    name: json['name'] as String,
    scientificName: json['scientific_name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    imageUrl: json['image_url'] as String? ?? '',
    category: json['category'] as String,
    spaceNeeded: json['space_needed'] as String,
    supportsSoil: json['supports_soil'] as bool,
    supportsHydroponic: json['supports_hydroponic'] as bool,
    sunlight: List<String>.from(json['sunlight'] as List? ?? []),
    watering: json['watering'] as String? ?? '',
    careLevel: json['care_level'] as String? ?? '',
    indoor: json['indoor'] as bool?,
    droughtTolerant: json['drought_tolerant'] as bool?,
    tempMin: (json['temp_min'] as num?)?.toDouble(),
    tempMax: (json['temp_max'] as num?)?.toDouble(),
    humidityMin: (json['humidity_min'] as num?)?.toDouble(),
    humidityMax: (json['humidity_max'] as num?)?.toDouble(),
    rainfallMin: (json['rainfall_min'] as num?)?.toDouble(),
    rainfallMax: (json['rainfall_max'] as num?)?.toDouble(),
  );

  String get categoryLabel => plantCategories[category] ?? category;
  String get spaceLabel => plantSpaces[spaceNeeded] ?? 'Belum diketahui';
  String get mediaLabel => [
    if (supportsSoil) 'Tanah',
    if (supportsHydroponic) 'Hidroponik',
  ].join(', ');
  String get sunlightLabel => sunlight.isEmpty
      ? 'Belum diketahui'
      : sunlight.map((value) => plantSunlight[value] ?? value).join(', ');
  String get careLabel => plantCareLevels[careLevel] ?? 'Belum diketahui';

  /// Hanya field yang dapat dikelola; ID sumber dan timestamp tidak dikirim.
  Map<String, dynamic> toFormData() => {
    'name': name,
    'scientific_name': scientificName,
    'description': description,
    'image_url': imageUrl,
    'category': category,
    'space_needed': spaceNeeded,
    'supports_soil': supportsSoil,
    'supports_hydroponic': supportsHydroponic,
    'sunlight': List<String>.of(sunlight),
    'watering': watering,
    'care_level': careLevel,
    'indoor': indoor,
    'drought_tolerant': droughtTolerant,
    'temp_min': tempMin,
    'temp_max': tempMax,
    'humidity_min': humidityMin,
    'humidity_max': humidityMax,
    'rainfall_min': rainfallMin,
    'rainfall_max': rainfallMax,
  };
}

class PlantPage {
  const PlantPage({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  final int count;
  final List<Plant> results;
  final String? next, previous;

  factory PlantPage.fromJson(Map<String, dynamic> json) => PlantPage(
    count: json['count'] as int,
    next: json['next'] as String?,
    previous: json['previous'] as String?,
    results: (json['results'] as List)
        .map((row) => Plant.fromJson(row as Map<String, dynamic>))
        .toList(),
  );
}

String plantBooleanLabel(bool? value) => switch (value) {
  true => 'Ya',
  false => 'Tidak',
  null => 'Belum diketahui',
};

String plantRangeLabel(double? minimum, double? maximum, String unit) {
  String number(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
  if (minimum == null && maximum == null) return 'Belum diketahui';
  if (minimum == null) return 'Maksimum ${number(maximum!)} $unit';
  if (maximum == null) return 'Minimum ${number(minimum)} $unit';
  return '${number(minimum)}–${number(maximum)} $unit';
}
