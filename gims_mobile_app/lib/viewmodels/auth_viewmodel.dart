import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthState {
  final bool isLoading;
  final String? error;
  final String? role;
  final String? message;
  final UserModel? user;

  AuthState({this.isLoading = false, this.error, this.role, this.message, this.user});

  AuthState copyWith({bool? isLoading, String? error, String? role, String? message, UserModel? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      role: role ?? this.role,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(username, password);
      if (response != null && response['user'] != null) {
        final user = UserModel.fromJson(response['user']);
        state = state.copyWith(
          isLoading: false, 
          role: user.role?.toString().split('.').last,
          user: user,
        );
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid username or password');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(userData);
      state = state.copyWith(isLoading: false, message: response['message']);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.verifyOtp(code);
      if (response['success'] == true) {
        state = state.copyWith(isLoading: false, message: response['message']);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: response['message'] ?? 'Verification failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.forgotPassword(email);
      if (response['success'] == true) {
        state = state.copyWith(isLoading: false, message: response['message']);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: response['message'] ?? 'Request failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> verifyResetCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.verifyResetCode(code);
      if (response['success'] == true) {
        state = state.copyWith(isLoading: false, message: response['message']);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: response['message'] ?? 'Invalid code');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> resetPassword(String code, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.resetPassword(code, newPassword);
      if (response['success'] == true) {
        state = state.copyWith(isLoading: false, message: response['message']);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: response['message'] ?? 'Reset failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState();
  }

  Future<bool> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.fetchProfile();
      final user = UserModel.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          user: user,
          role: user.role?.toString().split('.').last,
        );
        return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.updateProfile(data);
      if (response['success'] == true) {
        state = state.copyWith(isLoading: false, message: response['message']);
        // Fetch updated profile
        await fetchProfile();
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: response['message'] ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.watch(authServiceProvider));
});
