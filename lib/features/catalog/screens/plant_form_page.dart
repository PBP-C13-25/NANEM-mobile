import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../models/plant.dart';
import '../models/plant_validation.dart';
import '../service/catalog_service.dart';
import '../widgets/catalog_widgets.dart';

/// Form Tanaman (tambah/edit) — PIC: Bobby.
/// Route: Routes.adminPlantForm, arguments: int? plantId (null = tambah) (admin).
class PlantFormPage extends StatefulWidget {
  const PlantFormPage({super.key, this.plantId, this.service});
  final int? plantId;
  final CatalogService? service;

  @override
  State<PlantFormPage> createState() => _PlantFormPageState();
}

class _PlantFormPageState extends State<PlantFormPage> {
  final _form = GlobalKey<FormState>();
  final _scroll = ScrollController();
  final _controllers = <String, TextEditingController>{};
  Map<String, dynamic> _values = const Plant(
    id: 0,
    name: '',
    category: '',
    spaceNeeded: '',
  ).toFormData();
  Map<String, String> _errors = {};
  bool _loading = false, _saving = false;
  Object? _loadError;
  String? _message;
  CatalogService get _service => widget.service ?? CatalogService.instance;

  @override
  void initState() {
    super.initState();
    for (final field in [
      'name',
      'scientific_name',
      'description',
      'image_url',
      ...plantClimateLabels.keys,
    ]) {
      _controllers[field] = TextEditingController();
    }
    if (widget.plantId != null) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final plant = await _service.fetchPlant(widget.plantId!);
      if (!mounted) return;
      _values = plant.toFormData();
      for (final entry in _controllers.entries) {
        entry.value.text = _values[entry.key]?.toString() ?? '';
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _loadError = error;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  void _change(String field, dynamic value) => setState(() {
    _values[field] = value;
    _errors.remove(field);
    if (field.startsWith('supports_')) _errors.remove('__all__');
  });

  void _showErrors(Map<String, String> errors, String message) {
    setState(() {
      _errors = errors;
      _message = message;
    });
    _form.currentState?.validate();
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    FocusScope.of(context).unfocus();
    final input = {
      ..._values,
      for (final entry in _controllers.entries) entry.key: entry.value.text,
    };
    final errors = validatePlantInput(input);
    if (errors.isNotEmpty) {
      _showErrors(
        errors,
        errors['__all__'] ?? 'Periksa kembali field yang ditandai.',
      );
      return;
    }
    setState(() {
      _saving = true;
      _errors = {};
      _message = null;
    });
    try {
      await _service.savePlant(plantInputPayload(input), id: widget.plantId);
      if (!mounted) return;
      setState(() {
        _saving = false;
      });
      showToast(
        context,
        widget.plantId == null
            ? 'Tanaman berhasil ditambahkan.'
            : 'Tanaman berhasil diperbarui.',
      );
      Navigator.of(context).pop(true);
    } on CatalogApiException catch (error) {
      if (!mounted) return;
      final fields = {
        for (final entry in error.fields.entries)
          entry.key: entry.value.join(' '),
      };
      _showErrors(
        fields,
        fields['__all__'] ?? fields['non_field_errors'] ?? error.message,
      );
    } catch (error) {
      if (mounted) _showErrors({}, catalogErrorText(error));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Widget _text(
    String field,
    String label, {
    int lines = 1,
    int? maxLength,
    bool numeric = false,
  }) => AppTextField(
    key: ValueKey(field),
    label: label,
    controller: _controllers[field],
    maxLines: lines,
    maxLength: maxLength,
    keyboardType: numeric
        ? const TextInputType.numberWithOptions(decimal: true, signed: true)
        : null,
    validator: (_) => _errors[field],
    onChanged: (_) => setState(() {
      _errors.remove(field);
    }),
  );

  Widget _select(
    String field,
    String label,
    Map<String, String> choices, {
    String empty = 'Belum ditentukan',
  }) => PlantSelect(
    label: label,
    value: _values[field] as String? ?? '',
    choices: choices,
    emptyLabel: empty,
    validator: (_) => _errors[field],
    onChanged: (value) => _change(field, value),
  );

  Widget _boolean(String field, String label) => PlantSelect(
    label: label,
    value: _values[field] == null
        ? ''
        : (_values[field] == true ? 'true' : 'false'),
    choices: const {'true': 'Ya', 'false': 'Tidak'},
    emptyLabel: 'Belum diketahui',
    validator: (_) => _errors[field],
    onChanged: (value) =>
        _change(field, value.isEmpty ? null : value == 'true'),
  );

  Widget _section(String title, List<Widget> children) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: AppCard(
      title: title,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(height: 16),
              children[index],
            ],
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: const NanemAppBar(),
      body: _loading
          ? const Center(child: AppSpinner())
          : _loadError != null
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [CatalogFailure(error: _loadError, onRetry: _load)],
            )
          : AbsorbPointer(
              absorbing: _saving,
              child: Form(
                key: _form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.plantId == null
                            ? 'Tambah Tanaman'
                            : 'Edit Tanaman',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Data yang belum diketahui boleh dibiarkan kosong.',
                        style: TextStyle(color: AppColors.muted),
                      ),
                      const SizedBox(height: 20),
                      if (_message != null) ...[
                        AppAlert(message: _message!, type: MessageType.error),
                        const SizedBox(height: 16),
                      ],
                      _section('Identitas tanaman', [
                        _text('name', 'Nama tanaman', maxLength: 200),
                        _text('scientific_name', 'Nama ilmiah', maxLength: 200),
                        _select(
                          'category',
                          'Kategori',
                          plantCategories,
                          empty: 'Pilih kategori',
                        ),
                      ]),
                      _section('Media dan lokasi', [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Mendukung tanah'),
                          value: _values['supports_soil'] as bool,
                          onChanged: (value) =>
                              _change('supports_soil', value ?? false),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Mendukung hidroponik'),
                          value: _values['supports_hydroponic'] as bool,
                          onChanged: (value) =>
                              _change('supports_hydroponic', value ?? false),
                        ),
                        _select(
                          'space_needed',
                          'Kebutuhan ruang',
                          plantSpaces,
                          empty: 'Pilih kebutuhan ruang',
                        ),
                        _boolean('indoor', 'Dapat ditanam di dalam ruangan'),
                        const Text(
                          'Kebutuhan cahaya',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        for (final entry in plantSunlight.entries)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(entry.value),
                            value: (_values['sunlight'] as List).contains(
                              entry.key,
                            ),
                            onChanged: (checked) {
                              final selected = List<String>.from(
                                _values['sunlight'] as List,
                              );
                              if (checked == true) {
                                selected.add(entry.key);
                              } else {
                                selected.remove(entry.key);
                              }
                              _change('sunlight', selected);
                            },
                          ),
                        if (_errors['sunlight'] != null)
                          Text(
                            _errors['sunlight']!,
                            style: const TextStyle(color: AppColors.danger),
                          ),
                      ]),
                      _section('Perawatan', [
                        _select('watering', 'Kebutuhan air', plantWatering),
                        _select(
                          'care_level',
                          'Tingkat perawatan',
                          plantCareLevels,
                        ),
                        _boolean('drought_tolerant', 'Tahan kekeringan'),
                      ]),
                      _section('Kondisi lingkungan', [
                        const Text(
                          'Curah hujan adalah ekuivalen rata-rata tahunan, bukan kebutuhan penyiraman harian.',
                          style: TextStyle(color: AppColors.muted, height: 1.4),
                        ),
                        for (final entry in plantClimateLabels.entries)
                          _text(entry.key, entry.value, numeric: true),
                      ]),
                      _section('Deskripsi dan gambar', [
                        _text('description', 'Deskripsi', lines: 4),
                        _text('image_url', 'URL gambar', maxLength: 2048),
                      ]),
                      AppButton(
                        label: 'Simpan tanaman',
                        loading: _saving,
                        block: true,
                        onPressed: _save,
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        label: 'Batal',
                        variant: AppButtonVariant.outline,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    ),
  );
}
