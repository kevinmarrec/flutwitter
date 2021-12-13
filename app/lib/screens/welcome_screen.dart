import 'package:flutter/material.dart';

import './create_account_screen.dart';
import '../theme.dart';
import '../widgets/svg_icon.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SvgIcon.twitter(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => Container(
            width: constraints.maxWidth,
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * 0.05,
              horizontal: constraints.maxWidth * 0.125,
            ),
            child: Column(
              children: [
                const Spacer(flex: 6),
                Text(
                  "See what's happening in the world right now.",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const Spacer(flex: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          CreateAccountScreen.routeName,
                        );
                      },
                      child: const Text('Create an account'),
                    )
                  ],
                ),
                const Spacer(flex: 2),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.caption,
                    children: const [
                      TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(color: primaryColor),
                      ),
                      TextSpan(text: ', '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: primaryColor),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Cookie Use',
                        style: TextStyle(color: primaryColor),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text('Have an account already ?'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Log in'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
