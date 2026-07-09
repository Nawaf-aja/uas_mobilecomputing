import '../../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _apiClient.get('/users', queryParameters: {
        'email': email,
      });
      
      final List<dynamic> data = response.data;
      if (data.isNotEmpty) {
        final user = data.first as Map<String, dynamic>;
        // Match password locally to bypass JSON Server numeric parameters type coercion issues
        if (user['password']?.toString() == password) {
          return user;
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.post('/users', data: userData);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _apiClient.get('/users', queryParameters: {'email': email});
      final List<dynamic> data = response.data;
      return data.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
