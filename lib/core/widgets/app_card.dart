import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Kartu putih bergaris tipis dengan bayangan lembut (.card).
///
/// ```dart
/// AppCard(
///   title: 'Masuk',
///   text: 'Masuk untuk menyimpan riwayat rekomendasi.',
///   actions: [AppButton(label: 'Masuk', onPressed: _login)],
///   footer: const Text('Belum punya akun? Daftar'),
///   child: Column(children: [...]),
/// )
/// ```
///
/// Isi `onTap` kalau kartu bisa diketuk (mis. kartu riwayat).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.title,
    this.text,
    this.child,
    this.actions = const [],
    this.footer,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
  });

  /// .card__title
  final String? title;

  /// .card__text (abu-abu)
  final String? text;

  final Widget? child;

  /// Baris tombol rata kanan (.card__actions).
  final List<Widget> actions;

  /// Teks kecil di tengah bawah (.card__footer).
  final Widget? footer;

  final VoidCallback? onTap;

  /// Web memakai 28px; di HP default 20 karena layarnya sempit.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (title != null)
        Text(
          title!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      if (text != null)
        Text(text!, style: const TextStyle(fontSize: 15, color: AppColors.muted, height: 1.45)),
      ?child,
      if (actions.isNotEmpty)
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: actions,
        ),
      if (footer != null)
        Center(
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 14.4, color: AppColors.muted),
            textAlign: TextAlign.center,
            child: footer!,
          ),
        ),
    ];

    final content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: _gapBefore(children, i)),
            children[i],
          ],
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: const [
          BoxShadow(color: Color(0x0F1E2814), blurRadius: 30, offset: Offset(0, 10)),
        ],
      ),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.card),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }

  /// Jarak antar bagian: judul → teks 8px, sisanya 20px (mengikuti CSS).
  double _gapBefore(List<Widget> children, int index) {
    final afterTitle = title != null && index == 1;
    return afterTitle ? 8 : (footer != null && index == children.length - 1 ? 16 : 20);
  }
}
