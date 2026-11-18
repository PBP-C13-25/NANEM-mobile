import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Cari Pengguna — PIC: Hafidz. Route: Routes.profileSearch (user).
/// Dibuka dari Feed Koleksi (Zhafira).
class UserSearchPage extends StatelessWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Cari Pengguna',
      pic: 'Hafidz',
      description: 'cari berdasarkan username → GET /api/profile/search/?q=.',
      links: [
        PlaceholderLink(
          '@jihan → Profil Pengguna',
          () => Navigator.of(context).pushNamed(Routes.profileUser, arguments: 'jihan'),
        ),
      ],
    );
  }
}
