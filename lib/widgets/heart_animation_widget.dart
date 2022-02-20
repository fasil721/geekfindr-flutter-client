import 'package:flutter/material.dart';

class HeartAnimationWidget extends StatefulWidget {
  const HeartAnimationWidget({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.alwaysAnimate = false,
  }) : super(key: key);
  final Widget child;
  final bool isAnimating;
  final bool alwaysAnimate;
  final Duration duration;
  final VoidCallback? onEnd;
  @override
  _HeartAnimationWidgetState createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: halfDuration),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(HeartAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    if (widget.isAnimating || widget.alwaysAnimate) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 400));
      if (widget.onEnd != null) {
        widget.onEnd ?? () {}();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: scale,
        child: widget.child,
      );
}
