import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = AppScope.of(context).transactions;

    return Scaffold(
      body: Stack(
        children: [
          const RedTopAccent(height: 230),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              children: [
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Riwayat Transaksi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SummaryPanel(transactions: transactions),
                const SizedBox(height: 22),
                for (final transaction in transactions)
                  TransactionCard(transaction: transaction),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({super.key, required this.transactions});

  final List<TransactionHistory> transactions;

  @override
  Widget build(BuildContext context) {
    final totalTickets = transactions.fold<int>(
      0,
      (sum, item) => sum + item.seats.length,
    );
    final totalSpent = transactions.fold<int>(
      0,
      (sum, item) => sum + item.total,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: SummaryItem(
              label: 'TRANSAKSI',
              value: transactions.length.toString(),
            ),
          ),
          const SizedBox(height: 42, child: VerticalDivider()),
          Expanded(
            child: SummaryItem(label: 'TIKET', value: totalTickets.toString()),
          ),
          const SizedBox(height: 42, child: VerticalDivider()),
          Expanded(
            child: SummaryItem(label: 'TOTAL', value: formatRupiah(totalSpent)),
          ),
        ],
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  const SummaryItem({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 6),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});

  final TransactionHistory transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 76,
                  height: 104,
                  child: NetImage(url: transaction.poster),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            transaction.movieTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        StatusPill(label: transaction.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InfoLine(
                      icon: Icons.theaters_outlined,
                      text: transaction.cinemaName,
                    ),
                    InfoLine(
                      icon: Icons.event_outlined,
                      text: '${transaction.date} - ${transaction.time}',
                    ),
                    InfoLine(
                      icon: Icons.chair_outlined,
                      text:
                          '${transaction.studioFormat} - Kursi ${transaction.seats.join(', ')}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 26, color: Colors.white10),
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.id,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
              Text(
                transaction.paymentMethod,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(width: 12),
              Text(
                transaction.formattedTotal,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red.withValues(alpha: .5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.red,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  const InfoLine({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.muted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
        ],
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
