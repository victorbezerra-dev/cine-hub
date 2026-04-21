import 'dart:ui';

import 'package:flutter/material.dart';

class MovieRatingBadge extends StatelessWidget {
  const MovieRatingBadge({
    super.key,
    required this.voteAverage,
    required this.voteCount,
  });

  final double voteAverage;
  final int voteCount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 6),
              Text('${voteAverage.toStringAsFixed(1)} / 10'),
              if (voteCount > 0) ...[
                const SizedBox(width: 8),
                Text('($voteCount)'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
