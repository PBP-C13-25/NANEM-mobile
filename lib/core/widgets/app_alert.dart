import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// Jenis pesan, dipakai bersama oleh [AppAlert] dan `showToast`.
enum MessageType { success, error, warning, info }

extension MessageTypeIcon on MessageType {
  IconData get icon {
    switch (this) {
      case MessageType.success:
        return AppIcons.check;
      case MessageType.error:
        return AppIcons.x;
      case MessageType.warning:
        return AppIcons.warning;
      case MessageType.info:
        return AppIcons.info;
    }
  }
}

/// Kotak pesan di dalam halaman (.message dan .form-errors).
/// Cocok untuk error di atas form atau info yang harus tetap terlihat.
///
/// ```dart
/// if (_error != null) AppAlert(message: _error!, type: MessageType.error)
/// ```
class AppAlert extends StatelessWidget {
  const AppAlert({super.key, required this.message, this.type = MessageType.info});

  final String message;
  final MessageType type;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (type) {
      MessageType.success => (AppColors.messageSuccess, AppColors.toastSuccess),
      MessageType.error => (AppColors.messageError, AppColors.danger),
      MessageType.warning => (AppColors.messageWarning, AppColors.toastWarningIcon),
      MessageType.info => (AppColors.messageInfo, AppColors.text),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(type.icon, size: 18, color: foreground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: type == MessageType.error ? AppColors.danger : AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
