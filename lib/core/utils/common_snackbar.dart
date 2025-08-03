import 'package:flutter/material.dart';

void showCommonSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Accent line flush left
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF042F46),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Remove left margin
              const SizedBox(width: 0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Color(0xFF042F46),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.1,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0x11042F46), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 12,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
    ),
  );
}

/// Safely shows a snackbar using post-frame callback to avoid build-time issues
void showSafeSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    }
  });
}

/// Safely shows a common snackbar using post-frame callback to avoid build-time issues
void showSafeCommonSnackbar(BuildContext context, String message) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      showCommonSnackbar(context, message);
    }
  });
} 