import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../services/screen_time_service.dart';
import '../../services/database_service.dart';
import '../../services/device_info_service.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});
  
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  Duration _realScreenTime = const Duration(hours: 0);
  bool _isLoadingScreenTime = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
    _loadRealScreenTime();
    _loadUserName();
  }
  
  Future<void> _loadUserName() async {
    // No device details needed
  }
  
  Future<void> _loadData() async {
    await context.read<AppState>().loadAllData();
  }
  
  Future<void> _loadRealScreenTime() async {
    setState(() => _isLoadingScreenTime = true);
    
    // Get screen time from database (Kids Mode only)
    final dbSeconds = await DatabaseService.instance.getTodayScreenTime();
    
    if (mounted) {
      setState(() {
        _realScreenTime = Duration(seconds: dbSeconds);
        _isLoadingScreenTime = false;
      });
    }
  }
  
  Future<void> _refresh() async {
    await context.read<AppState>().loadAllData();
    await _loadRealScreenTime();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 140,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sentinel Guard',
                                style: AppTextStyles.headline2.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.sync,
                                    size: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Last synced: ${appState.device.lastSyncFormatted}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Badge(
                        isLabelVisible: appState.alertsCount > 0,
                        label: Text('${appState.alertsCount}'),
                        child: const Icon(Icons.notifications_outlined),
                      ),
                      onPressed: () {
                        _showNotifications(context, appState);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/settings');
                      },
                    ),
                  ],
                ),
                
                // Content
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Hero Stats Cards
                      _buildHeroStats(appState),
                      const SizedBox(height: 24),
                      
                      // Quick Actions Grid
                      _buildQuickActions(context, appState),
                      const SizedBox(height: 24),
                      
                      // Weekly Usage Chart
                      _buildWeeklyChart(appState),
                      const SizedBox(height: 24),
                      
                      // Top Apps Today
                      _buildTopApps(appState),
                      const SizedBox(height: 24),
                      
                      // Recent Activity
                      _buildRecentActivity(appState),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildHeroStats(AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: FadeInLeft(
              delay: const Duration(milliseconds: 100),
              child: StatCard(
                label: 'Screen Time',
                value: _isLoadingScreenTime 
                    ? '5m' 
                    : (_realScreenTime.inSeconds == 0 
                        ? '5m' 
                        : ScreenTimeService.formatDuration(_realScreenTime)),
                icon: Icons.timer,
                color: AppColors.primaryPurple,
                subtitle: 'Kids Mode Only',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FadeIn(
              delay: const Duration(milliseconds: 200),
              child: StatCard(
                label: 'Blocked',
                value: '${appState.blockedAttemptsToday}',
                icon: Icons.block,
                color: AppColors.errorRed,
                subtitle: 'Attempts',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FadeInRight(
              delay: const Duration(milliseconds: 300),
              child: StatCard(
                label: 'Requests',
                value: '${appState.alertsCount}',
                icon: Icons.notification_important,
                color: AppColors.warningOrange,
                subtitle: 'Pending',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions(BuildContext context, AppState appState) {
    final actions = [
      _QuickAction(
        icon: Icons.child_care,
        label: 'Kids Launcher',
        color: AppColors.primaryPurple,
        isPremium: false,
        onTap: () => Navigator.of(context).pushNamed('/kids-launcher'),
      ),
      _QuickAction(
        icon: Icons.web,
        label: 'Web Filters',
        color: AppColors.infoBlue,
        isPremium: false,
        onTap: () => Navigator.of(context).pushNamed('/web-filtering-functional'),
      ),
      _QuickAction(
        icon: Icons.apps,
        label: 'App Control',
        color: AppColors.secondaryTeal,
        isPremium: false,
        onTap: () => Navigator.of(context).pushNamed('/apps'),
      ),
      _QuickAction(
        icon: Icons.timer,
        label: 'Screen Time',
        color: AppColors.warningOrange,
        isPremium: true,
        onTap: () {
          if (appState.premiumService.isPremium) {
            Navigator.of(context).pushNamed('/screen-time');
          } else {
            appState.premiumService.showUpgradeDialog(
              context,
              'screen_time_management',
            );
          }
        },
      ),
      _QuickAction(
        icon: Icons.shield,
        label: 'NSFW Scanner',
        color: AppColors.errorRed,
        isPremium: true,
        onTap: () {
          if (appState.premiumService.isPremium) {
            Navigator.of(context).pushNamed('/nsfw-scanner');
          } else {
            appState.premiumService.showUpgradeDialog(
              context,
              'nsfw_scanner',
            );
          }
        },
      ),
      _QuickAction(
        icon: Icons.psychology,
        label: 'Study AI',
        color: Colors.deepPurple,
        isPremium: true,
        onTap: () {
          if (appState.premiumService.isPremium) {
            _showComingSoon(context, 'Study AI');
          } else {
            appState.premiumService.showUpgradeDialog(
              context,
              'study_ai',
            );
          }
        },
      ),
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Quick Actions', style: AppTextStyles.headline3),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.1 : 1.0,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return FadeIn(
                delay: Duration(milliseconds: 50 * index),
                child: _ActionCard(action: action),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildWeeklyChart(AppState appState) {
    final weekData = appState.getWeeklyChartData();
    final maxHours = weekData.fold<double>(
      0,
      (max, day) => day['total'] > max ? day['total'] : max,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('This Week', style: AppTextStyles.headline3),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/reports');
                },
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weekData.map((day) {
                    final height = (day['total'] as double) / maxHours * 150;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                            Text(
                              '${day['total']}h',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                        Container(
                              height: height,
                          decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppColors.primaryPurple,
                                    AppColors.primaryPurple.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                              day['day'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTopApps(AppState appState) {
    final topApps = appState.getTopApps(5);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Apps Today', style: AppTextStyles.headline3),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/apps');
                },
                child: const Text('Manage'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: topApps.length,
          itemBuilder: (context, index) {
            final app = topApps[index];
            final hours = app.usageMinutes ~/ 60;
            final minutes = app.usageMinutes % 60;
            final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
            
            return FadeInLeft(
              delay: Duration(milliseconds: 50 * index),
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: app.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      app.icon,
                      color: app.color,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    app.appName,
                    style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                  subtitle: Text(
                    app.category,
                    style: AppTextStyles.caption,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeStr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      if (!app.isAllowed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'BLOCKED',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
        ),
      ],
    );
  }
  
  Widget _buildRecentActivity(AppState appState) {
    final activities = appState.recentActivities.take(8).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: AppTextStyles.headline3),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/reports');
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return FadeInLeft(
              delay: Duration(milliseconds: 50 * index),
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: activity.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                        activity.icon,
                      color: activity.color,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    activity.message,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    activity.timeAgo,
                    style: AppTextStyles.caption,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  void _showNotifications(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
        child: Column(
          children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
            Text(
                'Pending Requests',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: appState.pendingRequests.isEmpty
                    ? const Center(child: Text('No pending requests'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: appState.pendingRequests.length,
                        itemBuilder: (context, index) {
                          final request = appState.pendingRequests[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(request.icon),
                              title: Text(request.appName),
                              subtitle: Text(
                                '${request.reason}\n${request.timeAgo}',
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      appState.approveInstallRequest(
                                        request.packageName,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      appState.denyInstallRequest(
                                        request.packageName,
                                      );
              },
            ),
          ],
        ),
      ),
    );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final bool isPremium;
  final VoidCallback onTap;
  
  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.isPremium,
    required this.onTap,
  });
}

class _ActionCard extends StatelessWidget {
  final _QuickAction action;
  
  const _ActionCard({required this.action});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: action.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Pro badge for premium features
            if (action.isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}