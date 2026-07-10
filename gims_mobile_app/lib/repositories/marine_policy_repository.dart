import 'dart:convert';
import 'package:gims_mobile_app/models/marine_policy_model.dart';
import 'package:gims_mobile_app/services/api_service.dart';

class MarinePolicyRepository {
  final ApiService _apiService;
  MarinePolicyRepository(this._apiService);

  Future<List<MarinePolicyModel>> fetchPolicies() async {
    final response = await _apiService.getMarinePolicies();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> data = decoded['data'];
      return data.map((item) => MarinePolicyModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load marine policies');
  }

  Future<bool> savePolicy(MarinePolicyModel policy) async {
    final response = await _apiService.saveMarinePolicy(policy.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: You do not have permission to perform this action.');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again.');
    } else {
      throw Exception('Failed to save marine policy: ${response.statusCode}');
    }
  }

  Future<bool> deletePolicy(int id) async {
    final response = await _apiService.deleteMarinePolicy(id);
    return response.statusCode == 200;
  }
}
