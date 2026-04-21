import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_network_image.dart';
import '../../../domain/entities/movie_details_entity.dart';
import '../../../domain/entities/movie_entity.dart';
import '../home/poster_fallback.dart';
import 'movie_rating_badge.dart';

class MovieDetailsAppBar extends StatelessWidget {
  const MovieDetailsAppBar({
    super.key,
    required this.heroTag,
    required this.movieId,
    required this.reloadVersion,
    required this.paletteColor,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.details,
    this.initialMovie,
  });

  final String heroTag;
  final int movieId;
  final int reloadVersion;
  final Color paletteColor;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final MovieDetailsEntity? details;
  final MovieEntity? initialMovie;

  @override
  Widget build(BuildContext context) {
    final backdropUrl = details?.backdropUrl ?? initialMovie?.backdropUrl;
    final posterUrl = details?.posterUrl ?? initialMovie?.posterUrl;

    return SliverAppBar(
      expandedHeight: 420,
      pinned: true,
      stretch: true,
      backgroundColor: paletteColor,
      actions: [
        IconButton(
          onPressed: onFavoriteTap,
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (backdropUrl != null && backdropUrl.isNotEmpty)
              AppNetworkImage(
                imageUrl: backdropUrl,
                key: ValueKey('backdrop-$movieId-$backdropUrl-$reloadVersion'),
                fit: BoxFit.cover,
                errorWidget: Container(color: paletteColor),
                placeholder: Container(color: paletteColor),
              )
            else
              Container(color: paletteColor),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.5),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox(
                          width: 140,
                          height: 210,
                          child: posterUrl != null && posterUrl.isNotEmpty
                              ? AppNetworkImage(
                                  key: ValueKey(
                                    'poster-$movieId-$posterUrl-$reloadVersion',
                                  ),
                                  imageUrl: posterUrl,
                                  fit: BoxFit.cover,
                                  placeholder: const PosterFallback(
                                    icon: Icons.movie,
                                  ),
                                  errorWidget: const PosterFallback(
                                    icon: Icons.movie,
                                  ),
                                )
                              : const PosterFallback(icon: Icons.movie),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details?.title ?? initialMovie?.title ?? '',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            MovieRatingBadge(
                              voteAverage:
                                  details?.voteAverage ??
                                  initialMovie?.voteAverage ??
                                  0,
                              voteCount:
                                  details?.voteCount ??
                                  initialMovie?.voteCount ??
                                  0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
