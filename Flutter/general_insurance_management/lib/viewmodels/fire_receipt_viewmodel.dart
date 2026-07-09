import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/money_receipt_model.dart';
import '../repositories/fire_receipt_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final fireReceiptRepositoryProvider = Provider((ref) => FireReceiptRepository(ref.watch(apiServiceProvider)));

class FireReceiptState {
  final bool isLoading;
  final List<MoneyReceiptModel> receipts;
  final String? error;

  FireReceiptState({this.isLoading = false, this.receipts = const [], this.error});

  FireReceiptState copyWith({bool? isLoading, List<MoneyReceiptModel>? receipts, String? error}) {
    return FireReceiptState(
      isLoading: isLoading ?? this.isLoading,
      receipts: receipts ?? this.receipts,
      error: error ?? this.error,
    );
  }
}

class FireReceiptViewModel extends StateNotifier<FireReceiptState> {
  final FireReceiptRepository _repository;

  FireReceiptViewModel(this._repository) : super(FireReceiptState());

  Future<void> fetchReceipts() async {
    state = state.copyWith(isLoading: true);
    try {
      final receipts = await _repository.fetchReceipts();
      state = state.copyWith(isLoading: false, receipts: receipts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> saveReceipt(MoneyReceiptModel receipt) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _repository.saveReceipt(receipt);
      if (success) fetchReceipts();
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteReceipt(int id) async {
    try {
      final success = await _repository.deleteReceipt(id);
      if (success) fetchReceipts();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final fireReceiptViewModelProvider = StateNotifierProvider<FireReceiptViewModel, FireReceiptState>((ref) {
  return FireReceiptViewModel(ref.watch(fireReceiptRepositoryProvider));
});
