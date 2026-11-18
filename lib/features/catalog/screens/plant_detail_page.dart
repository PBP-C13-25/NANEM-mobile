import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../../guide/widgets/guide_section.dart';

/// Detail Tanaman — PIC: Bobby (info tanaman) + Nicholas (bagian panduan).
/// Route: Routes.plantDetail, arguments: int plantId (user).
///
/// Dibuka dari Katalog, Hasil Rekomendasi, dan Detail Riwayat.
class PlantDetailPage extends StatelessWidget {
  const PlantDetailPage({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Detail Tanaman #$plantId',
      pic: 'Bobby',
      description: 'foto, nama, kebutuhan cuaca & media tanam → GET /api/plants/$plantId/. '
          'Siapkan tampilan 404 karena tanaman di hasil/riwayat bisa sudah dihapus admin.',
      children: [
        // Bagian milik modul Panduan Budidaya (Nicholas)
        GuideSection(plantId: plantId),
      ],
    );
  }
}
