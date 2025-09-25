import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../common/constants.dart';
import '../../base/base_background_sidepage.dart';
import '../../base/base_background_firstpage.dart';

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: hPadding),
        child: _buildContent(context),
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
    return Column(
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
          child: Column(
            children: [
              _buildKategoriSection(context),
            ],
          ),
        ),
      ],
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
              _buildCategoryRow(context, [
                ("assets/icons/kendaraan.svg", "Kendaraan"),
                ("assets/icons/properti.svg", "Rumah & Property"),
              ]),
              const SizedBox(height: 12),
              _buildCategoryRow(context, [
                ("assets/icons/kesehatan.svg", "Kesehatan"),
                ("assets/icons/perjalanan.svg", "Perjalanan"),
              ]),
              const SizedBox(height: 12),
              _buildCategoryRow(context, [
                ("assets/icons/pendidikan.svg", "Pendidikan"),
                ("assets/icons/jiwa.svg", "Jiwa"),
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
        Expanded(
          child: _buildCategory(context, categories[0].$1, categories[0].$2),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCategory(context, categories[1].$1, categories[1].$2),
        ),
      ],
    );
  }

  Widget _buildCategory(BuildContext context, String svgPath, String label) {
    return Container(
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
    );
  }
}

class CariAsuransiPage extends CariAsuransiWidget {
  const CariAsuransiPage({super.key}) : super(type: CariAsuransiType.page);
}

class CariAsuransiMenu extends CariAsuransiWidget {
  const CariAsuransiMenu({super.key}) : super(type: CariAsuransiType.menu);
}
