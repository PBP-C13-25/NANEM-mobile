import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Kelola Panduan — PIC: Nicholas.
/// Route: Routes.adminGuides, arguments: int? plantId (opsional, dari Kelola Tanaman) (admin).
/// Dibuka dari menu admin di Profil Saya.
class ManageGuidesPage extends StatelessWidget {
  const ManageGuidesPage({super.key, this.plantId});

  final int? plantId;

  @override
  Widget build(BuildContext context) {
    final targetId = plantId ?? 1;
    return PlaceholderPage(
      title: 'Kelola Panduan',
      pic: 'Nicholas',
      description: plantId == null
          ? 'daftar tanaman beserta status panduannya.'
          : 'panduan untuk tanaman #$plantId.',
      links: [
        PlaceholderLink(
          'Tambah/edit panduan tanaman #$targetId',
          () => Navigator.of(context).pushNamed(Routes.adminGuideForm, arguments: targetId),
        ),
      ],
    );
  }
}
