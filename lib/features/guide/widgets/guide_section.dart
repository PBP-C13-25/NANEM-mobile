import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Bagian Panduan Budidaya di halaman Detail Tanaman — PIC: Nicholas.
/// Dipakai di PlantDetailPage sebagai `GuideSection(plantId: plantId)`.
class GuideSection extends StatelessWidget {
  const GuideSection({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Panduan Budidaya',
      text: 'TODO (Nicholas): cara menanam, penyiraman, cahaya, pemupukan, waktu panen '
          '→ GET /api/plants/$plantId/guide/. '
          'Tanaman tanpa panduan → "Panduan belum tersedia".',
    );
  }
}
