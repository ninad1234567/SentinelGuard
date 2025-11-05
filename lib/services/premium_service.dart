import 'package:flutter/material.dart';

class PremiumService extends ChangeNotifier {
  // Set to true for testing premium features
  bool _isPremium = false;
  
  bool get isPremium => _isPremium;
  
  // Premium features list
  static const List<String> premiumFeatures = [
    'real_time_blur',
    'study_ai',
    'screen_time_management',
    'nsfw_scanner',
  ];
  
  // Free features list
  static const List<String> freeFeatures = [
    'kids_launcher',
    'web_filtering',
    'youtube_restricted',
    'app_management',
  ];
  
  bool isFeaturePremium(String featureId) {
    return premiumFeatures.contains(featureId);
  }
  
  bool canAccessFeature(String featureId) {
    if (freeFeatures.contains(featureId)) return true;
    return _isPremium;
  }
  
  void setPremiumStatus(bool isPremium) {
    _isPremium = isPremium;
    notifyListeners();
  }
  
  void showUpgradeDialog(BuildContext context, String feature) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PremiumUpgradeSheet(
        feature: feature,
      ),
    );
  }
}

class PremiumUpgradeSheet extends StatelessWidget {
  final String feature;
  
  const PremiumUpgradeSheet({
    super.key,
    required this.feature,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Premium icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[700]!, Colors.amber[400]!],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Upgrade to Premium',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Unlock all features including $_featureName',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Benefits list
          _buildBenefit(Icons.blur_on, 'Real-Time AI Blur'),
          _buildBenefit(Icons.psychology, 'Study AI Assistant'),
          _buildBenefit(Icons.timer, 'Advanced Screen Time'),
          _buildBenefit(Icons.shield, 'NSFW Content Scanner'),
          _buildBenefit(Icons.support_agent, 'Priority Support'),
          _buildBenefit(Icons.update, 'Regular Updates'),
          const SizedBox(height: 24),
          
          // Pricing
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '₹129/month',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '7-day free trial',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yearly',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SAVE 33%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '₹1,199/year',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹129/month',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Upgrade button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showComingSoon(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Free Trial',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe Later',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
  
  String get _featureName {
    switch (feature) {
      case 'real_time_blur':
        return 'Real-Time AI Blur';
      case 'study_ai':
        return 'Study AI Assistant';
      case 'screen_time_management':
        return 'Advanced Screen Time Management';
      case 'nsfw_scanner':
        return 'NSFW Content Scanner';
      default:
        return 'Sentinel Guard Premium';
    }
  }
  
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment integration coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
