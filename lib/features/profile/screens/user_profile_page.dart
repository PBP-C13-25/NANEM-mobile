import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../../collection/widgets/collection_card.dart';

/// Profil Pengguna Lain — PIC: Hafidz.
/// Route: Routes.profileUser, arguments: String username (user).
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: '@$username',
      pic: 'Hafidz',
      description: 'foto, nama, grid postingan → GET /api/profile/$username/.',
      children: [
        CollectionCard(postId: 1, ownerUsername: username),
        CollectionCard(postId: 2, ownerUsername: username),
      ],
    );
  }
}
