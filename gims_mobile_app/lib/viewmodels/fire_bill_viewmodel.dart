import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bill_model.dart';
import '../repositories/fire_bill_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final fireBillRepositoryProvider = Provider((ref) => FireBillRepository(ref.watch(apiServiceProvider)));

class FireBillState {
  final bool isLoading;
  final List<BillModel> bills;
  final String? error;

  FireBillState({this.isLoading = false, this.bills = const [], this.error});

  FireBillState copyWith({bool? isLoading, List<BillModel>? bills, String? error}) {
    return FireBillState(
      isLoading: isLoading ?? this.isLoading,
      bills: bills ?? this.bills,
      error: error ?? this.error,
    );
  }
}

class FireBillViewModel extends StateNotifier<FireBillState> {
  final FireBillRepository _repository;

  FireBillViewModel(this._repository) : super(FireBillState());

  Future<void> fetchBills() async {
    state = state.copyWith(isLoading: true);
    try {
      final bills = await _repository.fetchBills();
      state = state.copyWith(isLoading: false, bills: bills);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> saveBill(BillModel bill) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _repository.saveBill(bill);
      if (success) fetchBills();
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteBill(int id) async {
    try {
      final success = await _repository.deleteBill(id);
      if (success) fetchBills();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final fireBillViewModelProvider = StateNotifierProvider<FireBillViewModel, FireBillState>((ref) {
  return FireBillViewModel(ref.watch(fireBillRepositoryProvider));
});
