import 'package:flutter/material.dart';
import 'package:flutwitter/router/transitions/page_slide_transition.dart';
import 'package:flutwitter/screens/all.dart';
import 'package:flutwitter/screens/registration/verify_code_screen.dart';

class AppRouter {
  static String initialRoute = WelcomeScreen.routeName;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case WelcomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      case CreateAccountScreen.routeName:
        return PageSlideTransition(
          child: const CreateAccountScreen(),
        );
      case VerifyCodeScreen.routeName:
        return PageSlideTransition(
          child: const VerifyCodeScreen(),
        );
      default:
        throw 'Route not implemented';
    }
  }
}
