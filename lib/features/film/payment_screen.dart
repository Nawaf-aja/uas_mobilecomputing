import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import 'widgets/small_movie_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.movie,
    required this.cinema,
    required this.seats,
    required this.total,
  });

  final Movie movie;
  final Cinema cinema;
  final List<String> seats;
  final int total;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var selectedPayment = 'GoPay';
  var shareBooking = false;

  Future<void> pay() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Pembayaran Berhasil'),
        content: Text(
          'Tiket ${widget.movie.title} untuk kursi ${widget.seats.join(', ')} berhasil dibayar dengan $selectedPayment.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text(
              'Selesai',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments = ['GoPay', 'OVO', 'Transfer Bank', 'Kartu Debit'];

    return Scaffold(
      body: Stack(
        children: [
          const RedTopAccent(height: 220),
          HeroImage(url: widget.movie.backdrop, height: 210),
          const BackBubble(),
          DraggableScrollableSheet(
            initialChildSize: .78,
            builder: (_, controller) => Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Ringkasan & Pembayaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SmallMovieCard(
                    movie: widget.movie,
                    cinema: widget.cinema.name,
                    seatsText: 'Kursi ${widget.seats.join(', ')}',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(color: AppColors.muted),
                      ),
                      Text(
                        formatRupiah(widget.total),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: payments
                        .map(
                          (payment) => PayChip(
                            label: payment,
                            selected: selectedPayment == payment,
                            onTap: () =>
                                setState(() => selectedPayment = payment),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                  CheckboxListTile(
                    value: shareBooking,
                    onChanged: (value) =>
                        setState(() => shareBooking = value ?? false),
                    title: const Text('Bagikan kode booking ke teman'),
                    subtitle: const Text(
                      'Teman kamu bisa melihat tiket ini di aplikasi mereka.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: RedButton(label: 'Bayar Sekarang', onPressed: pay),
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

class PayChip extends StatelessWidget {
  const PayChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.red.withValues(alpha: .08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AppColors.red : Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 15,
              color: selected ? AppColors.red : AppColors.muted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
