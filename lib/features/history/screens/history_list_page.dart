import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Daftar Riwayat — PIC: Jihan. Route: Routes.history (user).
/// Dibuka dari tombol ikon di AppBar halaman Rekomendasi.
class HistoryListPage extends StatelessWidget {
  const HistoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Riwayat Rekomendasi',
      pic: 'Jihan',
      description: 'daftar riwayat + cari nama lahan → GET /api/history/?q=.',
      links: [
        PlaceholderLink(
          'Riwayat #1',
          () => Navigator.of(context).pushNamed(Routes.historyDetail, arguments: 1),
        ),
      ],
    );
  }
}
