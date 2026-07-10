import 'dart:convert';
import '../../models/fire/fire_policy.dart';
import '../../services/api_service.dart';

class FirePolicyRepository {
  final ApiService _apiService;
  FirePolicyRepository(this._apiService);

  Future<List<FirePolicy>> fetchPolicies() async {
    final response = await _apiService.getFirePolicies();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        return data.map((item) => FirePolicy.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to load fire policies');
  }

  Future<FirePolicy> getPolicyById(int id) async {
    final response = await _apiService.getFirePolicyById(id);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        return FirePolicy.fromJson(decoded['data']);
      }
    }
    throw Exception('Failed to load fire policy with ID $id');
  }

  Future<bool> savePolicy(FirePolicy policy) async {
    final response = await _apiService.saveFirePolicy(policy.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: You do not have permission to perform this action.');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again.');
    } else {
      throw Exception('Failed to save policy: ${response.statusCode}');
    }
  }

  Future<bool> updatePolicy(int id, FirePolicy policy) async {
    final response = await _apiService.updateFirePolicy(id, policy.toJson());
    return response.statusCode == 200;
  }

  Future<bool> deletePolicy(int id) async {
    final response = await _apiService.deleteFirePolicy(id);
    return response.statusCode == 200;
  }

  Future<List<FirePolicy>> searchByHolder(String holder) async {
    final response = await _apiService.searchFirePoliciesByHolder(holder);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        return data.map((item) => FirePolicy.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to search policies by holder');
  }

  Future<List<FirePolicy>> searchByBank(String bank) async {
    final response = await _apiService.searchFirePoliciesByBank(bank);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        return data.map((item) => FirePolicy.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to search policies by bank');
  }
}
