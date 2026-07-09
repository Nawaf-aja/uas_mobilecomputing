import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/session_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SessionService _sessionService;

  AuthNotifier(this._repository, this._sessionService) : super(AuthState()) {
    // Check initial session
    if (_sessionService.isLoggedIn) {
      state = AuthState(isAuthenticated: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.login(email, password);
      if (user != null) {
        await _sessionService.saveSession(
          userId: user['id'].toString(),
          name: user['name'] ?? '',
          email: user['email'] ?? '',
        );
        state = AuthState(isAuthenticated: true);
        return true;
      } else {
        state = AuthState(errorMessage: 'Email atau password salah');
        return false;
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final emailExists = await _repository.checkEmailExists(email);
      if (emailExists) {
        state = AuthState(errorMessage: 'Email sudah terdaftar');
        return false;
      }

      await _repository.register({
        'name': name,
        'email': email,
        'password': password,
      });
      state = AuthState(); // Reset loading
      return true;
    } catch (e) {
      state = AuthState(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _sessionService.clearSession();
    state = AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final sessionService = ref.watch(sessionServiceProvider);
  return AuthNotifier(repository, sessionService);
});
