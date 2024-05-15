import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final VoidCallback? onEnd;

  const HeartAnimation({
    super.key,
    required this.child,
    required this.isAnimating,
    this.onEnd,
  });

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
    );

    scale = Tween<double>(begin: 1, end: 1.2).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
    ));
  }

  void playAnimation() async {
    if(widget.isAnimating) {
      await _animationController.forward();
      await _animationController.reverse();
    }
    await Future.delayed(Duration(milliseconds: 300));

    if(widget.onEnd != null){
      widget.onEnd!();
    }
  }

  @override
  void didUpdateWidget(covariant HeartAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating){
      playAnimation();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
