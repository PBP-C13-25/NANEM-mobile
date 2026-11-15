import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Kelola Tanaman — PIC: Bobby. Route: Routes.adminPlants (admin).
/// Dibuka dari menu admin di Profil Saya.
class ManagePlantsPage extends StatelessWidget {
  const ManagePlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Kelola Tanaman',
      pic: 'Bobby',
      description: 'daftar tanaman dengan tombol tambah, edit, hapus → GET /api/plants/.',
      links: [
        PlaceholderLink(
          'Tambah tanaman',
          () => Navigator.of(context).pushNamed(Routes.adminPlantForm),
        ),
        PlaceholderLink(
          'Edit tanaman #1',
          () => Navigator.of(context).pushNamed(Routes.adminPlantForm, arguments: 1),
        ),
        PlaceholderLink(
          'Atur panduan tanaman #1',
          () => Navigator.of(context).pushNamed(Routes.adminGuides, arguments: 1),
        ),
      ],
    );
  }
}
