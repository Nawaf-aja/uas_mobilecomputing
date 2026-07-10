import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import '../film/widgets/movie_poster.dart';

class CinemaDetailScreen extends StatelessWidget {
  const CinemaDetailScreen({super.key, required this.cinema});

  final Cinema cinema;

  @override
  Widget build(BuildContext context) {
    final movies = AppScope.of(context).movies;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              HeroImage(url: cinema.image, height: 380),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cinema.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFFF9DA4),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            cinema.address,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cinema.facilities
                          .map(
                            (item) => Chip(
                              label: Text(item),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Film Tayang di Sini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .6,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                      itemCount: movies.take(4).length,
                      itemBuilder: (_, i) =>
                          MoviePoster(movie: movies[i], initialCinema: cinema),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const BackBubble(),
          Positioned(
            top: 46,
            right: 18,
            child: IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ),
        ],
      ),
    );
  }
}
