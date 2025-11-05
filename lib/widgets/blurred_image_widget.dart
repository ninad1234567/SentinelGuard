import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/nsfw_detector_service.dart';

class BlurredImageWidget extends StatefulWidget {
  final File imageFile;
  final NSFWResult? detectionResult;
  final VoidCallback? onParentReview;
  
  const BlurredImageWidget({
    super.key,
    required this.imageFile,
    this.detectionResult,
    this.onParentReview,
  });
  
  @override
  State<BlurredImageWidget> createState() => _BlurredImageWidgetState();
}

class _BlurredImageWidgetState extends State<BlurredImageWidget> {
  bool _isRevealed = false;
  
  @override
  Widget build(BuildContext context) {
    final bool shouldBlur = widget.detectionResult?.isNSFW ?? false;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        Image.file(
          widget.imageFile,
          fit: BoxFit.cover,
        ),
        
        // Blur overlay
        if (shouldBlur && !_isRevealed)
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.visibility_off,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Inappropriate Content Detected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (widget.detectionResult != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: widget.detectionResult!.riskColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.detectionResult!.riskLevel} • ${widget.detectionResult!.confidenceText} confidence',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (widget.onParentReview != null) {
                            widget.onParentReview!();
                          } else {
                            _showParentPinDialog(context);
                          }
                        },
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Parent Review Required'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        
        // Risk level badge
        if (shouldBlur && widget.detectionResult != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: widget.detectionResult!.riskColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.detectionResult!.riskLevel.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  void _showParentPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Parent PIN'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Enter PIN to view this content'),
          ],
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
                _isRevealed = true;
              });
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}

// Thumbnail version for grid display
class BlurredThumbnail extends StatelessWidget {
  final File imageFile;
  final NSFWResult? detectionResult;
  final VoidCallback? onTap;
  
  const BlurredThumbnail({
    super.key,
    required this.imageFile,
    this.detectionResult,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool shouldBlur = detectionResult?.isNSFW ?? false;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: shouldBlur
                ? (detectionResult?.riskColor ?? Colors.red)
                : Colors.transparent,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
              if (shouldBlur)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                            size: 32,
                          ),
                          if (detectionResult != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: detectionResult!.riskColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  detectionResult!.confidenceText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
