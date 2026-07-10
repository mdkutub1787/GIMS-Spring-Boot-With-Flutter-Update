import 'dart:convert';
import '../models/marine_bill_model.dart';
import '../services/api_service.dart';

class MarineBillRepository {
  final ApiService _apiService;
  MarineBillRepository(this._apiService);

  Future<List<MarineBillModel>> fetchBills() async {
    final response = await _apiService.getMarineBills();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MarineBillModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load marine bills');
  }

  Future<bool> saveBill(MarineBillModel bill) async {
    final response = await _apiService.saveMarineBill(bill.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteBill(int id) async {
    final response = await _apiService.deleteMarineBill(id);
    return response.statusCode == 200;
  }
}
