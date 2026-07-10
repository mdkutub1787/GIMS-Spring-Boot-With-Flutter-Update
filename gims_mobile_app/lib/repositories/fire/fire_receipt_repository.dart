import 'dart:convert';
import '../../models/fire/fire_money_receipt.dart';
import '../../services/api_service.dart';

class FireReceiptRepository {
  final ApiService _apiService;
  FireReceiptRepository(this._apiService);

  Future<List<FireMoneyReceipt>> fetchReceipts() async {
    final response = await _apiService.getFireReceipts();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        List<dynamic> data = decoded['data'];
        return data.map((item) => FireMoneyReceipt.fromJson(item)).toList();
      }
    }
    throw Exception('Failed to load fire receipts');
  }

  Future<bool> saveReceipt(FireMoneyReceipt receipt) async {
    final response = await _apiService.saveFireReceipt(receipt.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteReceipt(int id) async {
    final response = await _apiService.deleteFireReceipt(id);
    return response.statusCode == 200;
  }
}
