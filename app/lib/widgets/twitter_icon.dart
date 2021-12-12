import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

class TwitterIcon extends StatelessWidget {
  const TwitterIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/twitter.svg',
      color: primaryColor,
      height: 28,
    );
  }
}
