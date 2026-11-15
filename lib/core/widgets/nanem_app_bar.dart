import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'brand.dart';

/// AppBar standar NANEM: logo + "Nanem" di semua halaman.
///
/// Tombol back otomatis:
/// - halaman tab (di dalam HomeShell) → tanpa tombol back
/// - halaman yang dibuka dengan push (detail, form, dll.) → ada tombol back
///
/// ```dart
/// Scaffold(
///   appBar: const NanemAppBar(),
///   body: ...,
/// )
/// ```
///
/// Judul halaman ditulis di isi halaman (mis. di AppCard / DisplayTitle),
/// bukan di AppBar, supaya AppBar selalu konsisten.
class NanemAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NanemAppBar({super.key, this.actions});

  /// Tombol di kanan. Untuk tombol berlabel, pakai [AppBarAction].
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final inTab = TabScope.isInTab(context);
    final showBack =
        !inTab && (ModalRoute.of(context)?.impliesAppBarDismissal ?? false);

    return AppBar(
      automaticallyImplyLeading: !inTab,
      // Ada tombol back → logo langsung menempel di sebelahnya
      leadingWidth: showBack ? 48 : null,
      titleSpacing: showBack ? 4 : NavigationToolbar.kMiddleSpacing,
      title: const BrandLogo(size: 30),
      actions: actions,
    );
  }
}

/// Tombol ikon + tulisan di kanan AppBar, mis. "Riwayat".
/// Lebih jelas daripada ikon saja.
///
/// ```dart
/// NanemAppBar(actions: [
///   AppBarAction(icon: AppIcons.history, label: 'Riwayat', onPressed: ...),
/// ])
/// ```
class AppBarAction extends StatelessWidget {
  const AppBarAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

/// Penanda "halaman ini adalah tab". Dipasang oleh HomeShell; halaman modul
/// tidak perlu memakainya langsung.
class TabScope extends InheritedWidget {
  const TabScope({super.key, required super.child});

  static bool isInTab(BuildContext context) =>
      context.getInheritedWidgetOfExactType<TabScope>() != null;

  @override
  bool updateShouldNotify(TabScope oldWidget) => false;
}
