import 'package:flutter/material.dart';

class AppSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    final snackBar = SnackBar(
      content: _buildContent(message, type),
      backgroundColor: _getBackgroundColor(type),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _getBorderColor(type),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 12,
      duration: duration ?? _getDefaultDuration(type),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      action: onActionPressed != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: _getActionColor(type),
              onPressed: onActionPressed,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget _buildContent(String message, SnackbarType type) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Accent line
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: _getAccentColor(type),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            // Icon
            Icon(
              _getIcon(type),
              color: _getIconColor(type),
              size: 20,
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: _getTextColor(type),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.1,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFFE8F5E8);
      case SnackbarType.error:
        return const Color(0xFFFEE8E8);
      case SnackbarType.warning:
        return const Color(0xFFFFF8E1);
      case SnackbarType.info:
        return Colors.white;
    }
  }

  static Color _getBorderColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF4CAF50).withOpacity(0.2);
      case SnackbarType.error:
        return const Color(0xFFF44336).withOpacity(0.2);
      case SnackbarType.warning:
        return const Color(0xFFFF9800).withOpacity(0.2);
      case SnackbarType.info:
        return const Color(0xFF042F46).withOpacity(0.1);
    }
  }

  static Color _getAccentColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF4CAF50);
      case SnackbarType.error:
        return const Color(0xFFF44336);
      case SnackbarType.warning:
        return const Color(0xFFFF9800);
      case SnackbarType.info:
        return const Color(0xFF042F46);
    }
  }

  static Color _getTextColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF2E7D32);
      case SnackbarType.error:
        return const Color(0xFFD32F2F);
      case SnackbarType.warning:
        return const Color(0xFFE65100);
      case SnackbarType.info:
        return const Color(0xFF042F46);
    }
  }

  static Color _getIconColor(SnackbarType type) {
    return _getAccentColor(type);
  }

  static Color _getActionColor(SnackbarType type) {
    return _getAccentColor(type);
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_outlined;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }

  static Duration _getDefaultDuration(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Duration(seconds: 3);
      case SnackbarType.error:
        return const Duration(seconds: 4);
      case SnackbarType.warning:
        return const Duration(seconds: 4);
      case SnackbarType.info:
        return const Duration(seconds: 3);
    }
  }

  // Convenience methods
  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  static void info(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    show(
      context: context,
      message: message,
      type: SnackbarType.info,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }
}

enum SnackbarType {
  success,
  error,
  warning,
  info,
} 