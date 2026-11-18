import 'package:flutter/material.dart';

import '../core/widgets/widgets.dart';
import '../features/auth/screens/login_page.dart';
import '../features/auth/screens/password_page.dart';
import '../features/auth/screens/register_page.dart';
import '../features/auth/screens/splash_page.dart';
import '../features/catalog/screens/manage_plants_page.dart';
import '../features/catalog/screens/plant_detail_page.dart';
import '../features/catalog/screens/plant_form_page.dart';
import '../features/collection/screens/collection_detail_page.dart';
import '../features/collection/screens/collection_form_page.dart';
import '../features/guide/screens/guide_form_page.dart';
import '../features/guide/screens/manage_guides_page.dart';
import '../dev/components_preview_page.dart';
import '../features/history/screens/history_detail_page.dart';
import '../features/history/screens/history_list_page.dart';
import '../features/profile/screens/edit_profile_page.dart';
import '../features/profile/screens/user_profile_page.dart';
import '../features/profile/screens/user_search_page.dart';
import '../features/recommendation/screens/recommendation_result_page.dart';
import 'access_guard.dart';
import 'home_shell.dart';

/// Nama route yang disepakati tim (PETA_HALAMAN_MOBILE.md bagian 2).
///
/// Pindah halaman SELALU lewat nama di sini:
///   Navigator.of(context).pushNamed(Routes.plantDetail, arguments: 3);
///
/// Bagian `:id` / `:username` di dokumen dikirim lewat `arguments`
/// (tipe tertulis di komentar tiap route). Halaman tab (Beranda, Rekomendasi,
/// Katalog, Koleksi, Profil) dibuka lewat HomeShell.goTo, bukan pushNamed.
class Routes {
  Routes._();

  // Auth & umum — Jihan
  static const String splash = '/';
  static const String home = '/home'; // arguments: AppTab? (tab awal)
  static const String login = '/login';
  static const String register = '/register';
  static const String password = '/password';

  // Rekomendasi & Riwayat — Jihan
  static const String recommendationResult = '/recommendation/result';
  static const String history = '/history';
  static const String historyDetail = '/history/detail'; // arguments: int id

  // Katalog — Bobby
  static const String plantDetail = '/plants/detail'; // arguments: int plantId
  static const String adminPlants = '/admin/plants';
  static const String adminPlantForm = '/admin/plants/form'; // arguments: int? (null = tambah)

  // Panduan — Nicholas
  static const String adminGuides = '/admin/guides'; // arguments: int? plantId (opsional)
  static const String adminGuideForm = '/admin/guides/form'; // arguments: int plantId

  // Koleksi — Zhafira
  static const String collectionDetail = '/collections/detail'; // arguments: int id
  static const String collectionForm = '/collections/form'; // arguments: int? (null = buat)

  // Profil — Hafidz
  static const String profileEdit = '/profile/edit';
  static const String profileSearch = '/profile/search';
  static const String profileUser = '/profile/user'; // arguments: String username

  // Khusus development: katalog komponen (menu muncul hanya di mode debug)
  static const String devComponents = '/dev/components';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    final (Widget page, Access access) = switch (settings.name) {
      Routes.splash => (const SplashPage(), Access.all),
      Routes.home => (
        HomeShell(initialTab: args is AppTab ? args : AppTab.home),
        Access.all,
      ),
      Routes.login => (const LoginPage(), Access.all),
      Routes.register => (const RegisterPage(), Access.all),
      Routes.password => (const PasswordPage(), Access.user),
      Routes.recommendationResult => (const RecommendationResultPage(), Access.all),
      Routes.history => (const HistoryListPage(), Access.user),
      Routes.historyDetail => (HistoryDetailPage(historyId: args as int), Access.user),
      Routes.plantDetail => (PlantDetailPage(plantId: args as int), Access.user),
      Routes.adminPlants => (const ManagePlantsPage(), Access.admin),
      Routes.adminPlantForm => (PlantFormPage(plantId: args as int?), Access.admin),
      Routes.adminGuides => (ManageGuidesPage(plantId: args as int?), Access.admin),
      Routes.adminGuideForm => (GuideFormPage(plantId: args as int), Access.admin),
      Routes.collectionDetail => (CollectionDetailPage(postId: args as int), Access.user),
      Routes.collectionForm => (CollectionFormPage(postId: args as int?), Access.user),
      Routes.profileEdit => (const EditProfilePage(), Access.user),
      Routes.profileSearch => (const UserSearchPage(), Access.user),
      Routes.profileUser => (UserProfilePage(username: args as String), Access.user),
      Routes.devComponents => (const ComponentsPreviewPage(), Access.all),
      _ => (const _NotFoundPage(), Access.all),
    };

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => AccessGuard(access: access, child: page),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanemAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          EmptyState(
            icon: AppIcons.search,
            title: 'Halaman tidak ditemukan',
            text: 'Nama route belum terdaftar di routes.dart.',
          ),
        ],
      ),
    );
  }
}
