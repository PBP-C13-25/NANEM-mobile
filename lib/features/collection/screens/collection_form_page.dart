import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Form Postingan (buat/edit) — PIC: Zhafira.
/// Route: Routes.collectionForm, arguments: int? postId (null = buat) (user, edit: pemilik).
class CollectionFormPage extends StatelessWidget {
  const CollectionFormPage({super.key, this.postId});

  final int? postId;

  @override
  Widget build(BuildContext context) {
    final isEdit = postId != null;
    return PlaceholderPage(
      title: isEdit ? 'Edit Postingan #$postId' : 'Buat Postingan',
      pic: 'Zhafira',
      description: isEdit
          ? 'ubah judul & deskripsi → PATCH /api/collections/$postId/.'
          : 'foto dari kamera/galeri, judul, deskripsi → POST /api/collections/.',
    );
  }
}
