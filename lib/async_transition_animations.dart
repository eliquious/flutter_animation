import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

/// AnimationState represents the current state of the animation process.
enum AnimationState { waiting, animating, completed }

/// CompletionCallback is called when the Future has completed.
typedef void CompletionCallback(String event);

/// AsyncTransitionAnimations stores animation values for screen transitions.
class AsyncTransitionAnimation {
  final AnimationController controller;
  final CompletionCallback callback;

  AnimationState state = AnimationState.waiting;
  String _buttonEvent = "";
  Animation<double> _fractionAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _offsetAnimation;

  AsyncTransitionAnimation({@required this.controller, @required this.callback})
      : this._fractionAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.0, 0.667, curve: Curves.easeIn))),
        this._opacityAnimation = Tween(
          begin: 1.0,
          end: 0.0,
        ).animate(new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.0, 0.250, curve: Curves.easeIn))),
        this._offsetAnimation = Tween<Offset>(
          begin: new Offset(0.0, 0.0),
          end: new Offset(1.0, 0.0),
        ).animate(new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.25, 0.999, curve: Curves.ease)));

  double get fraction => _fractionAnimation.value;
  double get opacity => _opacityAnimation.value;
  Offset get offset => _offsetAnimation.value;

  _initializeAlignmentAnimation(BuildContext context, GlobalKey buttonKey) {
    Size screenSize = MediaQuery.of(context).size;
    final RenderBox renderBox = buttonKey.currentContext.findRenderObject();
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _offsetAnimation = Tween<Offset>(
      begin: new Offset(position.dx - screenSize.width / 2 + size.width / 2,
          position.dy - size.height - 56.0),
      end: new Offset(0.0,
          screenSize.height / 2 - 20.0 - size.height - screenSize.height / 6),
    ).animate(new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.1,
          0.750,
          curve: Curves.easeOut,
        )));
  }

  void done() async {
    state = AnimationState.completed;
    callback(_buttonEvent);
  }

  Future<Null> playAnimation(
      BuildContext context, GlobalKey key, String eventName) async {
    if (state == AnimationState.waiting) {
      try {
        state = AnimationState.animating;
        _buttonEvent = eventName;
        _initializeAlignmentAnimation(context, key);
        await controller.forward();
      } on TickerCanceled {}
    }
  }
}
