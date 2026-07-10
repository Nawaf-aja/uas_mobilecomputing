class CineData {
  const CineData({
    required this.users,
    required this.banners,
    required this.movies,
    required this.cinemas,
    required this.cinemaTypes,
  });

  final List<AuthUser> users;
  final List<BannerData> banners;
  final List<Movie> movies;
  final List<Cinema> cinemas;
  final List<CinemaType> cinemaTypes;

  factory CineData.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> moviesJson,
    Map<String, dynamic> authJson,
    Map<String, dynamic> cinemaTypesJson,
  ) {
    return CineData(
      users: (authJson['users'] as List<dynamic>)
          .map((e) => AuthUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      banners: (json['banners'] as List<dynamic>)
          .map((e) => BannerData.fromJson(e as Map<String, dynamic>))
          .toList(),
      movies: (moviesJson['movies'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      cinemas: (json['cinemas'] as List<dynamic>)
          .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
          .toList(),
      cinemaTypes: (cinemaTypesJson['types'] as List<dynamic>)
          .map((e) => CinemaType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CinemaType typeForCinema(Cinema cinema) {
    return cinemaTypes.firstWhere(
      (type) => type.id == cinema.type,
      orElse: () => cinemaTypes.first,
    );
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.saldo,
    required this.points,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final int saldo;
  final int points;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    phone: json['phone'] as String,
    saldo: json['saldo'] as int,
    points: json['points'] as int,
  );
}

class BannerData {
  const BannerData({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    image: json['image'] as String,
  );
}

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.year,
    required this.rating,
    required this.status,
    required this.age,
    required this.poster,
    required this.backdrop,
    required this.synopsis,
    required this.tags,
  });

  final String id;
  final String title;
  final String genre;
  final String duration;
  final String year;
  final double rating;
  final String status;
  final String age;
  final String poster;
  final String backdrop;
  final String synopsis;
  final List<String> tags;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'] as String,
    title: json['title'] as String,
    genre: json['genre'] as String,
    duration: json['duration'] as String,
    year: json['year'] as String,
    rating: (json['rating'] as num).toDouble(),
    status: json['status'] as String? ?? 'sedang_tayang',
    age: json['age'] as String,
    poster: json['poster'] as String,
    backdrop: json['backdrop'] as String,
    synopsis: json['synopsis'] as String,
    tags: (json['tags'] as List<dynamic>).cast<String>(),
  );
}

class Cinema {
  const Cinema({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.distance,
    required this.address,
    required this.image,
    required this.facilities,
  });

  final String id;
  final String name;
  final String type;
  final String city;
  final String distance;
  final String address;
  final String image;
  final List<String> facilities;

  factory Cinema.fromJson(Map<String, dynamic> json) => Cinema(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String? ?? 'xxi',
    city: json['city'] as String,
    distance: json['distance'] as String,
    address: json['address'] as String,
    image: json['image'] as String,
    facilities: (json['facilities'] as List<dynamic>).cast<String>(),
  );
}

class CinemaType {
  const CinemaType({
    required this.id,
    required this.name,
    required this.formats,
    required this.dates,
    required this.times,
  });

  final String id;
  final String name;
  final List<String> formats;
  final List<String> dates;
  final Map<String, List<String>> times;

  factory CinemaType.fromJson(Map<String, dynamic> json) => CinemaType(
    id: json['id'] as String,
    name: json['name'] as String,
    formats: (json['formats'] as List<dynamic>).cast<String>(),
    dates: (json['dates'] as List<dynamic>).cast<String>(),
    times: (json['times'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
    ),
  );
}
