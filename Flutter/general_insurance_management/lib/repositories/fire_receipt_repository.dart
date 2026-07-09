import 'dart:convert';
import '../models/money_receipt_model.dart';
import '../services/api_service.dart';

class FireReceiptRepository {
  final ApiService _apiService;
  FireReceiptRepository(this._apiService);

  Future<List<MoneyReceiptModel>> fetchReceipts() async {
    final response = await _apiService.getFireReceipts();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MoneyReceiptModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load fire receipts');
  }

  Future<bool> saveReceipt(MoneyReceiptModel receipt) async {
    final response = await _apiService.saveFireReceipt(receipt.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteReceipt(int id) async {
    final response = await _apiService.deleteFireReceipt(id);
    return response.statusCode == 200;
  }
}
