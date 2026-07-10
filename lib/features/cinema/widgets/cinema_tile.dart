import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/models.dart';
import '../../../core/shared_widgets.dart';
import '../cinema_detail_screen.dart';

class CinemaTile extends StatelessWidget {
  const CinemaTile({
    super.key,
    required this.cinema,
    this.compact = false,
    this.horizontal = false,
  });

  final Cinema cinema;
  final bool compact;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CinemaDetailScreen(cinema: cinema)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: horizontal ? 0 : 12),
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: compact ? AppColors.red : Colors.white10),
        ),
        child: horizontal
            ? _HorizontalCinema(cinema: cinema)
            : _VerticalCinema(cinema: cinema),
      ),
    );
  }
}

class _HorizontalCinema extends StatelessWidget {
  const _HorizontalCinema({required this.cinema});

  final Cinema cinema;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.theaters_outlined, color: AppColors.muted),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cinema.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${cinema.distance} - ${cinema.city}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerticalCinema extends StatelessWidget {
  const _VerticalCinema({required this.cinema});

  final Cinema cinema;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                cinema.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              '${cinema.distance} - ${cinema.city}',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: cinema.facilities
              .take(2)
              .map((item) => SmallTag(label: item))
              .toList(),
        ),
      ],
    );
  }
}
