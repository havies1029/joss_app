import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class HScrollAlwaysThumb extends StatefulWidget {
  final Widget child;

  const HScrollAlwaysThumb({
    super.key,
    required this.child,
  });

  @override
  State<HScrollAlwaysThumb> createState() => HScrollAlwaysThumbState();
}

class HScrollAlwaysThumbState extends State<HScrollAlwaysThumb> {
  late final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(true),
        trackVisibility: WidgetStateProperty.all(false),
        thickness: WidgetStateProperty.all(5),
        radius: const Radius.circular(cardBorderRadius),
        thumbColor: WidgetStateProperty.all(
          scrollBar.withOpacity(0.1),
        ),
      ),
      child: Scrollbar(
        controller: _ctrl,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _ctrl,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}