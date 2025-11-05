import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool hasGradient;
  final Widget? leading;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.hasGradient = false,
    this.leading,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasGradient
          ? const BoxDecoration(gradient: AppColors.primaryGradient)
          : null,
      child: AppBar(
        title: Text(
          title,
          style: AppTextStyles.headline3.copyWith(
            color: hasGradient ? Colors.white : null,
          ),
        ),
        leading: leading ??
            (showBackButton
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: hasGradient ? Colors.white : null,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                  )
                : null),
        actions: actions,
        elevation: hasGradient ? 0 : null,
        backgroundColor: hasGradient ? Colors.transparent : null,
        foregroundColor: hasGradient ? Colors.white : null,
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
