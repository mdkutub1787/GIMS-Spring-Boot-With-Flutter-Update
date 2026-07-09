import 'dart:convert';
import 'package:general_insurance_management/models/policy_model.dart';
import 'package:general_insurance_management/services/api_service.dart';

class FirePolicyRepository {
  final ApiService _apiService;
  FirePolicyRepository(this._apiService);

  Future<List<PolicyModel>> fetchPolicies() async {
    final response = await _apiService.getFirePolicies();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PolicyModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load fire policies');
  }

  Future<bool> savePolicy(PolicyModel policy) async {
    final response = await _apiService.saveFirePolicy(policy.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deletePolicy(int id) async {
    final response = await _apiService.deleteFirePolicy(id);
    return response.statusCode == 200;
  }
}
