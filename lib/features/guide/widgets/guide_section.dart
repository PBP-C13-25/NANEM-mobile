import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';
import '../models/guide_models.dart';
import '../service/guide_service.dart';

class GuideSection extends StatefulWidget {
  const GuideSection({super.key, required this.plantId});

  final int plantId;

  @override
  State<GuideSection> createState() => _GuideSectionState();
}

class _GuideSectionState extends State<GuideSection> {
  late Future<GuideResult> _future;

  @override
  void initState() {
    super.initState();
    _future = GuideService.instance.fetchGuide(widget.plantId);
  }

  void _reload() {
    setState(() {
      _future = GuideService.instance.fetchGuide(widget.plantId);
    });
  }

  void _openForm() {
    Navigator.of(context)
        .pushNamed(Routes.adminGuideForm, arguments: widget.plantId)
        .then((_) => _reload());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GuideResult>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppCard(
            title: 'Panduan Budidaya',
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: AppSpinner(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return AppCard(
            title: 'Panduan Budidaya',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAlert(message: snapshot.error.toString(), type: MessageType.error),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Coba lagi',
                  variant: AppButtonVariant.outline,
                  onPressed: _reload,
                ),
              ],
            ),
          );
        }

        final guide = snapshot.data!.guide;
        if (guide == null) {
          return AppCard(
            title: 'Panduan Budidaya',
            child: Column(
              children: [
                const EmptyState(
                  icon: AppIcons.clipboardList,
                  title: 'Panduan belum tersedia',
                  text: 'Panduan budidaya untuk tanaman ini belum ditambahkan.',
                ),
                if (AuthState.instance.isStaff) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Tambah panduan',
                    icon: AppIcons.pencil,
                    onPressed: _openForm,
                  ),
                ],
              ],
            ),
          );
        }

        return AppCard(
          title: 'Panduan Budidaya',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Heading(icon: AppIcons.sprout, label: 'Cara menanam'),
              const SizedBox(height: 8),
              for (var i = 0; i < guide.steps.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(guide.steps[i], style: const TextStyle(height: 1.4)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              _InfoBlock(
                icon: AppIcons.droplets,
                heading: 'Penyiraman',
                value: guide.wateringLabel,
                note: guide.wateringNote,
              ),
              const SizedBox(height: 16),
              _InfoBlock(
                icon: AppIcons.leaf,
                heading: 'Pemupukan',
                value: guide.fertilizingLabel,
                note: guide.fertilizingNote,
              ),
              const SizedBox(height: 16),
              _InfoBlock(
                icon: AppIcons.calendar,
                heading: 'Waktu panen',
                value: guide.harvestLabel,
                note: guide.harvestNote,
              ),
              if (AuthState.instance.isStaff) ...[
                const SizedBox(height: 20),
                AppButton(
                  label: 'Edit panduan',
                  icon: AppIcons.pencil,
                  variant: AppButtonVariant.outline,
                  block: true,
                  onPressed: _openForm,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.heading,
    required this.value,
    required this.note,
  });

  final IconData icon;
  final String heading;
  final String value;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Heading(icon: icon, label: heading),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (note.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(note, style: const TextStyle(color: AppColors.muted, height: 1.4)),
        ],
      ],
    );
  }
}