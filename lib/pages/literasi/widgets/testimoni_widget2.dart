import 'package:flutter/material.dart';

import 'testimoni_widget1.dart';

class TestimonialWidget2 extends StatelessWidget {
  final bool isPageMode;

  const TestimonialWidget2({
    super.key,
    this.isPageMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return TestimonialWidget(isPageMode: isPageMode);
  }
}
