import 'dart:convert';
import '../../models/marine/marine_policy.dart';
import '../../services/api_service.dart';

class MarinePolicyRepository {
  final ApiService _apiService;
  MarinePolicyRepository(this._apiService);

  Future<List<MarinePolicy>> fetchPolicies() async {
    final response = await _apiService.getMarinePolicies();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        List<dynamic> data = decoded['data'];
        return data.map((item) => MarinePolicy.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to load marine policies');
  }

  Future<MarinePolicy> getPolicyById(int id) async {
    final response = await _apiService.getMarinePolicyById(id);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        return MarinePolicy.fromJson(decoded['data']);
      }
    }
    throw Exception('Failed to load marine policy with ID $id');
  }

  Future<bool> savePolicy(MarinePolicy policy) async {
    final response = await _apiService.saveMarinePolicy(policy.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    }
    return false;
  }

  Future<bool> updatePolicy(int id, MarinePolicy policy) async {
    final response = await _apiService.updateMarinePolicy(id, policy.toJson());
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    }
    return false;
  }

  Future<bool> deletePolicy(int id) async {
    final response = await _apiService.deleteMarinePolicy(id);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    }
    return false;
  }
}
