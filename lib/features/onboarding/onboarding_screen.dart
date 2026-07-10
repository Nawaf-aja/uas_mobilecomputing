import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/session_prefs.dart';
import '../../core/shared_widgets.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;

  final items = const [
    (
      'Temukan Film Favoritmu',
      'Jelajahi ribuan film dari berbagai genre. Dari aksi mendebarkan hingga drama menyentuh hati, semua ada di sini.',
      Icons.movie_creation_outlined,
    ),
    (
      'Pesan Tiket dalam Sekejap',
      'Pilih kursi favoritmu dan bayar tanpa antre.',
      Icons.confirmation_number_outlined,
    ),
    (
      'Nikmati Pengalaman Nonton',
      'Tunjukkan QR code di loket dan nikmati film pilihanmu.',
      Icons.qr_code_2,
    ),
  ];

  Future<void> next() async {
    if (page == items.length - 1) {
      await SessionPrefs.finishOnboarding();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: PageView.builder(
                  controller: controller,
                  itemCount: items.length,
                  onPageChanged: (value) => setState(() => page = value),
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.$3, size: 88, color: AppColors.red),
                        const SizedBox(height: 34),
                        Text(
                          item.$1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.$2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.muted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  items.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: page == index ? 24 : 7,
                    height: 5,
                    decoration: BoxDecoration(
                      color: page == index
                          ? AppColors.red
                          : AppColors.muted.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              RedButton(
                label: page == items.length - 1 ? 'Mulai' : 'Selanjutnya',
                icon: Icons.arrow_forward,
                onPressed: next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
