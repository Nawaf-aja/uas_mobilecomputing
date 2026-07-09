class ApiEndpoints {
  ApiEndpoints._();

  // Set to http://localhost:3000 when using adb reverse tcp:3000 tcp:3000
  static const String baseUrl = 'http://localhost:3000';

  // Auth
  static const String login = '/users';
  static const String register = '/users';
  static String checkEmail(String email) => '/users?email=$email';

  // Movies
  static const String movies = '/movies';
  static String movieDetail(String id) => '/movies/$id';

  // Cinemas
  static const String cinemas = '/cinemas';
  static String cinemaDetail(String id) => '/cinemas/$id';

  // Tickets
  static const String tickets = '/tickets';
  static String ticketHistory(String userId) => '/tickets?userId=$userId';
}
