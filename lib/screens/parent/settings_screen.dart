import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            children: [
              // Profile section
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
                      child: const Text('👨‍💼', style: TextStyle(fontSize: 48)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parent Account',
                            style: AppTextStyles.headline3,
                          ),
                          Text(
                            'parent@example.com',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              
              // Notifications
              _buildSectionHeader('Notifications'),
              _buildSwitchTile(
                'Device Paused',
                'Alert when a child\'s device is paused',
                true,
                (value) {},
              ),
              _buildSwitchTile(
                'Bedtime Enforcement',
                'Notify when bedtime limits are active',
                true,
                (value) {},
              ),
              _buildSwitchTile(
                'Blocked Attempts',
                'Alert when blocked content is accessed',
                true,
                (value) {},
              ),
              _buildSwitchTile(
                'App Requests',
                'Notify of new app installation requests',
                true,
                (value) {},
              ),
              
              const Divider(),
              
              // Security
              _buildSectionHeader('Security'),
              _buildTile(
                'Change PIN',
                'Update your parent access PIN',
                Icons.lock,
                () {
                  _showChangePINDialog(context);
                },
              ),
              _buildSwitchTile(
                'Biometric Unlock',
                'Use fingerprint or face recognition',
                false,
                (value) {},
              ),
              
              const Divider(),
              
              // Data & Privacy
              _buildSectionHeader('Data & Privacy'),
              _buildTile(
                'Export Data',
                'Download all your data',
                Icons.download,
                () {
                  _showExportDialog(context);
                },
              ),
              _buildTile(
                'Clear Cache',
                'Free up storage space',
                Icons.cleaning_services,
                () {},
              ),
              _buildTile(
                'Delete Account',
                'Permanently delete your account',
                Icons.delete_forever,
                () {
                  _showDeleteAccountDialog(context);
                },
                textColor: AppColors.errorRed,
              ),
              
              const Divider(),
              
              // Appearance
              _buildSectionHeader('Appearance'),
              _buildTile(
                'Theme',
                _getThemeText(appState.themeMode),
                Icons.palette,
                () {
                  _showThemeDialog(context, appState);
                },
              ),
              _buildTile(
                'Language',
                'English',
                Icons.language,
                () {},
              ),
              
              const Divider(),
              
              // App Info
              _buildSectionHeader('App Information'),
              _buildTile(
                'Version',
                '1.0.0',
                Icons.info,
                () {},
              ),
              _buildTile(
                'Help Center',
                'FAQs and support',
                Icons.help,
                () {},
              ),
              _buildTile(
                'Contact Support',
                'Get help from our team',
                Icons.email,
                () {},
              ),
              _buildTile(
                'Rate Us',
                'Share your feedback',
                Icons.star,
                () {},
              ),
              _buildTile(
                'Terms of Service',
                'Read our terms',
                Icons.description,
                () {},
              ),
              _buildTile(
                'Privacy Policy',
                'How we protect your data',
                Icons.privacy_tip,
                () {},
              ),
              
              const Divider(),
              
              // Logout
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: const BorderSide(color: AppColors.errorRed),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: AppTextStyles.headline4.copyWith(
          color: AppColors.primaryPurple,
        ),
      ),
    );
  }
  
  Widget _buildTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      value: value,
      onChanged: onChanged,
    );
  }
  
  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System Default';
    }
  }
  
  static void _showThemeDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  static void _showChangePINDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: const Text('Enter your new 4-digit PIN to secure the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
  
  static void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Export all your monitoring data and settings?\n\n'
          'The data will be saved as a JSON file.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data exported successfully'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
  
  static void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
