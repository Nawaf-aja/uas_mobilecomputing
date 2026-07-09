import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../transaction/presentation/order_bottom_sheet.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  void _showOrderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderBottomSheet(
        movieId: movieId,
        movieTitle: 'Film Pilihan $movieId',
        cinemaId: '1',
        cinemaName: 'Bioskop XXI Central',
        pricePerTicket: 50000,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Movie Backdrop App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.cardBackground,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_rounded, size: 80, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text('Poster Film $movieId', style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Movie Info Content
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Film Pilihan $movieId',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '13+',
                            style: TextStyle(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Genre & Duration
                    const Text(
                      'Action, Sci-Fi • 120 Menit',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Synopsis
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ini adalah sinopsis lengkap dari film pilihan ini. Cerita menceritakan tentang perjuangan seorang pahlawan dalam menyelamatkan dunia dari ancaman kehancuran total dengan bumbu-bumbu aksi dramatis dan petualangan yang menegangkan di luar angkasa.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Available Cinemas Section
                    const Text(
                      'Tersedia di Bioskop',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Display up to 5 Cinemas (simulated list)
                    ...List.generate(3, (index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: ListTile(
                          title: Text('Bioskop XXI Central ${index + 1}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          subtitle: const Text('Regular • Jam 14:00, 16:30, 19:00', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right_rounded, color: AppColors.primary),
                            onPressed: () {
                              context.push('/cinema/${index + 1}');
                            },
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 100), // Spacing for bottom button
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomSheet: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: 'Beli Tiket Sekarang',
          onPressed: () => _showOrderBottomSheet(context),
        ),
      ),
    );
  }
}
