import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// Tinggi kolom pencarian, sama dengan .search-field--sm / default / --lg.
/// Default 36
enum SearchFieldSize {
  sm(32),
  md(36),
  lg(54);

  const SearchFieldSize(this.height);

  final double height;
}

/// Kolom pencarian: ikon kaca pembesar + input + tombol X (.search-field).
///
/// ```dart
/// SearchField(
///   hintText: 'Cari nama lahan...',
///   debounce: const Duration(milliseconds: 400), // cari otomatis saat mengetik
///   onChanged: (q) => _load(query: q),
/// )
/// ```
///
/// Tombol X mengosongkan kolom lalu memanggil `onChanged('')` dan `onCleared`.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.controller,
    this.hintText = 'Cari...',
    this.size = SearchFieldSize.md,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.debounce,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final SearchFieldSize size;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onCleared;

  /// Jeda sebelum `onChanged` dipanggil, supaya tidak request ke server
  /// di setiap ketikan. Kosong = langsung dipanggil.
  final Duration? debounce;

  final bool autofocus;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController? _ownController;
  Timer? _timer;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void dispose() {
    _timer?.cancel();
    _ownController?.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final delay = widget.debounce;
    if (delay == null) {
      widget.onChanged?.call(value);
      return;
    }
    _timer?.cancel();
    _timer = Timer(delay, () => widget.onChanged?.call(value));
  }

  void _handleSubmitted(String value) {
    _timer?.cancel();
    widget.onSubmitted?.call(value);
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    final small = widget.size == SearchFieldSize.sm;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.box),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return SizedBox(
      height: widget.size.height,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) => TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          // expands: kolom mengisi penuh tinggi SizedBox di atas
          expands: true,
          maxLines: null,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          onChanged: _handleChanged,
          onSubmitted: _handleSubmitted,
          style: TextStyle(
            fontSize: small ? 14.5 : 15.5,
            color: AppColors.text,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColors.muted),
            isDense: true,
            filled: true,
            fillColor: AppColors.surface,
            hoverColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(right: 12),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: small ? 12 : 16, right: 10),
              child: Icon(
                AppIcons.search,
                size: small ? 18 : 20,
                color: AppColors.muted,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    icon: const Icon(
                      AppIcons.x,
                      size: 16,
                      color: AppColors.muted,
                    ),
                    onPressed: _clear,
                  ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
