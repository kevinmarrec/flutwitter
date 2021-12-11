import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/home.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData.dark();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: const Color(0xFF1DA1F2),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
          ),
          scaffoldBackgroundColor: const Color(0xFF15202B)),
      onGenerateRoute: (_) {
        return MaterialPageRoute<void>(builder: (_) {
          return const HomeScreen();
        });
      },
    );
  }
}
