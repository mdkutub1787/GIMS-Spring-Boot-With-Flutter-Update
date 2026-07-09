import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<Map<String, dynamic>?> login(String username, String password) async {
    return await _authService.login(username, password);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return await _authService.register(userData);
  }

  Future<Map<String, dynamic>> verifyOtp(String code) async {
    return await _authService.verifyOtp(code);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await _authService.forgotPassword(email);
  }

  Future<Map<String, dynamic>> verifyResetCode(String code) async {
    return await _authService.verifyResetCode(code);
  }

  Future<Map<String, dynamic>> resetPassword(String code, String newPassword) async {
    return await _authService.resetPassword(code, newPassword);
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
