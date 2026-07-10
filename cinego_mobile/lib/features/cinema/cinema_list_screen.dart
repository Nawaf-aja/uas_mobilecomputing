import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/shared_widgets.dart';
import 'widgets/cinema_tile.dart';

class CinemaListScreen extends StatelessWidget {
  const CinemaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppScope.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const TopTitle(title: 'Bioskop'),
          const SizedBox(height: 16),
          const Segments(items: ['Jakarta', 'Bogor', 'Depok', 'Tangerang']),
          const SizedBox(height: 18),
          for (final cinema in data.cinemas) CinemaTile(cinema: cinema),
        ],
      ),
    );
  }
}
