import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_config.dart';

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
  Future<http.Response> getFirePolicies() => get(ApiConfig.firePolicyListUrl);
  Future<http.Response> getFirePolicyById(int id) => get(ApiConfig.firePolicyGetUrl(id));
  Future<http.Response> saveFirePolicy(Map<String, dynamic> data) => post(ApiConfig.firePolicySaveUrl, data);
  Future<http.Response> updateFirePolicy(int id, Map<String, dynamic> data) => put(ApiConfig.firePolicyUpdateUrl(id), data);
  Future<http.Response> deleteFirePolicy(int id) => delete(ApiConfig.firePolicyDeleteUrl(id));
  Future<http.Response> searchFirePoliciesByHolder(String holder) => get(ApiConfig.firePolicySearchHolderUrl(holder));
  Future<http.Response> searchFirePoliciesByBank(String bank) => get(ApiConfig.firePolicySearchBankUrl(bank));
  
  Future<http.Response> getFireBills() => get(ApiConfig.fireBillListUrl);
  Future<http.Response> getFireBillById(int id) => get(ApiConfig.fireBillGetUrl(id));
  Future<http.Response> saveFireBill(Map<String, dynamic> data) => post(ApiConfig.fireBillSaveUrl, data);
  Future<http.Response> updateFireBill(int id, Map<String, dynamic> data) => put(ApiConfig.fireBillUpdateUrl(id), data);
  Future<http.Response> deleteFireBill(int id) => delete(ApiConfig.fireBillDeleteUrl(id));
  Future<http.Response> searchFireBillsByPolicyholder(String policyholder) => get(ApiConfig.fireBillSearchPolicyholderUrl(policyholder));
  Future<http.Response> searchFireBillsByPolicyId(int policyId) => get(ApiConfig.fireBillSearchPolicyIdUrl(policyId));

  // Fire Money Receipt
  Future<http.Response> getFireReceipts() => get(ApiConfig.fireReceiptListUrl);
  Future<http.Response> saveFireReceipt(Map<String, dynamic> data) => post(ApiConfig.fireReceiptSaveUrl, data);
  Future<http.Response> deleteFireReceipt(int id) => delete(ApiConfig.fireReceiptDeleteUrl(id));

  // Marine Policy & Bill
  Future<http.Response> getMarinePolicies() => get(ApiConfig.marinePolicyListUrl);
  Future<http.Response> getMarinePolicyById(int id) => get(ApiConfig.marinePolicyGetUrl(id));
  Future<http.Response> saveMarinePolicy(Map<String, dynamic> data) => post(ApiConfig.marinePolicySaveUrl, data);
  Future<http.Response> updateMarinePolicy(int id, Map<String, dynamic> data) => put(ApiConfig.marinePolicyUpdateUrl(id), data);
  Future<http.Response> deleteMarinePolicy(int id) => delete(ApiConfig.marinePolicyDeleteUrl(id));

  Future<http.Response> getMarineBills() => get(ApiConfig.marineBillListUrl);
  Future<http.Response> getMarineBillById(int id) => get(ApiConfig.marineBillGetUrl(id));
  Future<http.Response> saveMarineBill(Map<String, dynamic> data) => post(ApiConfig.marineBillSaveUrl, data);
  Future<http.Response> updateMarineBill(int id, Map<String, dynamic> data) => put(ApiConfig.marineBillUpdateUrl(id), data);
  Future<http.Response> deleteMarineBill(int id) => delete(ApiConfig.marineBillDeleteUrl(id));

  // Marine Money Receipt
  Future<http.Response> getMarineReceipts() => get(ApiConfig.marineReceiptListUrl);
  Future<http.Response> saveMarineReceipt(Map<String, dynamic> data) => post(ApiConfig.marineReceiptSaveUrl, data);
  Future<http.Response> updateMarineReceipt(int id, Map<String, dynamic> data) => put(ApiConfig.marineReceiptUpdateUrl(id), data);
  Future<http.Response> deleteMarineReceipt(int id) => delete(ApiConfig.marineReceiptDeleteUrl(id));

  // Utility
  Future<http.Response> getBanks() => get(ApiConfig.banksUrl);
  Future<http.Response> getBranches(int bankId) => get(ApiConfig.branchesUrl(bankId));
  Future<http.Response> getInsuranceCompanies() => get(ApiConfig.insuranceCompaniesUrl);
}
