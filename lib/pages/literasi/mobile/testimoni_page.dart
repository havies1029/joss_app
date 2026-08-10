import 'package:flutter/material.dart';
import '../widgets/testimoni_widget1.dart';

class TestimoniPage1 extends StatelessWidget {
  const TestimoniPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const TestimonialWidget(isPageMode: false);
  }
}

class TestimoniPage2 extends StatelessWidget {
  const TestimoniPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const TestimonialWidget(isPageMode: true);
  }
}
