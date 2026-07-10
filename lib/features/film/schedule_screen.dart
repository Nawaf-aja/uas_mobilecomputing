import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import 'seat_screen.dart';
import 'widgets/small_movie_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.movie, required this.cinema});

  final Movie movie;
  final Cinema cinema;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int date = 0;
  int format = 0;
  int time = 0;

  @override
  Widget build(BuildContext context) {
    final cinemaType = AppScope.of(context).typeForCinema(widget.cinema);
    final selectedFormat = cinemaType.formats[format];
    final times = cinemaType.times[selectedFormat] ?? const <String>[];

    return Scaffold(
      body: Stack(
        children: [
          const RedTopAccent(height: 220),
          HeroImage(url: widget.movie.backdrop, height: 220),
          const BackBubble(),
          DraggableScrollableSheet(
            initialChildSize: .76,
            minChildSize: .76,
            maxChildSize: .96,
            builder: (_, controller) => Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'BIOSKOP TERPILIH: ${widget.cinema.name.toUpperCase()}',
                    style: const TextStyle(
                      color: Color(0xFFFF9DA4),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tipe bioskop: ${cinemaType.name}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SmallMovieCard(
                    movie: widget.movie,
                    cinema: widget.cinema.name,
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => ChoiceBox(
                        label: cinemaType.dates[i].replaceFirst(' ', '\n'),
                        width: 78,
                        selected: date == i,
                        onTap: () => setState(() => date = i),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: cinemaType.dates.length,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Format Studio',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      cinemaType.formats.length,
                      (i) => ChoiceBox(
                        label: cinemaType.formats[i],
                        selected: format == i,
                        onTap: () => setState(() {
                          format = i;
                          time = 0;
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Jam Tayang',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      times.length,
                      (i) => ChoiceBox(
                        label: times[i],
                        width: 86,
                        selected: time == i,
                        onTap: () => setState(() => time = i),
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: RedButton(
          label: 'Pilih Kursi',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  SeatScreen(movie: widget.movie, cinema: widget.cinema),
            ),
          ),
        ),
      ),
    );
  }
}

class ChoiceBox extends StatelessWidget {
  const ChoiceBox({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.width,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.red : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppColors.red : Colors.white10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: selected ? Colors.white : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
