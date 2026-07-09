import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../providers/movie_provider.dart';

class MovieListTab extends ConsumerWidget {
  const MovieListTab({super.key});

  // Exactly matches the mock UI data in Movie Grid.pdf
  static final List<Map<String, dynamic>> _mockMovies = [
    {'id': '1', 'title': 'Nebula Protocol', 'genre': 'Sci-Fi • Action', 'rating': '8.5'},
    {'id': '2', 'title': 'Neon Shadows', 'genre': 'Thriller • Noir', 'rating': '7.8'},
    {'id': '3', 'title': 'Empire\'s Fall', 'genre': 'Drama • History', 'rating': '9.1'},
    {'id': '4', 'title': 'Lumina\'s Quest', 'genre': 'Animation • Fantasy', 'rating': '8.2'},
    {'id': '5', 'title': 'The Hollow Manor', 'genre': 'Horror • Mystery', 'rating': '7.5'},
    {'id': '6', 'title': 'Lethal Laughs', 'genre': 'Action • Comedy', 'rating': '6.9'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(moviesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Jelajahi Film'),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cari film berdasarkan judul/genre...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          
          // Grid of Movies
          Expanded(
            child: moviesAsync.when(
              data: (moviesList) {
                final displayList = moviesList.isNotEmpty ? moviesList : _mockMovies;
                return _buildGrid(context, displayList);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildGrid(context, _mockMovies),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Map<String, dynamic>> displayList) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final movie = displayList[index];
        return GestureDetector(
          onTap: () {
            context.push('/movie/${movie['id']}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: movie['posterUrl'] != null && movie['posterUrl'].toString().isNotEmpty
                            ? Image.network(
                                movie['posterUrl'].toString(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.movie_rounded, color: AppColors.primary, size: 50),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.movie_rounded, color: AppColors.primary, size: 50),
                              ),
                      ),
                    ),
                    // Rating Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.primary, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              movie['rating']?.toString() ?? '8.0',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie['title'] ?? 'Judul Film',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                movie['genre'] is List
                    ? (movie['genre'] as List).join(' • ')
                    : movie['genre']?.toString() ?? 'Genre',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
