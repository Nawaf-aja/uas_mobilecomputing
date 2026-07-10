import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import '../cinema/widgets/cinema_tile.dart';
import '../film/widgets/movie_poster.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onSeeMovies,
    required this.onSeeCinemas,
  });

  final VoidCallback onSeeMovies;
  final VoidCallback onSeeCinemas;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController movieController;
  String query = '';

  @override
  void initState() {
    super.initState();
    movieController = PageController(viewportFraction: .78, initialPage: 1);
  }

  @override
  void dispose() {
    movieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = AppScope.of(context);
    final normalized = query.toLowerCase();
    final movies = normalized.isEmpty
        ? data.movies
        : data.movies
              .where(
                (movie) =>
                    movie.title.toLowerCase().contains(normalized) ||
                    movie.genre.toLowerCase().contains(normalized) ||
                    movie.tags.any(
                      (tag) => tag.toLowerCase().contains(normalized),
                    ),
              )
              .toList();
    final nowPlaying = movies
        .where((movie) => movie.status == 'sedang_tayang')
        .toList();
    final recommendations = movies.reversed.toList();

    return Stack(
      children: [
        const RedTopAccent(height: 290),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(30, 18, 30, 28),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Halo, Jason',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                      const Positioned(
                        top: 2,
                        right: 2,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SearchBox(onChanged: (value) => setState(() => query = value)),
              const SizedBox(height: 30),
              SizedBox(
                height: 190,
                child: PageView(
                  padEnds: false,
                  controller: PageController(viewportFraction: .96),
                  children: data.banners
                      .map((item) => PromoBanner(banner: item))
                      .toList(),
                ),
              ),
              SectionHeader(
                title: 'Sedang Tayang',
                action: 'Lihat Semua',
                onTap: widget.onSeeMovies,
              ),
              SizedBox(
                height: 440,
                child: PageView.builder(
                  controller: movieController,
                  itemCount: nowPlaying.length,
                  itemBuilder: (context, index) => AnimatedBuilder(
                    animation: movieController,
                    builder: (context, child) {
                      var page = movieController.initialPage.toDouble();
                      if (movieController.hasClients &&
                          movieController.page != null) {
                        page = movieController.page!;
                      }
                      final distance = (page - index).abs().clamp(0.0, 1.0);
                      final scale = 1.0 - (distance * .16);
                      return Transform.scale(
                        scale: scale,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: child,
                        ),
                      );
                    },
                    child: MoviePoster(
                      movie: nowPlaying[index],
                      showGenre: false,
                    ),
                  ),
                ),
              ),
              SectionHeader(
                title: 'Bioskop Terdekat',
                action: 'Lihat Bioskop',
                onTap: widget.onSeeCinemas,
              ),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => SizedBox(
                    width: 275,
                    child: CinemaTile(
                      cinema: data.cinemas[index],
                      horizontal: true,
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemCount: data.cinemas.length,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Rekomendasi Untukmu',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .58,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                ),
                itemCount: recommendations.length,
                itemBuilder: (context, index) => MoviePoster(
                  movie: recommendations[index],
                  showGenre: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.banner});

  final BannerData banner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Positioned.fill(child: NetImage(url: banner.image)),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 20,
            bottom: 20,
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.subtitle,
                  style: const TextStyle(
                    color: Color(0xFFD0D0D7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Cari film, bioskop, atau genre...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 28, 0, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
