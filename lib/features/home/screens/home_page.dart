import 'package:flutter/material.dart';

import '../../../app/home_shell.dart';
import '../../../core/widgets/widgets.dart';

/// Beranda (tab pertama) — PIC: Jihan. Guest boleh membuka.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Beranda',
      pic: 'Zhaf',
      description:
          'sapaan, penjelasan singkat NANEM, ajakan mencari rekomendasi.',
      links: [
        PlaceholderLink(
          'Cari Rekomendasi',
          () => HomeShell.goTo(context, AppTab.recommendation),
        ),
      ],
    );
  }
}
