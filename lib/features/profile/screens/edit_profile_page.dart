import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Edit Profil — PIC: Hafidz. Route: Routes.profileEdit (user).
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Edit Profil',
      pic: 'Hafidz',
      description: 'ubah nama, username, foto; hapus akun → PATCH/DELETE /api/profile/.',
    );
  }
}
