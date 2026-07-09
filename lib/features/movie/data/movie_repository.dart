import '../../../core/network/api_client.dart';

class MovieRepository {
  final ApiClient _apiClient;

  MovieRepository(this._apiClient);

  Future<List<Map<String, dynamic>>> getMovies() async {
    try {
      final response = await _apiClient.get('/movies');
      final List<dynamic> data = response.data;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMovieDetail(String id) async {
    try {
      final response = await _apiClient.get('/movies/$id');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
