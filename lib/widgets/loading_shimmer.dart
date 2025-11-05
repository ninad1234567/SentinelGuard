import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  
  const LoadingShimmer({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class LoadingCardShimmer extends StatelessWidget {
  const LoadingCardShimmer({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LoadingShimmer(width: 150, height: 20),
            const SizedBox(height: 12),
            const LoadingShimmer(width: double.infinity, height: 100),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: const LoadingShimmer(height: 40)),
                const SizedBox(width: 12),
                Expanded(child: const LoadingShimmer(height: 40)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
