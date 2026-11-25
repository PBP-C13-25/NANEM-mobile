import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Ganti Password — PIC: Jihan. Route: Routes.password (user).
/// Dibuka dari menu Profil Saya (Hafidz).
class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Ganti Password',
      pic: 'Jihan',
      description: 'kata sandi lama & baru → POST /api/auth/password/.',
    );
  }
}
