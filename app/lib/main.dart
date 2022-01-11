import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutwitter/router/router.dart';
import 'package:flutwitter/shared/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: getTheme(),
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return Toast(
          child: child!,
          navigatorKey: child.key as GlobalKey<NavigatorState>,
        );
      },
    );
  }
}
