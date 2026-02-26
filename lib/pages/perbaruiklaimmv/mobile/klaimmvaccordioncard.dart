import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class Klaimmvaccordioncard extends StatelessWidget {
  final String title;
  final bool isOpen;
  final VoidCallback onTap;
  final Widget child;

  const Klaimmvaccordioncard({
    super.key,
    required this.title,
    required this.isOpen,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: onTap,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: child,
            ),
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          )
        ],
      ),
    );
  }
}
