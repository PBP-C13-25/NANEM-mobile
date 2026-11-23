import 'package:nanem_mobile/features/catalog/models/plant.dart';
import 'package:nanem_mobile/features/catalog/service/catalog_service.dart';

const testPlant = Plant(
  id: 7,
  name: 'Kangkung',
  scientificName: 'Ipomoea aquatica',
  description: 'Sayuran daun untuk kebun rumah.',
  category: 'sayur',
  spaceNeeded: 'small',
  supportsHydroponic: true,
  sunlight: ['full_sun', 'partial_shade'],
  tempMin: 18,
  tempMax: 30,
);

class FakeCatalogService extends CatalogService {
  Future<PlantPage> Function(Map<String, String>, int)? onList;
  Future<Plant> Function(int)? onDetail;
  Future<Plant> Function(Map<String, dynamic>, int?)? onSave;
  Future<void> Function(int)? onDelete;
  final lists = <(Map<String, String>, int)>[];
  final saves = <(Map<String, dynamic>, int?)>[];
  final deletes = <int>[];

  @override
  Future<PlantPage> fetchPlants({
    Map<String, String> filters = const {},
    int page = 1,
  }) async {
    lists.add((Map.of(filters), page));
    return onList == null
        ? const PlantPage(count: 1, results: [testPlant])
        : await onList!(filters, page);
  }

  @override
  Future<Plant> fetchPlant(int id) async =>
      onDetail == null ? testPlant : await onDetail!(id);

  @override
  Future<Plant> savePlant(Map<String, dynamic> values, {int? id}) async {
    saves.add((Map.of(values), id));
    return onSave == null ? testPlant : await onSave!(values, id);
  }

  @override
  Future<void> deletePlant(int id) async {
    deletes.add(id);
    await onDelete?.call(id);
  }
}
