import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/models.dart';
import '../../../core/shared_widgets.dart';
import '../film_detail_screen.dart';

class MoviePoster extends StatelessWidget {
  const MoviePoster({
    super.key,
    required this.movie,
    this.width,
    this.showGenre = true,
    this.initialCinema,
  });

  final Movie movie;
  final double? width;
  final bool showGenre;
  final Cinema? initialCinema;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FilmDetailScreen(movie: movie, initialCinema: initialCinema),
        ),
      ),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Positioned.fill(child: NetImage(url: movie.poster)),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: RatingBadge(value: movie.rating),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            if (showGenre)
              Text(
                '${movie.genre} - ${movie.tags.take(1).join()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}
