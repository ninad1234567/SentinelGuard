import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

class NSFWDetectorService {
  // Simulate ML model detection
  Future<NSFWResult> scanImage(File imageFile) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate random confidence score (for demo purposes)
    final random = Random();
    final nsfwScore = random.nextDouble() * 100;
    
    return NSFWResult(
      imageFile: imageFile,
      isNSFW: nsfwScore > 65,
      confidence: nsfwScore,
      classifications: {
        'Safe': 100 - nsfwScore,
        'Suggestive': nsfwScore * 0.6,
        'Explicit': nsfwScore * 0.4,
      },
      timestamp: DateTime.now(),
    );
  }
  
  Future<List<NSFWResult>> scanDirectory(
    String directoryPath, {
    Function(int current, int total)? onProgress,
  }) async {
    final results = <NSFWResult>[];
    
    // Simulate scanning multiple files
    final totalFiles = 50;
    for (int i = 0; i < totalFiles; i++) {
      onProgress?.call(i + 1, totalFiles);
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Randomly mark some as NSFW
      final random = Random();
      final nsfwScore = random.nextDouble() * 100;
      
      results.add(NSFWResult(
        imageFile: File('dummy_image_$i.jpg'),
        isNSFW: nsfwScore > 75,
        confidence: nsfwScore,
        classifications: {
          'Safe': 100 - nsfwScore,
          'Suggestive': nsfwScore * 0.6,
          'Explicit': nsfwScore * 0.4,
        },
        timestamp: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
      ));
    }
    
    return results;
  }
}

class NSFWResult {
  final File imageFile;
  final bool isNSFW;
  final double confidence;
  final Map<String, double> classifications;
  final DateTime timestamp;
  final bool isReviewed;
  final bool isFalsePositive;
  
  NSFWResult({
    required this.imageFile,
    required this.isNSFW,
    required this.confidence,
    required this.classifications,
    required this.timestamp,
    this.isReviewed = false,
    this.isFalsePositive = false,
  });
  
  NSFWResult copyWith({
    bool? isReviewed,
    bool? isFalsePositive,
  }) {
    return NSFWResult(
      imageFile: imageFile,
      isNSFW: isNSFW,
      confidence: confidence,
      classifications: classifications,
      timestamp: timestamp,
      isReviewed: isReviewed ?? this.isReviewed,
      isFalsePositive: isFalsePositive ?? this.isFalsePositive,
    );
  }
  
  String get confidenceText {
    return '${confidence.toStringAsFixed(1)}%';
  }
  
  String get riskLevel {
    if (!isNSFW) return 'Safe';
    if (confidence > 85) return 'High Risk';
    if (confidence > 70) return 'Medium Risk';
    return 'Low Risk';
  }
  
  Color get riskColor {
    if (!isNSFW) return Colors.green;
    if (confidence > 85) return Colors.red;
    if (confidence > 70) return Colors.orange;
    return Colors.yellow[700]!;
  }
}

// Blur Overlay Service for real-time blurring
class BlurOverlayService {
  static OverlayEntry? _overlayEntry;
  
  static void showBlur(BuildContext context, Rect position) {
    removeBlur();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.left,
        top: position.top,
        width: position.width,
        height: position.height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility_off,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Content Blocked',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }
  
  static void removeBlur() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
