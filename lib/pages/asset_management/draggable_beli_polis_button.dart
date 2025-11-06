import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/beli_polis/mobile/beli_polis_page.dart';

class DraggableBeliPolisButton extends StatefulWidget {
  const DraggableBeliPolisButton({super.key});

  @override
  State<DraggableBeliPolisButton> createState() =>
      _DraggableBeliPolisButtonState();
}

class _DraggableBeliPolisButtonState extends State<DraggableBeliPolisButton>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isDragging = false;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  void _animateTo(Offset newPosition) {
    _animation = Tween<Offset>(begin: position, end: newPosition).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
    const double bottomNavHeight = 80;

    // posisi awal default
    if (position == Offset.zero) {
      const double margin = 16;
      position = Offset(
        screen.width - 100 - margin,
        screen.height - 40 - margin - bottomNavHeight,
      );
    }


    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () {
          if (!isDragging) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BeliPolisPage()),
            );
          }
        },
        onTapDown: (_) => setState(() => scale = 0.92),
        onTapUp: (_) => setState(() => scale = 1.0),
        onTapCancel: () => setState(() => scale = 1.0),
        onPanStart: (_) => setState(() => isDragging = true),
        onPanUpdate: (details) {
          setState(() => position += details.delta);
        },
        onPanEnd: (details) {
          setState(() => isDragging = false);
          final double vx = details.velocity.pixelsPerSecond.dx;
          final double vy = details.velocity.pixelsPerSecond.dy;

          final double minY = 80;
          final double maxY =
              screen.height - buttonHeight - bottomNavHeight - 10 - keyboardHeight;

          double newX =
          (position.dx + vx / 12).clamp(10, screen.width - 100 - 10);
          double newY = (position.dy + vy / 12).clamp(minY, maxY);

          _animateTo(Offset(newX, newY));
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  "Beli Polis",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
