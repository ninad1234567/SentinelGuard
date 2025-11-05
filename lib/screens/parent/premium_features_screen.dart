import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/premium_feature_card.dart';

class PremiumFeaturesScreen extends StatelessWidget {
  const PremiumFeaturesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Sentinel Guard Premium',
        showBackButton: false,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final isPremium = appState.premiumService.isPremium;
          
          return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber[700]!, Colors.orange[600]!],
                    ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.star,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                        isPremium
                            ? 'Premium Active'
                            : 'Unlock Premium Protection',
                    style: AppTextStyles.headline1.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                        isPremium
                            ? 'You have access to all premium features'
                            : 'Advanced features for complete peace of mind',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                      if (isPremium) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✓ Premium Member',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Premium feature cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PremiumFeatureCard(
                        title: 'Real-Time AI Blur',
                        description:
                            'Automatically blur inappropriate content using AI',
                        icon: Icons.blur_on,
                        isActive: isPremium,
                    features: const [
                          'Live ML detection',
                          'Instant blur effect',
                          'Works in all apps',
                          'Parent review system',
                        ],
                        ctaText: isPremium ? 'Active' : 'Upgrade Now',
                        price: '₹129/month',
                        onCtaTap: () {}, // Remove click functionality
                  ),
                  const SizedBox(height: 16),
                  
                  PremiumFeatureCard(
                        title: 'Study AI Assistant',
                        description: 'AI-powered homework help and learning',
                    icon: Icons.psychology,
                        isActive: isPremium,
                        features: const [
                          'Photo homework solver',
                          'Step-by-step explanations',
                          'Multiple subjects support',
                          'Document scanner',
                        ],
                        ctaText: isPremium ? 'Active' : 'Try Free for 7 Days',
                        price: '₹129/month',
                        onCtaTap: () {}, // Remove click functionality
                      ),
                      const SizedBox(height: 16),
                      
                      PremiumFeatureCard(
                        title: 'Advanced Screen Time',
                        description: 'Detailed usage limits and scheduling',
                        icon: Icons.timer,
                        isActive: isPremium,
                    features: const [
                          'Daily time limits',
                          'App-specific restrictions',
                          'Bedtime scheduler',
                          'Tech-free hours',
                          'Bonus time rewards',
                        ],
                        ctaText: isPremium ? 'Active' : 'Upgrade Now',
                        price: 'Included in Premium',
                        onCtaTap: () {}, // Remove click functionality
                  ),
                  const SizedBox(height: 16),
                  
                  PremiumFeatureCard(
                        title: 'NSFW Content Scanner',
                        description: 'Scan device for inappropriate content',
                        icon: Icons.shield_outlined,
                        isActive: isPremium,
                    features: const [
                          'Full device scan',
                          'Auto-detection',
                          'Scheduled scanning',
                          'Detailed reports',
                        ],
                        ctaText: isPremium ? 'Active' : 'Upgrade Now',
                        price: 'Included in Premium',
                        onCtaTap: () {}, // Remove click functionality
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Free features section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Always Free Features',
                        style: AppTextStyles.headline2,
                      ),
                      const SizedBox(height: 16),
                      _buildFreeFeatureCard(
                        context,
                        'Kids Mode Launcher',
                        'Child-friendly interface with approved apps',
                        Icons.child_care,
                        Colors.purple,
                        '/kids-launcher',
                      ),
                      const SizedBox(height: 12),
                      _buildFreeFeatureCard(
                        context,
                        'Web Filtering',
                        'Block inappropriate websites by category',
                        Icons.web,
                        Colors.blue,
                        '/web-filtering',
                      ),
                      const SizedBox(height: 12),
                      _buildFreeFeatureCard(
                        context,
                        'App Management',
                        'Allow/block apps and set basic limits',
                        Icons.apps,
                        Colors.teal,
                        '/apps',
                      ),
                      const SizedBox(height: 12),
                      _buildFreeFeatureCard(
                        context,
                        'YouTube Restricted Mode',
                        'Enable YouTube safety features',
                        Icons.play_circle,
                        Colors.red,
                        '/web-filtering',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Compare plans
                if (!isPremium) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compare Plans',
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 16),
                  _buildComparisonTable(),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Testimonials
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What Parents Say',
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTestimonial(
                          'Sarah M.',
                          'The real-time blur feature is a game changer! I feel so much safer knowing my kids are protected.',
                          5,
                        ),
                        _buildTestimonial(
                                'Rajesh K.',
                                'Study AI has transformed homework time. My daughter actually enjoys learning now!',
                          5,
                        ),
                        _buildTestimonial(
                                'Priya S.',
                                'Worth every rupee. The NSFW scanner gives me complete peace of mind.',
                          5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
                ],
                
                // Upgrade CTA (if not premium)
                if (!isPremium)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[700]!, Colors.orange[600]!],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🎉 Limited Time Offer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Start your 7-day free trial',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              appState.premiumService.showUpgradeDialog(
                                context,
                                'premium',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.amber[700],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Upgrade to Premium',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cancel anytime • No credit card required for trial',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
  
  Widget _buildFreeFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      child: Padding(
              padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Text(
                'FREE',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildComparisonTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                const SizedBox(),
                _buildTableHeader('Free'),
                _buildTableHeader('Premium', highlight: true),
              ],
            ),
            _buildTableRow('Kids Launcher', true, true),
            _buildTableRow('App Management', true, true),
            _buildTableRow('Web Filtering', true, true),
            _buildTableRow('YouTube Mode', true, true),
            _buildTableRow('Basic Reports', true, true),
            _buildTableRow('Real-Time Blur', false, true),
            _buildTableRow('Study AI', false, true),
            _buildTableRow('Screen Time', false, true),
            _buildTableRow('NSFW Scanner', false, true),
            _buildTableRow('Priority Support', false, true),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTableHeader(String text, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: highlight ? Colors.amber[700] : null,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  TableRow _buildTableRow(String feature, bool free, bool premium) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(feature, style: AppTextStyles.bodySmall),
        ),
        _buildCheckmark(free),
        _buildCheckmark(premium),
      ],
    );
  }
  
  Widget _buildCheckmark(bool hasFeature) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        hasFeature ? Icons.check_circle : Icons.remove_circle_outline,
        color: hasFeature ? AppColors.successGreen : Colors.grey,
        size: 20,
      ),
    );
  }
  
  Widget _buildTestimonial(String name, String text, int rating) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber[700],
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- $name',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showComingSoon(BuildContext context) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
        content: Text('Study AI feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}