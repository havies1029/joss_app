import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class AvatarWithLoadingRing extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? userImage;
  final bool isLoading;
  final double avatarSize;
  final double ringSize;

  const AvatarWithLoadingRing({
    super.key,
    this.imageBytes,
    this.userImage,
    required this.isLoading,
    this.avatarSize = 46,
    this.ringSize = 54,
  });

  @override
  State<AvatarWithLoadingRing> createState() => _AvatarWithLoadingRingState();
}

class _AvatarWithLoadingRingState extends State<AvatarWithLoadingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AvatarWithLoadingRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _avatarFallback() => Container(
    color: pGrey,
    child: SvgPicture.asset(
      'assets/icons/place_holder_2.svg',
      width: 25,
      height: 25,
      fit: BoxFit.contain,
    ),
  );

  Widget _buildFromString(String? s) {
    if (s == null || s.isEmpty) return _avatarFallback();

    if (s.startsWith('http')) {
      return Image.network(
        s,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _avatarFallback(),
      );
    }

    return _avatarFallback();
  }

  @override
  Widget build(BuildContext context) {
    final hasBytes = widget.imageBytes != null && widget.imageBytes!.isNotEmpty;

    return SizedBox(
      width: widget.ringSize,
      height: widget.ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.avatarSize,
            height: widget.avatarSize,
            child: ClipOval(
              child: hasBytes
                  ? Image.memory(
                widget.imageBytes!,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, __, ___) => _avatarFallback(),
              )
                  : _buildFromString(widget.userImage),
            ),
          ),
          if (widget.isLoading)
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return CustomPaint(
                  size: Size(widget.ringSize, widget.ringSize),
                  painter: _AvatarLoadingPainter(
                    progress: _controller.value,
                    color: primaryColor,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _AvatarLoadingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _AvatarLoadingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 2.5;
    final rect = Offset.zero & size;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // panjang arc sekitar 80 derajat
    const sweepAngle = math.pi * 0.75;

    // start angle berputar
    final startAngle = (-math.pi / 2) + (2 * math.pi * progress);

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}