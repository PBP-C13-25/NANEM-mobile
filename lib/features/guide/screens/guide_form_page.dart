import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/widgets.dart';
import '../models/guide_models.dart';
import '../service/guide_service.dart';

class GuideFormPage extends StatefulWidget {
  const GuideFormPage({super.key, required this.plantId});

  final int plantId;

  @override
  State<GuideFormPage> createState() => _GuideFormPageState();
}

class _GuideFormPageState extends State<GuideFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _steps = TextEditingController();
  final _wateringNote = TextEditingController();
  final _fertilizingNote = TextEditingController();
  final _harvestMin = TextEditingController();
  final _harvestMax = TextEditingController();
  final _harvestNote = TextEditingController();

  String _watering = 'when_dry';
  String _fertilizing = 'as_needed';
  bool _harvestable = true;
  bool _loading = true;
  bool _saving = false;
  bool _exists = false;
  String _plantName = '';
  String? _loadError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _steps.dispose();
    _wateringNote.dispose();
    _fertilizingNote.dispose();
    _harvestMin.dispose();
    _harvestMax.dispose();
    _harvestNote.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final result = await GuideService.instance.fetchGuide(widget.plantId);
      if (!mounted) return;
      final guide = result.guide;
      setState(() {
        _plantName = result.plantName;
        _exists = guide != null;
        if (guide != null) {
          _steps.text = guide.steps.join('\n');
          _watering = guide.wateringFrequency;
          _wateringNote.text = guide.wateringNote;
          _fertilizing = guide.fertilizingFrequency;
          _fertilizingNote.text = guide.fertilizingNote;
          _harvestable = guide.isHarvestable;
          _harvestMin.text = guide.harvestDaysMin?.toString() ?? '';
          _harvestMax.text = guide.harvestDaysMax?.toString() ?? '';
          _harvestNote.text = guide.harvestNote;
        }
        _loading = false;
      });
    } on GuideApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.message;
        _loading = false;
      });
    }
  }

  List<String> _stepLines() {
    return _steps.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  String? _validateSteps(String? value) {
    final lines = _stepLines();
    if (lines.length < 3) {
      return 'Isi minimal 3 langkah menanam, satu langkah per baris.';
    }
    final tooShort = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].length < 5) tooShort.add('${i + 1}');
    }
    if (tooShort.isNotEmpty) {
      return 'Setiap langkah minimal 5 karakter. Periksa langkah nomor ${tooShort.join(', ')}.';
    }
    return null;
  }

  String? _validateDays(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    final number = int.tryParse(text);
    if (number == null || number < 1) return 'Isi angka minimal 1.';
    return null;
  }

  String? _validateHarvestMin(String? value) {
    final invalid = _validateDays(value);
    if (invalid != null) return invalid;
    if (_harvestable &&
        _harvestMin.text.trim().isEmpty &&
        _harvestMax.text.trim().isEmpty &&
        _harvestNote.text.trim().isEmpty) {
      return 'Isi perkiraan hari panen atau tulis catatan panen.';
    }
    return null;
  }

  String? _validateHarvestMax(String? value) {
    final invalid = _validateDays(value);
    if (invalid != null) return invalid;
    final minimum = int.tryParse(_harvestMin.text.trim());
    final maximum = int.tryParse((value ?? '').trim());
    if (minimum != null && maximum != null && minimum > maximum) {
      return 'Hari panen paling lambat tidak boleh lebih kecil dari yang paling cepat.';
    }
    return null;
  }

  Map<String, dynamic> _payload() {
    return {
      'planting_steps': _stepLines(),
      'watering_frequency': _watering,
      'watering_note': _wateringNote.text.trim(),
      'fertilizing_frequency': _fertilizing,
      'fertilizing_note': _fertilizingNote.text.trim(),
      'is_harvestable': _harvestable,
      'harvest_days_min': _harvestable ? int.tryParse(_harvestMin.text.trim()) : null,
      'harvest_days_max': _harvestable ? int.tryParse(_harvestMax.text.trim()) : null,
      'harvest_note': _harvestable ? _harvestNote.text.trim() : '',
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _submitError = null;
    });
    try {
      await GuideService.instance.saveGuide(widget.plantId, _payload(), exists: _exists);
      if (!mounted) return;
      showToast(
        context,
        _exists ? 'Panduan berhasil diperbarui.' : 'Panduan berhasil ditambahkan.',
      );
      Navigator.of(context).pop();
    } on GuideApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = e.message;
        _saving = false;
      });
    }
  }

  Future<void> _delete() async {
    final confirmed = await showAppDialog<bool>(
      context,
      builder: (dialogContext) => AppDialogContent(
        title: 'Hapus panduan?',
        icon: AppIcons.trash,
        danger: true,
        message: 'Panduan budidaya untuk',
        item: _plantName,
        actions: [
          AppButton(
            label: 'Batal',
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton(
            label: 'Hapus',
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() {
      _saving = true;
      _submitError = null;
    });
    try {
      await GuideService.instance.deleteGuide(widget.plantId);
      if (!mounted) return;
      showToast(context, 'Panduan berhasil dihapus.');
      Navigator.of(context).pop();
    } on GuideApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = e.message;
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanemAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: AppSpinner());
    }
    if (_loadError != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppAlert(message: _loadError!, type: MessageType.error),
          const SizedBox(height: 12),
          AppButton(label: 'Coba lagi', variant: AppButtonVariant.outline, onPressed: _load),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _exists ? 'Edit Panduan' : 'Tambah Panduan',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(_plantName, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Cara menanam',
            controller: _steps,
            maxLines: 6,
            helperText: 'Tulis satu langkah per baris.',
            validator: _validateSteps,
          ),
          const SizedBox(height: 16),
          const Text(
            'Frekuensi penyiraman',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _watering,
            isExpanded: true,
            items: wateringChoices.entries
                .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: (value) => setState(() => _watering = value ?? _watering),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Catatan penyiraman',
            controller: _wateringNote,
            maxLines: 2,
            hint: 'Opsional',
          ),
          const SizedBox(height: 16),
          const Text(
            'Frekuensi pemupukan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _fertilizing,
            isExpanded: true,
            items: fertilizingChoices.entries
                .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: (value) => setState(() => _fertilizing = value ?? _fertilizing),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Jenis dan catatan pupuk',
            controller: _fertilizingNote,
            maxLines: 2,
            hint: 'Opsional',
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tanaman ini dipanen'),
            value: _harvestable,
            activeThumbColor: AppColors.primary,
            onChanged: (value) => setState(() => _harvestable = value),
          ),
          if (_harvestable) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Panen tercepat',
                    controller: _harvestMin,
                    suffixText: 'hari',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validateHarvestMin,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Panen terlambat',
                    controller: _harvestMax,
                    suffixText: 'hari',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validateHarvestMax,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Catatan panen',
              controller: _harvestNote,
              maxLines: 2,
              hint: 'Opsional',
            ),
          ],
          if (_submitError != null) ...[
            const SizedBox(height: 16),
            AppAlert(message: _submitError!, type: MessageType.error),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: 'Simpan',
            icon: AppIcons.check,
            block: true,
            loading: _saving,
            onPressed: _save,
          ),
          if (_exists) ...[
            const SizedBox(height: 12),
            AppButton(
              label: 'Hapus panduan',
              icon: AppIcons.trash,
              variant: AppButtonVariant.danger,
              block: true,
              onPressed: _saving ? null : _delete,
            ),
          ],
        ],
      ),
    );
  }
}