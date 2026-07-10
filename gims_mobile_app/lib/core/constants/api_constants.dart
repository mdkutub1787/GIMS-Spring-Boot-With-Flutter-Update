class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8080';
  
  // Auth
  static const String login = '$baseUrl/api/auth/login';
  static const String register = '$baseUrl/api/auth/register';
  static const String verifyOtp = '$baseUrl/api/auth/verify-otp';
  static const String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static const String verifyResetCode = '$baseUrl/api/auth/verify-reset-code';
  static const String resetPassword = '$baseUrl/api/auth/reset-password';
  
  // Fire Policy
  static const String firePolicySave = '$baseUrl/api/policy/save';
  static const String firePolicyList = '$baseUrl/api/policy/list';
  static const String firePolicyUpdate = '$baseUrl/api/policy/update';
  static const String firePolicyDelete = '$baseUrl/api/policy/delete';
  static const String firePolicyGet = '$baseUrl/api/policy';
  static const String firePolicySearchHolder = '$baseUrl/api/policy/searchpolicyholder';
  static const String firePolicySearchBank = '$baseUrl/api/policy/searchbankname';
  
  // Fire Bill
  static const String fireBillSave = '$baseUrl/api/bill/save';
  static const String fireBillList = '$baseUrl/api/bill/list';
  static const String fireBillUpdate = '$baseUrl/api/bill/update';
  static const String fireBillDelete = '$baseUrl/api/bill/delete';
  static const String fireBillGet = '$baseUrl/api/bill';
  static const String fireBillSearchPolicyholder = '$baseUrl/api/bill/searchpolicyholder';
  static const String fireBillSearchPolicyId = '$baseUrl/api/bill/searchpolicyid';
  
  // Fire Money Receipt
  static const String fireReceiptSave = '$baseUrl/api/moneyreceipt/save';
  static const String fireReceiptList = '$baseUrl/api/moneyreceipt/list';
  static const String fireReceiptDelete = '$baseUrl/api/moneyreceipt/delete';
  
  // Marine Policy
  static const String marinePolicySave = '$baseUrl/api/marine/save';
  static const String marinePolicyList = '$baseUrl/api/marine/list';
  static const String marinePolicyUpdate = '$baseUrl/api/marine/update';
  static const String marinePolicyDelete = '$baseUrl/api/marine/delete';
  static const String marinePolicyGet = '$baseUrl/api/marine';
  
  // Marine Bill
  static const String marineBillSave = '$baseUrl/api/marinebill/save';
  static const String marineBillList = '$baseUrl/api/marinebill/';
  static const String marineBillUpdate = '$baseUrl/api/marinebill/update';
  static const String marineBillDelete = '$baseUrl/api/marinebill/delete';
  static const String marineBillGet = '$baseUrl/api/marinebill';

  // Marine Money Receipt
  static const String marineReceiptSave = '$baseUrl/api/marinebillmoneyreceipt/save';
  static const String marineReceiptList = '$baseUrl/api/marinebillmoneyreceipt/list';
  static const String marineReceiptDelete = '$baseUrl/api/marinebillmoneyreceipt/delete';

  // Utility
  static const String banks = '$baseUrl/api/banks';
  static const String branches = '$baseUrl/api/banks'; // Usage: $banks/$bankId/branches
  static const String insuranceCompanies = '$baseUrl/api/insurance-companies';
}
