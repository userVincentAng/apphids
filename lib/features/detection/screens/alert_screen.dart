import 'package:flutter/material.dart';

class PulsatingBugIcon extends StatefulWidget {
  const PulsatingBugIcon({Key? key}) : super(key: key);

  @override
  _PulsatingBugIconState createState() => _PulsatingBugIconState();
}

class _PulsatingBugIconState extends State<PulsatingBugIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.scale(
        scale: _animation.value,
        child: child,
      ),
      child: const Icon(
        Icons.bug_report,
        size: 80,
        color: Colors.greenAccent,
      ),
    );
  }
}
