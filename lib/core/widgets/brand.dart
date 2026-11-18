import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// Logo + tulisan "Nanem" (.navbar__brand). Pakai di AppBar, login, dll.
///
/// ```dart
/// AppBar(title: const BrandLogo())
/// ```
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 34, this.showText = true});

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.29),
          ),
          child: Icon(AppIcons.leaf, size: size * 0.53, color: Colors.white),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'Nanem',
            style: TextStyle(
              fontSize: size * 0.56,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: AppColors.text,
            ),
          ),
        ],
      ],
    );
  }
}

/// Judul besar huruf kapital dengan baris kedua abu muda (.display-title).
///
/// ```dart
/// const DisplayTitle(title: 'Temukan tanaman', ghost: 'yang cocok')
/// ```
class DisplayTitle extends StatelessWidget {
  const DisplayTitle({super.key, required this.title, this.ghost, this.fontSize = 32});

  final String title;

  /// Baris kedua berwarna pudar (.display-title__ghost).
  final String? ghost;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      height: 1.05,
      letterSpacing: -fontSize * 0.02,
      color: AppColors.text,
    );
    return Text.rich(
      TextSpan(
        text: title.toUpperCase(),
        children: [
          if (ghost != null)
            TextSpan(
              text: '\n${ghost!.toUpperCase()}',
              style: const TextStyle(color: AppColors.ghost),
            ),
        ],
      ),
      style: style,
    );
  }
}

/// Lingkaran foto profil, atau huruf pertama nama jika belum ada foto (.avatar).
///
/// ```dart
/// AppAvatar(name: user.username, photoUrl: profile.photoUrl)
/// ```
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.name, this.photoUrl, this.size = 40});

  final String name;
  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed.substring(0, 1).toUpperCase();

    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );

    final url = photoUrl;
    if (url == null || url.isEmpty) return fallback;

    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
