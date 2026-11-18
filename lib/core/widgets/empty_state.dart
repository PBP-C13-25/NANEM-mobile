import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'app_button.dart';

/// Tampilan saat data kosong, dengan garis putus-putus (.empty-state).
///
/// ```dart
/// EmptyState(
///   icon: AppIcons.history,
///   title: 'Belum ada riwayat',
///   text: 'Hasil rekomendasi yang kamu simpan bakal muncul di sini.',
///   actionLabel: 'Cari Rekomendasi',
///   onAction: () => ...,
/// )
/// ```
///
/// Ikon di web: history, search, plant (default), cloud →
/// `AppIcons.history`, `AppIcons.search`, `AppIcons.sprout`, `AppIcons.cloud`.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.icon = AppIcons.sprout,
    this.text,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final IconData icon;
  final String? text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: CustomPaint(
          foregroundPainter: _DashedBorderPainter(
            color: AppColors.emptyStateBorder,
            radius: AppRadius.emptyState,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.emptyState),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 30, color: AppColors.primary),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                if (text != null) ...[
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, height: 1.55, color: AppColors.muted),
                    ),
                  ),
                ],
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 22),
                  AppButton(label: actionLabel!, onPressed: onAction),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _strokeWidth = 2;
  static const double _dash = 8;
  static const double _gap = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    const half = _strokeWidth / 2;
    final rect = Rect.fromLTWH(half, half, size.width - _strokeWidth, size.height - _strokeWidth);
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + _dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
