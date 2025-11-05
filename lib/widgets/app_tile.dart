import 'package:flutter/material.dart';
import '../models/app_usage.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppTile extends StatelessWidget {
  final AppUsage app;
  final bool showSwitch;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTimeLimitTap;
  final VoidCallback? onTap;
  
  const AppTile({
    super.key,
    required this.app,
    this.showSwitch = true,
    this.onToggle,
    this.onTimeLimitTap,
    this.onTap,
  });
  
  Color _getCategoryColor() {
    switch (app.category.toLowerCase()) {
      case 'educational':
        return AppColors.successGreen;
      case 'games':
        return AppColors.primaryPurple;
      case 'social':
        return AppColors.infoBlue;
      case 'utilities':
        return AppColors.textTertiary;
      default:
        return AppColors.textSecondary;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              app.iconPath,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        title: Text(
          app.appName,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getCategoryColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                app.category,
                style: AppTextStyles.caption.copyWith(
                  color: _getCategoryColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              app.todayUsageFormatted,
              style: AppTextStyles.caption,
            ),
            if (app.hasTimeLimit) ...[
              const SizedBox(width: 4),
              Text(
                '/ ${app.timeLimitMinutes}m',
                style: AppTextStyles.caption.copyWith(
                  color: app.isTimeLimitReached
                      ? AppColors.errorRed
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onTimeLimitTap != null)
              IconButton(
                icon: Icon(
                  Icons.timer,
                  color: app.hasTimeLimit
                      ? AppColors.primaryPurple
                      : Colors.grey,
                ),
                onPressed: onTimeLimitTap,
                tooltip: 'Set time limit',
              ),
            if (showSwitch)
              Switch(
                value: !app.isBlocked,
                onChanged: onToggle,
              ),
          ],
        ),
      ),
    );
  }
}
