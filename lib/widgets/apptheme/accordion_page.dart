import 'package:flutter/material.dart';

import '../../common/constants.dart';
class AccordionPage extends StatelessWidget {
  final String title;
  final bool isOpen;
  final VoidCallback onTap;
  final Widget child;

  const AccordionPage({
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
      margin: const EdgeInsets.only(
        left: hPadding * 1.5,
        right: hPadding * 1.5,
        bottom: hPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: bodyTextStyle(context),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.expand_more, size: 16),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: child,
            crossFadeState:
            isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}