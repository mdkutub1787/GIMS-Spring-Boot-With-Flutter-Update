import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeStatus { success, warning, error, info }

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeStatus status;

  const StatusBadge({
    super.key,
    required this.text,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case BadgeStatus.success:
        backgroundColor = AppTheme.successBackground;
        textColor = AppTheme.success;
        break;
      case BadgeStatus.warning:
        backgroundColor = AppTheme.warningBackground;
        textColor = AppTheme.warning;
        break;
      case BadgeStatus.error:
        backgroundColor = AppTheme.errorBackground;
        textColor = AppTheme.error; // actually darkError in dark mode, but we'll use primary error
        break;
      case BadgeStatus.info:
        backgroundColor = AppTheme.infoBackground;
        textColor = AppTheme.info;
        break;
    }

    // Adjust for dark mode if background is too light
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      backgroundColor = backgroundColor.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
