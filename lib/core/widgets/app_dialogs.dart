import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'app_button.dart';
import 'app_spinner.dart';
import 'app_text_field.dart';

// ============================================================================
// Pemakaian cepat:
//
//   final yakin = await showConfirmDialog(
//     context,
//     title: 'Hapus riwayat?',
//     message: 'Riwayat ini akan dihapus permanen:',
//     item: history.landName,
//     confirmLabel: 'Ya, hapus',
//     danger: true,
//   );
//   if (yakin) { ... }
//
//   final namaBaru = await showRenameDialog(context, initialValue: history.landName);
//   if (namaBaru != null) { ... }
//
//   final hasil = await runWithLoading(
//     context,
//     () => service.generate(input),
//     title: 'Mencari tanaman yang cocok…',
//     text: 'Mengambil data cuaca dari Open-Meteo.',
//   );
// ============================================================================

/// Isi modal (.dialog): ikon bulat, judul, teks, isi tambahan, dua tombol.
/// Dipakai oleh semua dialog di bawah; bisa juga dipakai untuk dialog baru.
class AppDialogContent extends StatelessWidget {
  const AppDialogContent({
    super.key,
    required this.title,
    this.icon,
    this.danger = false,
    this.message,
    this.item,
    this.body,
    this.actions = const [],
    this.showClose = true,
  });

  final String title;
  final IconData? icon;

  /// Ikon merah (.dialog__icon--danger).
  final bool danger;

  final String? message;

  /// Nama item yang ditampilkan tebal setelah `message`.
  final String? item;

  /// Isi tambahan rata kiri, mis. kolom form (.dialog__body).
  final Widget? body;

  /// Tombol, dibuat sama lebar dan berdampingan (.dialog__actions).
  final List<Widget> actions;

  /// Tombol X di pojok kanan atas.
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: danger ? AppColors.dangerSoft : AppColors.primarySoft,
                    ),
                    child: Icon(icon, size: 22, color: danger ? AppColors.danger : AppColors.primary),
                  ),
                  const SizedBox(height: 14),
                ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                if (message != null || item != null) ...[
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      text: message,
                      children: [
                        if (item != null)
                          TextSpan(
                            text: message == null ? item : ' $item',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14.7, height: 1.5, color: AppColors.muted),
                  ),
                ],
                if (body != null) ...[
                  const SizedBox(height: 18),
                  SizedBox(width: double.infinity, child: body),
                ],
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      for (var i = 0; i < actions.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(child: actions[i]),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (showClose)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                tooltip: 'Tutup',
                visualDensity: VisualDensity.compact,
                icon: const Icon(AppIcons.x, size: 18, color: AppColors.muted),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}

/// Wadah modal (.modal): putih, sudut 16, maksimal 400px.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool dismissible = true,
  double maxWidth = 400,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: AppColors.barrier,
    builder: (dialogContext) => Dialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: builder(dialogContext),
      ),
    ),
  );
}

/// Modal konfirmasi (confirm_modal.html). Mengembalikan `true` jika user setuju.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? item,
  String confirmLabel = 'Ya, lanjut',
  String cancelLabel = 'Batal',
  bool danger = false,
}) async {
  final result = await showAppDialog<bool>(
    context,
    builder: (dialogContext) => AppDialogContent(
      icon: danger ? AppIcons.trash : AppIcons.info,
      danger: danger,
      title: title,
      message: message,
      item: item,
      actions: [
        AppButton(
          label: cancelLabel,
          variant: AppButtonVariant.outline,
          block: true,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        AppButton(
          label: confirmLabel,
          variant: danger ? AppButtonVariant.danger : AppButtonVariant.primary,
          block: true,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Modal ubah nama (rename_modal.html). Mengembalikan nama baru (sudah di-trim),
/// atau `null` jika dibatalkan.
Future<String?> showRenameDialog(
  BuildContext context, {
  required String initialValue,
  String title = 'Ubah Nama Lahan',
  String message = 'Nama ini cuma buat penanda di riwayatmu.',
  String label = 'Nama lahan',
  String saveLabel = 'Simpan',
  int maxLength = 100,
}) {
  return showAppDialog<String>(
    context,
    builder: (_) => _RenameDialog(
      initialValue: initialValue,
      title: title,
      message: message,
      label: label,
      saveLabel: saveLabel,
      maxLength: maxLength,
    ),
  );
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({
    required this.initialValue,
    required this.title,
    required this.message,
    required this.label,
    required this.saveLabel,
    required this.maxLength,
  });

  final String initialValue;
  final String title;
  final String message;
  final String label;
  final String saveLabel;
  final int maxLength;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '${widget.label} wajib diisi.';
    if (text.length > widget.maxLength) {
      return '${widget.label} maksimal ${widget.maxLength} karakter.';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AppDialogContent(
        icon: AppIcons.pencil,
        title: widget.title,
        message: widget.message,
        body: AppTextField(
          label: widget.label,
          controller: _controller,
          maxLength: widget.maxLength,
          autofocus: true,
          textInputAction: TextInputAction.done,
          validator: _validate,
          onFieldSubmitted: (_) => _submit(),
        ),
        actions: [
          AppButton(
            label: 'Batal',
            variant: AppButtonVariant.outline,
            block: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton(label: widget.saveLabel, block: true, onPressed: _submit),
        ],
      ),
    );
  }
}

/// Modal loading (loading_modal.html). Tampil selama `task` berjalan, tidak
/// bisa ditutup user, dan tertutup sendiri walaupun `task` gagal.
Future<T> runWithLoading<T>(
  BuildContext context,
  Future<T> Function() task, {
  String title = 'Memproses…',
  String? text,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);

  showAppDialog<void>(
    context,
    dismissible: false,
    maxWidth: 340,
    builder: (_) => PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSpinner(),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            if (text != null) ...[
              const SizedBox(height: 6),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14.7, height: 1.5, color: AppColors.muted),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  try {
    return await task();
  } finally {
    navigator.pop();
  }
}
