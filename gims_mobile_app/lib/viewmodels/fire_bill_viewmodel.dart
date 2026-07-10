import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fire/fire_bill.dart';
import '../repositories/fire/fire_bill_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final fireBillRepositoryProvider = Provider((ref) => FireBillRepository(ref.watch(apiServiceProvider)));

class FireBillState {
  final bool isLoading;
  final List<FireBill> bills;
  final String? error;

  FireBillState({this.isLoading = false, this.bills = const [], this.error});

  FireBillState copyWith({bool? isLoading, List<FireBill>? bills, String? error}) {
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

  Future<void> searchBills(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final bills = await _repository.searchByPolicyholder(query);
      state = state.copyWith(isLoading: false, bills: bills);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> saveBill(FireBill bill) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _repository.saveBill(bill);
      if (success) await fetchBills();
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateBill(int id, FireBill bill) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _repository.updateBill(id, bill);
      if (success) await fetchBills();
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteBill(int id) async {
    try {
      final success = await _repository.deleteBill(id);
      if (success) await fetchBills();
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
