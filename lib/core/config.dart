/// Satu-satunya tempat alamat server ditulis. Semua request API memakai ini.
class Config {
  Config._();

  /// Tanpa garis miring di akhir.
  /// Untuk server Django lokal dari emulator Android: 'http://10.0.2.2:8000'
  static const String baseUrl = 'https://jihan-nabiilah-nanem.pws.cs.ui.ac.id';
}
