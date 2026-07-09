import '../../../core/network/api_client.dart';

class TransactionRepository {
  final ApiClient _apiClient;

  TransactionRepository(this._apiClient);

  Future<Map<String, dynamic>> createTicket(Map<String, dynamic> ticketData) async {
    try {
      final response = await _apiClient.post('/tickets', data: ticketData);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTicketHistory(String userId) async {
    try {
      final response = await _apiClient.get('/tickets', queryParameters: {'userId': userId});
      final List<dynamic> data = response.data;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      rethrow;
    }
  }
}
