import 'dart:math';
import 'package:flutter/material.dart';

class DraggableHalfCircleButton extends StatefulWidget {
  const DraggableHalfCircleButton({super.key});

  @override
  State<DraggableHalfCircleButton> createState() =>
      _DraggableHalfCircleButtonState();
}

class _DraggableHalfCircleButtonState extends State<DraggableHalfCircleButton>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  late AnimationController _controller;
  bool isOpen = false;
  bool isDragging = false;
  double scale = 1.0;

  final List<_ButtonItem> buttons = [
    _ButtonItem(icon: Icons.home, label: "Home", color: Colors.blue),
    _ButtonItem(icon: Icons.search, label: "Search", color: Colors.green),
    _ButtonItem(icon: Icons.notifications, label: "Notif", color: Colors.amber),
    _ButtonItem(icon: Icons.settings, label: "Settings", color: Colors.purple),
    _ButtonItem(icon: Icons.favorite, label: "Fav", color: Colors.pink),
    _ButtonItem(icon: Icons.person, label: "Profile", color: Colors.indigo),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // REVISI 1: Sudut dan Radius yang Presisi
  Offset getPosition(int index, double progress) {
    const double startAngle = 180; // Mulai dari sisi kiri
    const double endAngle = 0;     // Berakhir di sisi kanan
    final double angle =
        (startAngle + (endAngle - startAngle) * (index / (buttons.length - 1))) *
            pi /
            -180;
    const double radius = 100; // Radius 100 untuk hasil yang lebih renggang
    return Offset(cos(angle) * radius * progress, sin(angle) * radius * progress);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    // posisi awal di kanan bawah
    if (position == Offset.zero) {
      position = Offset(screen.width - 100, screen.height - 200);
    }

    return Stack(
      children: [
        // tombol-tombol kecil
        ..._buildFloatingMenu(),
        // tombol utama draggable
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onTapDown: (_) => setState(() => scale = 0.9),
            onTapUp: (_) => setState(() => scale = 1.0),
            onTapCancel: () => setState(() => scale = 1.0),
            onTap: () {
              if (!isDragging) {
                setState(() {
                  isOpen = !isOpen;
                  isOpen ? _controller.forward() : _controller.reverse();
                });
              }
            },
            onPanStart: (_) => setState(() => isDragging = true),
            onPanUpdate: (details) {
              setState(() => position += details.delta);
            },
            onPanEnd: (_) => setState(() => isDragging = false),
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutBack,
              child: AnimatedRotation(
                turns: isOpen ? 0.125 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFloatingMenu() {
    final progress = Curves.easeOutCubic.transform(_controller.value);

    // daftar tombol (muter)
    // Penentuan LabelPosition disesuaikan berdasarkan letak di busur:
    // Index 0, 1, 2 berada di busur kiri (Label di Kiri)
    // Index 3, 4, 5 berada di busur kanan (Label di Kanan)
    final buttons = [
      _buildButtonItem(0, progress, this.buttons[0].icon, this.buttons[0].color, this.buttons[0].label, LabelPosition.left),  // Home
      _buildButtonItem(1, progress, this.buttons[1].icon, this.buttons[1].color, this.buttons[1].label, LabelPosition.left),  // Search
      _buildButtonItem(2, progress, this.buttons[2].icon, this.buttons[2].color, this.buttons[2].label, LabelPosition.left),  // Notif
      _buildButtonItem(3, progress, this.buttons[3].icon, this.buttons[3].color, this.buttons[3].label, LabelPosition.right), // Settings
      _buildButtonItem(4, progress, this.buttons[4].icon, this.buttons[4].color, this.buttons[4].label, LabelPosition.right), // Fav
      _buildButtonItem(5, progress, this.buttons[5].icon, this.buttons[5].color, this.buttons[5].label, LabelPosition.right), // Profile
    ];

    // ambil semua widget tombol dan label, lalu gabungkan ke Stack
    return buttons.expand((pair) => pair).toList();
  }

  // REVISI 2: Perhitungan Posisi Horizontal yang Presisi
  List<Widget> _buildButtonItem(
      int index,
      double progress,
      IconData icon,
      Color color,
      String label,
      LabelPosition labelPosition,
      ) {
    final pos = getPosition(index, progress);

    const double buttonSize = 50.0;
    const double mainButtonSize = 70.0;
    const double mainButtonRadius = mainButtonSize / 2;
    const double buttonRadius = buttonSize / 2;
    const double spacing = 10.0;

    // Pusat tombol utama
    final double centerBaseX = position.dx + mainButtonRadius;
    final double centerBaseY = position.dy + mainButtonRadius;

    // --- Perkiraan Lebar Label (Heuristik) ---
    // Diperlukan untuk menghitung pergeseran yang tepat saat label di Kiri.
    // Disesuaikan: 6.5 per karakter + 18 (padding & sedikit margin).
    final double estimatedLabelWidth = label.length * 6.5 + 18.0;
    final double estimatedShift = estimatedLabelWidth + spacing;

    // Pusat Posisi Tombol Kecil
    final double finalLeftAnchor = centerBaseX + pos.dx;
    final double finalTopAnchor = centerBaseY + pos.dy;

    // Tombol
    final buttonWidget = Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );

    // Label
    final labelWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );

    // tombol + label disusun horizontal
    final combinedRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection:
      labelPosition == LabelPosition.left ? TextDirection.rtl : TextDirection.ltr,
      children: [
        buttonWidget,
        const SizedBox(width: spacing),
        labelWidget,
      ],
    );

    double finalLeft;
    if (labelPosition == LabelPosition.left) {
      // Tombol di kanan (RTL). Geser seluruh Row ke KIRI sejauh lebar label + spasi + radius tombol
      finalLeft = finalLeftAnchor - (estimatedShift + buttonRadius);
    } else {
      // Tombol di kiri (LTR). Cukup geser ke KIRI sejauh radius tombol (dari pusat ke tepi kiri).
      finalLeft = finalLeftAnchor - buttonRadius;
    }

    // `finalTop` mengatur pusat vertikal Row yang tingginya `buttonSize`.
    final double finalTop = finalTopAnchor - buttonRadius;


    return [
      Positioned(
        left: finalLeft,
        top: finalTop,
        child: Opacity(
          opacity: progress,
          child: Transform.scale(
            scale: progress,
            alignment: Alignment.center,
            child: combinedRow,
          ),
        ),
      ),
    ];
  }
}

class _ButtonItem {
  final IconData icon;
  final String label;
  final Color color;

  const _ButtonItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

enum LabelPosition { bottom, left, right }

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final LabelPosition labelPosition;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    this.labelPosition = LabelPosition.bottom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );

    Widget labelWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );

    Widget content;
    switch (labelPosition) {
      case LabelPosition.left:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            labelWidget,
            const SizedBox(width: 6),
            iconWidget,
          ],
        );
        break;

      case LabelPosition.right:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(width: 6),
            labelWidget,
          ],
        );
        break;

      default:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 6),
            labelWidget,
          ],
        );
    }

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}