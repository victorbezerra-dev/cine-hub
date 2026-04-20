import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie_entity.dart';
import '../notifiers/home_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(homeNotifierProvider.notifier).fetchMovies(),
    );
  }

  Widget _buildMovieTile(MovieEntity movie, IconData fallbackIcon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 50,
        height: 75,
        child: movie.posterUrl != null && movie.posterUrl!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.posterUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(fallbackIcon),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              )
            : Icon(fallbackIcon),
      ),
      title: Text(movie.title),
      subtitle: Text(
        movie.releaseDate.isEmpty ? 'No release date' : movie.releaseDate,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMovieSection({
    required String title,
    required List<MovieEntity> movies,
    required IconData fallbackIcon,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: movies.isEmpty
                ? const Center(child: Text('No movies available'))
                : ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (_, index) =>
                        _buildMovieTile(movies[index], fallbackIcon),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cine Hub')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.error != null && state.error!.isNotEmpty) ...[
                    Text(
                      state.error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildMovieSection(
                    title: 'Now Playing',
                    movies: state.nowPlaying,
                    fallbackIcon: Icons.local_fire_department_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildMovieSection(
                    title: 'Popular Movies',
                    movies: state.popular,
                    fallbackIcon: Icons.movie_outlined,
                  ),
                ],
              ),
      ),
    );
  }
}
