import 'package:flutter/material.dart';
import 'package:flutwitter/router/transitions/page_slide_transition.dart';
import 'package:flutwitter/screens/registration/details_screen.dart';
import 'package:flutwitter/screens/registration/verification_screen.dart';
import 'package:flutwitter/screens/welcome_screen.dart';

class AppRouter {
  static String initialRoute = WelcomeScreen.routeName;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case WelcomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      case RegistrationDetailsScreen.routeName:
        return PageSlideTransition(
          child: const RegistrationDetailsScreen(),
        );
      case RegistrationVerificationScreen.routeName:
        return PageSlideTransition(
          child: const RegistrationVerificationScreen(),
        );
      default:
        throw 'Route not implemented';
    }
  }
}
