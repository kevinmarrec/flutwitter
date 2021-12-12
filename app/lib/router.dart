import 'package:flutter/material.dart';

import 'screens/signup/all.dart';
import 'screens/welcome.dart';

class PageSlideTransition extends PageRouteBuilder {
  final Widget child;

  PageSlideTransition({
    required this.child,
  }) : super(
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.ease)),
              ),
              child: child,
            );
          },
        );
}

class AppRouter {
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
