import 'package:flutter/material.dart';
import 'package:flutwitter/widgets/screen.dart';

class LoginSearchScreen extends StatelessWidget {
  static const routeName = '/login/search';

  const LoginSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen(
      body: Center(
        child: Text('Login'),
      ),
    );
  }
}
