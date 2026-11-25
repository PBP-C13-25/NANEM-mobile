import 'package:flutter/material.dart';

import '../core/auth/auth_state.dart';
import '../core/widgets/widgets.dart';
import 'routes.dart';

/// Siapa yang boleh membuka halaman.
enum Access {
  /// Semua orang, termasuk guest.
  all,

  /// Harus login.
  user,

  /// Harus login dan `is_staff`.
  admin,
}

/// Penjaga akses. Dipasang otomatis oleh routes.dart dan home_shell.dart,
/// jadi halaman modul tidak perlu mengecek login sendiri.
class AccessGuard extends StatelessWidget {
  const AccessGuard({
    super.key,
    required this.access,
    required this.child,
    this.guestFallback,
  });

  final Access access;
  final Widget child;

  /// Yang tampil untuk guest. Default: ajakan masuk.
  final Widget? guestFallback;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthState.instance,
      builder: (context, _) {
        final auth = AuthState.instance;
        if (access == Access.all) return child;
        if (!auth.isLoggedIn) return guestFallback ?? const _LoginRequired();
        if (access == Access.admin && !auth.isStaff) return const _AdminOnly();
        return child;
      },
    );
  }
}

class _LoginRequired extends StatelessWidget {
  const _LoginRequired();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanemAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EmptyState(
            icon: AppIcons.lock,
            title: 'Masuk dulu, ya',
            text: 'Halaman ini khusus pengguna yang sudah terdaftar.',
            actionLabel: 'Masuk',
            onAction: () => Navigator.of(context).pushNamed(Routes.login),
          ),
        ],
      ),
    );
  }
}

class _AdminOnly extends StatelessWidget {
  const _AdminOnly();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanemAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          EmptyState(
            icon: AppIcons.sliders,
            title: 'Khusus admin',
            text: 'Halaman ini hanya bisa dibuka oleh admin.',
          ),
        ],
      ),
    );
  }
}
