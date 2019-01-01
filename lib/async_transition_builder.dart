import 'package:flutter/material.dart';
import 'package:flutter_animation/async_transition_animations.dart';
import 'package:flutter_animation/progress_container.dart';

typedef Widget BuilderCallback(
    BuildContext context, AsyncTransitionAnimation anim);

/// AsyncTransitionBuilder
class AsyncTransitionBuilder extends StatefulWidget {
  final AnimationController controller;
  final CompletionCallback onComplete;
  final BuilderCallback builder;
  final Color iconColor;
  final Color textColor;
  final String inProgressText;
//  final String onCompeteText;

  AsyncTransitionBuilder({
    this.controller,
    this.onComplete,
    this.builder,
    this.inProgressText,
    this.iconColor,
    this.textColor,
//    this.onCompeteText,
  });

  @override
  State createState() {
    return AsyncTransitionBuilderState();
  }
}

class AsyncTransitionBuilderState extends State<AsyncTransitionBuilder> {
  AsyncTransitionAnimation animation;

  @override
  void initState() {
    super.initState();
    animation = AsyncTransitionAnimation(
      controller: widget.controller,
      callback: onComplete,
    );
  }

  onComplete(String event) {
    setState(() {});
    new Future.delayed(Duration(milliseconds: 500), () {
      widget.onComplete(event);
      animation.state = AnimationState.waiting;
//      widget.controller.reset();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
      widget.builder(context, animation),
      ProgressContainer(
          opacity: animation.opacity,
          offset: animation.offset,
          state: animation.state,
          textColor: widget.textColor,
          iconColor: widget.iconColor,
          description: (animation.state == AnimationState.animating)
              ? widget.inProgressText
              : ""),
    ]));
  }
}
