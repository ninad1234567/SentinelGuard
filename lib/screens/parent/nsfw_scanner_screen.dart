import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../services/nsfw_detector_service.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/blurred_image_widget.dart';

class NSFWScannerScreen extends StatefulWidget {
  const NSFWScannerScreen({super.key});
  
  @override
  State<NSFWScannerScreen> createState() => _NSFWScannerScreenState();
}

class _NSFWScannerScreenState extends State<NSFWScannerScreen> {
  final NSFWDetectorService _detectorService = NSFWDetectorService();
  bool _isScanning = false;
  double _scanProgress = 0.0;
  int _currentFile = 0;
  int _totalFiles = 0;
  List<NSFWResult> _scanResults = [];
  bool _autoScanEnabled = true;
  
  @override
  void initState() {
    super.initState();
    _checkPremiumAccess();
  }
  
  void _checkPremiumAccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      if (!appState.premiumService.isPremium) {
        _showPremiumRequired();
      }
    });
  }
  
  void _showPremiumRequired() {
    final appState = Provider.of<AppState>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.star, color: Colors.amber[700]),
            const SizedBox(width: 8),
            const Text('Premium Feature'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'NSFW Content Scanner is a premium feature.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Upgrade to access:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Full device scanning'),
            Text('• AI-powered detection'),
            Text('• Automatic monitoring'),
            Text('• Detailed reports'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              appState.premiumService.showUpgradeDialog(
                context,
                'nsfw_scanner',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
            ),
            child: const Text(
              'Upgrade Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
      _currentFile = 0;
      _scanResults = [];
    });
    
    // Simulate scanning with progress
    final results = await _detectorService.scanDirectory(
      '/storage/emulated/0/DCIM',
      onProgress: (current, total) {
        if (mounted) {
          setState(() {
            _currentFile = current;
            _totalFiles = total;
            _scanProgress = current / total;
          });
        }
      },
    );
    
    setState(() {
      _isScanning = false;
      _scanResults = results;
    });
    
    if (mounted) {
      final flaggedCount = results.where((r) => r.isNSFW).length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Scan completed! Found $flaggedCount potentially inappropriate files.',
          ),
          backgroundColor: flaggedCount > 0
              ? AppColors.warningOrange
              : AppColors.successGreen,
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              // Scroll to results
            },
          ),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'NSFW Content Scanner',
        showBackButton: true,
        hasGradient: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium banner
                if (!appState.premiumService.isPremium)
                  _buildPremiumBanner(appState),
                
                // Scan status card
                _buildScanStatusCard(),
                
                // Results summary
                if (!_isScanning && _scanResults.isNotEmpty)
                  _buildResultsSummary(),
                
                // Detected content grid
                if (!_isScanning && _scanResults.isNotEmpty)
                  _buildDetectedContentGrid(),
                
                // Settings
                if (!_isScanning) _buildSettingsSection(),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPremiumBanner(AppState appState) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[700]!, Colors.orange[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Feature',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Limited free trial: Scan 5 photos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              appState.premiumService.showUpgradeDialog(
                context,
                'nsfw_scanner',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.amber[700],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScanStatusCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.errorRed,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protection Status',
                        style: AppTextStyles.headline4,
                      ),
                      Text(
                        _autoScanEnabled ? 'Auto-scan enabled' : 'Manual scan only',
                        style: AppTextStyles.caption.copyWith(
                          color: _autoScanEnabled
                              ? AppColors.successGreen
                              : AppColors.warningOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_isScanning) ...[
              LinearProgressIndicator(
                value: _scanProgress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scanning... $_currentFile/$_totalFiles files (${(_scanProgress * 100).toInt()}%)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      label: 'Last Scan',
                      value: '2 hours ago',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      label: 'Files Scanned',
                      value: '${_scanResults.length}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startScan,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: Text(
                    'Start Full Scan',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildResultsSummary() {
    final flaggedCount = _scanResults.where((r) => r.isNSFW).length;
    final safeCount = _scanResults.length - flaggedCount;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '$flaggedCount',
                      style: AppTextStyles.statNumber.copyWith(
                        color: AppColors.errorRed,
                      ),
                    ),
                    Text(
                      'Flagged',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '$safeCount',
                      style: AppTextStyles.statNumber.copyWith(
                        color: AppColors.successGreen,
                      ),
                    ),
                    Text(
                      'Safe',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${_scanResults.length}',
                      style: AppTextStyles.statNumber.copyWith(
                        color: AppColors.infoBlue,
                      ),
                    ),
                    Text(
                      'Total',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetectedContentGrid() {
    final flaggedResults = _scanResults.where((r) => r.isNSFW).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flagged Content (${flaggedResults.length})',
                style: AppTextStyles.headline3,
              ),
              if (flaggedResults.isNotEmpty)
                TextButton(
                  onPressed: _showBulkActions,
                  child: const Text('Bulk Actions'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        flaggedResults.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    const Text('✅', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'No Issues Found',
                      style: AppTextStyles.headline3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All content is safe',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: flaggedResults.length,
                itemBuilder: (context, index) {
                  final result = flaggedResults[index];
                  return BlurredThumbnail(
                    imageFile: result.imageFile,
                    detectionResult: result,
                    onTap: () => _showDetectionDetails(result),
                  );
                },
              ),
      ],
    );
  }
  
  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Scanner Settings',
            style: AppTextStyles.headline3,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Automatic Scanning'),
                subtitle: const Text('Scan new media automatically'),
                value: _autoScanEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoScanEnabled = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Scan Frequency'),
                subtitle: Text(_autoScanEnabled ? 'Daily at 2:00 AM' : 'Manual only'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _autoScanEnabled ? _showFrequencyDialog : null,
              ),
              const ListTile(
                title: Text('Sensitivity Level'),
                subtitle: Text('Medium (Recommended)'),
                trailing: Icon(Icons.chevron_right),
              ),
              const ListTile(
                title: Text('Notification Settings'),
                subtitle: Text('Alert me when content is detected'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  void _showDetectionDetails(NSFWResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
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
                'Content Review',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 24),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: BlurredImageWidget(
                  imageFile: result.imageFile,
                  detectionResult: result,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Risk Level', result.riskLevel),
              _buildDetailRow('Confidence', result.confidenceText),
              _buildDetailRow('Detected', _formatTime(result.timestamp)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSnackbar('Marked as false positive');
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('False Positive'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(result);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showBulkActions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: const Text(
          'Choose an action for all flagged files:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('All files marked as reviewed');
            },
            child: const Text('Mark All as Safe'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteAllConfirmation();
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(NSFWResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File?'),
        content: const Text(
          'This action cannot be undone. The file will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _scanResults.remove(result);
              });
              _showSnackbar('File deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Flagged Files?'),
        content: const Text(
          'This will permanently delete all flagged files. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _scanResults.removeWhere((r) => r.isNSFW);
              });
              _showSnackbar('All flagged files deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
  
  void _showFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Daily'),
              value: 'daily',
              groupValue: 'daily',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: const Text('Weekly'),
              value: 'weekly',
              groupValue: 'daily',
              onChanged: (value) {},
            ),
          ],
        ),
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
  
  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
  
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}