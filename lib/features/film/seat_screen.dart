import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import 'payment_screen.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key, required this.movie, required this.cinema});

  final Movie movie;
  final Cinema cinema;

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  final selected = <String>{'F1', 'F2'};
  final filled = {'B5', 'B6', 'C4', 'D7', 'E3', 'G8'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RedTopAccent(height: 220),
          HeroImage(url: widget.movie.backdrop, height: 230),
          const BackBubble(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 80, 22, 22),
              child: Column(
                children: [
                  Text(
                    widget.movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${widget.cinema.name} • Hari ini, 13:15',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'LAYAR',
                    style: TextStyle(color: AppColors.muted, letterSpacing: 2),
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 7,
                                mainAxisSpacing: 7,
                              ),
                          itemCount: 64,
                          itemBuilder: (_, i) {
                            final row = String.fromCharCode(65 + (i ~/ 8));
                            final id = '$row${(i % 8) + 1}';
                            final isSelected = selected.contains(id);
                            final isFilled = filled.contains(id);
                            return InkWell(
                              onTap: isFilled
                                  ? null
                                  : () => setState(
                                      () => isSelected
                                          ? selected.remove(id)
                                          : selected.add(id),
                                    ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isFilled
                                      ? Colors.white24
                                      : isSelected
                                      ? AppColors.red
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  '${i % 8 + 1}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SeatLegend(color: Color(0xFF33333E), label: 'Tersedia'),
                        SeatLegend(color: AppColors.red, label: 'Dipilih'),
                        SeatLegend(color: Colors.white24, label: 'Terisi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: RedButton(
          label: 'Lanjut ke Pembayaran',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PaymentScreen(movie: widget.movie, cinema: widget.cinema),
            ),
          ),
        ),
      ),
    );
  }
}

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}
