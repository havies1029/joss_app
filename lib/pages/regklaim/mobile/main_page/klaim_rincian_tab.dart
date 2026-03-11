import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/rincian/klaim_rincian_main_page.dart';

class KlaimRincianTab extends StatelessWidget {
  const KlaimRincianTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: secondaryBlackColor,
      body: KlaimRincianMainPage(),
    );
  }
}