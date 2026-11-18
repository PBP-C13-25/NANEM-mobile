import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';

/// Login — PIC: Jihan. Route: Routes.login.
/// Juga tampil di tab Profil untuk guest.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _login(BuildContext context, String username) async {
    final route = ModalRoute.of(context);
    final navigator = Navigator.of(context);
    await AuthState.instance.login(username, '');
    // Dibuka sebagai halaman sendiri → kembali ke halaman sebelumnya.
    // Di tab Profil, AccessGuard otomatis menggantinya dengan Profil Saya.
    if (route != null && !route.isFirst) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Masuk',
      pic: 'Jihan',
      description: 'form username & kata sandi → POST /api/auth/login/.',
      links: [
        PlaceholderLink('Masuk sebagai user (contoh)', () => _login(context, 'jihan')),
        PlaceholderLink('Masuk sebagai admin (contoh)', () => _login(context, 'admin')),
        PlaceholderLink(
          'Belum punya akun? Daftar',
          () => Navigator.of(context).pushNamed(Routes.register),
        ),
      ],
    );
  }
}
