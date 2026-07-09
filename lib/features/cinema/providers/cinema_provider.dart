import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cinema_repository.dart';
import '../../../core/network/api_client.dart';

final cinemaRepositoryProvider = Provider<CinemaRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CinemaRepository(apiClient);
});

final cinemasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(cinemaRepositoryProvider);
  return repository.getCinemas();
});

final cinemaDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final repository = ref.watch(cinemaRepositoryProvider);
  return repository.getCinemaDetail(id);
});
