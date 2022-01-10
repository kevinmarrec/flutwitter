import 'package:flutter/material.dart';
// import 'package:flutwitter/shared/registration.dart';
import 'package:flutwitter/widgets/svg_icon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyCodeScreen extends StatelessWidget {
  static const routeName = '/registration/verify_code';

  const VerifyCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgIcon.twitter(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * 0.05,
              horizontal: constraints.maxWidth * 0.125,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                // final registration = ref.read(registrationProvider);
                // print(registration.name);
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
