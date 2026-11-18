import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Detail Riwayat — PIC: Jihan.
/// Route: Routes.historyDetail, arguments: int id (user).
class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key, required this.historyId});

  final int historyId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Detail Riwayat #$historyId',
      pic: 'Jihan',
      description: 'data lahan, cuaca, hasil; ubah nama lahan & hapus → '
          'GET/PATCH/DELETE /api/history/$historyId/.',
      links: [
        PlaceholderLink(
          'Ketuk tanaman → Detail Tanaman #1',
          () => Navigator.of(context).pushNamed(Routes.plantDetail, arguments: 1),
        ),
      ],
    );
  }
}
