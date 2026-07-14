import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    // Default to 'en' if the locale is not directly injected
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'settings_title': 'Settings',
      'back': 'Back',
      'settings_security': 'Security Settings',
      'settings_biometric_lock': 'Biometric Lock',
      'settings_biometric_subtitle': 'Enable fingerprint or face unlock',
      'settings_biometric_not_setup': 'Biometric authentication is not setup on this device.',
      'settings_currency': 'Base Currency',
      'settings_currency_subtitle': 'Select your preferred currency',
      'settings_theme': 'Dark Mode',
      'settings_theme_subtitle': 'Toggle between light and dark theme',
      'settings_color_theme': 'Color Theme',
      'settings_color_subtitle': 'Choose your app primary color',
      'settings_language': 'Bengali Language',
      'settings_language_subtitle': 'Switch app language to Bengali',
      'action_cancel': 'Cancel',
      'settings_selected': 'Selected',
      'login_welcome': 'Welcome Back!',
      'login_subtitle': 'Login to your account by entering your\nusername and password below, we are really\nhappy to see you come back!',
      'login_email_hint': 'Email address or username',
      'login_password_hint': 'Password',
      'login_forgot_password': 'Forgot Password?',
      'login_button': 'Login',
      'login_signup': 'Sign Up',
      'nav_home': 'Home',
      'nav_fire': 'Fire',
      'nav_marine': 'Marine',
      'nav_reports': 'Reports',
      'nav_profile': 'Profile',
      'home_dashboard': 'Dashboard',
      'home_total_policies': 'Total Policies',
      'home_total_bills': 'Total Bills',
      'home_total_receipts': 'Total Receipts',
      'home_active_projects': 'Active Projects',
      'home_quick_actions': 'Quick Actions',
      'home_new_policy': 'New Policy',
      'home_generate_bill': 'Generate Bill',
      'home_create_receipt': 'Create Receipt',
      'home_reports': 'Reports',
      'home_projects_activity': 'Projects / Activity',
      'home_view_all': 'View All',
      'home_no_activity': 'No activity found',
      'create_new': 'Create New',
      'fire_policy': 'Fire Policy',
      'fire_bill': 'Fire Bill',
      'fire_money_receipt': 'Fire Money Receipt',
      'marine_policy': 'Marine Policy',
      'marine_bill': 'Marine Bill',
      'marine_money_receipt': 'Marine Money Receipt',
    },
    'bn': {
      'settings_title': 'সেটিংস',
      'back': 'পিছনে',
      'settings_security': 'নিরাপত্তা সেটিংস',
      'settings_biometric_lock': 'বায়োমেট্রিক লক',
      'settings_biometric_subtitle': 'ফিঙ্গারপ্রিন্ট বা ফেস আনলক সক্ষম করুন',
      'settings_biometric_not_setup': 'এই ডিভাইসে বায়োমেট্রিক প্রমাণীকরণ সেটআপ করা নেই।',
      'settings_currency': 'মূল মুদ্রা',
      'settings_currency_subtitle': 'আপনার পছন্দের মুদ্রা নির্বাচন করুন',
      'settings_theme': 'ডার্ক মোড',
      'settings_theme_subtitle': 'লাইট এবং ডার্ক থিমের মধ্যে পরিবর্তন করুন',
      'settings_color_theme': 'কালার থিম',
      'settings_color_subtitle': 'আপনার অ্যাপের প্রাথমিক রঙ চয়ন করুন',
      'settings_language': 'বাংলা ভাষা',
      'settings_language_subtitle': 'অ্যাপের ভাষা বাংলায় পরিবর্তন করুন',
      'action_cancel': 'বাতিল করুন',
      'settings_selected': 'নির্বাচিত',
      'login_welcome': 'স্বাগতম!',
      'login_subtitle': 'আপনার ব্যবহারকারীর নাম এবং পাসওয়ার্ড দিয়ে\nঅ্যাকাউন্টে লগইন করুন, আপনাকে আবার\nদেখতে পেয়ে আমরা আনন্দিত!',
      'login_email_hint': 'ইমেইল বা ইউজারনেম',
      'login_password_hint': 'পাসওয়ার্ড',
      'login_forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'login_button': 'লগইন করুন',
      'login_signup': 'সাইন আপ করুন',
      'nav_home': 'হোম',
      'nav_fire': 'ফায়ার',
      'nav_marine': 'মেরিন',
      'nav_reports': 'রিপোর্টস',
      'nav_profile': 'প্রোফাইল',
      'home_dashboard': 'ড্যাশবোর্ড',
      'home_total_policies': 'মোট পলিসি',
      'home_total_bills': 'মোট বিল',
      'home_total_receipts': 'মোট রসিদ',
      'home_active_projects': 'সক্রিয় প্রজেক্ট',
      'home_quick_actions': 'কুইক অ্যাকশন',
      'home_new_policy': 'নতুন পলিসি',
      'home_generate_bill': 'বিল তৈরি',
      'home_create_receipt': 'রসিদ তৈরি',
      'home_reports': 'রিপোর্টস',
      'home_projects_activity': 'প্রজেক্ট / অ্যাক্টিভিটি',
      'home_view_all': 'সবগুলো দেখুন',
      'home_no_activity': 'কোনো অ্যাক্টিভিটি পাওয়া যায়নি',
      'create_new': 'নতুন তৈরি করুন',
      'fire_policy': 'ফায়ার পলিসি',
      'fire_bill': 'ফায়ার বিল',
      'fire_money_receipt': 'ফায়ার মানি রসিদ',
      'marine_policy': 'মেরিন পলিসি',
      'marine_bill': 'মেরিন বিল',
      'marine_money_receipt': 'মেরিন মানি রসিদ',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
