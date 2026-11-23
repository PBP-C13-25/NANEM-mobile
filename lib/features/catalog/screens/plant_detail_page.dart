import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../../guide/widgets/guide_section.dart';
import '../models/plant.dart';
import '../service/catalog_service.dart';
import '../widgets/catalog_widgets.dart';

/// Detail Tanaman — PIC: Bobby (info tanaman) + Nicholas (bagian panduan).
/// Route: Routes.plantDetail, arguments: int plantId (user).
///
/// Dibuka dari Katalog, Hasil Rekomendasi, dan Detail Riwayat.
class PlantDetailPage extends StatefulWidget {
  const PlantDetailPage({super.key, required this.plantId, this.service});
  final int plantId;
  final CatalogService? service;

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  late Future<Plant> _future;

  @override
  void initState() {
    super.initState();
    _future = (widget.service ?? CatalogService.instance).fetchPlant(
      widget.plantId,
    );
  }

  void _reload() => setState(() {
    _future = (widget.service ?? CatalogService.instance).fetchPlant(
      widget.plantId,
    );
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const NanemAppBar(),
    body: FutureBuilder<Plant>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: AppSpinner());
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (error is CatalogApiException && error.statusCode == 404)
                EmptyState(
                  title: 'Tanaman tidak ditemukan',
                  text: 'Tanaman ini mungkin sudah dihapus dari katalog.',
                  actionLabel: 'Kembali',
                  onAction: () => Navigator.of(context).maybePop(),
                )
              else
                CatalogFailure(error: error, onRetry: _reload),
            ],
          );
        }
        final plant = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PlantImage(url: plant.imageUrl, name: plant.name, height: 230),
            const SizedBox(height: 20),
            Text(
              plant.categoryLabel,
              style: const TextStyle(color: AppColors.muted),
            ),
            Text(
              plant.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            Text(
              plant.scientificName.isEmpty
                  ? 'Nama ilmiah belum tersedia'
                  : plant.scientificName,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              plant.description.isEmpty
                  ? 'Deskripsi belum tersedia.'
                  : plant.description,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 24),
            AppCard(
              title: 'Kebutuhan tanaman',
              child: Column(
                children: [
                  PlantFact('Media', plant.mediaLabel),
                  PlantFact('Ruang', plant.spaceLabel),
                  PlantFact('Cahaya', plant.sunlightLabel),
                  PlantFact('Perawatan', plant.careLabel),
                  PlantFact(
                    'Kebutuhan air',
                    plantWatering[plant.watering] ?? 'Belum diketahui',
                  ),
                  PlantFact('Cocok indoor', plantBooleanLabel(plant.indoor)),
                  PlantFact(
                    'Tahan kering',
                    plantBooleanLabel(plant.droughtTolerant),
                  ),
                  PlantFact(
                    'Suhu',
                    plantRangeLabel(plant.tempMin, plant.tempMax, '°C'),
                  ),
                  PlantFact(
                    'Kelembapan',
                    plantRangeLabel(plant.humidityMin, plant.humidityMax, '%'),
                  ),
                  PlantFact(
                    'Curah hujan',
                    plantRangeLabel(
                      plant.rainfallMin,
                      plant.rainfallMax,
                      'mm/hari',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Curah hujan adalah rata-rata harian ekuivalen dari kisaran tahunan, bukan kebutuhan penyiraman.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GuideSection(plantId: plant.id),
            const SizedBox(height: 24),
          ],
        );
      },
    ),
  );
}
