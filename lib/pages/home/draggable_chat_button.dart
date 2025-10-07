import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class DraggableChatButton extends StatefulWidget {
  final VoidCallback onTap;
  const DraggableChatButton({super.key, required this.onTap});

  @override
  State<DraggableChatButton> createState() => _DraggableChatButtonState();
}

class _DraggableChatButtonState extends State<DraggableChatButton> with SingleTickerProviderStateMixin {
  Offset position = const Offset(0, 0);
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void _animateTo(Offset newPosition) {
    _animation = Tween<Offset>(begin: position, end: newPosition).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.addListener(() {
      setState(() => position = _animation.value);
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double buttonSize = 70.0;

    // Default position: bottom right
    if (position == Offset.zero) {
      position = Offset(screen.width - buttonSize - 20, screen.height - buttonSize - 120);
    }

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () {
          if (!isDragging) widget.onTap();
        },
        onPanStart: (_) => setState(() => isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        onPanEnd: (details) {
          setState(() => isDragging = false);
          final double vx = details.velocity.pixelsPerSecond.dx;
          final double vy = details.velocity.pixelsPerSecond.dy;

          // lempar ke arah dengan batas layar
          final Offset target = Offset(
            (position.dx + vx / 10).clamp(10, screen.width - buttonSize - 10),
            (position.dy + vy / 10).clamp(80, screen.height - buttonSize - 80),
          );
          _animateTo(target);
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/bantuan.svg',
              width: 30,
              height: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
