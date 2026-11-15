import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';
import '../../collection/widgets/collection_card.dart';

/// Profil Saya (tab Profil) — PIC: Hafidz. User; guest melihat Login.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthState.instance;
    final username = auth.user?.username ?? '-';
    final navigator = Navigator.of(context);

    return PlaceholderPage(
      title: 'Profil Saya',
      pic: 'Hafidz',
      description: 'foto, nama, @$username, grid postingan, menu akun → GET /api/profile/.',
      links: [
        PlaceholderLink('Edit Profil', () => navigator.pushNamed(Routes.profileEdit)),
        PlaceholderLink('Ganti Password', () => navigator.pushNamed(Routes.password)),
        if (auth.isStaff) ...[
          PlaceholderLink('Kelola Tanaman (admin)', () => navigator.pushNamed(Routes.adminPlants)),
          PlaceholderLink('Kelola Panduan (admin)', () => navigator.pushNamed(Routes.adminGuides)),
        ],
        // Hanya muncul saat `flutter run` (debug), tidak ikut di APK rilis.
        if (kDebugMode)
          PlaceholderLink('Lihat komponen (dev)', () => navigator.pushNamed(Routes.devComponents)),
        // Setelah logout, tab ini otomatis menampilkan Login.
        PlaceholderLink('Logout', auth.logout),
      ],
      children: [
        CollectionCard(postId: 1, ownerUsername: username),
      ],
    );
  }
}
