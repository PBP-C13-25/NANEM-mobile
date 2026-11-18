import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Spinner bulat (.spinner). Ukuran 40 = normal, 18 = kecil (.spinner--sm).
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = 40, this.color});

  final double size;

  /// Default hijau primary dengan lintasan abu.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final spinnerColor = color ?? AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size >= 32 ? 3 : 2,
        color: spinnerColor,
        backgroundColor: color == null ? AppColors.border : spinnerColor.withAlpha(60),
      ),
    );
  }
}
