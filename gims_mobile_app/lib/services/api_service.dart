import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Generic Methods
  Future<http.Response> get(String url) async {
    print('GET Request to: $url');
    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    print('Response from $url: [${response.statusCode}] ${response.body}');
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    print('POST Request to: $url');
    print('Request Body: ${jsonEncode(body)}');
    final response = await http.post(Uri.parse(url), headers: await _getHeaders(), body: jsonEncode(body));
    print('Response from $url: [${response.statusCode}] ${response.body}');
    return response;
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    print('PUT Request to: $url');
    print('Request Body: ${jsonEncode(body)}');
    final response = await http.put(Uri.parse(url), headers: await _getHeaders(), body: jsonEncode(body));
    print('Response from $url: [${response.statusCode}] ${response.body}');
    return response;
  }

  Future<http.Response> delete(String url) async {
    print('DELETE Request to: $url');
    final response = await http.delete(Uri.parse(url), headers: await _getHeaders());
    print('Response from $url: [${response.statusCode}] ${response.body}');
    return response;
  }

  // Fire Policy & Bill
  Future<http.Response> getFirePolicies() => get(ApiConstants.firePolicyList);
  Future<http.Response> getFirePolicyById(int id) => get('${ApiConstants.firePolicyGet}/$id');
  Future<http.Response> saveFirePolicy(Map<String, dynamic> data) => post(ApiConstants.firePolicySave, data);
  Future<http.Response> updateFirePolicy(int id, Map<String, dynamic> data) => put('${ApiConstants.firePolicyUpdate}/$id', data);
  Future<http.Response> deleteFirePolicy(int id) => delete('${ApiConstants.firePolicyDelete}/$id');
  Future<http.Response> searchFirePoliciesByHolder(String holder) => get('${ApiConstants.firePolicySearchHolder}?policyholder=$holder');
  Future<http.Response> searchFirePoliciesByBank(String bank) => get('${ApiConstants.firePolicySearchBank}?bankname=$bank');
  
  Future<http.Response> getFireBills() => get(ApiConstants.fireBillList);
  Future<http.Response> getFireBillById(int id) => get('${ApiConstants.fireBillGet}/$id');
  Future<http.Response> saveFireBill(Map<String, dynamic> data) => post(ApiConstants.fireBillSave, data);
  Future<http.Response> updateFireBill(int id, Map<String, dynamic> data) => put('${ApiConstants.fireBillUpdate}/$id', data);
  Future<http.Response> deleteFireBill(int id) => delete('${ApiConstants.fireBillDelete}/$id');
  Future<http.Response> searchFireBillsByPolicyholder(String policyholder) => get('${ApiConstants.fireBillSearchPolicyholder}?policyholder=$policyholder');
  Future<http.Response> searchFireBillsByPolicyId(int policyId) => get('${ApiConstants.fireBillSearchPolicyId}?policyid=$policyId');

  // Fire Money Receipt
  Future<http.Response> getFireReceipts() => get(ApiConstants.fireReceiptList);
  Future<http.Response> saveFireReceipt(Map<String, dynamic> data) => post(ApiConstants.fireReceiptSave, data);
  Future<http.Response> deleteFireReceipt(int id) => delete('${ApiConstants.fireReceiptDelete}/$id');

  // Marine Policy & Bill
  Future<http.Response> getMarinePolicies() => get(ApiConstants.marinePolicyList);
  Future<http.Response> getMarinePolicyById(int id) => get('${ApiConstants.marinePolicyGet}/$id');
  Future<http.Response> saveMarinePolicy(Map<String, dynamic> data) => post(ApiConstants.marinePolicySave, data);
  Future<http.Response> updateMarinePolicy(int id, Map<String, dynamic> data) => put('${ApiConstants.marinePolicyUpdate}/$id', data);
  Future<http.Response> deleteMarinePolicy(int id) => delete('${ApiConstants.marinePolicyDelete}/$id');

  Future<http.Response> getMarineBills() => get(ApiConstants.marineBillList);
  Future<http.Response> getMarineBillById(int id) => get('${ApiConstants.marineBillGet}/$id');
  Future<http.Response> saveMarineBill(Map<String, dynamic> data) => post(ApiConstants.marineBillSave, data);
  Future<http.Response> updateMarineBill(int id, Map<String, dynamic> data) => put('${ApiConstants.marineBillUpdate}/$id', data);
  Future<http.Response> deleteMarineBill(int id) => delete('${ApiConstants.marineBillDelete}/$id');

  // Marine Money Receipt
  Future<http.Response> getMarineReceipts() => get(ApiConstants.marineReceiptList);
  Future<http.Response> saveMarineReceipt(Map<String, dynamic> data) => post(ApiConstants.marineReceiptSave, data);
  Future<http.Response> deleteMarineReceipt(int id) => delete('${ApiConstants.marineReceiptDelete}/$id');

  // Utility
  Future<http.Response> getBanks() => get(ApiConstants.banks);
  Future<http.Response> getBranches(int bankId) => get('${ApiConstants.branches}/$bankId/branches');
  Future<http.Response> getInsuranceCompanies() => get(ApiConstants.insuranceCompanies);
}
