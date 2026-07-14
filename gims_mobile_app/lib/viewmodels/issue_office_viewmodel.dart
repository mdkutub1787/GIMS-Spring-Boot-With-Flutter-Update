import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/utility/issue_office.dart';
import '../core/constants/api_config.dart';
class IssueOfficeState {
  final List<IssueOffice> offices;
  final bool isLoading;
  final String? error;

  IssueOfficeState({this.offices = const [], this.isLoading = false, this.error});

  IssueOfficeState copyWith({List<IssueOffice>? offices, bool? isLoading, String? error}) {
    return IssueOfficeState(
      offices: offices ?? this.offices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class IssueOfficeViewModel extends StateNotifier<IssueOfficeState> {
  IssueOfficeViewModel() : super(IssueOfficeState());

  Future<void> fetchOffices() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/issue-offices'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final offices = jsonList.map((json) => IssueOffice.fromJson(json)).toList();
        state = state.copyWith(offices: offices, isLoading: false);
      } else {
        state = state.copyWith(error: 'Failed to load offices', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final issueOfficeViewModelProvider = StateNotifierProvider<IssueOfficeViewModel, IssueOfficeState>((ref) {
  return IssueOfficeViewModel();
});
