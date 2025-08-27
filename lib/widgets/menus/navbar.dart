import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}

class WebNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const WebNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const String _logoPathRight = 'assets/icons/logo_jps_no_background.png';
  static const List<NavBarItem> _defaultItems = [
    NavBarItem(iconPath: 'assets/icons/beranda.svg', label: 'Beranda'),
    NavBarItem(iconPath: 'assets/icons/literasi.svg', label: 'Literasi'),
    NavBarItem(iconPath: 'assets/icons/bantuan.svg', label: 'Bantuan'),
    NavBarItem(iconPath: 'assets/icons/setting.svg', label: 'Pengaturan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: primaryBlackColor,
      padding: const EdgeInsets.symmetric(horizontal: hPadding),
      child: Row(
        children: [
          Image.asset(
            _logoPathRight,
            height: 40,
            width: 100,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(_defaultItems.length, (i) {
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: hPadding),
                  padding: const EdgeInsets.symmetric(
                    vertical: vPadding / 2,
                    horizontal: hPadding,
                  ),
                  decoration: isActive
                      ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: primaryColor, width: 3),
                    ),
                  )
                      : null,
                  child: Row(
                    children: [
                      if (_defaultItems[i].iconPath.isNotEmpty) ...[
                        SvgPicture.asset(
                          _defaultItems[i].iconPath,
                          width: 22,
                          height: 22,
                          color: isActive ? primaryColor : sGrey,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _defaultItems[i].label,
                        style: TextStyle(
                          fontSize: 15,
                          color: isActive ? primaryColor : sGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}