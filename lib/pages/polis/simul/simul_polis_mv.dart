import 'package:flutter/material.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import '../../../widgets/section/polis/simul_polis/simul_mv/simul_mv_page.dart';

class SimulPolisMvMain extends StatelessWidget {
  const SimulPolisMvMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(title: "Kendaraan", child: SimulMvPage());
  }
}