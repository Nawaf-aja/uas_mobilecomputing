class CineData {
  const CineData({
    required this.users,
    required this.banners,
    required this.movies,
    required this.cinemas,
    required this.cinemaTypes,
    required this.transactions,
  });

  final List<AuthUser> users;
  final List<BannerData> banners;
  final List<Movie> movies;
  final List<Cinema> cinemas;
  final List<CinemaType> cinemaTypes;
  final List<TransactionHistory> transactions;

  factory CineData.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> moviesJson,
    Map<String, dynamic> authJson,
    Map<String, dynamic> cinemaTypesJson,
    Map<String, dynamic> transactionsJson,
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
      transactions: (transactionsJson['transactions'] as List<dynamic>)
          .map((e) => TransactionHistory.fromJson(e as Map<String, dynamic>))
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

class TransactionHistory {
  const TransactionHistory({
    required this.id,
    required this.movieTitle,
    required this.cinemaName,
    required this.studioFormat,
    required this.date,
    required this.time,
    required this.seats,
    required this.paymentMethod,
    required this.total,
    required this.status,
    required this.poster,
  });

  final String id;
  final String movieTitle;
  final String cinemaName;
  final String studioFormat;
  final String date;
  final String time;
  final List<String> seats;
  final String paymentMethod;
  final int total;
  final String status;
  final String poster;

  String get formattedTotal {
    final value = total.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      final remaining = value.length - i;
      buffer.write(value[i]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        id: json['id'] as String,
        movieTitle: json['movieTitle'] as String,
        cinemaName: json['cinemaName'] as String,
        studioFormat: json['studioFormat'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        seats: (json['seats'] as List<dynamic>).cast<String>(),
        paymentMethod: json['paymentMethod'] as String,
        total: json['total'] as int,
        status: json['status'] as String,
        poster: json['poster'] as String,
      );
}
