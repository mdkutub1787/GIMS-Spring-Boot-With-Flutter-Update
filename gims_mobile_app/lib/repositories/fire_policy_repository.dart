import 'dart:convert';
import 'package:gims_mobile_app/models/policy_model.dart';
import 'package:gims_mobile_app/services/api_service.dart';

class FirePolicyRepository {
  final ApiService _apiService;
  FirePolicyRepository(this._apiService);

  Future<List<PolicyModel>> fetchPolicies() async {
    final response = await _apiService.getFirePolicies();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> data = decoded['data'];
      return data.map((item) => PolicyModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load fire policies');
  }

  Future<bool> savePolicy(PolicyModel policy) async {
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

  Future<bool> deletePolicy(int id) async {
    final response = await _apiService.deleteFirePolicy(id);
    return response.statusCode == 200;
  }
}
