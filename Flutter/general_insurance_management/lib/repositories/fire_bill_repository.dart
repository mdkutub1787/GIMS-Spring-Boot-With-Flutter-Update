import 'dart:convert';
import 'package:general_insurance_management/models/bill_model.dart';
import 'package:general_insurance_management/services/api_service.dart';

class FireBillRepository {
  final ApiService _apiService;
  FireBillRepository(this._apiService);

  Future<List<BillModel>> fetchBills() async {
    final response = await _apiService.getFireBills();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> data = decoded['data'];
      return data.map((item) => BillModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load fire bills');
  }

  Future<bool> saveBill(BillModel bill) async {
    final response = await _apiService.saveFireBill(bill.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteBill(int id) async {
    final response = await _apiService.deleteFireBill(id);
    return response.statusCode == 200;
  }
}
