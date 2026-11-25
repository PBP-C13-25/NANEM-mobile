import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';

/// Hasil Rekomendasi — PIC: Jihan. Route: Routes.recommendationResult (semua).
/// TODO (Jihan): terima hasil rekomendasi lewat `arguments`.
class RecommendationResultPage extends StatelessWidget {
  const RecommendationResultPage({super.key});

  void _save(BuildContext context) {
    final navigator = Navigator.of(context);
    if (!AuthState.instance.isLoggedIn) {
      navigator.pushNamed(Routes.login);
      return;
    }
    // TODO (Jihan): POST /api/history/, lalu buka riwayat yang baru dibuat.
    navigator.pushReplacementNamed(Routes.historyDetail, arguments: 1);
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Hasil Rekomendasi',
      pic: 'Jihan',
      description: 'cuaca, 10 tanaman + skor kecocokan, tombol simpan (guest diminta masuk).',
      links: [
        PlaceholderLink(
          'Ketuk tanaman → Detail Tanaman #1',
          () => Navigator.of(context).pushNamed(Routes.plantDetail, arguments: 1),
        ),
        PlaceholderLink('Ubah data lahan', () => Navigator.of(context).pop()),
        PlaceholderLink('Simpan ke riwayat', () => _save(context)),
      ],
    );
  }
}
