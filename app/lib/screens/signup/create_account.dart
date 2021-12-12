import 'package:flutter/material.dart';

import '../../widgets/twitter_icon.dart';

class CreateAccountScreen extends StatelessWidget {
  static const routeName = '/register/create';

  const CreateAccountScreen({Key? key}) : super(key: key);

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
            child: Container(),
          ),
        ),
      ),
    );
  }
}
