// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'custom_button.dart';

class AlertPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;

  const AlertPopup({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.backgroundColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 48,
                color: iconColor ?? Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (cancelText != null)
                  Expanded(
                    child: CustomButton(
                      text: cancelText!,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCancel?.call();
                      },
                      backgroundColor: Colors.grey[300],
                      textColor: Colors.black87,
                    ),
                  ),
                if (cancelText != null && confirmText != null)
                  const SizedBox(width: 16),
                if (confirmText != null)
                  Expanded(
                    child: CustomButton(
                      text: confirmText!,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm?.call();
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertPopup(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        backgroundColor: backgroundColor,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}
