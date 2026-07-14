import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gims_mobile_app/core/theme/app_theme.dart';
import 'package:gims_mobile_app/core/routing/app_router.dart';
import 'package:gims_mobile_app/core/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gims_mobile_app/viewmodels/settings_viewmodel.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsViewModelProvider);

    return MaterialApp(
      title: 'Insurance Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(primaryColor: settingsState.primaryColor),
      darkTheme: AppTheme.darkTheme(primaryColor: settingsState.primaryColor),
      themeMode: settingsState.themeMode,
      locale: settingsState.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splash,
    );
  }
}
