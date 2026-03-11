import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/ringkasan/klaim_ringkasan_main_page.dart';

class KlaimRingkasanTab extends StatelessWidget {
  const KlaimRingkasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: secondaryBlackColor,
      body: KlaimRingkasanMainPage(),
    );
  }
}