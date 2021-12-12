import 'package:flutter/material.dart';

import 'screens/welcome.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const WelcomeScreen(),
    );
  }
}
