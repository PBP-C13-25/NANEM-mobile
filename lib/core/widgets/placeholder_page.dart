import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'nanem_app_bar.dart';

/// Satu tombol navigasi contoh di halaman placeholder.
class PlaceholderLink {
  const PlaceholderLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;
}

/// Kerangka halaman sementara: judul, PIC, isi nanti, dan tombol ke halaman
/// tujuan supaya alur navigasi bisa dicoba dari ujung ke ujung.
///
/// Saat modul mulai dikerjakan, ganti seluruh isi build() halamanmu;
/// widget ini tidak perlu dipakai lagi.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    required this.pic,
    required this.description,
    this.links = const [],
    this.children = const [],
    this.appBarActions,
  });

  final String title;
  final String pic;

  /// Apa yang nanti tampil di halaman ini.
  final String description;

  final List<PlaceholderLink> links;

  /// Bagian tambahan, mis. widget dari modul lain.
  final List<Widget> children;

  /// Tombol ikon di kanan AppBar.
  final List<Widget>? appBarActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NanemAppBar(actions: appBarActions),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            title: title,
            text: 'TODO ($pic): $description',
          ),
          for (final child in children) ...[
            const SizedBox(height: 16),
            child,
          ],
          if (links.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'NAVIGASI (CONTOH)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.muted,
              ),
            ),
            for (final link in links) ...[
              const SizedBox(height: 8),
              AppButton(
                label: link.label,
                variant: AppButtonVariant.outline,
                block: true,
                onPressed: link.onTap,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
