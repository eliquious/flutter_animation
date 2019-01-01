import 'package:flutter/material.dart';
import 'package:flutter_animation/async_transition_animations.dart';

class ProgressContainer extends StatelessWidget {
  final double opacity;
  final Offset offset;
  final AnimationState state;
  final String description;
  final Color iconColor;
  final Color textColor;

  ProgressContainer({
    this.opacity,
    this.offset,
    this.state,
    this.description,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    Widget icon;
    if (state == AnimationState.animating) {
      icon = new CircularProgressIndicator(
          value: null, valueColor: AlwaysStoppedAnimation<Color>(iconColor));
    } else {
      icon = new Icon(Icons.check, color: iconColor, size: 40.0);
    }

    if (state == AnimationState.waiting) {
      child = Container();
    } else {
      child = Column(children: <Widget>[
        icon,
        SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: textColor,
                      ),
                ))),
      ]);
    }

    return Container(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: offset,
        child: Opacity(opacity: 1.0 - opacity, child: Container(child: child)),
      ),
    );
  }
}
