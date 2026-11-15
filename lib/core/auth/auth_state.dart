import 'package:flutter/foundation.dart';

/// Data user yang sedang login (dari GET /api/auth/me/).
class AppUser {
  const AppUser({required this.id, required this.username, this.isStaff = false});

  final int id;
  final String username;

  /// `is_staff` di Django: true = admin.
  final bool isStaff;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        username: json['username'] as String,
        isStaff: json['is_staff'] == true,
      );
}

/// Status login yang dipakai SEMUA modul — PIC: Jihan.
///
/// Membaca status:
///   AuthState.instance.isLoggedIn / .isStaff / .user
///
/// Ikut berubah otomatis saat login/logout:
///   ListenableBuilder(
///     listenable: AuthState.instance,
///     builder: (context, _) => ...,
///   )
///
/// PLACEHOLDER: login() belum memanggil API, user langsung dibuat di sini.
class AuthState extends ChangeNotifier {
  AuthState._();

  static final AuthState instance = AuthState._();

  AppUser? _user;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isStaff => _user?.isStaff ?? false;

  /// Dipanggil Splash saat app dibuka.
  /// TODO (Jihan): GET /api/auth/me/ pakai cookie yang tersimpan.
  Future<void> restoreSession() async {}

  /// TODO (Jihan): POST /api/auth/login/, simpan cookie sessionid.
  Future<void> login(String username, String password) async {
    _user = AppUser(id: 1, username: username, isStaff: username == 'admin');
    notifyListeners();
  }

  /// TODO (Jihan): POST /api/auth/logout/, hapus cookie.
  /// Dipakai juga setelah hapus akun (modul Profil).
  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  /// Dipanggil api_client saat server membalas 401 (sesi habis).
  void handleUnauthorized() {
    if (_user == null) return;
    _user = null;
    notifyListeners();
  }
}
