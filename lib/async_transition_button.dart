import 'package:flutter/material.dart';
import 'package:flutter_animation/async_transition_animations.dart';
import 'package:flutter_animation/reveal_painter.dart';

class AsyncTransitionButton extends StatelessWidget {
  final AsyncTransitionAnimation animation;
  final Widget child;
  final Color fillColor;

  AsyncTransitionButton({
    @required this.animation,
    @required this.fillColor,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        child:
            Container(child: Opacity(opacity: animation.opacity, child: child)),
        painter: RevealPainter(
            fraction: animation.fraction,
            fillColor: fillColor,
            screenSize: MediaQuery.of(context).size));
  }
}
