import 'dart:convert';
import '../../models/marine/marine_bill.dart';
import '../../services/api_service.dart';

class MarineBillRepository {
  final ApiService _apiService;
  MarineBillRepository(this._apiService);

  Future<List<MarineBill>> fetchBills() async {
    final response = await _apiService.getMarineBills();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MarineBill.fromJson(item)).toList();
    }
    throw Exception('Failed to load marine bills');
  }

  Future<MarineBill> getBillById(int id) async {
    final response = await _apiService.getMarineBillById(id);
    if (response.statusCode == 200) {
      return MarineBill.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load marine bill with ID $id');
  }

  Future<bool> saveBill(MarineBill bill) async {
    final response = await _apiService.saveMarineBill(bill.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
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
