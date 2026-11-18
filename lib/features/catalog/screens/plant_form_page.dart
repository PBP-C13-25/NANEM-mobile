import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Form Tanaman (tambah/edit) — PIC: Bobby.
/// Route: Routes.adminPlantForm, arguments: int? plantId (null = tambah) (admin).
class PlantFormPage extends StatelessWidget {
  const PlantFormPage({super.key, this.plantId});

  final int? plantId;

  @override
  Widget build(BuildContext context) {
    final isEdit = plantId != null;
    return PlaceholderPage(
      title: isEdit ? 'Edit Tanaman #$plantId' : 'Tambah Tanaman',
      pic: 'Bobby',
      description: isEdit
          ? 'form data tanaman → PATCH /api/plants/$plantId/.'
          : 'form data tanaman → POST /api/plants/.',
    );
  }
}
