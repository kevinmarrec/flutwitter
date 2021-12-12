import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color backgroundColor = Color(0xFF15202B);
const Color primaryColor = Color(0xFF1DA1F2);

ThemeData getTheme() {
  ThemeData darkTheme = ThemeData.dark();

  ThemeData theme = darkTheme.copyWith(
    appBarTheme: darkTheme.appBarTheme.copyWith(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
      ),
    ),
    colorScheme: darkTheme.colorScheme.copyWith(
      primary: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: primaryColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    splashFactory: NoSplash.splashFactory,
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        color: Color(0xFF8899A6),
      ),
      caption: TextStyle(
        color: Color(0xFF8899A6),
      ),
      headline4: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  return theme;
}
