import 'package:flutter/material.dart';

import 'movie_card_skeleton.dart';

class MovieCarousel extends StatelessWidget {
  const MovieCarousel({
    super.key,
    required this.title,
    required this.itemCount,
    required this.carouselHeight,
    required this.controller,
    required this.itemBuilder,
    required this.isEmpty,
    required this.emptyChild,
    required this.isLoadingMore,
    required this.loadingCardWidth,
  });

  final String title;
  final int itemCount;
  final double carouselHeight;
  final ScrollController controller;
  final IndexedWidgetBuilder itemBuilder;
  final bool isEmpty;
  final Widget emptyChild;
  final bool isLoadingMore;
  final double loadingCardWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$itemCount items',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: carouselHeight,
          child: isEmpty
              ? emptyChild
              : ListView.separated(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: itemBuilder,
                ),
        ),
        if (isLoadingMore) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: carouselHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, _) => SizedBox(
                width: loadingCardWidth,
                child: MovieCardSkeleton(cardWidth: loadingCardWidth),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
