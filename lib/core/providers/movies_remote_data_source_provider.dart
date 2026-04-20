import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/movies/data/datasources/movies_remote_data_source_impl.dart';
import '../../features/movies/data/infra/interfaces/movies_remote_data_source.dart';
import 'http_client_provider.dart';

final moviesRemoteDataSourceProvider = Provider<MoviesRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return TmdbMoviesRemoteDataSourceImpl(client);
});
