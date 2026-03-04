import 'package:flutter/material.dart';

class HScrollAlwaysThumb extends StatefulWidget {
  final Widget child;
  const HScrollAlwaysThumb({super.key, required this.child});

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
    return Scrollbar(
      controller: _ctrl,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        child: widget.child,
      ),
    );
  }
}