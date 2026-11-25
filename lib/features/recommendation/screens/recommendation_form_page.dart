import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Form Rekomendasi (tab Rekomendasi) — PIC: Jihan. Guest boleh membuka.
class RecommendationFormPage extends StatelessWidget {
  const RecommendationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      appBarActions: [
        // Riwayat khusus user; guest akan melihat ajakan masuk.
        AppBarAction(
          icon: AppIcons.history,
          label: 'Riwayat',
          onPressed: () => Navigator.of(context).pushNamed(Routes.history),
        ),
      ],
      title: 'Rekomendasi Tanaman',
      pic: 'Jihan',
      description: 'form lokasi, nama lahan, luas lahan, media tanam → POST /api/recommendations/.',
      links: [
        PlaceholderLink(
          'Cari Rekomendasi (contoh)',
          () => Navigator.of(context).pushNamed(Routes.recommendationResult),
        ),
      ],
    );
  }
}
