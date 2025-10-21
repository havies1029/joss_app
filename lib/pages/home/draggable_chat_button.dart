import 'package:flutter/material.dart';

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
        curve: Curves.easeOutCubic,
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
    const double floatMargin = 45;

    // posisi awal default
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

          final double minY = topNavHeight + 10;
          final double maxY = screen.height -
              buttonSize -
              bottomNavHeight -
              10 -
              keyboardHeight;

          double newX =
          (position.dx + vx / 12).clamp(10, screen.width - buttonSize - 10);
          double newY = (position.dy + vy / 12).clamp(minY, maxY);

          const double bounceTop = 14;
          const double bounceBottom = 28;

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
              color: Colors.white, // background putih clean
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            // 🧠 Ganti SVG ke icon bawaan dulu
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/logo_bantuan.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),


            /*
            child: Center(
              child:SvgPicture.asset(
                'assets/icons/logo_bantuan.svg',
                width: 36,
                height: 36,
                colorFilter: const ColorFilter.mode(
                  Colors.black, // ubah jadi hitam
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          */
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
