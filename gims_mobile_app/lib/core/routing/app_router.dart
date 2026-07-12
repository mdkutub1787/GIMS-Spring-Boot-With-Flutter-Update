import 'package:flutter/material.dart';
import 'package:gims_mobile_app/screens/auth/login_screen.dart';
import 'package:gims_mobile_app/screens/auth/registration_screen.dart';
import 'package:gims_mobile_app/screens/auth/forgot_password_screen.dart';
import 'package:gims_mobile_app/screens/auth/verify_otp_screen.dart';
import 'package:gims_mobile_app/screens/auth/reset_password_screen.dart';
import 'package:gims_mobile_app/screens/home/home_screen.dart';
import 'package:gims_mobile_app/screens/profile/profile_screen.dart';
import 'package:gims_mobile_app/screens/splash/splash_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/view_fire_policy_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/create_fire_policy_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/view_fire_bill_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/create_fire_bill_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/view_fire_money_receipt_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/create_fire_money_receipt_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/view_marine_policy_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/create_marine_policy_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/view_marine_bill_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/create_marine_bill_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/view_marine_money_receipt_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/create_marine_money_receipt_screen.dart';
import 'package:gims_mobile_app/models/marine/marine_money_receipt.dart';
import 'package:gims_mobile_app/screens/reports/fire_policy_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/fire_bill_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/fire_money_receipt_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/marine_policy_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/marine_bill_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/marine_money_receipt_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/combined_report_screen.dart';
import 'package:gims_mobile_app/screens/reports/combined_money_receipt_report_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String profile = '/profile';
  
  static const String viewFirePolicy = '/view-fire-policy';
  static const String createFirePolicy = '/create-fire-policy';
  static const String viewFireBill = '/view-fire-bill';
  static const String createFireBill = '/create-fire-bill';
  static const String viewFireMoneyReceipt = '/view-fire-money-receipt';
  static const String createFireMoneyReceipt = '/create-fire-money-receipt';
  
  static const String viewMarinePolicy = '/view-marine-policy';
  static const String createMarinePolicy = '/create-marine-policy';
  static const String viewMarineBill = '/view-marine-bill';
  static const String createMarineBill = '/create-marine-bill';
  static const String viewMarineMoneyReceipt = '/view-marine-money-receipt';
  static const String createMarineMoneyReceipt = '/create-marine-money-receipt';
  
  static const String firePolicyReport = '/fire-policy-report';
  static const String fireBillReport = '/fire-bill-report';
  static const String fireMoneyReceiptReport = '/fire-money-receipt-report';
  static const String marinePolicyReport = '/marine-policy-report';
  static const String marineBillReport = '/marine-bill-report';
  static const String marineMoneyReceiptReport = '/marine-money-receipt-report';
  static const String combinedReport = '/combined-report';
  static const String combinedMoneyReceiptReport = '/combined-money-receipt-report';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case verifyOtp:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            email: args?['email'],
            isForReset: args?['isForReset'] ?? true,
          ),
        );
      case resetPassword:
        final email = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email));
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
        
      case viewFirePolicy:
        return MaterialPageRoute(builder: (_) => const ViewFirePolicyScreen());
      case createFirePolicy:
        return MaterialPageRoute(builder: (_) => const CreateFirePolicyScreen());
      case viewFireBill:
        return MaterialPageRoute(builder: (_) => const ViewFireBillScreen());
      case createFireBill:
        return MaterialPageRoute(builder: (_) => const CreateFireBillScreen());
      case viewFireMoneyReceipt:
        return MaterialPageRoute(builder: (_) => const ViewFireMoneyReceiptScreen());
      case createFireMoneyReceipt:
        return MaterialPageRoute(builder: (_) => const CreateFireMoneyReceiptScreen());
        
      case viewMarinePolicy:
        return MaterialPageRoute(builder: (_) => const ViewMarinePolicyScreen());
      case createMarinePolicy:
        return MaterialPageRoute(builder: (_) => const CreateMarinePolicyScreen());
      case viewMarineBill:
        return MaterialPageRoute(builder: (_) => const ViewMarineBillScreen());
      case createMarineBill:
        return MaterialPageRoute(builder: (_) => const CreateMarineBillScreen());
      case viewMarineMoneyReceipt:
        return MaterialPageRoute(builder: (_) => const ViewMarineMoneyReceiptScreen());
      case createMarineMoneyReceipt:
        final receipt = settings.arguments as MarineMoneyReceipt?;
        return MaterialPageRoute(builder: (_) => CreateMarineMoneyReceiptScreen(receipt: receipt));
      case firePolicyReport:
        return MaterialPageRoute(builder: (_) => const FirePolicyReportScreen());
      case fireBillReport:
        return MaterialPageRoute(builder: (_) => const FireBillReportScreen());
      case fireMoneyReceiptReport:
        return MaterialPageRoute(builder: (_) => const FireMoneyReceiptReportScreen());
      case marinePolicyReport:
        return MaterialPageRoute(builder: (_) => const MarinePolicyReportScreen());
      case marineBillReport:
        return MaterialPageRoute(builder: (_) => const MarineBillReportScreen());
      case marineMoneyReceiptReport:
        return MaterialPageRoute(builder: (_) => const MarineMoneyReceiptReportScreen());
      case combinedReport:
        return MaterialPageRoute(builder: (_) => const CombinedReportScreen());
      case combinedMoneyReceiptReport:
        return MaterialPageRoute(builder: (_) => const CombinedMoneyReceiptReportScreen());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
