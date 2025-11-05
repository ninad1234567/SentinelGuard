import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/child_profile_card.dart';

class ChildProfilesScreen extends StatelessWidget {
  const ChildProfilesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Child Profiles',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return appState.children.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 80)),
                      const SizedBox(height: 24),
                      Text(
                        'No Children Added Yet',
                        style: AppTextStyles.headline2,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add your first child profile to get started',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddChildDialog(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Child Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: appState.children.length,
                  itemBuilder: (context, index) {
                    final childProfile = appState.children[index];
                    return ChildProfileCard(
                      child: childProfile,
                      onTap: () {
                        appState.selectChild(childProfile);
                        _showChildDetails(context, childProfile);
                      },
                      onLongPress: () {
                        _showChildOptions(context, appState, childProfile);
                      },
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddChildDialog(context);
        },
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Child',
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
    );
  }
  
  void _showAddChildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Child Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  prefixIcon: Icon(Icons.phone_android),
                ),
              ),
            ],
          ),
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
                  content: Text('Child profile created successfully'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  void _showChildDetails(BuildContext context, child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                '${child.name}\'s Profile',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 24),
              
              _buildDetailCard('Device', child.deviceName, Icons.phone_android),
              _buildDetailCard('Age', '${child.age} years old', Icons.cake),
              _buildDetailCard('Daily Limit', child.dailyLimitFormatted, Icons.access_time),
              _buildDetailCard('Bedtime', child.bedtime, Icons.nightlight_round),
              _buildDetailCard('Wake Time', child.wakeTime, Icons.wb_sunny),
              _buildDetailCard('Today\'s Usage', '${child.todayUsageMinutes} minutes', Icons.phone_android),
              _buildDetailCard('Status', child.isDeviceActive ? 'Active' : 'Paused', Icons.info),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/screen-time');
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryPurple),
        title: Text(label, style: AppTextStyles.bodySmall),
        trailing: Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  void _showChildOptions(BuildContext context, AppState appState, child) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${child.name}\'s Device',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(
                child.isDeviceActive ? Icons.pause : Icons.play_arrow,
                color: AppColors.primaryPurple,
              ),
              title: Text(
                child.isDeviceActive ? 'Pause Device' : 'Resume Device',
              ),
              onTap: () {
                appState.toggleDevicePause(child.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: AppColors.infoBlue,
              ),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                _showAddChildDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: AppColors.errorRed,
              ),
              title: const Text('Delete Profile'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, child);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: Text(
          'Are you sure you want to delete ${child.name}\'s profile? This action cannot be undone.',
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
                SnackBar(
                  content: Text('${child.name}\'s profile deleted'),
                  backgroundColor: AppColors.errorRed,
                ),
              );
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
}
