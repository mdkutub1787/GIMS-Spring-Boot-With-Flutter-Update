import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Generic Methods
  Future<http.Response> get(String url) async => await http.get(Uri.parse(url), headers: await _getHeaders());
  Future<http.Response> post(String url, Map<String, dynamic> body) async => await http.post(Uri.parse(url), headers: await _getHeaders(), body: jsonEncode(body));
  Future<http.Response> put(String url, Map<String, dynamic> body) async => await http.put(Uri.parse(url), headers: await _getHeaders(), body: jsonEncode(body));
  Future<http.Response> delete(String url) async => await http.delete(Uri.parse(url), headers: await _getHeaders());

  // Fire Policy & Bill
  Future<http.Response> getFirePolicies() => get(ApiConstants.firePolicyList);
  Future<http.Response> saveFirePolicy(Map<String, dynamic> data) => post(ApiConstants.firePolicySave, data);
  Future<http.Response> deleteFirePolicy(int id) => delete('${ApiConstants.firePolicyDelete}/$id');
  
  Future<http.Response> getFireBills() => get(ApiConstants.fireBillList);
  Future<http.Response> saveFireBill(Map<String, dynamic> data) => post(ApiConstants.fireBillSave, data);
  Future<http.Response> deleteFireBill(int id) => delete('${ApiConstants.fireBillDelete}/$id');

  // Fire Money Receipt
  Future<http.Response> getFireReceipts() => get(ApiConstants.fireReceiptList);
  Future<http.Response> saveFireReceipt(Map<String, dynamic> data) => post(ApiConstants.fireReceiptSave, data);
  Future<http.Response> deleteFireReceipt(int id) => delete('${ApiConstants.fireReceiptDelete}/$id');

  // Marine Policy & Bill
  Future<http.Response> getMarinePolicies() => get(ApiConstants.marinePolicyList);
  Future<http.Response> saveMarinePolicy(Map<String, dynamic> data) => post(ApiConstants.marinePolicySave, data);
  Future<http.Response> deleteMarinePolicy(int id) => delete('${ApiConstants.marinePolicyDelete}/$id');

  Future<http.Response> getMarineBills() => get(ApiConstants.marineBillList);
  Future<http.Response> saveMarineBill(Map<String, dynamic> data) => post(ApiConstants.marineBillSave, data);
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
