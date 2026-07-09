import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/movie_repository.dart';
import '../../../core/network/api_client.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MovieRepository(apiClient);
});

final moviesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getMovies();
});

final movieDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getMovieDetail(id);
});
