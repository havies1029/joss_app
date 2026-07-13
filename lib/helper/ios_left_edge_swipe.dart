import 'dart:io';

import 'package:flutter/material.dart';

class IosLeftEdgeSwipe extends StatefulWidget {
  const IosLeftEdgeSwipe({
    super.key,
    required this.child,
    required this.onSwipeBack,
    this.enabled = true,
    this.edgeWidth = 30,
    this.minimumSwipeDistance = 70,
    this.maximumVerticalDistance = 60,
    this.blockNativeBack = true,
  });

  final Widget child;

  final Future<void> Function() onSwipeBack;
  final bool enabled;
  final double edgeWidth;
  final double minimumSwipeDistance;
  final double maximumVerticalDistance;
  final bool blockNativeBack;

  @override
  State<IosLeftEdgeSwipe> createState() => _IosLeftEdgeSwipeState();
}

class _IosLeftEdgeSwipeState extends State<IosLeftEdgeSwipe> {
  Offset? _startPosition;
  bool _isExecuting = false;

  bool get _isEnabled {
    return Platform.isIOS && widget.enabled;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!_isEnabled || _isExecuting) return;

    if (event.position.dx <= widget.edgeWidth) {
      _startPosition = event.position;
    } else {
      _startPosition = null;
    }
  }

  Future<void> _handlePointerUp(PointerUpEvent event) async {
    final startPosition = _startPosition;
    _startPosition = null;

    if (!_isEnabled || startPosition == null || _isExecuting) {
      return;
    }

    final horizontalDistance = event.position.dx - startPosition.dx;
    final verticalDistance = (event.position.dy - startPosition.dy).abs();

    final isValidSwipe = horizontalDistance >= widget.minimumSwipeDistance &&
        verticalDistance <= widget.maximumVerticalDistance &&
        horizontalDistance > verticalDistance;

    if (!isValidSwipe) return;

    _isExecuting = true;

    try {
      await widget.onSwipeBack();
    } finally {
      _isExecuting = false;
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _startPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    final content = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: widget.child,
    );

    if (!Platform.isIOS || !widget.blockNativeBack) {
      return content;
    }

    return PopScope<Object?>(
      canPop: false,
      child: content,
    );
  }
}
