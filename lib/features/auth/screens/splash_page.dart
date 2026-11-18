import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';

/// Splash: cek sesi lalu masuk ke Beranda — PIC: Jihan.
/// TODO (Jihan): restoreSession() memanggil GET /api/auth/me/.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await AuthState.instance.restoreSession();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandLogo(size: 56),
            SizedBox(height: 32),
            AppSpinner(size: 28),
          ],
        ),
      ),
    );
  }
}
