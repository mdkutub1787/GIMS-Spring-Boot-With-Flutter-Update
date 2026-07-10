import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/marine/marine_money_receipt.dart';
import '../repositories/marine/marine_receipt_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final marineReceiptRepositoryProvider = Provider((ref) => MarineReceiptRepository(ref.watch(apiServiceProvider)));

class MarineReceiptState {
  final bool isLoading;
  final List<MarineMoneyReceipt> receipts;
  final String? error;

  MarineReceiptState({this.isLoading = false, this.receipts = const [], this.error});

  MarineReceiptState copyWith({bool? isLoading, List<MarineMoneyReceipt>? receipts, String? error}) {
    return MarineReceiptState(
      isLoading: isLoading ?? this.isLoading,
      receipts: receipts ?? this.receipts,
      error: error ?? this.error,
    );
  }
}

class MarineReceiptViewModel extends StateNotifier<MarineReceiptState> {
  final MarineReceiptRepository _repository;

  MarineReceiptViewModel(this._repository) : super(MarineReceiptState());

  Future<void> fetchReceipts() async {
    state = state.copyWith(isLoading: true);
    try {
      final receipts = await _repository.fetchReceipts();
      state = state.copyWith(isLoading: false, receipts: receipts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> saveReceipt(MarineMoneyReceipt receipt) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.saveReceipt(receipt);
      if (success) await fetchReceipts();
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateReceipt(int id, MarineMoneyReceipt receipt) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.updateReceipt(id, receipt);
      if (success) await fetchReceipts();
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteReceipt(int id) async {
    try {
      final success = await _repository.deleteReceipt(id);
      if (success) await fetchReceipts();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final marineReceiptViewModelProvider = StateNotifierProvider<MarineReceiptViewModel, MarineReceiptState>((ref) {
  return MarineReceiptViewModel(ref.watch(marineReceiptRepositoryProvider));
});
