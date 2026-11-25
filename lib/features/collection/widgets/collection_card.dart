import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Kartu satu postingan koleksi — PIC: Zhafira.
/// Dipakai bersama di Feed Koleksi dan grid postingan di halaman Profil
/// (seperti partial _grid.html di web). Ketuk → Detail Postingan.
class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key, required this.postId, required this.ownerUsername});

  final int postId;
  final String ownerUsername;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Postingan #$postId',
      text: '@$ownerUsername · TODO (Zhafira): foto, judul, jumlah suka.',
      onTap: () => Navigator.of(context).pushNamed(Routes.collectionDetail, arguments: postId),
    );
  }
}
