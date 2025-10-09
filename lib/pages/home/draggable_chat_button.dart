import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DraggableChatButton extends StatefulWidget {
  final VoidCallback onTap;
  const DraggableChatButton({super.key, required this.onTap});

  @override
  State<DraggableChatButton> createState() => _DraggableChatButtonState();
}

class _DraggableChatButtonState extends State<DraggableChatButton>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isDragging = false;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  void _animateTo(Offset newPosition) {
    _animation = Tween<Offset>(begin: position, end: newPosition).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic, // 🔹 lebih halus dari Quad, natural deceleration
      ),
    );

    _controller.addListener(() {
      setState(() => position = _animation.value);
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const double buttonSize = 70.0;
    const double topNavHeight = 80;
    const double bottomNavHeight = 80;
    const double floatMargin = 45; // 🔹 jarak elegan dari bottom nav

    // default posisi awal
    if (position == Offset.zero) {
      position = Offset(
        screen.width - buttonSize - 20,
        screen.height - buttonSize - bottomNavHeight - floatMargin,
      );
    }

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () {
          if (!isDragging) widget.onTap();
        },
        onTapDown: (_) => setState(() => scale = 0.92),
        onTapUp: (_) => setState(() => scale = 1.0),
        onTapCancel: () => setState(() => scale = 1.0),
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

          // batas aman top & bottom
          final double minY = topNavHeight + 10;
          final double maxY = screen.height -
              buttonSize -
              bottomNavHeight -
              10 -
              keyboardHeight;

          double newX =
          (position.dx + vx / 12).clamp(10, screen.width - buttonSize - 10);
          double newY = (position.dy + vy / 12).clamp(minY, maxY);

          // 🔹 Pantulan lebih jauh dari bottomNav biar gak tenggelam
          const double bounceTop = 14; // halus
          const double bounceBottom = 28; // agak jauh, jaga radius bottom nav

          if (newY <= minY + 5) newY += bounceTop;
          if (newY >= maxY - 5) newY -= bounceBottom;

          _animateTo(Offset(newX, newY));
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
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
      ),
    );
  }
}