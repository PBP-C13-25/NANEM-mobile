import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Katalog Tanaman (tab Katalog) — PIC: Bobby. User.
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Katalog Tanaman',
      pic: 'Bobby',
      description: 'daftar tanaman + cari & filter → GET /api/plants/.',
      links: [
        PlaceholderLink(
          'Tanaman #1 → Detail Tanaman',
          () => Navigator.of(context).pushNamed(Routes.plantDetail, arguments: 1),
        ),
      ],
    );
  }
}
