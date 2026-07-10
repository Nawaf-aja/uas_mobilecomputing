import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../auth/login_screen.dart';
import 'transaction_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.receipt_long_outlined, 'Riwayat Transaksi'),
      (Icons.confirmation_number_outlined, 'Voucher Saya'),
      (Icons.campaign_outlined, 'Promo'),
      (Icons.person_outline, 'Informasi Akun'),
      (Icons.help_outline, 'Pusat Bantuan'),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Profil',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.red,
            child: CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/jason-ranti/300',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jason Ranti',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const Text(
            '0812-3456-7890 | jason.ranti@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'SALDO CINEGO',
                        style: TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                      Text(
                        'Rp 150.000',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35, child: VerticalDivider()),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'CINEGO POINTS',
                        style: TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                      Text(
                        '1,250',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final item in items)
            ListTile(
              leading: Icon(item.$1, color: AppColors.muted),
              title: Text(item.$2),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
              onTap: item.$2 == 'Riwayat Transaksi'
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionHistoryScreen(),
                      ),
                    )
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.$2} belum tersedia')),
                    ),
            ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
            child: const Text('Keluar', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}
