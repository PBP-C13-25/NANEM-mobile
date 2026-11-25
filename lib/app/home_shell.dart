import 'package:flutter/material.dart';

import '../core/theme/app_icons.dart';
import '../core/widgets/app_bottom_nav.dart';
import '../core/widgets/nanem_app_bar.dart';
import '../features/auth/screens/login_page.dart';
import '../features/catalog/screens/catalog_page.dart';
import '../features/collection/screens/collection_feed_page.dart';
import '../features/home/screens/home_page.dart';
import '../features/profile/screens/profile_page.dart';
import '../features/recommendation/screens/recommendation_form_page.dart';
import 'access_guard.dart';

/// Tab di navigasi bawah, urut dari kiri ke kanan.
enum AppTab { home, recommendation, catalog, collections, profile }

/// Kerangka utama aplikasi (padanan base.html di web): navigasi bawah
/// + halaman awal tiap tab. Anggota tidak perlu mengubah file ini.
///
/// Navigasi bawah hanya tampil di 5 halaman tab. Halaman lain yang dibuka
/// dengan `Navigator.of(context).pushNamed(...)` tampil penuh dengan tombol
/// back (seperti Edit Profile di Instagram).
///
/// Guest hanya bisa membuka Beranda dan Rekomendasi; tab Profil menampilkan
/// Login, tab lain menampilkan ajakan masuk.
///
/// Pindah tab dari halaman mana pun:
///   HomeShell.goTo(context, AppTab.recommendation);
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = AppTab.home});

  final AppTab initialTab;

  /// Pindah tab. Kalau dipanggil dari halaman yang di-push, halaman itu
  /// ditutup dulu sampai kembali ke shell.
  static void goTo(BuildContext context, AppTab tab) {
    final state = context.findAncestorStateOfType<_HomeShellState>();
    if (state != null) {
      state._select(tab);
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    _HomeShellState._current?._select(tab);
  }

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static _HomeShellState? _current;

  late int _index = widget.initialTab.index;

  /// Halaman awal tiap tab. Urutan harus sama dengan [AppTab].
  static const List<Widget> _pages = [
    HomePage(),
    RecommendationFormPage(),
    AccessGuard(access: Access.user, child: CatalogPage()),
    AccessGuard(access: Access.user, child: CollectionFeedPage()),
    AccessGuard(access: Access.user, guestFallback: LoginPage(), child: ProfilePage()),
  ];

  static const List<AppBottomNavItem> _items = [
    AppBottomNavItem(icon: AppIcons.home, label: 'Beranda'),
    AppBottomNavItem(icon: AppIcons.sprout, label: 'Rekomendasi'),
    AppBottomNavItem(icon: AppIcons.bookOpen, label: 'Katalog'),
    AppBottomNavItem(icon: AppIcons.layoutGrid, label: 'Koleksi'),
    AppBottomNavItem(icon: AppIcons.user, label: 'Profil'),
  ];

  @override
  void initState() {
    super.initState();
    _current = this;
  }

  @override
  void dispose() {
    if (_current == this) _current = null;
    super.dispose();
  }

  void _select(AppTab tab) {
    if (mounted && tab.index != _index) setState(() => _index = tab.index);
  }

  @override
  Widget build(BuildContext context) {
    final onFirstTab = _index == AppTab.home.index;

    // Tombol back di tab lain kembali ke Beranda dulu, bukan keluar app.
    return PopScope(
      canPop: onFirstTab,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(AppTab.home);
      },
      child: Scaffold(
        // IndexedStack: isi & posisi scroll tiap tab tetap tersimpan saat pindah tab
        body: TabScope(child: IndexedStack(index: _index, children: _pages)),
        bottomNavigationBar: AppBottomNav(
          items: _items,
          currentIndex: _index,
          onTap: (index) => _select(AppTab.values[index]),
        ),
      ),
    );
  }
}
