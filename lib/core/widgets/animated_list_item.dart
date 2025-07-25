import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../constants/app_constants.dart';

class AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration? delay;

  const AnimatedListItem({
    Key? key,
    required this.index,
    required this.child,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: AppConstants.animationDuration,
      delay: delay ?? AppConstants.staggerDelay,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}