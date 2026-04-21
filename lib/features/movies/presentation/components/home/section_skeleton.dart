import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'movie_card_skeleton.dart';

class SectionSkeleton extends StatelessWidget {
  const SectionSkeleton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final cardWidth = math.min(170.0, math.max(130.0, screenWidth * 0.40));
        final posterHeight = cardWidth * 1.5;
        final carouselHeight = posterHeight + 80;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: carouselHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, _) => SizedBox(
                  width: cardWidth,
                  child: MovieCardSkeleton(cardWidth: cardWidth),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
