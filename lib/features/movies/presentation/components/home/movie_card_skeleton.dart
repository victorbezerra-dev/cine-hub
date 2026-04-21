import 'package:flutter/material.dart';

import 'poster_skeleton.dart';
import 'shimmer_box.dart';

class MovieCardSkeleton extends StatelessWidget {
  const MovieCardSkeleton({super.key, required this.cardWidth});

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final posterHeight = cardWidth * 1.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: cardWidth,
          height: posterHeight,
          child: const PosterSkeleton(),
        ),
        const SizedBox(height: 10),
        const ShimmerBox(height: 14, widthFactor: 0.85),
        const SizedBox(height: 8),
        const ShimmerBox(height: 12, widthFactor: 0.55),
      ],
    );
  }
}
