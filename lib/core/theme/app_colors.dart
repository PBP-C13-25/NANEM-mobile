import 'package:flutter/material.dart';

/// Warna NANEM, disamakan dengan variabel CSS di base.css versi web.
class AppColors {
  AppColors._();

  // Dasar
  static const Color background = Color(0xFFFFFFFF); // --color-bg
  static const Color surface = Color(0xFFFFFFFF); // --color-surface
  static const Color border = Color(0xFFE4E6DC); // --color-border

  // Teks
  static const Color text = Color(0xFF1A1A1A); // --color-text
  static const Color textHover = Color(0xFF333333); // .btn--dark:hover
  static const Color ghost = Color(0x594C2E05); // --color-ghost: rgb(76 46 5 / 0.35)
  static const Color muted = Color(0xFF6B6C72); // --color-muted

  // Brand
  static const Color primary = Color(0xFF566246); // --color-primary
  static const Color primaryHover = Color(0xFF4C5530); // --color-primary-hover
  static const Color primarySoft = Color(0xFFBEE7B8); // --color-primary-soft
  static const Color accent = Color(0xFF7A8450); // --color-accent
  static const Color sage = Color(0xFFAEBD93); // --color-sage
  static const Color neutral = Color(0xFF95969D); // --color-neutral

  // Status
  static const Color danger = Color(0xFFC0392B); // --color-danger
  static const Color dangerHover = Color(0xFFA8301F); // .btn--danger:hover
  static const Color dangerSoft = Color(0xFFFDE8E5); // .dialog__icon--danger

  // Lain-lain dari components.css
  static const Color hover = Color(0xFFF3F5EE); // --nav-hover
  static const Color inputFill = Color(0xFFF3F5EE); // .form-group input
  static const Color emptyStateBorder = sage; // .empty-state (#aebd93)

  /// Latar gelap di belakang modal: rgba(20, 25, 15, 0.45)
  static const Color barrier = Color(0x7314190F);

  // Toast
  static const Color toastSuccess = Color(0xFF2F7A35);
  static const Color toastError = Color(0xFFC0392B);
  static const Color toastInfo = Color(0xFF2B6CB0);
  static const Color toastWarning = Color(0xFFF2C14E);
  static const Color toastWarningText = Color(0xFF3D2E00);
  static const Color toastWarningIcon = Color(0xFFB7791F);

  // Pesan inline (.message & .form-errors)
  static const Color messageSuccess = Color(0xFFDFF5E1);
  static const Color messageError = Color(0xFFFBE6E3);
  static const Color messageWarning = Color(0xFFFFF3CD);
  static const Color messageInfo = Color(0xFFEEEEEE);
}

/// Sudut lengkung, disamakan dengan --radius-* di base.css.
class AppRadius {
  AppRadius._();

  static const double sm = 4; // --radius-sm
  static const double md = 6; // --radius-md
  static const double lg = 10; // --radius-lg: tombol, input, alert
  static const double box = 12; // .search-field, .toast (12px di CSS)
  static const double card = 16; // .card, .modal
  static const double emptyState = 20; // .empty-state
}
