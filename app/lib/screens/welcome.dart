import 'package:flutter/material.dart';

import '../widgets/twitter_icon.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TwitterIcon(),
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
                SizedBox(height: constraints.maxHeight * 0.2),
                const Text(
                  "See what's happening in the world right now.",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Create an account'),
                    )
                  ],
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
