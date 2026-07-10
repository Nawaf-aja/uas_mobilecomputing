import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../cinema/cinema_list_screen.dart';
import '../film/film_list_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onSeeMovies: () => setState(() => tab = 1),
        onSeeCinemas: () => setState(() => tab = 2),
      ),
      const FilmListScreen(),
      const CinemaListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF17171F),
        indicatorColor: Colors.transparent,
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.red),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie, color: AppColors.red),
            label: 'Film',
          ),
          NavigationDestination(
            icon: Icon(Icons.theaters_outlined),
            selectedIcon: Icon(Icons.theaters, color: AppColors.red),
            label: 'Bioskop',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.red),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
