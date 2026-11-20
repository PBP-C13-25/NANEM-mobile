const Map<String, String> wateringChoices = {
  'daily': 'Setiap hari',
  'every_2_3_days': '2-3 hari sekali',
  'weekly': 'Seminggu sekali',
  'biweekly': 'Dua minggu sekali',
  'when_dry': 'Saat media bagian atas kering',
};

const Map<String, String> fertilizingChoices = {
  'weekly': 'Seminggu sekali',
  'biweekly': 'Dua minggu sekali',
  'monthly': 'Sebulan sekali',
  'every_3_months': 'Tiga bulan sekali',
  'as_needed': 'Sesuai fase tumbuh',
  'none': 'Tidak perlu rutin',
};

class CultivationGuide {
  const CultivationGuide({
    required this.id,
    required this.steps,
    required this.wateringFrequency,
    required this.wateringLabel,
    required this.wateringNote,
    required this.fertilizingFrequency,
    required this.fertilizingLabel,
    required this.fertilizingNote,
    required this.isHarvestable,
    required this.harvestDaysMin,
    required this.harvestDaysMax,
    required this.harvestLabel,
    required this.harvestNote,
  });

  final int id;
  final List<String> steps;
  final String wateringFrequency;
  final String wateringLabel;
  final String wateringNote;
  final String fertilizingFrequency;
  final String fertilizingLabel;
  final String fertilizingNote;
  final bool isHarvestable;
  final int? harvestDaysMin;
  final int? harvestDaysMax;
  final String harvestLabel;
  final String harvestNote;

  factory CultivationGuide.fromJson(Map<String, dynamic> json) => CultivationGuide(
        id: json['id'] as int,
        steps: (json['planting_steps'] as List<dynamic>).map((e) => e as String).toList(),
        wateringFrequency: json['watering_frequency'] as String,
        wateringLabel: json['watering_frequency_label'] as String,
        wateringNote: (json['watering_note'] as String?) ?? '',
        fertilizingFrequency: json['fertilizing_frequency'] as String,
        fertilizingLabel: json['fertilizing_frequency_label'] as String,
        fertilizingNote: (json['fertilizing_note'] as String?) ?? '',
        isHarvestable: json['is_harvestable'] == true,
        harvestDaysMin: json['harvest_days_min'] as int?,
        harvestDaysMax: json['harvest_days_max'] as int?,
        harvestLabel: json['harvest_label'] as String,
        harvestNote: (json['harvest_note'] as String?) ?? '',
      );
}

class GuideResult {
  const GuideResult({required this.plantId, required this.plantName, required this.guide});

  final int plantId;
  final String plantName;
  final CultivationGuide? guide;

  factory GuideResult.fromJson(Map<String, dynamic> json) {
    final plant = json['plant'] as Map<String, dynamic>;
    final guide = json['guide'];
    return GuideResult(
      plantId: plant['id'] as int,
      plantName: plant['name'] as String,
      guide: guide == null ? null : CultivationGuide.fromJson(guide as Map<String, dynamic>),
    );
  }
}

class GuideListItem {
  const GuideListItem({
    required this.plantId,
    required this.name,
    required this.scientificName,
    required this.categoryLabel,
    required this.hasGuide,
  });

  final int plantId;
  final String name;
  final String? scientificName;
  final String categoryLabel;
  final bool hasGuide;

  factory GuideListItem.fromJson(Map<String, dynamic> json) => GuideListItem(
        plantId: json['id'] as int,
        name: json['name'] as String,
        scientificName: json['scientific_name'] as String?,
        categoryLabel: (json['category_label'] as String?) ?? '',
        hasGuide: json['has_guide'] == true,
      );
}

class GuideSummary {
  const GuideSummary({required this.total, required this.withGuide, required this.withoutGuide});

  final int total;
  final int withGuide;
  final int withoutGuide;

  factory GuideSummary.fromJson(Map<String, dynamic> json) => GuideSummary(
        total: json['total'] as int,
        withGuide: json['with_guide'] as int,
        withoutGuide: json['without_guide'] as int,
      );
}

class GuideListResult {
  const GuideListResult({required this.summary, required this.items});

  final GuideSummary summary;
  final List<GuideListItem> items;
}