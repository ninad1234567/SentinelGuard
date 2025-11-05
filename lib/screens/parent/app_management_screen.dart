import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../data/real_apps.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';

class AppManagementScreen extends StatefulWidget {
  const AppManagementScreen({super.key});
  
  @override
  State<AppManagementScreen> createState() => _AppManagementScreenState();
}

class _AppManagementScreenState extends State<AppManagementScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'App Management',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          // Filter apps
          var filteredApps = appState.apps.where((app) {
            if (_searchQuery.isNotEmpty &&
                !app.appName.toLowerCase().contains(_searchQuery.toLowerCase())) {
              return false;
            }
            
            switch (_selectedFilter) {
              case 'Allowed':
                return app.isAllowed;
              case 'Blocked':
                return !app.isAllowed;
              case 'Time-Limited':
                return app.timeLimitMinutes != null;
              default:
                return true;
            }
          }).toList();
          
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search apps...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              
              // Filter chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Allowed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Blocked'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Time-Limited'),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Pending requests badge
              if (appState.pendingRequests.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warningOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: AppColors.warningOrange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${appState.pendingRequests.length} Pending Requests',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.warningOrange,
                              ),
                            ),
                            Text(
                              'Tap to review install requests',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.warningOrange,
                      ),
                    ],
                  ),
                ),
              
              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Allowed',
                        appState.apps.where((a) => a.isAllowed).length.toString(),
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Blocked',
                        appState.apps.where((a) => !a.isAllowed).length.toString(),
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Limited',
                        appState.apps.where((a) => a.timeLimitMinutes != null).length.toString(),
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Apps list
              Expanded(
                child: filteredApps.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No apps found',
                              style: AppTextStyles.headline3.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = filteredApps[index];
                          return _buildAppTile(appState, app);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: AppColors.primaryPurple.withOpacity(0.2),
      checkmarkColor: AppColors.primaryPurple,
    );
  }
  
  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.headline2.copyWith(
                color: color,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAppTile(AppState appState, AppData app) {
    final hours = app.usageMinutes ~/ 60;
    final minutes = app.usageMinutes % 60;
    final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  app.category,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(width: 8),
                Text(
                  '• $timeStr today',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (app.timeLimitMinutes != null)
              Text(
                'Time limit: ${app.timeLimitMinutes} min',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.orange,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: app.isAllowed
                    ? Colors.green[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                app.isAllowed ? 'Allowed' : 'Blocked',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: app.isAllowed
                      ? Colors.green[900]
                      : Colors.red[900],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showAppOptions(appState, app);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAppOptions(AppState appState, AppData app) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: app.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(app.icon, color: app.color),
              ),
              title: Text(
                app.appName,
                style: AppTextStyles.headline4,
              ),
              subtitle: Text(app.category),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                app.isAllowed ? Icons.block : Icons.check_circle,
                color: app.isAllowed ? Colors.red : Colors.green,
              ),
              title: Text(app.isAllowed ? 'Block App' : 'Allow App'),
              onTap: () {
                appState.toggleAppBlock(app.packageName);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.orange),
              title: const Text('Set Time Limit'),
              trailing: Text(
                app.timeLimitMinutes != null
                    ? '${app.timeLimitMinutes} min'
                    : 'None',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showTimeLimitDialog(appState, app);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('App Info'),
              onTap: () {
                Navigator.pop(context);
                _showAppInfo(app);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showTimeLimitDialog(AppState appState, AppData app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Time Limit for ${app.appName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeLimitOption(appState, app, 30, '30 minutes'),
            _buildTimeLimitOption(appState, app, 60, '1 hour'),
            _buildTimeLimitOption(appState, app, 120, '2 hours'),
            _buildTimeLimitOption(appState, app, 180, '3 hours'),
            _buildTimeLimitOption(appState, app, null, 'No limit'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimeLimitOption(
    AppState appState,
    AppData app,
    int? minutes,
    String label,
  ) {
    return ListTile(
      title: Text(label),
      trailing: app.timeLimitMinutes == minutes
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        appState.setAppTimeLimit(app.packageName, minutes);
        Navigator.pop(context);
      },
    );
  }
  
  void _showAppInfo(AppData app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(app.icon, color: app.color),
            const SizedBox(width: 8),
            Expanded(child: Text(app.appName)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Package', app.packageName),
            _buildInfoRow('Category', app.category),
            _buildInfoRow('Status', app.isAllowed ? 'Allowed' : 'Blocked'),
            _buildInfoRow('Usage Today', '${app.usageMinutes} minutes'),
            if (app.timeLimitMinutes != null)
              _buildInfoRow('Time Limit', '${app.timeLimitMinutes} minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}