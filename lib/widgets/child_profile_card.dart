import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class ChildProfileCard extends StatelessWidget {
  final ChildProfile child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  const ChildProfileCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });
  
  Color _getAvatarColor() {
    try {
      return Color(int.parse(child.avatarColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primaryPurple;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: _getAvatarColor().withOpacity(0.2),
                    child: Text(
                      child.avatarIcon,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: child.isDeviceActive
                            ? AppColors.successGreen
                            : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Name
              Text(
                child.name,
                style: AppTextStyles.headline4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // Device name
              Text(
                child.deviceName,
                style: AppTextStyles.caption,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Usage progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: AppTextStyles.bodySmall,
                      ),
                      Text(
                        child.remainingTime,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: child.usageProgress > 0.9
                              ? AppColors.errorRed
                              : AppColors.secondaryTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: child.usageProgress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        child.usageProgress > 0.9
                            ? AppColors.errorRed
                            : child.usageProgress > 0.75
                                ? AppColors.warningOrange
                                : AppColors.secondaryTeal,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Quick action
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
