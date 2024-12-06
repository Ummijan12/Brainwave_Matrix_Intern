import 'package:flutter/material.dart';

void navigateWithFadeTransition({
  required BuildContext context,
  required Widget targetPage,
  Duration transitionDuration = const Duration(milliseconds: 500),
}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: targetPage,
        );
      },
    ),
  );
}
