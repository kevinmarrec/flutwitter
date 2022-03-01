import 'package:flutter/material.dart';
import 'package:flutwitter/router/transitions/page_slide_transition.dart';
import 'package:flutwitter/screens/login/form_screen.dart';
import 'package:flutwitter/screens/registration/details_screen.dart';
import 'package:flutwitter/screens/registration/password_screen.dart';
import 'package:flutwitter/screens/registration/verification_screen.dart';
import 'package:flutwitter/screens/welcome_screen.dart';

class AppRouter {
  static String initialRoute = WelcomeScreen.routeName;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Welcome
      case WelcomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      // Registration
      case RegistrationDetailsScreen.routeName:
        return slide(const RegistrationDetailsScreen());
      case RegistrationVerificationScreen.routeName:
        return slide(const RegistrationVerificationScreen());
      case RegistrationPasswordScreen.routeName:
        return slide(const RegistrationPasswordScreen());
      case LoginFormScreen.routeName:
        return slide(const LoginFormScreen());
      default:
        throw 'Route not implemented';
    }
  }
}
