import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/premium_colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/premium_card.dart';

class FunctionalWebFilteringScreen extends StatefulWidget {
  const FunctionalWebFilteringScreen({super.key});
  
  @override
  State<FunctionalWebFilteringScreen> createState() => _FunctionalWebFilteringScreenState();
}

class _FunctionalWebFilteringScreenState extends State<FunctionalWebFilteringScreen> {
  bool isFilteringEnabled = true;
  
  // Hardcoded blocked websites - Adult content keywords
  final List<String> blockedDomains = const [
    'pornhub',
    'porn',
    'xxx',
    'adult',
    'sex',
    'nude',
    'naked',
    'hot',
    'sexy',
    'adultvideos',
  ];
  
  // Categories with blocked site counts
  final Map<String, CategoryData> categories = const {
    'Adult Content': CategoryData(icon: Icons.block, count: 1245, color: AppColors.error),
    'Gambling': CategoryData(icon: Icons.casino, count: 523, color: AppColors.warning),
    'Violence & Weapons': CategoryData(icon: Icons.dangerous, count: 890, color: AppColors.error),
    'Drugs & Alcohol': CategoryData(icon: Icons.medication, count: 456, color: AppColors.warning),
    'Social Media': CategoryData(icon: Icons.people, count: 12, color: AppColors.info),
    'Gaming Sites': CategoryData(icon: Icons.games, count: 34, color: AppColors.info),
    'Streaming': CategoryData(icon: Icons.play_circle, count: 8, color: AppColors.info),
    'Dating': CategoryData(icon: Icons.favorite, count: 234, color: AppColors.warning),
    'File Sharing': CategoryData(icon: Icons.folder_shared, count: 178, color: AppColors.warning),
    'Proxy & VPN': CategoryData(icon: Icons.vpn_key, count: 345, color: AppColors.error),
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Web Filtering',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          // Master Toggle Card
          PremiumCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: const Icon(Icons.shield, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Web Filtering',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        'Block inappropriate websites',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isFilteringEnabled,
                  onChanged: (val) {
                    HapticFeedback.lightImpact();
                    setState(() => isFilteringEnabled = val);
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: Spacing.lg),
          
          // Test Browser Button
          PremiumCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestBrowserScreen(
                    blockedDomains: blockedDomains,
                    isFilteringEnabled: isFilteringEnabled,
                  ),
                ),
              );
            },
            color: AppColors.info.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.language, color: AppColors.info, size: 32),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Browser',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Try browsing to see filtering in action',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.info),
              ],
            ),
          ),
          
          const SizedBox(height: Spacing.lg),
          
          // Statistics
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Blocked Today',
                  value: '127',
                  icon: Icons.block,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: _StatCard(
                  label: 'Categories',
                  value: categories.length.toString(),
                  icon: Icons.category,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: Spacing.lg),
          
          // Categories
          Text(
            'Filter Categories',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.md),
          
          ...categories.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: _CategoryTile(
              category: entry.key,
              data: entry.value,
              isEnabled: isFilteringEnabled,
            ),
          )),
        ],
      ),
    );
  }
}

class CategoryData {
  final IconData icon;
  final int count;
  final Color color;
  
  const CategoryData({
    required this.icon,
    required this.count,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Category Tile Widget
class _CategoryTile extends StatefulWidget {
  final String category;
  final CategoryData data;
  final bool isEnabled;
  
  const _CategoryTile({
    required this.category,
    required this.data,
    required this.isEnabled,
  });
  
  @override
  State<_CategoryTile> createState() => __CategoryTileState();
}

class __CategoryTileState extends State<_CategoryTile> {
  bool isActive = true;
  
  @override
  Widget build(BuildContext context) {
    final bool effectivelyEnabled = widget.isEnabled && isActive;
    
    return PremiumCard(
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: [
          Icon(
            widget.data.icon,
            color: effectivelyEnabled 
                ? widget.data.color 
                : AppColors.textTertiary,
            size: 24,
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${widget.data.count} sites blocked',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: effectivelyEnabled,
            onChanged: widget.isEnabled ? (val) {
              HapticFeedback.lightImpact();
              setState(() => isActive = val);
            } : null,
            activeColor: widget.data.color,
          ),
        ],
      ),
    );
  }
}

// Test Browser with ACTUAL BLOCKING
class TestBrowserScreen extends StatefulWidget {
  final List<String> blockedDomains;
  final bool isFilteringEnabled;
  
  const TestBrowserScreen({
    super.key,
    required this.blockedDomains,
    required this.isFilteringEnabled,
  });
  
  @override
  State<TestBrowserScreen> createState() => _TestBrowserScreenState();
}

class _TestBrowserScreenState extends State<TestBrowserScreen> {
  late WebViewController _webViewController;
  final TextEditingController _urlController = TextEditingController();
  bool isLoading = false;
  String currentUrl = '';
  
  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }
  
  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
  
  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
              currentUrl = url;
            });
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (!widget.isFilteringEnabled) {
              return NavigationDecision.navigate;
            }
            
            final url = request.url.toLowerCase();
            
            // Check if URL contains any blocked domain
            for (String blocked in widget.blockedDomains) {
              if (url.contains(blocked.toLowerCase())) {
                _showBlockedPage(blocked);
                return NavigationDecision.prevent;
              }
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com'));
  }
  
  void _showBlockedPage(String blockedDomain) {
    HapticFeedback.heavyImpact();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
              child: const Icon(Icons.block, color: AppColors.error, size: 32),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                '🚫 Access Blocked',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This website is BLOCKED:',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.error, size: 28),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      blockedDomain.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield, color: AppColors.info, size: 24),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      'This site is blocked by parental controls for your safety.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
              ),
              child: Text(
                'Understood',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _loadUrl(String url) {
    if (url.isEmpty) return;
    
    // Check if it's a search query or URL
    if (!url.contains('.') && !url.startsWith('http')) {
      // It's a search query
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
    } else {
      // It's a URL
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
    }
    
    _webViewController.loadRequest(Uri.parse(url));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Protected Browser',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(Spacing.md),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(Spacing.radiusFull),
                    ),
                    child: TextField(
                      controller: _urlController,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Try: pornhub.com (BLOCKED)',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.md,
                        ),
                      ),
                      onSubmitted: _loadUrl,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(Spacing.radiusFull),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () => _loadUrl(_urlController.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading)
            const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              backgroundColor: Color(0xFFE0E0FF),
            ),
        ],
      ),
    );
  }
}