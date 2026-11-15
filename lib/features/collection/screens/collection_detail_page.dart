import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';

/// Detail Postingan — PIC: Zhafira.
/// Route: Routes.collectionDetail, arguments: int postId (user).
class CollectionDetailPage extends StatelessWidget {
  const CollectionDetailPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Postingan #$postId',
      pic: 'Zhafira',
      description: 'foto, judul, deskripsi, suka; edit & hapus untuk pemilik '
          '→ GET /api/collections/$postId/.',
      links: [
        PlaceholderLink(
          'Ketuk pemilik → Profil @jihan',
          () => Navigator.of(context).pushNamed(Routes.profileUser, arguments: 'jihan'),
        ),
        PlaceholderLink(
          'Edit postingan (pemilik)',
          () => Navigator.of(context).pushNamed(Routes.collectionForm, arguments: postId),
        ),
      ],
    );
  }
}
