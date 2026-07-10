import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/marine/marine_policy.dart';
import '../repositories/marine/marine_policy_repository.dart';
import '../viewmodels/fire_policy_viewmodel.dart';

final marinePolicyRepositoryProvider = Provider((ref) => MarinePolicyRepository(ref.watch(apiServiceProvider)));

class MarinePolicyState {
  final bool isLoading;
  final List<MarinePolicy> policies;
  final String? error;

  MarinePolicyState({this.isLoading = false, this.policies = const [], this.error});

  MarinePolicyState copyWith({bool? isLoading, List<MarinePolicy>? policies, String? error}) {
    return MarinePolicyState(
      isLoading: isLoading ?? this.isLoading,
      policies: policies ?? this.policies,
      error: error ?? this.error,
    );
  }
}

class MarinePolicyViewModel extends StateNotifier<MarinePolicyState> {
  final MarinePolicyRepository _repository;

  MarinePolicyViewModel(this._repository) : super(MarinePolicyState());

  Future<void> fetchPolicies() async {
    state = state.copyWith(isLoading: true);
    try {
      final policies = await _repository.fetchPolicies();
      state = state.copyWith(isLoading: false, policies: policies);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> savePolicy(MarinePolicy policy) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.savePolicy(policy);
      if (success) {
        await fetchPolicies();
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to save marine policy');
      }
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deletePolicy(int id) async {
    try {
      final success = await _repository.deletePolicy(id);
      if (success) fetchPolicies();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final marinePolicyViewModelProvider = StateNotifierProvider<MarinePolicyViewModel, MarinePolicyState>((ref) {
  return MarinePolicyViewModel(ref.watch(marinePolicyRepositoryProvider));
});
