import 'package:flutter/material.dart';

import '../core/widgets/widgets.dart';

/// Katalog komponen untuk melihat & mencoba semua widget di core/widgets.
/// Dibuka dari Profil Saya → "Lihat komponen (dev)" (hanya saat debug).
/// Route: Routes.devComponents.
class ComponentsPreviewPage extends StatefulWidget {
  const ComponentsPreviewPage({super.key});

  @override
  State<ComponentsPreviewPage> createState() => _ComponentsPreviewPageState();
}

class _ComponentsPreviewPageState extends State<ComponentsPreviewPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _fakeSave() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    showToast(context, 'Rekomendasi disimpan ke riwayat.');
  }

  Future<void> _confirm({required bool danger}) async {
    final ok = await showConfirmDialog(
      context,
      title: danger ? 'Hapus riwayat?' : 'Simpan perubahan?',
      message: danger ? 'Riwayat ini akan dihapus permanen:' : 'Perubahan akan langsung disimpan.',
      item: danger ? 'Kebun belakang' : null,
      confirmLabel: danger ? 'Ya, hapus' : 'Ya, lanjut',
      danger: danger,
    );
    if (!mounted) return;
    showToast(context, ok ? 'Dikonfirmasi.' : 'Dibatalkan.', type: MessageType.info);
  }

  Future<void> _rename() async {
    final name = await showRenameDialog(context, initialValue: 'Kebun belakang');
    if (!mounted || name == null) return;
    showToast(context, 'Nama lahan diubah menjadi "$name".');
  }

  Future<void> _loadingModal() async {
    await runWithLoading(
      context,
      () => Future<void>.delayed(const Duration(seconds: 2)),
      title: 'Mencari tanaman yang cocok…',
      text: 'Mengambil data cuaca dari Open-Meteo.',
    );
    if (mounted) showToast(context, 'Selesai.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanemAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const DisplayTitle(title: 'Komponen', ghost: 'Nanem Mobile'),
          _Section(
            title: 'AppButton',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                AppButton(label: 'Danger', variant: AppButtonVariant.danger, onPressed: () {}),
                AppButton(label: 'Dark', variant: AppButtonVariant.dark, onPressed: () {}),
                AppButton(label: 'Ghost', variant: AppButtonVariant.ghost, onPressed: () {}),
                AppButton(label: 'Outline', variant: AppButtonVariant.outline, onPressed: () {}),
                AppButton(label: 'Ikon', icon: AppIcons.search, onPressed: () {}),
                const AppButton(label: 'Nonaktif', onPressed: null),
                AppButton(
                  label: _loading ? 'Menyimpan...' : 'Loading (klik)',
                  loading: _loading,
                  onPressed: _fakeSave,
                ),
                AppButton(label: 'Block', block: true, onPressed: () {}),
              ],
            ),
          ),
          _Section(
            title: 'SearchField',
            child: SearchField(
              hintText: 'Cari nama lahan...',
              debounce: const Duration(milliseconds: 400),
              onChanged: (q) => debugPrint('cari: $q'),
            ),
          ),
          _Section(
            title: 'AppTextField',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Nama lahan',
                    hint: 'Contoh: Kebun belakang rumah',
                    helperText: 'Maksimal 100 karakter.',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Nama lahan wajib diisi.' : null,
                  ),
                  const SizedBox(height: 14),
                  const AppTextField(
                    label: 'Luas lahan',
                    suffixText: 'm²',
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 14),
                  const AppTextField(label: 'Kata sandi', isPassword: true),
                  const SizedBox(height: 14),
                  const AppTextField(label: 'Deskripsi', maxLines: 4),
                  const SizedBox(height: 14),
                  AppButton(
                    label: 'Coba validasi',
                    variant: AppButtonVariant.outline,
                    block: true,
                    onPressed: () => _formKey.currentState!.validate(),
                  ),
                ],
              ),
            ),
          ),
          const _Section(
            title: 'AppAlert',
            child: Column(
              children: [
                AppAlert(message: 'Akun berhasil dibuat.', type: MessageType.success),
                SizedBox(height: 8),
                AppAlert(message: 'Username atau kata sandi salah.', type: MessageType.error),
                SizedBox(height: 8),
                AppAlert(message: 'Data cuaca mungkin belum lengkap.', type: MessageType.warning),
                SizedBox(height: 8),
                AppAlert(message: 'Hasil rekomendasi tidak dapat diubah.'),
              ],
            ),
          ),
          _Section(
            title: 'Toast',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in MessageType.values)
                  AppButton(
                    label: type.name,
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    onPressed: () => showToast(context, 'Contoh pesan ${type.name}.', type: type),
                  ),
              ],
            ),
          ),
          _Section(
            title: 'Dialog',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(
                  label: 'Konfirmasi',
                  variant: AppButtonVariant.outline,
                  onPressed: () => _confirm(danger: false),
                ),
                AppButton(
                  label: 'Hapus',
                  variant: AppButtonVariant.danger,
                  onPressed: () => _confirm(danger: true),
                ),
                AppButton(
                  label: 'Ubah nama',
                  variant: AppButtonVariant.outline,
                  icon: AppIcons.pencil,
                  onPressed: _rename,
                ),
                AppButton(
                  label: 'Loading',
                  variant: AppButtonVariant.outline,
                  onPressed: _loadingModal,
                ),
              ],
            ),
          ),
          _Section(
            title: 'AppCard',
            child: AppCard(
              title: 'Masuk',
              text: 'Masuk untuk menyimpan riwayat rekomendasi.',
              actions: [
                AppButton(label: 'Batal', variant: AppButtonVariant.ghost, onPressed: () {}),
                AppButton(label: 'Masuk', onPressed: () {}),
              ],
              footer: const Text('Belum punya akun? Daftar'),
            ),
          ),
          const _Section(
            title: 'AppAvatar & AppSpinner',
            child: Row(
              children: [
                AppAvatar(name: 'jihan'),
                SizedBox(width: 12),
                AppAvatar(name: 'hafidz', size: 56),
                SizedBox(width: 24),
                AppSpinner(),
                SizedBox(width: 16),
                AppSpinner(size: 18),
              ],
            ),
          ),
          _Section(
            title: 'EmptyState',
            child: EmptyState(
              icon: AppIcons.history,
              title: 'Belum ada riwayat',
              text: 'Hasil rekomendasi yang kamu simpan bakal muncul di sini.',
              actionLabel: 'Cari Rekomendasi',
              onAction: () => showToast(context, 'Tombol ditekan.', type: MessageType.info),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
