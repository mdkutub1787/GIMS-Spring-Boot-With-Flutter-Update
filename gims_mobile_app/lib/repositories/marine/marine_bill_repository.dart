import 'dart:convert';
import '../../models/marine/marine_bill.dart';
import '../../services/api_service.dart';

class MarineBillRepository {
  final ApiService _apiService;
  MarineBillRepository(this._apiService);

  Future<List<MarineBill>> fetchBills() async {
    final response = await _apiService.getMarineBills();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        if (decoded['data'] == null) return [];
        List<dynamic> data = decoded['data'];
        List<MarineBill> allBills = [];
        for (var entry in data) {
          if (entry is Map<String, dynamic> && entry.containsKey('BillDetails')) {
            var policyJson = entry['PolicyDetails'];
            List<dynamic> billDetails = entry['BillDetails'];
            for (var billJson in billDetails) {
              billJson['PolicyDetails'] = policyJson;
              allBills.add(MarineBill.fromJson(billJson));
            }
          } else {
            allBills.add(MarineBill.fromJson(entry));
          }
        }
        return allBills;
      }
    }
    throw Exception('Failed to load marine bills');
  }

  Future<MarineBill> getBillById(int id) async {
    final response = await _apiService.getMarineBillById(id);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        return MarineBill.fromJson(decoded['data']);
      }
    }
    throw Exception('Failed to load marine bill with ID $id');
  }

  Future<bool> saveBill(MarineBill bill) async {
    final response = await _apiService.saveMarineBill(bill.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<MarineBill?> calculateBill(MarineBill bill) async {
    final response = await _apiService.calculateMarineBill(bill.toJson());
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        return MarineBill.fromJson(decoded['data']);
      }
    }
    return null;
  }

  Future<bool> updateBill(int id, MarineBill bill) async {
    final response = await _apiService.updateMarineBill(id, bill.toJson());
    return response.statusCode == 200;
  }

  Future<bool> deleteBill(int id) async {
    final response = await _apiService.deleteMarineBill(id);
    return response.statusCode == 204 || response.statusCode == 200;
  }
}
