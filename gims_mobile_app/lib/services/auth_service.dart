import 'dart:convert';
import 'dart:developer';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse(ApiConstants.login);
    log('API Request: POST $url');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('userRole', payload['role'] ?? 'USER');
        
        return data;
      }
    } catch (e) {
      log('API Error (Login): $e');
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final url = Uri.parse(ApiConstants.register);
    log('API Request: POST $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      log('API Error (Register): $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String code) async {
    final url = Uri.parse(ApiConstants.verifyOtp);
    log('API Request: POST $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      log('API Error (VerifyOtp): $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse(ApiConstants.forgotPassword);
    log('API Request: POST $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      log('API Error (ForgotPassword): $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyResetCode(String code) async {
    final url = Uri.parse(ApiConstants.verifyResetCode);
    log('API Request: POST $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      log('API Error (VerifyResetCode): $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> resetPassword(String code, String newPassword) async {
    final url = Uri.parse(ApiConstants.resetPassword);
    log('API Request: POST $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'newPassword': newPassword,
        }),
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      log('API Error (ResetPassword): $e');
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        return {'message': response.body};
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
