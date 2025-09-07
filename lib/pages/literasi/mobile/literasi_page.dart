import 'package:flutter/material.dart';
import 'package:joss_app/pages/literasi/mobile/artikel_page.dart';
import 'package:joss_app/pages/literasi/mobile/tentang_jps_page.dart';
import 'package:joss_app/pages/literasi/mobile/testimoni_page.dart';

class LiterasiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> tabLabels;

  const LiterasiAppBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.tabLabels = const ['Tentang_JPS', 'Artikel', 'Testimoni'],
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header dengan judul
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Literasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Custom Tab Bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  tabLabels.length,
                      (index) => Expanded(
                    child: _buildTabItem(
                      label: tabLabels[index],
                      isSelected: currentIndex == index,
                      onTap: () => onTap(index),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.orange : Colors.grey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Custom indicator
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiterasiPage extends StatefulWidget {
  const LiterasiPage({Key? key}) : super(key: key);

  @override
  State<LiterasiPage> createState() => _LiterasiPageState();
}

class _LiterasiPageState extends State<LiterasiPage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    TentangJPSPage(),
    ArtikelPage(),
    TestimoniPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiterasiAppBar(
        currentIndex: selectedIndex,
        onTap: (idx) => setState(() => selectedIndex = idx),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
    );
  }
}