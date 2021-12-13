import 'package:flutter/material.dart';

import './transitions/page_slide_transition.dart';
import '../screens/all.dart';

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
      default:
        throw 'Route not implemented';
    }
  }
}
