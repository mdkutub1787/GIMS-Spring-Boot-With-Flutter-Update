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
