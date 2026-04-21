import 'package:flutter_dotenv/flutter_dotenv.dart';

class Settings {
  const Settings._();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static String get tmdbReadAccessToken =>
      dotenv.env['TMDB_READ_ACCESS_TOKEN'] ?? '';

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String defaultPosterSize = 'w500';
  static const String defaultBackdropSize = 'w780';

  static const String language = 'pt-BR';

  static const String nowPlayingPath = '/movie/now_playing';
  static const String popularMoviesPath = '/movie/popular';
  static const String configurationPath = '/configuration';

  static String movieDetailsPath(int movieId) => '/movie/$movieId';
}
