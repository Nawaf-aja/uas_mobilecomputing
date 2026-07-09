import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../transaction/presentation/order_bottom_sheet.dart';

class CinemaDetailScreen extends StatelessWidget {
  final String cinemaId;

  const CinemaDetailScreen({
    super.key,
    required this.cinemaId,
  });

  void _showOrderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderBottomSheet(
        movieId: '1',
        movieTitle: 'Film Sedang Tayang Populer',
        cinemaId: cinemaId,
        cinemaName: 'Bioskop XXI $cinemaId',
        pricePerTicket: 50000,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bioskop XXI $cinemaId'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner/Image Placeholder
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Icon(Icons.location_on_rounded, size: 60, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            
            // Name & Location
            Text(
              'Bioskop XXI $cinemaId',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lantai 3, Mall Mega Plaza, Jakarta Pusat, DKI Jakarta',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            
            // Details / Facilities
            const Text(
              'Fasilitas',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Chip(
                  label: Text('Regular'),
                  backgroundColor: AppColors.cardBackground,
                  side: BorderSide(color: AppColors.border),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text('Premiere'),
                  backgroundColor: AppColors.cardBackground,
                  side: BorderSide(color: AppColors.border),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text('IMAX'),
                  backgroundColor: AppColors.cardBackground,
                  side: BorderSide(color: AppColors.border),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Operational Hours
            const Text(
              'Jam Operasional',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '10:00 - 22:00 WIB',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            
            // Random Playing Movies (3-5 items)
            const Text(
              'Film Sedang Tayang',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.movie_creation_outlined, color: AppColors.primary),
                    title: Text('Film Sedang Tayang ${index + 1}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Action, Thriller • Jam: 13:00, 18:30', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    onTap: () {
                      context.push('/movie/${index + 1}');
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: 'Pesan Tiket di Bioskop Ini',
          onPressed: () => _showOrderBottomSheet(context),
        ),
      ),
    );
  }
}
