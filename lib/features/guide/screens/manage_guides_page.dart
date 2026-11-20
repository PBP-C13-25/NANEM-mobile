import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/widgets.dart';
import '../models/guide_models.dart';
import '../service/guide_service.dart';

class ManageGuidesPage extends StatefulWidget {
  const ManageGuidesPage({super.key, this.plantId});

  final int? plantId;

  @override
  State<ManageGuidesPage> createState() => _ManageGuidesPageState();
}

class _ManageGuidesPageState extends State<ManageGuidesPage> {
  String _query = '';
  String _status = '';
  int _requestId = 0;
  bool _loading = true;
  String? _error;
  GuideListResult? _result;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await GuideService.instance.fetchGuideList(
        query: _query,
        status: _status,
      );
      if (!mounted || id != _requestId) return;
      setState(() {
        _result = result;
        _loading = false;
      });
    } on GuideApiException catch (e) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  void _setStatus(String status) {
    if (_status == status) return;
    _status = status;
    _load();
  }

  void _openForm(GuideListItem item) {
    Navigator.of(context)
        .pushNamed(Routes.adminGuideForm, arguments: item.plantId)
        .then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: const NanemAppBar(),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Kelola Panduan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.text),
            ),
            const SizedBox(height: 4),
            Text(
              result == null
                  ? 'Tambah, ubah, dan hapus panduan budidaya tiap tanaman.'
                  : '${result.summary.withGuide} dari ${result.summary.total} tanaman sudah punya panduan.',
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            SearchField(
              hintText: 'Cari nama tanaman',
              size: SearchFieldSize.lg,
              debounce: const Duration(milliseconds: 400),
              onChanged: (value) {
                _query = value;
                _load();
              },
              onCleared: () {
                _query = '';
                _load();
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: _status == '',
                  onSelected: (_) => _setStatus(''),
                ),
                ChoiceChip(
                  label: const Text('Sudah ada'),
                  selected: _status == 'ada',
                  onSelected: (_) => _setStatus('ada'),
                ),
                ChoiceChip(
                  label: const Text('Belum ada'),
                  selected: _status == 'belum',
                  onSelected: (_) => _setStatus('belum'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading && result == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: AppSpinner()),
              )
            else if (_error != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAlert(message: _error!, type: MessageType.error),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Coba lagi',
                    variant: AppButtonVariant.outline,
                    onPressed: _load,
                  ),
                ],
              )
            else if (result != null && result.items.isEmpty)
              const EmptyState(
                icon: AppIcons.search,
                title: 'Tanaman tidak ditemukan',
                text: 'Coba kata kunci atau filter lain.',
              )
            else if (result != null)
              for (final item in result.items) ...[
                AppCard(
                  title: item.name,
                  text: [
                    if (item.scientificName != null && item.scientificName!.isNotEmpty)
                      item.scientificName!,
                    item.categoryLabel,
                    item.hasGuide ? 'Panduan sudah ada' : 'Belum ada panduan',
                  ].where((part) => part.isNotEmpty).join(' · '),
                  onTap: () => _openForm(item),
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}