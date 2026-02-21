import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/klaimlacak/klaimprogresscari_list.dart';
import 'package:flutter/material.dart';

class KlaimProgressCariMainPage extends StatelessWidget {
  final String klaim1Id;
  const KlaimProgressCariMainPage({super.key, required this.klaim1Id});

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Lacak Klaim',
      child: KlaimprogresscariPage(klaim1Id: klaim1Id),
    );
  }
}
