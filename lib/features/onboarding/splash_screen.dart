import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/session_prefs.dart';
import '../auth/login_screen.dart';
import '../home/main_shell.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () async {
      if (!mounted) return;
      final isLoggedIn = await SessionPrefs.isLoggedIn();
      final hasSeenOnboarding = await SessionPrefs.hasSeenOnboarding();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLoggedIn
              ? const MainShell()
              : hasSeenOnboarding
              ? const LoginScreen()
              : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'CineGo',
          style: TextStyle(
            color: AppColors.red,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
