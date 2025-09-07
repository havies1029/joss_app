import 'package:flutter/material.dart';
import 'package:joss_app/pages/literasi/mobile/artikel_page.dart';
import 'package:joss_app/pages/literasi/mobile/tentang_jps_page.dart';
import 'package:joss_app/pages/literasi/mobile/testimoni_page.dart';
import 'package:joss_app/common/constants.dart';
import 'package:path/path.dart';

class LiterasiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> tabLabels;

  const LiterasiAppBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.tabLabels = const ['Tentang JPS', 'Artikel', 'Testimoni'],
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(color: secondaryBlackColor),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: List.generate(
                  tabLabels.length,
                      (index) => Expanded(
                    child: _buildTabItem(
                      context: context,
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
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: bodyTextStyle(context).copyWith(
                    color: isSelected ? primaryColor : pGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 3,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
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

  final List<Widget> pages = [TentangJPSPage(), ArtikelPage(), TestimoniPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiterasiAppBar(
        currentIndex: selectedIndex,
        onTap: (idx) => setState(() => selectedIndex = idx),
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
    );
  }
}
