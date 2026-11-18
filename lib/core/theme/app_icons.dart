import 'package:flutter/material.dart';

/// Ikon NANEM. Nama disamakan dengan `components/icon.html` di web
/// (ikon Lucide), tapi isinya memakai Material Icons bawaan Flutter.
///
/// Kalau nanti mau persis seperti web, pasang package ikon Lucide lalu cukup
/// ganti isi file ini; halaman lain tidak perlu diubah.
class AppIcons {
  AppIcons._();

  // Navigasi
  static const IconData home = Icons.home_outlined;
  static const IconData sprout = Icons.spa_outlined; // Rekomendasi
  static const IconData bookOpen = Icons.menu_book_outlined; // Katalog
  static const IconData layoutGrid = Icons.grid_view_outlined; // Koleksi
  static const IconData history = Icons.history; // Riwayat
  static const IconData clipboardList = Icons.assignment_outlined; // Panduan
  static const IconData sliders = Icons.tune; // Kelola (admin)

  // Akun
  static const IconData user = Icons.person_outline;
  static const IconData lock = Icons.lock_outline;
  static const IconData logOut = Icons.logout;

  // Lokasi & cuaca
  static const IconData locate = Icons.my_location;
  static const IconData mapPin = Icons.location_on_outlined;
  static const IconData thermometer = Icons.thermostat;
  static const IconData droplets = Icons.water_drop_outlined;
  static const IconData cloudRain = Icons.umbrella_outlined;
  static const IconData cloud = Icons.cloud_outlined;
  static const IconData sun = Icons.wb_sunny_outlined;

  // Lahan
  static const IconData maximize = Icons.crop_free; // Luas lahan
  static const IconData layers = Icons.layers_outlined; // Media tanam
  static const IconData calendar = Icons.calendar_today_outlined;

  // Aksi
  static const IconData pencil = Icons.edit_outlined;
  static const IconData trash = Icons.delete_outline;
  static const IconData bookmark = Icons.bookmark_border;
  static const IconData search = Icons.search;
  static const IconData heart = Icons.favorite_border;
  static const IconData heartFilled = Icons.favorite;
  static const IconData x = Icons.close;
  static const IconData check = Icons.check;
  static const IconData arrowLeft = Icons.arrow_back;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData chevronDown = Icons.expand_more;

  // Lain-lain
  static const IconData leaf = Icons.eco; // Logo
  static const IconData info = Icons.info_outline;
  static const IconData warning = Icons.priority_high;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
}
