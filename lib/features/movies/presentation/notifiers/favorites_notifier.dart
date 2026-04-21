import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/shared_preferences_provider.dart';

const _favoriteMovieIdsKey = 'favorite_movie_ids';

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
      final preferences = ref.watch(sharedPreferencesProvider);

      return FavoritesNotifier(preferences);
    });

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier(this._preferences) : super(<int>{}) {
    _loadFavorites();
  }

  final SharedPreferences _preferences;

  void _loadFavorites() {
    final storedIds =
        _preferences.getStringList(_favoriteMovieIdsKey) ?? <String>[];
    state = storedIds.map(int.parse).toSet();
  }

  Future<void> toggleFavorite(int movieId) async {
    final nextState = Set<int>.from(state);

    if (nextState.contains(movieId)) {
      nextState.remove(movieId);
    } else {
      nextState.add(movieId);
    }

    state = nextState;

    await _preferences.setStringList(
      _favoriteMovieIdsKey,
      nextState.map((id) => id.toString()).toList(),
    );
  }

  bool isFavorite(int movieId) => state.contains(movieId);
}
