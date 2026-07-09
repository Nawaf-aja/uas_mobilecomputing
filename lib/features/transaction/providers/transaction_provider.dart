import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/transaction_repository.dart';
import '../../../core/network/api_client.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TransactionRepository(apiClient);
});

final ticketHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  // Using dummy user ID '1' if not logged in for testing
  const userId = '1'; 
  return repository.getTicketHistory(userId);
});

class TransactionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  TransactionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  TransactionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository _repository;

  TransactionNotifier(this._repository) : super(TransactionState());

  Future<bool> purchaseTicket({
    required String userId,
    required String movieId,
    required String cinemaId,
    required int quantity,
    required double pricePerTicket,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final double totalPrice = pricePerTicket * quantity;
      await _repository.createTicket({
        'userId': userId,
        'movieId': movieId,
        'cinemaId': cinemaId,
        'showTime': DateTime.now().add(const Duration(days: 1)).toIso8601String(), // Mock showTime tomorrow
        'quantity': quantity,
        'pricePerTicket': pricePerTicket,
        'totalPrice': totalPrice,
        'purchasedAt': DateTime.now().toIso8601String(),
      });
      state = TransactionState(isSuccess: true);
      return true;
    } catch (e) {
      state = TransactionState(errorMessage: e.toString());
      return false;
    }
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});
