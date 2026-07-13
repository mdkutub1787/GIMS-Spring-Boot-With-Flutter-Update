import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS) {
      return 'http://localhost:8080';
    }
    return 'http://10.0.2.2:8080';
  }
  
  /// Auth API endpoints
  static String get loginUrl => '$baseUrl/api/auth/login';
  static String get registerUrl => '$baseUrl/api/auth/register';
  static String get verifyOtpUrl => '$baseUrl/api/auth/verify-otp';
  static String get forgotPasswordUrl => '$baseUrl/api/auth/forgot-password';
  static String get verifyResetCodeUrl => '$baseUrl/api/auth/verify-reset-code';
  static String get resetPasswordUrl => '$baseUrl/api/auth/reset-password';
  
  /// User API endpoints
  static String get userProfileUrl => '$baseUrl/api/user/me';
  static String get userProfileUpdateUrl => '$baseUrl/api/user/update';
  
  /// Fire Policy API endpoints
  static String get firePolicySaveUrl => '$baseUrl/api/policy/save';
  static String get firePolicyListUrl => '$baseUrl/api/policy/list';
  static String firePolicyUpdateUrl(int id) => '$baseUrl/api/policy/update/$id';
  static String firePolicyDeleteUrl(int id) => '$baseUrl/api/policy/delete/$id';
  static String firePolicyGetUrl(int id) => '$baseUrl/api/policy/$id';
  static String firePolicySearchHolderUrl(String holder) => '$baseUrl/api/policy/searchpolicyholder?policyholder=$holder';
  static String firePolicySearchBankUrl(String bank) => '$baseUrl/api/policy/searchbankname?bankname=$bank';
  
  /// Fire Bill API endpoints
  static String get fireBillSaveUrl => '$baseUrl/api/bill/save';
  static String get fireBillListUrl => '$baseUrl/api/bill/list';
  static String fireBillUpdateUrl(int id) => '$baseUrl/api/bill/update/$id';
  static String fireBillDeleteUrl(int id) => '$baseUrl/api/bill/delete/$id';
  static String fireBillGetUrl(int id) => '$baseUrl/api/bill/$id';
  static String fireBillSearchPolicyholderUrl(String policyholder) => '$baseUrl/api/bill/searchpolicyholder?policyholder=$policyholder';
  static String fireBillSearchPolicyIdUrl(int policyId) => '$baseUrl/api/bill/searchpolicyid?policyid=$policyId';
  
  /// Fire Money Receipt API endpoints
  static String get fireReceiptSaveUrl => '$baseUrl/api/moneyreceipt/save';
  static String get fireReceiptListUrl => '$baseUrl/api/moneyreceipt/list';
  static String fireReceiptUpdateUrl(int id) => '$baseUrl/api/moneyreceipt/update/$id';
  static String fireReceiptDeleteUrl(int id) => '$baseUrl/api/moneyreceipt/delete/$id';
  
  /// Marine Policy API endpoints
  static String get marinePolicySaveUrl => '$baseUrl/api/marine/save';
  static String get marinePolicyListUrl => '$baseUrl/api/marine/list';
  static String marinePolicyUpdateUrl(int id) => '$baseUrl/api/marine/update/$id';
  static String marinePolicyDeleteUrl(int id) => '$baseUrl/api/marine/delete/$id';
  static String marinePolicyGetUrl(int id) => '$baseUrl/api/marine/$id';
  
  /// Marine Bill API endpoints
  static String get marineBillSaveUrl => '$baseUrl/api/marinebill/save';
  static String get marineBillListUrl => '$baseUrl/api/marinebill/list';
  static String marineBillUpdateUrl(int id) => '$baseUrl/api/marinebill/update/$id';
  static String marineBillDeleteUrl(int id) => '$baseUrl/api/marinebill/delete/$id';
  static String marineBillGetUrl(int id) => '$baseUrl/api/marinebill/$id';

  /// Marine Money Receipt API endpoints
  static String get marineReceiptSaveUrl => '$baseUrl/api/marinemoneyreceipt/save';
  static String get marineReceiptListUrl => '$baseUrl/api/marinemoneyreceipt/list';
  static String marineReceiptUpdateUrl(int id) => '$baseUrl/api/marinemoneyreceipt/update/$id';
  static String marineReceiptDeleteUrl(int id) => '$baseUrl/api/marinemoneyreceipt/delete/$id';

  /// Utility API endpoints
  static String get banksUrl => '$baseUrl/api/banks';
  static String branchesUrl(int bankId) => '$baseUrl/api/banks/$bankId/branches';
  static String get insuranceCompaniesUrl => '$baseUrl/api/insurance-companies';
  
  /// Currency API endpoints
  static String get currencyRateUrl => '$baseUrl/api/currency/rate';
}
