import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import 'schedule_screen.dart';

class FilmDetailScreen extends StatefulWidget {
  const FilmDetailScreen({super.key, required this.movie, this.initialCinema});

  final Movie movie;
  final Cinema? initialCinema;

  @override
  State<FilmDetailScreen> createState() => _FilmDetailScreenState();
}

class _FilmDetailScreenState extends State<FilmDetailScreen> {
  Cinema? selectedCinema;
  var isFavorite = false;

  @override
  void initState() {
    super.initState();
    selectedCinema = widget.initialCinema;
  }

  void buyTicket() {
    final cinema = selectedCinema;
    if (cinema == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih bioskop dulu sebelum beli tiket.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleScreen(movie: widget.movie, cinema: cinema),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = AppScope.of(context);
    final movie = widget.movie;
    final isComingSoon = movie.status == 'segera_tayang';
    return Scaffold(
      body: Stack(
        children: [
          const RedTopAccent(height: 250),
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                HeroImage(url: movie.backdrop, height: 360),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${movie.year} - ${movie.duration} - ${movie.genre} - ${movie.age}',
                        style: const TextStyle(color: AppColors.muted),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        children: movie.tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        movie.synopsis,
                        style: const TextStyle(
                          color: Color(0xFFC8C8D0),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Read more',
                        style: TextStyle(color: AppColors.red),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Text(
                            'Film ini segera tayang. Tiket belum tersedia.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 22),
                        const Text(
                          'Pilih Bioskop',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final cinema in data.cinemas)
                          SelectableCinemaCard(
                            cinema: cinema,
                            selected: selectedCinema?.id == cinema.id,
                            typeName: data.typeForCinema(cinema).name,
                            onTap: () =>
                                setState(() => selectedCinema = cinema),
                          ),
                      ],
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const BackBubble(),
          Positioned(
            top: 46,
            right: 18,
            child: IconButton.filled(
              onPressed: () => setState(() => isFavorite = !isFavorite),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.red : Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: isComingSoon
            ? FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.muted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size.fromHeight(54),
                ),
                onPressed: null,
                icon: const Icon(Icons.event_available_outlined, size: 18),
                label: const Text(
                  'Segera Tayang',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              )
            : RedButton(
                label: 'Beli Tiket',
                icon: Icons.confirmation_number,
                onPressed: buyTicket,
              ),
      ),
    );
  }
}

class SelectableCinemaCard extends StatelessWidget {
  const SelectableCinemaCard({
    super.key,
    required this.cinema,
    required this.selected,
    required this.typeName,
    required this.onTap,
  });

  final Cinema cinema;
  final bool selected;
  final String typeName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.red : Colors.white10,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white10),
              ),
              child: const Icon(
                Icons.theaters_outlined,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cinema.name,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$typeName - ${cinema.distance} - ${cinema.city}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: AppColors.red),
          ],
        ),
      ),
    );
  }
}
