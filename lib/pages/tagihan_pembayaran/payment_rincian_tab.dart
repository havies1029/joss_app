import 'package:flutter/material.dart';
import '../../../common/constants.dart';
import 'mobile/rincian/rincian_page.dart';

class PaymentRincianTab extends StatelessWidget {
  const PaymentRincianTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: secondaryBlackColor,
      body: RincianPage(),
    );
  }
}