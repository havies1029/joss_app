import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class StatusBox extends StatelessWidget {
  final String assetPath;
  final Color bgColor;
  final double size;
  final double iconSize;

  const StatusBox({
    super.key,
    required this.assetPath,
    required this.bgColor,
    this.size = 36,      // default ukuran box
    this.iconSize = 18,  // default ukuran icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: SvgPicture.asset(
          assetPath,
          width: iconSize,
          height: iconSize,
          colorFilter: const ColorFilter.mode(
            primaryLightColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
