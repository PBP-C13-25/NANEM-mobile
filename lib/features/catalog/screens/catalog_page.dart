import 'package:flutter/material.dart';

import '../service/catalog_service.dart';
import '../widgets/plant_list_page.dart';

/// Katalog Tanaman (tab Katalog) — PIC: Bobby. User.
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key, this.service});
  final CatalogService? service;

  @override
  Widget build(BuildContext context) => PlantListPage(service: service);
}
