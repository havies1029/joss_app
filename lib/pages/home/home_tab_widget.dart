import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/pages/testpage/testpage0.dart';
import 'package:joss_app/pages/testpage/testpage1.dart';
import 'package:joss_app/pages/testpage/testpage2.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

import '../heropage/mobile/heropage.dart';
import '../qontak/mobile/customer_service_page.dart';

class HomeTabWidget extends StatelessWidget {
  final UserRepository userRepository;
  const HomeTabWidget({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // atau Brightness.light sesuai tema
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // JPS Logo
              Image.asset(
                'assets/icons/logo_jps_no_background.png',
                height: 42,
                width: 120,
              ),
              // Notification Bell with Badge
              Stack(
                children: [
                  Image.asset(
                    'assets/icons/notification.png',
                    height: 39,
                    width: 40,
                  ),
                  // Notification badge (red dot with "2+")
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '2+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: const TabBarView(
          children: [
            HeroPage(),
            ReportTab(),
            CustomerServicePage(),
            SettingsTab(),
          ],
        ),
        bottomNavigationBar: Material(
          color: const Color(0xFF121212),
          child: const SafeArea(
            top: false,
            child: RoundedEndsTabBar(),
          ),
        ),
      ),
    );
  }
}

class CurvedTopIndicator extends Decoration {
  final Color color;
  final double thickness;
  final double cornerRadius;
  final bool curveLeft;   // true kalau tab pertama
  final bool curveRight;  // true kalau tab terakhir

  const CurvedTopIndicator({
    required this.color,
    this.thickness = 3,
    this.cornerRadius = 10,
    this.curveLeft = false,
    this.curveRight = false,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CurvedTopPainter(
      color: color,
      thickness: thickness,
      cornerRadius: cornerRadius,
      curveLeft: curveLeft,
      curveRight: curveRight,
    );
  }
}

class _CurvedTopPainter extends BoxPainter {
  final Color color;
  final double thickness;
  final double cornerRadius;
  final bool curveLeft;
  final bool curveRight;

  _CurvedTopPainter({
    required this.color,
    required this.thickness,
    required this.cornerRadius,
    required this.curveLeft,
    required this.curveRight,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final rect = offset & cfg.size!;
    final p = Path();

    // Mulai dari kiri → kanan, sisipkan arc di sisi yang perlu
    if (curveLeft) {
      // arc 1/4 lingkaran di kiri atas
      p.moveTo(rect.left, rect.top + cornerRadius);
      p.arcToPoint(
        Offset(rect.left + cornerRadius, rect.top),
        radius: Radius.circular(cornerRadius),
        clockwise: true,
      );
    } else {
      p.moveTo(rect.left, rect.top);
    }

    if (curveRight) {
      // garis datar sampai sebelum sudut kanan
      p.lineTo(rect.right - cornerRadius, rect.top);
      // arc 1/4 lingkaran di kanan atas
      p.arcToPoint(
        Offset(rect.right, rect.top + cornerRadius),
        radius: Radius.circular(cornerRadius),
        clockwise: true,
      );
    } else {
      p.lineTo(rect.right, rect.top);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt; // ujung "lurus", kelengkungan dari arc

    canvas.drawPath(p, paint);
  }
}

class RoundedEndsTabBar extends StatefulWidget {
  const RoundedEndsTabBar({super.key});

  @override
  State<RoundedEndsTabBar> createState() => _RoundedEndsTabBarState();
}

class _RoundedEndsTabBarState extends State<RoundedEndsTabBar> {
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= DefaultTabController.of(context)
      ?..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller?.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = _controller?.index ?? 0;
    final len = _controller?.length ?? 3;

    return TabBar(
      tabs: const [
        Tab(icon: Icon(Icons.home), text: 'Beranda'),
        Tab(icon: Icon(Icons.pie_chart), text: 'Literasi'),
        Tab(icon: Icon(Icons.pie_chart), text: 'Bantuan'),
        Tab(icon: Icon(Icons.settings), text: 'Profil Anda'),
      ],
      labelColor: const Color(0xFFEFA728),
      unselectedLabelColor: const Color(0xFF666666),
      indicatorSize: TabBarIndicatorSize.tab,
      // indikator: garis atas dengan arc di kiri/kanan sesuai posisi
      indicator: CurvedTopIndicator(
        color: const Color(0xFFEFA728),
        thickness: 3,
        cornerRadius: 10,              // <- ini radius lengkungnya
        curveLeft: idx == 0,           // aktifin arc kiri jika tab pertama
        curveRight: idx == len - 1,    // aktifin arc kanan jika tab terakhir
      ),
    );
  }
}