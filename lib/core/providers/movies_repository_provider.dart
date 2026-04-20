import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/movies/data/infra/tmdb_movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import 'movies_remote_data_source_provider.dart';

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final remoteDataSource = ref.watch(moviesRemoteDataSourceProvider);
  return TmdbMoviesRepositoryImpl(remoteDataSource);
});
