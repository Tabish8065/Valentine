import 'package:flutter/material.dart';
import '../constants.dart';

/// A smooth fade + upward‑slide page transition.
class FadeSlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlideRoute({required this.page})
      : super(
          transitionDuration: Anim.pageTransition,
          reverseTransitionDuration: Anim.fast,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Anim.pageIn,
              reverseCurve: Anim.defaultIn,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.06),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// A grand scale + fade transition for the Valentine Day page.
class ScaleFadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScaleFadeRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 550),
          reverseTransitionDuration: Anim.fast,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Anim.bounce,
              reverseCurve: Anim.defaultIn,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        );
}
