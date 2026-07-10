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
  static const seatPrice = 55000;

  final selected = <String>{};
  final filled = {'B5', 'B6', 'C4', 'D7', 'E3', 'G8'};

  int get totalPrice => selected.length * seatPrice;

  List<String> get sortedSeats {
    final seats = selected.toList();
    seats.sort();
    return seats;
  }

  void continueToPayment() {
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 kursi dulu.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          movie: widget.movie,
          cinema: widget.cinema,
          seats: sortedSeats,
          total: totalPrice,
        ),
      ),
    );
  }

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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 22),
                              for (var i = 1; i <= 8; i++)
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '$i',
                                      style: const TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AspectRatio(
                            aspectRatio: 1,
                            child: Row(
                              children: [
                                Column(
                                  children: List.generate(
                                    8,
                                    (index) => Expanded(
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(65 + index),
                                          style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 8,
                                          crossAxisSpacing: 7,
                                          mainAxisSpacing: 7,
                                        ),
                                    itemCount: 64,
                                    itemBuilder: (_, i) {
                                      final row = String.fromCharCode(
                                        65 + (i ~/ 8),
                                      );
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
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: Text(
                                            id,
                                            style: TextStyle(
                                              color: isFilled
                                                  ? AppColors.muted
                                                  : isSelected
                                                  ? Colors.white
                                                  : Colors.white54,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kursi Dipilih',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                selected.isEmpty
                                    ? 'Belum ada kursi'
                                    : sortedSeats.join(', '),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${selected.length} x ${formatRupiah(seatPrice)}',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatRupiah(totalPrice),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SeatLegend(
                              color: Color(0xFF33333E),
                              label: 'Tersedia',
                            ),
                            SeatLegend(color: AppColors.red, label: 'Dipilih'),
                            SeatLegend(color: Colors.white24, label: 'Terisi'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Harga per kursi Rp 55.000',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
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
          label: selected.isEmpty
              ? 'Pilih Kursi Dulu'
              : 'Bayar ${formatRupiah(totalPrice)}',
          onPressed: continueToPayment,
        ),
      ),
    );
  }
}

String formatRupiah(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp $buffer';
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
