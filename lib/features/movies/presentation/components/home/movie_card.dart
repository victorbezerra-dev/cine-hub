import 'package:flutter/material.dart';

import '../../../domain/entities/movie_entity.dart';
import 'poster_fallback.dart';
import 'poster_skeleton.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.fallbackIcon,
    required this.sectionKey,
    required this.cardWidth,
    this.onTap,
  });

  final MovieEntity movie;
  final IconData fallbackIcon;
  final String sectionKey;
  final double cardWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final heroTag = '$sectionKey-${movie.id}';

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: movie.posterUrl != null && movie.posterUrl!.isNotEmpty
                      ? Image.network(
                          movie.posterUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              PosterFallback(icon: fallbackIcon),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const PosterSkeleton();
                          },
                        )
                      : PosterFallback(icon: fallbackIcon),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              movie.releaseDate.isEmpty
                  ? 'Release date unavailable'
                  : movie.releaseDate,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
