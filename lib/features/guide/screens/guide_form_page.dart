import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Form Panduan — PIC: Nicholas.
/// Route: Routes.adminGuideForm, arguments: int plantId (admin).
class GuideFormPage extends StatelessWidget {
  const GuideFormPage({super.key, required this.plantId});

  final int plantId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Form Panduan',
      pic: 'Nicholas',
      description: 'form panduan tanaman #$plantId → POST/PATCH /api/plants/$plantId/guide/.',
    );
  }
}
