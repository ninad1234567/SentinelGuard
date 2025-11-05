import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/usage_chart_card.dart';
import '../../widgets/stat_card.dart';

class ActivityReportsScreen extends StatefulWidget {
  const ActivityReportsScreen({super.key});
  
  @override
  State<ActivityReportsScreen> createState() => _ActivityReportsScreenState();
}

class _ActivityReportsScreenState extends State<ActivityReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Today';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: 'Activity Reports',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              // Period selector
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'Today', label: Text('Today')),
                          ButtonSegment(value: 'Week', label: Text('Week')),
                          ButtonSegment(value: 'Month', label: Text('Month')),
                        ],
                        selected: {_selectedPeriod},
                        onSelectionChanged: (Set<String> selection) {
                          setState(() {
                            _selectedPeriod = selection.first;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: () {
                        _showExportDialog();
                      },
                      tooltip: 'Export to PDF',
                    ),
                  ],
                ),
              ),
              
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryPurple,
                indicatorColor: AppColors.primaryPurple,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Browsing'),
                  Tab(text: 'App Usage'),
                ],
              ),
              
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(appState),
                    _buildBrowsingTab(appState),
                    _buildAppUsageTab(appState),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildOverviewTab(AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Screen Time',
                  value: appState.totalScreenTimeTodayFormatted,
                  icon: Icons.access_time,
                  color: AppColors.primaryPurple,
                  subtitle: _selectedPeriod,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Apps Used',
                  value: '${appState.apps.where((a) => a.todayUsageMinutes > 0).length}',
                  icon: Icons.apps,
                  color: AppColors.secondaryTeal,
                  subtitle: 'Different apps',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Websites',
                  value: '${appState.browsingHistory.length}',
                  icon: Icons.public,
                  color: AppColors.infoBlue,
                  subtitle: 'Visited',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Blocked',
                  value: '${appState.browsingHistory.where((h) => h.riskLevel == 'blocked').length}',
                  icon: Icons.block,
                  color: AppColors.errorRed,
                  subtitle: 'Attempts',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Daily usage chart
          UsageChartCard(
            title: 'Daily Screen Time',
            subtitle: 'Last 7 days',
            data: [185, 220, 195, 210, 240, 205, 220],
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          ),
          const SizedBox(height: 24),
          
          // Most active times
          Text('Peak Usage Times', style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTimeSlot('Morning', '7 AM - 12 PM', 45, 0.3),
                  const SizedBox(height: 12),
                  _buildTimeSlot('Afternoon', '12 PM - 5 PM', 120, 0.8),
                  const SizedBox(height: 12),
                  _buildTimeSlot('Evening', '5 PM - 9 PM', 95, 0.65),
                  const SizedBox(height: 12),
                  _buildTimeSlot('Night', '9 PM - 7 AM', 15, 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeSlot(String name, String time, int minutes, double intensity) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
            Text(
              '${minutes}m',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: intensity,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
        ),
      ],
    );
  }
  
  Widget _buildBrowsingTab(AppState appState) {
    return Column(
      children: [
        // Filter by child
        if (appState.children.length > 1)
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Child',
                prefixIcon: Icon(Icons.person),
              ),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Children')),
                ...appState.children.map((child) =>
                    DropdownMenuItem(value: child.id, child: Text(child.name))),
              ],
              onChanged: (value) {},
              value: 'all',
            ),
          ),
        
        // Browsing history list
        Expanded(
          child: appState.browsingHistory.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('📭', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 16),
                      Text('No browsing history yet'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appState.browsingHistory.length,
                  itemBuilder: (context, index) {
                    final item = appState.browsingHistory[index];
                    final child = appState.children.firstWhere(
                      (c) => c.id == item.childId,
                      orElse: () => appState.children.first,
                    );
                    
                    Color riskColor;
                    IconData riskIcon;
                    switch (item.riskLevel) {
                      case 'blocked':
                        riskColor = AppColors.riskBlocked;
                        riskIcon = Icons.block;
                        break;
                      case 'warning':
                        riskColor = AppColors.riskWarning;
                        riskIcon = Icons.warning_amber;
                        break;
                      default:
                        riskColor = AppColors.riskSafe;
                        riskIcon = Icons.check_circle;
                    }
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: riskColor.withOpacity(0.2),
                          child: Icon(riskIcon, color: riskColor, size: 20),
                        ),
                        title: Text(
                          item.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${item.url}\n${child.name} • ${DateFormat.jm().format(item.timestamp)}',
                          style: AppTextStyles.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: riskColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.riskLevel.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: riskColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  Widget _buildAppUsageTab(AppState appState) {
    final topApps = appState.apps
        .where((app) => app.todayUsageMinutes > 0)
        .toList()
      ..sort((a, b) => b.todayUsageMinutes.compareTo(a.todayUsageMinutes));
    
    final totalMinutes = topApps.fold<int>(
      0,
      (sum, app) => sum + app.todayUsageMinutes,
    );
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart would go here
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top 5 Apps', style: AppTextStyles.headline4),
                  const SizedBox(height: 16),
                  ...topApps.take(5).map((app) {
                    final percentage = totalMinutes > 0
                        ? (app.todayUsageMinutes / totalMinutes * 100).toInt()
                        : 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            app.iconPath,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.appName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  app.todayUsageFormatted,
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Detailed list
          Text('All Apps', style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          ...topApps.map((app) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.1),
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(app.category, style: AppTextStyles.caption),
                  trailing: Text(
                    app.todayUsageFormatted,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
  
  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: const Text(
          'Export this report as a PDF file?\n\n'
          'The report will include all current statistics and charts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report exported successfully'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            icon: const Icon(Icons.file_download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }
}
