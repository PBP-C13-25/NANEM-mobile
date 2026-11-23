import 'package:flutter/material.dart';

import '../service/catalog_service.dart';
import '../widgets/plant_list_page.dart';

/// Kelola Tanaman — PIC: Bobby. Route: Routes.adminPlants (admin).
/// Dibuka dari menu admin di Profil Saya.
class ManagePlantsPage extends StatelessWidget {
  const ManagePlantsPage({super.key, this.service});
  final CatalogService? service;

  @override
  Widget build(BuildContext context) =>
      PlantListPage(service: service, manage: true);
}
