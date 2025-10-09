import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../common/constants.dart';

class HeaderAsuransiCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final VoidCallback? onTap;

  const HeaderAsuransiCard({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: orangeToBlackGradient,
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        onTap: onTap,
        child: Row(
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(
                iconPath!,
                color: Colors.white,
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Text(title, style: headingStyle(context, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
