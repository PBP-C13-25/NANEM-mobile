import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema global. Dipasang sekali di `MaterialApp(theme: AppTheme.light)`,
/// sehingga TextField, AppBar, dan NavigationBar otomatis bergaya NANEM.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      error: AppColors.danger,
      surface: AppColors.surface,
      onSurface: AppColors.text,
    );

    OutlineInputBorder inputBorder(Color color, {double width = 1}) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        shape: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      // .form-group input: latar abu kehijauan, berubah putih + garis hijau saat fokus
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused) ? AppColors.surface : AppColors.inputFill,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        hintStyle: const TextStyle(color: AppColors.muted),
        helperStyle: const TextStyle(color: AppColors.muted, fontSize: 12.8),
        errorStyle: const TextStyle(color: AppColors.danger, fontSize: 13.6),
        border: inputBorder(Colors.transparent),
        enabledBorder: inputBorder(Colors.transparent),
        focusedBorder: inputBorder(AppColors.primary),
        errorBorder: inputBorder(AppColors.danger),
        focusedErrorBorder: inputBorder(AppColors.danger),
      ),
    );
  }
}
