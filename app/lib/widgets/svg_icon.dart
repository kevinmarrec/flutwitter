import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutwitter/shared/theme.dart';

class SvgIcon extends StatelessWidget {
  final String icon;
  final Color color;
  final double? height;

  const SvgIcon(
    this.icon, {
    Key? key,
    this.color = primaryColor,
    this.height,
  }) : super(key: key);

  factory SvgIcon.twitter() => const SvgIcon('twitter', height: 28);
  factory SvgIcon.checkboxMarkedCircleOutline() => const SvgIcon('checkbox-marked-circle-outline', color: Colors.green);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/$icon.svg',
      color: color,
      height: height,
    );
  }
}
