import 'package:flutter/material.dart';

import 'hitung_premi_widget.dart';
class HitungPremiVerticalDemo extends StatefulWidget {
  const HitungPremiVerticalDemo({super.key});

  @override
  State<HitungPremiVerticalDemo> createState() => _HitungPremiVerticalDemoState();
}

class _HitungPremiVerticalDemoState extends State<HitungPremiVerticalDemo> {
  final premiCascoController = TextEditingController(text: "IDR 3,166,500");
  final premiAddController = TextEditingController(text: "IDR 475,000");
  final premiDiskonController = TextEditingController(text: "IDR 910,375");
  final premiNetController = TextEditingController(text: "IDR 2,783,125");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vertical Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HitungPremiWidget(
          rows: [
            HitungPremiRow(
              label: "Annual Premium",
              description: "Premi tahunan sebelum diskon",
              controller: premiAddController,
              layoutType: HitungPremiLayoutType.vertical,
              showValueBorder: true,
            ),
            HitungPremiRow(
              label: "Total Premium",
              description: "Premi yang harus dibayarkan",
              controller: premiCascoController,
              layoutType: HitungPremiLayoutType.vertical,
              highlight: true,
              showValueBorder: true,
            ),
            HitungPremiRow(
              label: "Discount 25%",
              controller: premiDiskonController,
              layoutType: HitungPremiLayoutType.vertical,
            ),
            HitungPremiRow(
              label: "Total Premium",
              controller: premiNetController,
              layoutType: HitungPremiLayoutType.vertical,
              highlight: true,
            ),
            HitungPremiRow(
              label: "Annual Premium",
              controller: premiCascoController,
              layoutType: HitungPremiLayoutType.vertical,
            ),
            HitungPremiRow(
              label: "Total Premium",
              controller: premiNetController,
              layoutType: HitungPremiLayoutType.vertical,
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}
