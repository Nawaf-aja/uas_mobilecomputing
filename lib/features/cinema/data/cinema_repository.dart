import '../../../core/network/api_client.dart';

class CinemaRepository {
  final ApiClient _apiClient;

  CinemaRepository(this._apiClient);

  Future<List<Map<String, dynamic>>> getCinemas() async {
    try {
      final response = await _apiClient.get('/cinemas');
      final List<dynamic> data = response.data;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCinemaDetail(String id) async {
    try {
      final response = await _apiClient.get('/cinemas/$id');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
