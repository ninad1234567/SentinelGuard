import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';

class WebFilteringScreen extends StatefulWidget {
  const WebFilteringScreen({super.key});
  
  @override
  State<WebFilteringScreen> createState() => _WebFilteringScreenState();
}

class _WebFilteringScreenState extends State<WebFilteringScreen> {
  bool _masterFilterEnabled = true;
  bool _youtubeRestrictedMode = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Web Filtering',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Master toggle
                Card(
                  margin: const EdgeInsets.all(16),
                  color: _masterFilterEnabled
                      ? AppColors.successGreen.withOpacity(0.1)
                      : Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          _masterFilterEnabled ? Icons.shield : Icons.shield_outlined,
                          color: _masterFilterEnabled
                              ? AppColors.successGreen
                              : Colors.grey,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Web Filtering',
                                style: AppTextStyles.headline4,
                              ),
                              Text(
                                _masterFilterEnabled
                                    ? 'Active across all browsers'
                                    : 'Currently disabled',
                                style: AppTextStyles.caption.copyWith(
                                  color: _masterFilterEnabled
                                      ? AppColors.successGreen
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _masterFilterEnabled,
                          onChanged: (value) {
                            setState(() {
                              _masterFilterEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Categories section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Content Categories',
                    style: AppTextStyles.headline3,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Block or allow specific types of content',
                    style: AppTextStyles.caption,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Category list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: appState.websiteCategories.length,
                  itemBuilder: (context, index) {
                    final category = appState.websiteCategories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: category.isEnabled
                                ? AppColors.errorRed.withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              category.icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        title: Text(
                          category.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${category.blockedCount} sites blocked',
                          style: AppTextStyles.caption,
                        ),
                        trailing: Switch(
                          value: category.isEnabled,
                          onChanged: _masterFilterEnabled
                              ? (value) {
                                  appState.toggleCategoryFilter(category.id);
                                }
                              : null,
                        ),
                        onTap: () {
                          _showCategoryDetails(category);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // YouTube section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'YouTube Controls',
                    style: AppTextStyles.headline3,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Restricted Mode'),
                        subtitle: const Text('Filter potentially mature content'),
                        value: _youtubeRestrictedMode,
                        onChanged: (value) {
                          setState(() {
                            _youtubeRestrictedMode = value;
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('Watch History'),
                        subtitle: Text(
                          '${appState.youtubeHistory.length} videos watched',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _showYouTubeHistory(appState);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Custom URLs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Custom URL Blocking',
                    style: AppTextStyles.headline3,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter website URL to block',
                            prefixIcon: const Icon(Icons.link),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {
                                // Add URL
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download),
                                label: const Text('Import List'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.upload),
                                label: const Text('Export List'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
  
  void _showCategoryDetails(category) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: AppTextStyles.headline2,
                        ),
                        Text(
                          '${category.blockedSitesCount} domains',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Blocked Domains',
                style: AppTextStyles.headline4,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: category.domains.isEmpty
                    ? const Center(
                        child: Text('No specific domains listed'),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: category.domains.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.block, color: AppColors.errorRed),
                            title: Text(category.domains[index]),
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
  
  void _showYouTubeHistory(AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YouTube Watch History',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: appState.youtubeHistory.length,
                  itemBuilder: (context, index) {
                    final video = appState.youtubeHistory[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        title: Text(
                          video.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${video.channelName} • ${video.duration} • ${video.timeAgo}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(Icons.play_circle_outline),
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
}
