import 'package:flutter/material.dart';

import 'mobile/riwayat/riwayat_page_remake.dart';
// import '../payment/mobile/riwayat/riwayat_page_remake.dart';

class PaymentRiwayatTab extends StatelessWidget {
  const PaymentRiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RiwayatPageRemake(),
    );
  }
}