import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_spinner.dart';

/// Varian tombol, sama dengan .btn--primary / --danger / --dark / --ghost / --outline.
enum AppButtonVariant { primary, danger, dark, ghost, outline }

/// Tinggi tombol. Web memakai 40px; di HP default dibuat 44 agar mudah ditekan.
enum AppButtonSize {
  sm(36),
  md(44),
  lg(52);

  const AppButtonSize(this.height);

  final double height;
}

/// Tombol NANEM.
///
/// ```dart
/// AppButton(label: 'Cari Rekomendasi', icon: AppIcons.search, onPressed: _submit)
/// AppButton(label: 'Hapus', variant: AppButtonVariant.danger, onPressed: _hapus)
/// AppButton(label: 'Simpan', loading: _saving, block: true, onPressed: _simpan)
/// ```
///
/// `onPressed: null` membuat tombol nonaktif (tampil pudar).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.block = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;

  /// Lebar penuh (.btn--block).
  final bool block;

  /// Menampilkan spinner dan menonaktifkan tombol.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = _ButtonColors.of(variant);
    final enabled = onPressed != null && !loading;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (loading)
          AppSpinner(size: 16, color: colors.foreground)
        else if (icon != null)
          Icon(icon, size: 18),
        if (loading || icon != null) const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            // Jarak atas-bawah huruf dibuat sama supaya teks pas di tengah ikon
            textHeightBehavior: const TextHeightBehavior(
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
      ],
    );

    final button = TextButton(
      onPressed: enabled ? onPressed : null,
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, size.height)),
        // Dengan ikon: sisi ikon sedikit lebih sempit, karena gambar ikon punya
        // ruang kosong sendiri. Tanpa ini isi tombol terlihat bergeser ke kanan.
        padding: WidgetStatePropertyAll(
          icon != null || loading
              ? const EdgeInsetsDirectional.only(start: 14, end: 18)
              : const EdgeInsets.symmetric(horizontal: 18),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: colors.border == null
                ? BorderSide.none
                : BorderSide(color: colors.border!),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.hovered)
              ? colors.backgroundHover
              : colors.background,
        ),
        foregroundColor: WidgetStatePropertyAll(colors.foreground),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.2),
        ),
      ),
      child: content,
    );

    final result = Opacity(
      opacity: enabled || loading ? 1 : 0.5,
      child: button,
    );
    return block ? SizedBox(width: double.infinity, child: result) : result;
  }
}

class _ButtonColors {
  const _ButtonColors(
    this.background,
    this.backgroundHover,
    this.foreground, [
    this.border,
  ]);

  final Color background;
  final Color backgroundHover;
  final Color foreground;
  final Color? border;

  static _ButtonColors of(AppButtonVariant variant) {
    switch (variant) {
      case AppButtonVariant.primary:
        return const _ButtonColors(
          AppColors.primary,
          AppColors.primaryHover,
          Colors.white,
        );
      case AppButtonVariant.danger:
        return const _ButtonColors(
          AppColors.danger,
          AppColors.dangerHover,
          Colors.white,
        );
      case AppButtonVariant.dark:
        return const _ButtonColors(
          AppColors.text,
          AppColors.textHover,
          Colors.white,
        );
      case AppButtonVariant.ghost:
        return const _ButtonColors(
          Colors.transparent,
          AppColors.hover,
          AppColors.text,
        );
      case AppButtonVariant.outline:
        return const _ButtonColors(
          AppColors.surface,
          AppColors.hover,
          AppColors.text,
          AppColors.border,
        );
    }
  }
}
