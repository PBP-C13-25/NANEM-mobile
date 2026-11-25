import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'app_alert.dart';

/// Toast di bawah layar (toaster.html), pengganti `messages.success(...)` di Django.
///
/// ```dart
/// showToast(context, 'Rekomendasi disimpan ke riwayat.');
/// showToast(context, 'Data cuaca belum bisa diambil.', type: MessageType.error);
/// ```
///
/// Hilang sendiri setelah 5 detik (error 8 detik), bisa ditutup dengan X atau
/// digeser. Otomatis muncul di atas navigasi bawah.
void showToast(
  BuildContext context,
  String message, {
  MessageType type = MessageType.success,
  String? title,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  final duration = Duration(seconds: type == MessageType.error ? 8 : 5);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        clipBehavior: Clip.none,
        duration: duration,
        content: _ToastCard(
          type: type,
          title: title ?? _defaultTitle(type),
          message: message,
          duration: duration,
          onClose: messenger.hideCurrentSnackBar,
        ),
      ),
    );
}

String _defaultTitle(MessageType type) {
  switch (type) {
    case MessageType.success:
      return 'Berhasil!';
    case MessageType.error:
      return 'Gagal!';
    case MessageType.warning:
      return 'Perhatian!';
    case MessageType.info:
      return 'Info';
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({
    required this.type,
    required this.title,
    required this.message,
    required this.duration,
    required this.onClose,
  });

  final MessageType type;
  final String title;
  final String message;
  final Duration duration;
  final VoidCallback onClose;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> with SingleTickerProviderStateMixin {
  late final AnimationController _progress =
      AnimationController(vsync: this, duration: widget.duration)..forward();

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground, iconColor) = switch (widget.type) {
      MessageType.success => (AppColors.toastSuccess, Colors.white, AppColors.toastSuccess),
      MessageType.error => (AppColors.toastError, Colors.white, AppColors.toastError),
      MessageType.info => (AppColors.toastInfo, Colors.white, AppColors.toastInfo),
      MessageType.warning => (
          AppColors.toastWarning,
          AppColors.toastWarningText,
          AppColors.toastWarningIcon,
        ),
    };

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.box),
        boxShadow: const [
          BoxShadow(color: Color(0x38141E0F), blurRadius: 30, offset: Offset(0, 12)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.box),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(widget.type.icon, size: 18, color: iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 15.7,
                              fontWeight: FontWeight.w700,
                              color: foreground,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.message,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.45,
                              color: foreground.withAlpha(235),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup notifikasi',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(AppIcons.x, size: 18, color: foreground),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            // Garis waktu di bawah, memendek sampai toast hilang
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 4,
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) => Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 1 - _progress.value,
                    heightFactor: 1,
                    child: Container(color: Colors.white.withAlpha(115)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
