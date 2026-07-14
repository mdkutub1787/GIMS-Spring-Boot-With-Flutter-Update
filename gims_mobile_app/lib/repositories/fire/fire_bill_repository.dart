import 'dart:convert';
import '../../models/fire/fire_bill.dart';
import '../../services/api_service.dart';

class FireBillRepository {
  final ApiService _apiService;
  FireBillRepository(this._apiService);

  Future<List<FireBill>> fetchBills() async {
    final response = await _apiService.getFireBills();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        List<FireBill> allBills = [];
        for (var entry in data) {
          if (entry is Map<String, dynamic> && entry.containsKey('BillDetails')) {
            var policyJson = entry['PolicyDetails'];
            List<dynamic> billDetails = entry['BillDetails'];
            for (var billJson in billDetails) {
              billJson['policy'] = policyJson;
              allBills.add(FireBill.fromJson(billJson));
            }
          } else {
            allBills.add(FireBill.fromJson(entry));
          }
        }
        return allBills;
      }
    }
    throw Exception('Failed to load fire bills');
  }

  Future<FireBill> getBillById(int id) async {
    final response = await _apiService.getFireBillById(id);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        return FireBill.fromJson(decoded['data']);
      }
    }
    throw Exception('Failed to load fire bill with ID $id');
  }

  Future<bool> saveBill(FireBill bill) async {
    final response = await _apiService.saveFireBill(bill.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<FireBill?> calculateBill(FireBill bill) async {
    final response = await _apiService.calculateFireBill(bill.toJson());
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        return FireBill.fromJson(decoded['data']);
      }
    }
    return null;
  }

  Future<bool> updateBill(int id, FireBill bill) async {
    final response = await _apiService.updateFireBill(id, bill.toJson());
    return response.statusCode == 200;
  }

  Future<bool> deleteBill(int id) async {
    final response = await _apiService.deleteFireBill(id);
    return response.statusCode == 200;
  }

  Future<List<FireBill>> searchByPolicyholder(String policyholder) async {
    final response = await _apiService.searchFireBillsByPolicyholder(policyholder);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        return data.map((item) => FireBill.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to search fire bills');
  }

  Future<List<FireBill>> findByPolicyId(int policyId) async {
    final response = await _apiService.searchFireBillsByPolicyId(policyId);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        return data.map((item) => FireBill.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to find fire bills by policy ID');
  }
}
