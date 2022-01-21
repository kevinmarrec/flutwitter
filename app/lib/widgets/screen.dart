import 'package:flutter/material.dart';
import 'package:flutwitter/shared/constants.dart';
import 'package:flutwitter/widgets/svg_icon.dart';

class Screen extends StatelessWidget {
  const Screen({
    Key? key,
    required this.body,
    this.padding = const EdgeInsets.all(kDefaultPadding),
    this.bottom,
  }) : super(key: key);

  final Widget body;
  final EdgeInsets padding;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgIcon.twitter(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: padding,
                    child: body,
                  ),
                ),
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenBottomAppBar extends StatelessWidget {
  const ScreenBottomAppBar({
    Key? key,
    this.leftChild,
    this.rightChild,
  })  : assert(leftChild != null || rightChild != null),
        super(key: key);

  final Widget? leftChild;
  final Widget? rightChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        mainAxisAlignment: leftChild == null
            ? MainAxisAlignment.end
            : rightChild == null
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
        children: [
          if (leftChild != null) leftChild!,
          if (rightChild != null) rightChild!,
        ],
      ),
    );
  }
}

class ScreenBottomAppBarRightButton extends StatelessWidget {
  const ScreenBottomAppBarRightButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
        ),
        primary: Colors.white.withOpacity(onPressed != null ? 1 : 0),
        onPrimary: Colors.black,
      ),
    );
  }
}
