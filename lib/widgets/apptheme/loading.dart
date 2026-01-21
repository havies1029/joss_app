import 'package:flutter/cupertino.dart';

class LoadingWave extends StatefulWidget {
  const LoadingWave({super.key});

  @override
  State<LoadingWave> createState() => _LoadingWaveState();
}

class _LoadingWaveState extends State<LoadingWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(_controller.value),
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;

  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEF7A28)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final scale = size.width / 100;

    // Wave path (simplified version)
    path.moveTo(24.3 * scale, 30 * scale);
    path.cubicTo(
      11.4 * scale, 30 * scale,
      5 * scale, 43.3 * scale,
      5 * scale, 50 * scale,
    );
    path.cubicTo(
      5 * scale, 56.7 * scale,
      11.4 * scale, 70 * scale,
      24.3 * scale, 70 * scale,
    );
    path.cubicTo(
      43.6 * scale, 70 * scale,
      56.4 * scale, 30 * scale,
      75.7 * scale, 30 * scale,
    );
    path.cubicTo(
      88.6 * scale, 30 * scale,
      95 * scale, 43.3 * scale,
      95 * scale, 50 * scale,
    );
    path.cubicTo(
      95 * scale, 56.7 * scale,
      88.6 * scale, 70 * scale,
      75.7 * scale, 70 * scale,
    );

    final metric = path.computeMetrics().first;
    final dashPath = Path();

    const dashLength = 42.76;
    double distance = 0.0;
    final offset = progress * 256.59;

    while (distance < metric.length) {
      final start = (distance - offset) % 256.59;
      if (start >= 0 && start < dashLength) {
        final end = (start + dashLength).clamp(0.0, metric.length);
        dashPath.addPath(
          metric.extractPath(start, end),
          Offset.zero,
        );
      }
      distance += dashLength * 2;
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}