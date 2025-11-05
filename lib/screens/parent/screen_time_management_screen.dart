import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenTimeManagementScreen extends StatefulWidget {
  const ScreenTimeManagementScreen({super.key});
  
  @override
  State<ScreenTimeManagementScreen> createState() =>
      _ScreenTimeManagementScreenState();
}

class _ScreenTimeManagementScreenState
    extends State<ScreenTimeManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Screen Time Limits',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryPurple,
                indicatorColor: AppColors.primaryPurple,
                tabs: const [
                  Tab(text: 'Daily Limits'),
                  Tab(text: 'Schedule'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDailyLimitsTab(appState),
                    _buildScheduleTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildDailyLimitsTab(AppState appState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appState.children.length,
      itemBuilder: (context, index) {
        final child = appState.children[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      child.avatarIcon,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(child.name, style: AppTextStyles.headline3),
                          Text(
                            child.deviceName,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Daily limit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Screen Time',
                          style: AppTextStyles.bodyMedium,
                        ),
                        Text(
                          child.dailyLimitFormatted,
                          style: AppTextStyles.headline4.copyWith(
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showLimitPicker(appState, child);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Bedtime
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeCard(
                        icon: Icons.nightlight_round,
                        label: 'Bedtime',
                        time: child.bedtime,
                        onTap: () {
                          _showTimePicker(child.bedtime, 'Bedtime');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeCard(
                        icon: Icons.wb_sunny,
                        label: 'Wake Time',
                        time: child.wakeTime,
                        onTap: () {
                          _showTimePicker(child.wakeTime, 'Wake Time');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Bonus time
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.successGreen,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonus Time Bank',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '30 minutes available',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showBonusTimeDialog(child);
                        },
                        child: const Text('Award'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTimeCard({
    required IconData icon,
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryPurple),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.bodySmall),
            Text(
              time,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tech-Free Schedules',
            style: AppTextStyles.headline3,
          ),
          const SizedBox(height: 8),
          Text(
            'Block device usage during specific times',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 24),
          
          // Example schedule blocks
          _buildScheduleBlock(
            'School Hours',
            'Mon-Fri, 8:00 AM - 3:00 PM',
            true,
          ),
          _buildScheduleBlock(
            'Homework Time',
            'Mon-Fri, 4:00 PM - 6:00 PM',
            true,
          ),
          _buildScheduleBlock(
            'Family Dinner',
            'Every day, 6:00 PM - 7:00 PM',
            true,
          ),
          _buildScheduleBlock(
            'Sleep Time',
            'Every day, 8:00 PM - 7:00 AM',
            true,
          ),
          
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showAddScheduleDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Time Block'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScheduleBlock(String title, String time, bool enabled) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          Icons.schedule,
          color: enabled ? AppColors.primaryPurple : Colors.grey,
        ),
        title: Text(title, style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        )),
        subtitle: Text(time, style: AppTextStyles.caption),
        trailing: Switch(
          value: enabled,
          onChanged: (value) {},
        ),
      ),
    );
  }
  
  void _showLimitPicker(AppState appState, child) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Daily Limit for ${child.name}',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (context, index) {
                  final hours = index;
                  return ListTile(
                    title: Text('$hours ${hours == 1 ? 'hour' : 'hours'}'),
                    selected: child.dailyLimitMinutes == hours * 60,
                    onTap: () {
                      appState.updateChildLimit(child.id, hours * 60);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showTimePicker(String currentTime, String label) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set $label'),
        content: Text('Selected time: $currentTime\n\nTime picker would go here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _showBonusTimeDialog(child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Award Bonus Time'),
        content: Text(
          'Give ${child.name} extra screen time as a reward for good behavior or completing tasks.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Award 30 min'),
          ),
        ],
      ),
    );
  }
  
  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Time Block'),
        content: const Text(
          'Create a custom tech-free schedule block for specific times and days.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
