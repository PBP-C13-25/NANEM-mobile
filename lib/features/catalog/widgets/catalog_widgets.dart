import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import '../service/catalog_service.dart';

class PlantImage extends StatelessWidget {
  const PlantImage({
    super.key,
    required this.url,
    required this.name,
    this.height = 190,
  });
  final String url, name;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: AppColors.hover,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.sprout, color: AppColors.primary, size: 36),
            SizedBox(height: 8),
            Text(
              'Gambar belum tersedia',
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.box),
      child: url.isEmpty
          ? fallback
          : Image.network(
              url,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: name,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}

class PlantSelect extends StatelessWidget {
  const PlantSelect({
    super.key,
    required this.label,
    required this.value,
    required this.choices,
    required this.onChanged,
    this.emptyLabel = 'Semua',
    this.validator,
  });
  final String label, value, emptyLabel;
  final Map<String, String> choices;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        key: ValueKey('$label:$value'),
        initialValue: value,
        isExpanded: true,
        menuMaxHeight: 320,
        icon: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.expand_more),
        ),
        items: [
          DropdownMenuItem(value: '', child: Text(emptyLabel)),
          for (final entry in choices.entries)
            DropdownMenuItem(value: entry.key, child: Text(entry.value)),
        ],
        onChanged: onChanged == null
            ? null
            : (value) => onChanged!(value ?? ''),
        validator: validator,
      ),
    ],
  );
}

String catalogErrorText(Object? error) => error is CatalogApiException
    ? error.message
    : 'Data belum dapat dimuat. Silakan coba lagi.';

class CatalogFailure extends StatelessWidget {
  const CatalogFailure({super.key, required this.error, required this.onRetry});
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
    title: 'Data belum bisa dimuat',
    text: catalogErrorText(error),
    actionLabel: 'Coba lagi',
    onAction: onRetry,
  );
}

class PlantFact extends StatelessWidget {
  const PlantFact(this.label, this.value, {super.key});
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(color: AppColors.muted)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
