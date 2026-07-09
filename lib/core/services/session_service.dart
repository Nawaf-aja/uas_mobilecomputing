import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider that must be overridden in main.dart with initialized SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

final sessionServiceProvider = Provider<SessionService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SessionService(prefs);
});

class SessionService {
  final SharedPreferences _prefs;
  
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';

  SessionService(this._prefs);

  Future<void> saveSession({
    required String userId,
    required String name,
    required String email,
  }) async {
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setBool(_keyIsLoggedIn, true);
  }

  String? get userId => _prefs.getString(_keyUserId);
  String? get userName => _prefs.getString(_keyUserName);
  String? get userEmail => _prefs.getString(_keyUserEmail);
  
  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  Future<void> clearSession() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserEmail);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }
}
