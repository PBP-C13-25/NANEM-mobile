import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/collection_card.dart';

/// Feed Koleksi (tab Koleksi) — PIC: Zhafira. User.
class CollectionFeedPage extends StatelessWidget {
  const CollectionFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Koleksi Tanaman',
      pic: 'Zhafira',
      description: 'feed postingan semua pengguna + suka, kolom cari pengguna '
          '→ GET /api/collections/.',
      links: [
        PlaceholderLink(
          'Buat postingan',
          () => Navigator.of(context).pushNamed(Routes.collectionForm),
        ),
        PlaceholderLink(
          'Cari pengguna',
          () => Navigator.of(context).pushNamed(Routes.profileSearch),
        ),
      ],
      children: const [
        CollectionCard(postId: 1, ownerUsername: 'jihan'),
        CollectionCard(postId: 2, ownerUsername: 'hafidz'),
      ],
    );
  }
}
