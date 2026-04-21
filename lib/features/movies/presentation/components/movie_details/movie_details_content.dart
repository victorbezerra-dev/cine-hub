import 'package:flutter/material.dart';

import '../../../domain/entities/movie_details_entity.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../states/movie_details_state.dart';
import '../home/home_inline_error_banner.dart';
import 'movie_details_info_tile.dart';

class MovieDetailsContent extends StatelessWidget {
  const MovieDetailsContent({
    super.key,
    required this.state,
    required this.isFavorite,
    required this.onRetry,
    this.details,
    this.initialMovie,
  });

  final MovieDetailsState state;
  final bool isFavorite;
  final VoidCallback onRetry;
  final MovieDetailsEntity? details;
  final MovieEntity? initialMovie;

  @override
  Widget build(BuildContext context) {
    if (details == null && initialMovie != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((state.error ?? '').isNotEmpty)
            HomeInlineErrorBanner(message: state.error!, onRetry: onRetry),
          Text(
            initialMovie!.overview.isEmpty
                ? 'Sinopse indisponível.'
                : initialMovie!.overview,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    final movie = details!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((state.error ?? '').isNotEmpty)
          HomeInlineErrorBanner(message: state.error!, onRetry: onRetry),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: movie.genres
              .map(
                (genre) => Chip(
                  label: Text(genre.name),
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  side: BorderSide.none,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        Text(
          'Sinopse',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          movie.overview.isEmpty ? 'Sinopse indisponível.' : movie.overview,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 24),
        MovieDetailsInfoTile(
          label: 'Título original',
          value: movie.originalTitle,
        ),
        MovieDetailsInfoTile(
          label: 'Idioma',
          value: movie.originalLanguage.toUpperCase(),
        ),
        MovieDetailsInfoTile(label: 'Lançamento', value: movie.releaseDate),
        MovieDetailsInfoTile(
          label: 'Favorito',
          value: isFavorite ? 'Sim' : 'Não',
        ),
      ],
    );
  }
}
