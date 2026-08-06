import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/common/constants.dart';

class Klaimparaccordioncard extends StatelessWidget {
  final String title;
  final bool isOpen;
  final bool isLoading;
  final VoidCallback onTap;
  final Widget child;

  const Klaimparaccordioncard({
    super.key,
    required this.title,
    required this.isOpen,
    this.isLoading = false,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      clipBehavior: Clip.antiAlias,
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
          ClipRect(
            child: AnimatedAlign(
              alignment: Alignment.topCenter,
              heightFactor: isOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Stack(
                  children: [
                    child,
                    if (isLoading)
                      Positioned.fill(
                        child: Container(
                          color: pGrey,
                          alignment: Alignment.topCenter,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: LoadingIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
