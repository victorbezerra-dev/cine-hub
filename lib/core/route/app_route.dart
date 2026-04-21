import 'package:go_router/go_router.dart';

import '../../features/movies/domain/entities/movie_entity.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MovieDetailsPage(
          movieId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          heroTag:
              extra?['heroTag'] as String? ??
              'movie-${state.pathParameters['id'] ?? ''}',
          initialMovie: extra?['movie'] as MovieEntity?,
        );
      },
    ),
  ],
);
