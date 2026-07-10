import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/constants.dart';
import '../../core/models.dart';
import '../../core/shared_widgets.dart';
import 'widgets/movie_poster.dart';

class FilmListScreen extends StatefulWidget {
  const FilmListScreen({super.key});

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  final searchController = TextEditingController();
  var activeStatus = 'sedang_tayang';
  var showSearch = false;

  final tabs = const [
    ('sedang_tayang', 'Sedang Tayang'),
    ('presale', 'Tiket Presale'),
    ('segera_tayang', 'Segera Tayang'),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Movie> filteredMovies(List<Movie> movies) {
    final query = searchController.text.toLowerCase();
    return movies.where((movie) {
      final matchesTab = movie.status == activeStatus;
      final matchesSearch =
          query.isEmpty ||
          movie.title.toLowerCase().contains(query) ||
          movie.genre.toLowerCase().contains(query) ||
          movie.tags.any((tag) => tag.toLowerCase().contains(query));
      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = AppScope.of(context);
    final movies = filteredMovies(data.movies);

    return Stack(
      children: [
        const RedTopAccent(height: 230),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(30, 42, 30, 28),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Film',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => showSearch = !showSearch),
                    icon: const Icon(Icons.search, size: 32),
                  ),
                ],
              ),
              if (showSearch) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari film atau genre...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final tab = tabs[index];
                    final selected = activeStatus == tab.$1;
                    return InkWell(
                      onTap: () => setState(() => activeStatus = tab.$1),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.red : AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: selected ? AppColors.red : Colors.white10,
                          ),
                        ),
                        child: Text(
                          tab.$2,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemCount: tabs.length,
                ),
              ),
              const SizedBox(height: 34),
              if (movies.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: Text(
                      'Film tidak ditemukan',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .58,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (_, i) => MoviePoster(movie: movies[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
