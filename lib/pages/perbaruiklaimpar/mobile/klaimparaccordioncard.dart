import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class Klaimparaccordioncard extends StatelessWidget {
  final String title;
  final bool isOpen;
  final VoidCallback onTap;
  final Widget child;

  const Klaimparaccordioncard({super.key, 
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
          if (isOpen)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: child,
            ),
        ],
      ),
    );
  }
}