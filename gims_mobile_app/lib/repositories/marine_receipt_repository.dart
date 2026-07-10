import 'dart:convert';
import '../models/marine_money_receipt_model.dart';
import '../services/api_service.dart';

class MarineReceiptRepository {
  final ApiService _apiService;
  MarineReceiptRepository(this._apiService);

  Future<List<MarineMoneyReceiptModel>> fetchReceipts() async {
    final response = await _apiService.getMarineReceipts();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MarineMoneyReceiptModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load marine receipts');
  }

  Future<bool> saveReceipt(MarineMoneyReceiptModel receipt) async {
    final response = await _apiService.saveMarineReceipt(receipt.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteReceipt(int id) async {
    final response = await _apiService.deleteMarineReceipt(id);
    return response.statusCode == 200;
  }
}
