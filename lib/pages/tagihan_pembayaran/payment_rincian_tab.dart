import 'package:flutter/material.dart';

import 'mobile/rincian/rincian_page.dart';
// import '../payment/mobile/rincian/rincian_page.dart';

class PaymentRincianTab extends StatelessWidget {
  const PaymentRincianTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RincianPage(),
    );
  }
}

