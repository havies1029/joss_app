import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/payment/historybayarcari_bloc.dart';
import 'mobile/riwayat/riwayat_page_remake.dart';
import '../../../common/constants.dart';

class PaymentRiwayatTab extends StatelessWidget {
  const PaymentRiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: secondaryBlackColor,
      body: RiwayatPageRemake(),
    );
  }
}