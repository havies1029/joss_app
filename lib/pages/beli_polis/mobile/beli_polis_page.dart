import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../common/constants.dart';
import '../../calpar/mobile/calpar_main_page_remake.dart';
import '../../calmv/mobile/calmv_main_page_remake.dart';
import '../../regother/mobile/regother_form/regother_form1.dart';

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
        const HeaderCard(
          iconPath: "assets/icons/menu_beli_polis.svg",
          title: "Beli Polis",
          subtitle: "Pilih jenis asuransi dan hitung premi langsung di sini.",
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
              Text("Kategori Asuransi", style: bodyTextStyle(context), textAlign: TextAlign.center),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCategory(
                      context,
                      "assets/icons/kendaraan.svg",
                      "Kendaraan",
                      const CalmvMainPageRemake(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCategory(
                      context,
                      "assets/icons/properti.svg",
                      "Rumah & Property",
                      const CalparMainPageRemake(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ✅ full width di bawah row
              _buildCategory(
                context,
                "null",
                "Lainnya",
                const Regother1CrudFormPage(
                  viewMode: 'tambah',
                  recordId: '',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildCategory(
      BuildContext context,
      String svgPath,
      String label,
      Widget? targetPage,
      ) {
    final bool hasIcon = svgPath != "null" && svgPath.trim().isNotEmpty;

    return InkWell(
      onTap: targetPage == null
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
        ),

        child: hasIcon
            ? Row(
          children: [
            SvgPicture.asset(svgPath, width: 40, height: 40),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: bodyTextStyle(context))),
          ],
        )
            : Center(
          child: Text(
            label,
            style: bodyTextStyle(context),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
