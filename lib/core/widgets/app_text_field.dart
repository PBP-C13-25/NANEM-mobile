import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// Kolom form dengan label di atas (.form-group).
///
/// ```dart
/// AppTextField(
///   label: 'Nama lahan',
///   controller: _landName,
///   hint: 'Contoh: Kebun belakang rumah',
///   validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama lahan wajib diisi.' : null,
/// )
/// AppTextField(label: 'Kata sandi', controller: _password, isPassword: true)
/// ```
///
/// Taruh di dalam `Form` supaya `validator` berjalan.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helperText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.prefixIcon,
    this.suffixText,
    this.maxLength,
    this.maxLines = 1,
    this.isPassword = false,
    this.autofocus = false,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;

  /// Teks contoh di dalam kolom (placeholder).
  final String? hint;

  /// Teks bantuan kecil di bawah kolom (.field-hint).
  final String? helperText;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final IconData? prefixIcon;

  /// Satuan di kanan kolom, mis. 'm²'.
  final String? suffixText;

  final int? maxLength;

  /// Lebih dari 1 = textarea.
  final int maxLines;

  /// Menyembunyikan teks dan menampilkan tombol mata.
  final bool isPassword;

  final bool autofocus;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          maxLength: widget.maxLength,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.maxLines > 1 ? widget.maxLines : null,
          obscureText: widget.isPassword && _obscure,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          style: const TextStyle(color: AppColors.text),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            helperMaxLines: 3,
            errorMaxLines: 3,
            suffixText: widget.suffixText,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, size: 20, color: AppColors.muted),
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscure ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
                    icon: Icon(
                      _obscure ? AppIcons.visibility : AppIcons.visibilityOff,
                      size: 20,
                      color: AppColors.muted,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
