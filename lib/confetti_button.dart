// library confetti_button;

import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  const ConfettiButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = Colors.purple,
  });

  @override
  State<ConfettiButton> createState() => _ConfettiButtonState();
}

class _ConfettiButtonState extends State<ConfettiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<_Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(() {
        setState(() {
          _updateBubbles();
        });
      });
  }

  void _handleTap() {
    widget.onPressed();

    _generateBubbles();

    _controller.forward(from: 0);
  }

  // 🎉 CREATE CENTER EXPLOSION
  void _generateBubbles() {
    _bubbles.clear();

    final random = Random();

    for (int i = 0; i < 35; i++) {
      final angle = random.nextDouble() * 2 * pi;

      // 🚀 SPEED
      final speed = random.nextDouble() * 6 + 4;

      _bubbles.add(
        _Bubble(
          x: 0,
          y: 0,

          // 🎯 PERFECT ALL DIRECTION SPREAD
          dx: cos(angle) * speed,
          dy: sin(angle) * speed,

          // 🔥 BIGGER BUBBLES
          size: random.nextDouble() * 16 + 10,

          color: Colors.primaries[
              random.nextInt(Colors.primaries.length)],
        ),
      );
    }
  }

  // 🎈 UPDATE MOVEMENT
  void _updateBubbles() {
    for (var bubble in _bubbles) {
      bubble.x += bubble.dx;
      bubble.y += bubble.dy;

      // gravity
      bubble.dy += 0.12;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [

          // 🎈 BUBBLES
          ..._bubbles.map((bubble) {
            return Positioned(
              left: 160 + bubble.x,
              top: 110 + bubble.y,
              child: Container(
                width: bubble.size,
                height: bubble.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bubble.color.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: bubble.color.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            );
          }),

          // 🔘 BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              elevation: 8,
              shadowColor: widget.color.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _handleTap,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

// 🎈 Bubble Model
class _Bubble {
  double x;
  double y;
  double dx;
  double dy;
  double size;
  Color color;

  _Bubble({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.size,
    required this.color,
  });
}