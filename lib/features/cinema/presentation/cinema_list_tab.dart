import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../providers/cinema_provider.dart';

class CinemaListTab extends ConsumerWidget {
  const CinemaListTab({super.key});

  // Matches the mock UI data in Frame 47.pdf
  static final List<Map<String, dynamic>> _mockCinemas = [
    {'id': '1', 'name': 'AEON MALL TANJUNG BARAT', 'distance': '6.32 km', 'location': 'Jakarta Selatan'},
    {'id': '2', 'name': 'AGORA MALL XXI', 'distance': '5.99 km', 'location': 'Jakarta Pusat'},
    {'id': '3', 'name': 'ARION XXI', 'distance': '2.4 km', 'location': 'Jakarta Pusat'},
    {'id': '4', 'name': 'ARTHA GADING XXI', 'distance': '2.4 km', 'location': 'Jakarta Pusat'},
    {'id': '5', 'name': 'BASURA XXI', 'distance': '2.4 km', 'location': 'Jakarta Pusat'},
    {'id': '6', 'name': 'BAYWALK PLUIT XXI', 'distance': '2.4 km', 'location': 'Jakarta Pusat'},
    {'id': '7', 'name': 'BLOK M SQUARE', 'distance': '2.4 km', 'location': 'Jakarta Pusat'},
    {'id': '8', 'name': 'BLOK M PLAZA', 'distance': '2.4 km', 'location': 'Jakarta Pusat'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cinemasAsync = ref.watch(cinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bioskop Terdekat'),
      ),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Cari bioskop...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
                ),
              ],
            ),
          ),

          // List of Cinemas
          Expanded(
            child: cinemasAsync.when(
              data: (cinemasList) {
                final displayList = cinemasList.isNotEmpty ? cinemasList : _mockCinemas;
                return _buildList(context, displayList);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildList(context, _mockCinemas),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Map<String, dynamic>> displayList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final cinema = displayList[index];
        final distanceStr = cinema['distance'] ?? '2.0 km';
        final locationStr = cinema['location'] ?? 'Jakarta';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
            ),
            title: Text(
              cinema['name'] ?? 'Nama Bioskop',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  '$distanceStr • $locationStr',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Text(
                      'REGULAR 2D',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'IMAX 2D',
                      style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            onTap: () {
              context.push('/cinema/${cinema['id']}');
            },
          ),
        );
      },
    );
  }
}
