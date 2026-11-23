import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';
import '../models/plant.dart';
import '../service/catalog_service.dart';
import 'catalog_widgets.dart';

class PlantListPage extends StatefulWidget {
  const PlantListPage({super.key, this.service});
  final CatalogService? service;

  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  final _search = TextEditingController();
  Map<String, String> _filters = {'sort': 'name'};
  int _page = 1;
  late Future<PlantPage> _future;
  CatalogService get _service => widget.service ?? CatalogService.instance;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchPlants(filters: _filters, page: _page);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final future = _service.fetchPlants(filters: Map.of(_filters), page: _page);
    setState(() {
      _future = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder menampilkan error dan tombol coba lagi.
    }
  }

  void _setFilter(String field, String value) {
    _filters = {..._filters, field: value};
    _page = 1;
    _reload();
  }

  Future<void> _showFilters() async {
    final draft = Map<String, String>.of(_filters);
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Filter tanaman',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                for (final filter in <(String, String, Map<String, String>)>[
                  (
                    'medium',
                    'Media tanam',
                    {'soil': 'Tanah', 'hydroponic': 'Hidroponik'},
                  ),
                  ('sunlight', 'Kebutuhan cahaya', plantSunlight),
                  ('space', 'Kebutuhan ruang', plantSpaces),
                  (
                    'sort',
                    'Urutkan',
                    {
                      'name': 'Nama A–Z',
                      'name_desc': 'Nama Z–A',
                      'category': 'Kategori',
                      'updated': 'Terakhir diperbarui',
                    },
                  ),
                ]) ...[
                  PlantSelect(
                    label: filter.$2,
                    value: draft[filter.$1] ?? '',
                    choices: filter.$3,
                    emptyLabel: filter.$1 == 'sort' ? 'Nama A–Z' : 'Semua',
                    onChanged: (value) =>
                        update(() => draft[filter.$1] = value),
                  ),
                  const SizedBox(height: 16),
                ],
                AppButton(
                  label: 'Terapkan filter',
                  block: true,
                  onPressed: () => Navigator.of(context).pop(draft),
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: 'Atur ulang',
                  variant: AppButtonVariant.outline,
                  onPressed: () =>
                      Navigator.of(context)
                          .pop(<String, String>{'sort': 'name'}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result == null || !mounted) return;
    _filters = result;
    _search.text = _filters['q'] ?? '';
    _page = 1;
    _reload();
  }

  Future<void> _openPlant(Plant plant) async {
    await Navigator.of(context)
        .pushNamed(Routes.plantDetail, arguments: plant.id);
    if (mounted) _reload();
  }

  Widget _card(Plant plant) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlantImage(url: plant.imageUrl, name: plant.name),
        const SizedBox(height: 14),
        Text(
          plant.categoryLabel,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        Text(
          plant.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        if (plant.scientificName.isNotEmpty)
          Text(
            plant.scientificName,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.muted,
            ),
          ),
        const SizedBox(height: 10),
        PlantFact('Media', plant.mediaLabel),
        PlantFact('Cahaya', plant.sunlightLabel),
        PlantFact('Ruang', plant.spaceLabel),
        const SizedBox(height: 12),
        AppButton(
          label: 'Lihat tanaman',
          variant: AppButtonVariant.outline,
          block: true,
          onPressed: () => _openPlant(plant),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const NanemAppBar(),
    body: RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Katalog Tanaman',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kenali tanaman dan temukan panduan budidayanya.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          SearchField(
            controller: _search,
            size: SearchFieldSize.lg,
            hintText: 'Cari nama atau nama ilmiah',
            debounce: const Duration(milliseconds: 400),
            onChanged: (value) => _setFilter('q', value.trim()),
            onSubmitted: (value) => _setFilter('q', value.trim()),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final entry in {'': 'Semua', ...plantCategories}.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(entry.value),
                      selected: (_filters['category'] ?? '') == entry.key,
                      onSelected: (_) => _setFilter('category', entry.key),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _showFilters,
              icon: const Icon(AppIcons.sliders),
              label: const Text('Filter & urutan'),
            ),
          ),
          FutureBuilder<PlantPage>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: AppSpinner()),
                );
              }
              if (snapshot.hasError) {
                return CatalogFailure(error: snapshot.error, onRetry: _reload);
              }
              final data = snapshot.data!;
              if (data.results.isEmpty) {
                return EmptyState(
                  title: 'Tanaman tidak ditemukan',
                  text: 'Coba kata kunci lain atau kurangi filter.',
                  actionLabel: 'Atur ulang',
                  onAction: () {
                    _filters = {'sort': 'name'};
                    _search.clear();
                    _page = 1;
                    _reload();
                  },
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${data.count} tanaman',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),
                  for (final plant in data.results) ...[
                    _card(plant),
                    const SizedBox(height: 16),
                  ],
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppButton(
                        label: 'Sebelumnya',
                        size: AppButtonSize.sm,
                        variant: AppButtonVariant.outline,
                        onPressed: data.previous == null
                            ? null
                            : () {
                                _page--;
                                _reload();
                              },
                      ),
                      Text('Halaman $_page'),
                      AppButton(
                        label: 'Berikutnya',
                        size: AppButtonSize.sm,
                        variant: AppButtonVariant.outline,
                        onPressed: data.next == null
                            ? null
                            : () {
                                _page++;
                                _reload();
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}
