import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class BayarButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const BayarButton({
    super.key,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 16,
        bottom: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: labelLightColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Bayar",
                style: headingStyle(context, fontSize: 12),
              ),
            ),

            const SizedBox(height: 4),

            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: isEnabled ? onTap : null,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isEnabled ? Color(0xFFEF7A28) : unselectedColor,
                    border: Border.all(
                      color: isEnabled ? const Color(0xFFFF9144) : sGrey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/icons/bayar.svg",
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
