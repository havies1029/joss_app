import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}

class MobileBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _height = 64;
  static const double _thickness = 1.5;

  // Daftar menu default JPS
  static const List<NavBarItem> _defaultItems = [
    NavBarItem(iconPath: 'assets/icons/beranda.svg', label: 'Beranda'),
    NavBarItem(iconPath: 'assets/icons/find_insurance_icon.svg', label: 'Cari Asuransi'),
    NavBarItem(iconPath: 'assets/icons/literasi.svg', label: 'Literasi'),
    NavBarItem(iconPath: 'assets/icons/setting.svg', label: 'Pengaturan'),
  ];

  const MobileBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: primaryBlackColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(cardBorderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_defaultItems.length, (i) {
          final isActive = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: _height,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isActive ? primaryColor : sGrey,
                      width: _thickness,
                    ),
                  ),
                  borderRadius:
                      i == 0
                          ? const BorderRadius.only(
                            topLeft: Radius.circular(cardBorderRadius),
                          )
                          : i == _defaultItems.length - 1
                          ? const BorderRadius.only(
                            topRight: Radius.circular(cardBorderRadius),
                          )
                          : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      _defaultItems[i].iconPath,
                      width: 24,
                      height: 24,
                      color: isActive ? primaryColor : sGrey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _defaultItems[i].label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? primaryColor : sGrey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
