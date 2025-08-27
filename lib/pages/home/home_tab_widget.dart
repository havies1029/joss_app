import 'package:flutter/material.dart';

import '../../widgets/menus/bottom_nav.dart' as bottom_nav;
import '../../widgets/menus/navbar.dart' as web_nav;

import '../../widgets/menus/top_nav.dart';
import '../heropage/mobile/heropage.dart';
import '../qontak/mobile/customer_service_page.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/testpage/testpage1.dart';
import 'package:joss_app/pages/testpage/testpage2.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

class HomeTabWidget extends StatefulWidget {
  final UserRepository userRepository;
  const HomeTabWidget({super.key, required this.userRepository});

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HeroPage(),
      const ReportTab(),
      const CustomerServicePage(),
      const SettingsTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (pIsWeb) {
      return Scaffold(
        extendBody: true,
        body: Column(
          children: [
            web_nav.WebNavbar(
              currentIndex: selectedIndex,
              onTap: (idx) => setState(() => selectedIndex = idx),
            ),
            // Expanded biar page ngisi space sisa
            Expanded(
              child: IndexedStack(index: selectedIndex, children: pages),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MobileTopNavigationBar(context: context),
      body: pages[selectedIndex],
      bottomNavigationBar: Material(
        color: primaryBlackColor,
        child: SafeArea(
          top: false,
          child: bottom_nav.MobileBottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (idx) => setState(() => selectedIndex = idx),
          )
        ),
      ),
    );
  }
}

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}
