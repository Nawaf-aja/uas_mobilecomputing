import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_scope.dart';
import 'core/constants.dart';
import 'features/onboarding/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const DataGate(child: CineGoApp()));
}

class CineGoApp extends StatelessWidget {
  const CineGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineGo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red,
          brightness: Brightness.dark,
          primary: AppColors.red,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
