import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/policy_model.dart';
import '../repositories/fire_policy_repository.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final firePolicyRepositoryProvider = Provider((ref) => FirePolicyRepository(ref.watch(apiServiceProvider)));

class FirePolicyState {
  final bool isLoading;
  final List<PolicyModel> policies;
  final String? error;

  FirePolicyState({this.isLoading = false, this.policies = const [], this.error});

  FirePolicyState copyWith({bool? isLoading, List<PolicyModel>? policies, String? error}) {
    return FirePolicyState(
      isLoading: isLoading ?? this.isLoading,
      policies: policies ?? this.policies,
      error: error ?? this.error,
    );
  }
}

class FirePolicyViewModel extends StateNotifier<FirePolicyState> {
  final FirePolicyRepository _repository;

  FirePolicyViewModel(this._repository) : super(FirePolicyState());

  Future<void> fetchPolicies() async {
    state = state.copyWith(isLoading: true);
    try {
      final policies = await _repository.fetchPolicies();
      state = state.copyWith(isLoading: false, policies: policies);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> savePolicy(PolicyModel policy) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _repository.savePolicy(policy);
      if (success) fetchPolicies();
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

final firePolicyViewModelProvider = StateNotifierProvider<FirePolicyViewModel, FirePolicyState>((ref) {
  return FirePolicyViewModel(ref.watch(firePolicyRepositoryProvider));
});
