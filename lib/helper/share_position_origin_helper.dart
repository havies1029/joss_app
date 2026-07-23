import 'package:flutter/material.dart';

Rect sharePositionOrigin(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject is RenderBox &&
      renderObject.hasSize &&
      renderObject.size.width > 0 &&
      renderObject.size.height > 0) {
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  final mediaSize = MediaQuery.maybeOf(context)?.size;
  if (mediaSize != null && mediaSize.width > 0 && mediaSize.height > 0) {
    return Rect.fromLTWH(
      mediaSize.width / 2,
      mediaSize.height / 2,
      1,
      1,
    );
  }

  return const Rect.fromLTWH(1, 1, 1, 1);
}
