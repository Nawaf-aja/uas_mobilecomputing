import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/models.dart';
import '../../../core/shared_widgets.dart';

class SmallMovieCard extends StatelessWidget {
  const SmallMovieCard({super.key, required this.movie, required this.cinema});

  final Movie movie;
  final String cinema;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 70,
              height: 92,
              child: NetImage(url: movie.poster),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  cinema,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 10),
                RatingBadge(value: movie.rating),
                const SizedBox(height: 6),
                const Text(
                  '15 Mar     19:30\nKursi F1, F2',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
