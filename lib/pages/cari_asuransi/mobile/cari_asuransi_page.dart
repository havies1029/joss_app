import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../common/constants.dart';
import '../../../widgets/section/polis/simul_polis/simul_mv/simul_mv_page.dart';
import '../../../widgets/section/polis/simul_polis/simul_par/simul_par_page.dart';
import '../../base/base_background_sidepage.dart';
import '../../base/base_background_firstpage.dart';
import '../../calpar/mobile/calpar_main_page.dart';
import '../../calpar/mobile/calpar_main_page_remake.dart';
import '../../gen_calmv/mobile/calmv_main_page.dart';
import '../../gen_calmv/mobile/calmv_main_page_remake.dart';
import '../../regother/mobile/regother_form/regother_form1.dart';

enum CariAsuransiType { page, menu }

class CariAsuransiWidget extends StatelessWidget {
  final CariAsuransiType type;

  const CariAsuransiWidget({super.key, this.type = CariAsuransiType.page});

  const CariAsuransiWidget.page({Key? key})
    : type = CariAsuransiType.page,
      super(key: key);

  const CariAsuransiWidget.menu({Key? key})
    : type = CariAsuransiType.menu,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == CariAsuransiType.page
        ? _buildAsPage(context)
        : _buildAsMenu(context);
  }

  // Build sebagai Page (BaseBackgroundSidePage)
  Widget _buildAsPage(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Cari Asuransi",
      child: Container(
        color: secondaryBlackColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: hPadding),
          child: _buildContent(context),
        ),
      ),
    );
  }

  // Build sebagai Menu (Scaffold + BaseBackgroundFirstPage)
  Widget _buildAsMenu(BuildContext context) {
    return Scaffold(
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [SizedBox(height: hPadding), _buildContent(context)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderCard(
            iconPath: "assets/icons/menu_cari_asuransi.svg",
            title: "Cari Asuransi",
            subtitle:
            "Pilih kategori asuransi untuk keamanan Anda dan keluarga, Yuk!",
          ),
          Container(
            color: primaryBlackColor,
            child: _buildKategoriSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: hPadding),
          decoration: BoxDecoration(color: secondaryBlackColor),
          child: Column(
            children: [
              Text(
                "Kategori Asuransi",
                style: bodyTextStyle(context),
                textAlign:
                type == CariAsuransiType.page
                    ? TextAlign.center
                    : TextAlign.left,
              ),
              const SizedBox(height: 10),
              kDivider(),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(
            vertical: hPadding,
            horizontal: hPadding * 1.5,
          ),
          decoration: BoxDecoration(color: secondaryBlackColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Properti",
                      const CalparMainPageRemake(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

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

class CariAsuransiPage extends CariAsuransiWidget {
  const CariAsuransiPage({super.key}) : super(type: CariAsuransiType.page);
}

class CariAsuransiMenu extends CariAsuransiWidget {
  const CariAsuransiMenu({super.key}) : super(type: CariAsuransiType.menu);
}
