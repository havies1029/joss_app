import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../common/constants.dart';
import '../../../widgets/section/polis/simul_polis/simul_mv/simul_mv_page.dart';
import '../../../widgets/section/polis/simul_polis/simul_par/simul_par_page.dart';
import '../../base/base_background_firstpage.dart';
import '../../gen_sppamv/sppamvlist_main.dart';
import '../../gen_sppapar/sppaparlist_list.dart';
import '../../polis/simul/simul_polis_mv.dart';
import '../../polis/simul/simul_polis_par.dart';

class BeliPolisPage extends StatelessWidget {
  const BeliPolisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseBackgroundSidePage(
        title: "Beli Polis",
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: hPadding),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderCard(
          iconPath: "assets/icons/menu_beli_polis.svg",
          title: "Beli Polis",
          subtitle:
          "Pilih jenis asuransi dan hitung premi langsung di sini.",
        ),
        const SizedBox(height: 10),
        _buildKategoriSection(context),
      ],
    );
  }

  Widget _buildKategoriSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: hPadding),
          color: secondaryBlackColor,
          child: Column(
            children: [
              Text(
                "Kategori Asuransi",
                style: bodyTextStyle(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              kDivider(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: hPadding,
            horizontal: hPadding * 1.5,
          ),
          color: primaryBlackColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryRow(context, [
                ("assets/icons/kendaraan.svg", "Kendaraan"),
                ("assets/icons/properti.svg", "Rumah & Property"),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
      BuildContext context,
      List<(String, String)> categories,
      ) {
    return Row(
      children: [
        Expanded(child: _buildCategory(context, categories[0].$1, categories[0].$2, const SimulMvPage())),
        const SizedBox(width: 12),
        Expanded(child: _buildCategory(context, categories[1].$1, categories[1].$2, const SimulPolisParPage())),
      ],
    );
  }

  Widget _buildCategory(BuildContext context, String svgPath, String label, Widget? targetPage) {
    return InkWell(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetPage),
          );
        }
      },
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, width: 40, height: 40),
            const SizedBox(width: 10),
            Flexible(child: Text(label, style: bodyTextStyle(context))),
          ],
        ),
      ),
    );
  }
}
