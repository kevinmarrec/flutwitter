import 'package:flutter/material.dart';

Route slide(Widget child) {
  return PageSlideTransition(child: child);
}

class PageSlideTransition extends PageRouteBuilder {
  final Widget child;

  PageSlideTransition({
    required this.child,
  }) : super(
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.ease)).animate(animation),
              child: child,
            );
          },
        );
}
