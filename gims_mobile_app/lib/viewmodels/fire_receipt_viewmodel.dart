import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fire/fire_money_receipt.dart';
import '../repositories/fire/fire_receipt_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final fireReceiptRepositoryProvider = Provider((ref) => FireReceiptRepository(ref.watch(apiServiceProvider)));

class FireReceiptState {
  final bool isLoading;
  final List<FireMoneyReceipt> receipts;
  final String? error;

  FireReceiptState({this.isLoading = false, this.receipts = const [], this.error});

  FireReceiptState copyWith({bool? isLoading, List<FireMoneyReceipt>? receipts, String? error}) {
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

  Future<bool> saveReceipt(FireMoneyReceipt receipt) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _repository.saveReceipt(receipt);
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

  Future<bool> updateReceipt(int id, FireMoneyReceipt receipt) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.updateReceipt(id, receipt);
      if (success) {
        await fetchReceipts();
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to update receipt');
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final fireReceiptViewModelProvider = StateNotifierProvider<FireReceiptViewModel, FireReceiptState>((ref) {
  return FireReceiptViewModel(ref.watch(fireReceiptRepositoryProvider));
});
