import 'dart:convert';
import 'package:general_insurance_management/models/marine_policy_model.dart';
import 'package:general_insurance_management/services/api_service.dart';

class MarinePolicyRepository {
  final ApiService _apiService;
  MarinePolicyRepository(this._apiService);

  Future<List<MarinePolicyModel>> fetchPolicies() async {
    final response = await _apiService.getMarinePolicies();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MarinePolicyModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load marine policies');
  }

  Future<bool> savePolicy(MarinePolicyModel policy) async {
    final response = await _apiService.saveMarinePolicy(policy.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deletePolicy(int id) async {
    final response = await _apiService.deleteMarinePolicy(id);
    return response.statusCode == 200;
  }
}
