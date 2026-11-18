import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Register — PIC: Jihan. Route: Routes.register.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Daftar',
      pic: 'Jihan',
      description: 'form username, kata sandi, ulangi kata sandi → POST /api/auth/register/.',
      links: [
        PlaceholderLink(
          'Daftar (contoh) lalu ke Login',
          () => Navigator.of(context).pushReplacementNamed(Routes.login),
        ),
      ],
    );
  }
}
