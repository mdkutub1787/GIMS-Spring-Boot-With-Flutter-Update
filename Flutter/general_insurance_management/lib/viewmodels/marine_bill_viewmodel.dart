import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/marine_bill_model.dart';
import '../repositories/marine_bill_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final marineBillRepositoryProvider = Provider((ref) => MarineBillRepository(ref.watch(apiServiceProvider)));

class MarineBillState {
  final bool isLoading;
  final List<MarineBillModel> bills;
  final String? error;

  MarineBillState({this.isLoading = false, this.bills = const [], this.error});

  MarineBillState copyWith({bool? isLoading, List<MarineBillModel>? bills, String? error}) {
    return MarineBillState(
      isLoading: isLoading ?? this.isLoading,
      bills: bills ?? this.bills,
      error: error ?? this.error,
    );
  }
}

class MarineBillViewModel extends StateNotifier<MarineBillState> {
  final MarineBillRepository _repository;

  MarineBillViewModel(this._repository) : super(MarineBillState());

  Future<void> fetchBills() async {
    state = state.copyWith(isLoading: true);
    try {
      final bills = await _repository.fetchBills();
      state = state.copyWith(isLoading: false, bills: bills);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> saveBill(MarineBillModel bill) async {
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

final marineBillViewModelProvider = StateNotifierProvider<MarineBillViewModel, MarineBillState>((ref) {
  return MarineBillViewModel(ref.watch(marineBillRepositoryProvider));
});
