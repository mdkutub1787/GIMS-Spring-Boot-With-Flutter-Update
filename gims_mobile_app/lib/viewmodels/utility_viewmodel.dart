import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/utility_models.dart';
import 'fire_policy_viewmodel.dart';

class UtilityState {
  final List<Bank> banks;
  final List<Branch> branches;
  final List<InsuranceCompany> insuranceCompanies;
  final double currencyRate;
  final bool isLoading;

  UtilityState({
    this.banks = const [],
    this.branches = const [],
    this.insuranceCompanies = const [],
    this.currencyRate = 0.0,
    this.isLoading = false,
  });

  UtilityState copyWith({
    List<Bank>? banks,
    List<Branch>? branches,
    List<InsuranceCompany>? insuranceCompanies,
    double? currencyRate,
    bool? isLoading,
  }) {
    return UtilityState(
      banks: banks ?? this.banks,
      branches: branches ?? this.branches,
      insuranceCompanies: insuranceCompanies ?? this.insuranceCompanies,
      currencyRate: currencyRate ?? this.currencyRate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UtilityViewModel extends StateNotifier<UtilityState> {
  final Ref ref;

  UtilityViewModel(this.ref) : super(UtilityState());

  Future<void> fetchBanks() async {
    state = state.copyWith(isLoading: true);
    final response = await ref.read(apiServiceProvider).getBanks();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Bank> banks = (data['data'] as List).map((e) => Bank.fromJson(e)).toList();
      state = state.copyWith(banks: banks, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchBranches(int bankId) async {
    state = state.copyWith(isLoading: true, branches: []);
    final response = await ref.read(apiServiceProvider).getBranches(bankId);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Branch> branches = (data['data'] as List).map((e) => Branch.fromJson(e)).toList();
      state = state.copyWith(branches: branches, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchInsuranceCompanies() async {
    state = state.copyWith(isLoading: true);
    final response = await ref.read(apiServiceProvider).getInsuranceCompanies();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<InsuranceCompany> companies = (data['data'] as List).map((e) => InsuranceCompany.fromJson(e)).toList();
      state = state.copyWith(insuranceCompanies: companies, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchCurrencyRate() async {
    final response = await ref.read(apiServiceProvider).getCurrencyRate();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rate = data['data']['usd_rate'] as double;
      state = state.copyWith(currencyRate: rate);
    }
  }
}

final utilityViewModelProvider = StateNotifierProvider<UtilityViewModel, UtilityState>((ref) {
  return UtilityViewModel(ref);
});
