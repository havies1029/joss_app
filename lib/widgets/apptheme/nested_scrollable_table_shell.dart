import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';

class NestedScrollableTableShell extends StatefulWidget {
  final Widget child;
  final double height;
  final BorderRadius borderRadius;

  const NestedScrollableTableShell({super.key,
    required this.child,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<NestedScrollableTableShell> createState() =>
      NestedScrollableTableShellState();
}

class NestedScrollableTableShellState
    extends State<NestedScrollableTableShell> {
  final ScrollController verticalController = ScrollController();

  @override
  void dispose() {
    verticalController.dispose();
    super.dispose();
  }

  void _scrollParent(BuildContext context, double delta) {
    final parent = Scrollable.maybeOf(context);
    if (parent == null) return;

    final position = parent.position;
    if (!position.hasPixels) return;

    final next = (position.pixels + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    position.animateTo(
      next,
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeOut,
    );
  }

  void _handleWheelScroll(BuildContext parentContext, PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (!verticalController.hasClients) return;

    final delta = event.scrollDelta.dy;
    final position = verticalController.position;

    final isAtTop = position.pixels <= position.minScrollExtent;
    final isAtBottom = position.pixels >= position.maxScrollExtent;

    final shouldPassToParent =
        (isAtTop && delta < 0) || (isAtBottom && delta > 0);

    if (shouldPassToParent) {
      _scrollParent(parentContext, delta);
    }
  }

  bool _handleOverscroll(
      BuildContext parentContext,
      OverscrollNotification notification,
      ) {
    if (notification.overscroll == 0) return false;
    _scrollParent(parentContext, notification.overscroll);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;

    return SizedBox(
      height: widget.height,
      child: NotificationListener<OverscrollNotification>(
        onNotification: (notification) {
          return _handleOverscroll(parentContext, notification);
        },
        child: Listener(
          onPointerSignal: (event) {
            _handleWheelScroll(parentContext, event);
          },
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbVisibility: WidgetStateProperty.all(true),
              trackVisibility: WidgetStateProperty.all(false),
              thickness: WidgetStateProperty.all(5),
              radius: Radius.circular(cardBorderRadius),
              thumbColor: WidgetStateProperty.all(
                scrollBar.withOpacity(0.35),
              ),
            ),
            child: Scrollbar(
              controller: verticalController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: verticalController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}