import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import '../../base/base_background_sidepage.dart';

class CariAsuransiMenu extends StatelessWidget {
  const CariAsuransiMenu({super.key});
  @override
  Widget build(BuildContext context) {
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
                children: [
                  SizedBox(height: hPadding),
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
                        Container(
                          padding: EdgeInsets.symmetric(vertical: hPadding),
                          decoration: BoxDecoration(color: secondaryBlackColor),
                          child: Column(
                            children: [
                              Text(
                                "Kategori Asuransi",
                                style: bodyTextStyle(context),
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
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCategory(
                                      context,
                                      "assets/icons/properti.svg",
                                      "Rumah & Property",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCategory(
                                      context,
                                      "assets/icons/kesehatan.svg",
                                      "Kesehatan",
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCategory(
                                      context,
                                      "assets/icons/perjalanan.svg",
                                      "Perjalanan",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCategory(
                                      context,
                                      "assets/icons/pendidikan.svg",
                                      "Pendidikan",
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCategory(
                                      context,
                                      "assets/icons/jiwa.svg",
                                      "Jiwa",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(hPadding * 1.5),
                          decoration: BoxDecoration(color: secondaryBlackColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kenapa pilih asuransi di JPS?",
                                style: bodyTextStyle(context),
                              ),
                              const SizedBox(height: 10),

                              _buildReason(
                                context,
                                "assets/icons/lightning.svg",
                                "Klaim Anti Ribet",
                                "Urus klaim cepat, gampang, dan selalu transparan.",
                              ),
                              _buildReason(
                                context,
                                "assets/icons/hospital.svg",
                                "Mitra di Mana-Mana",
                                "JPS selalu dekat denganmu.",
                              ),
                              _buildReason(
                                context,
                                "assets/icons/secured.svg",
                                "Terjamin Aman",
                                "JPS sudah resmi berizin OJK, jadi nggak perlu ragu.",
                              ),
                              _buildReason(
                                context,
                                "assets/icons/fulltime.svg",
                                "Layanan 24/7",
                                "Tenang, tim kami standby kapan pun kamu butuh.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  Widget _buildReason(
    BuildContext context,
    String icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(hPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, width: 34, height: 34),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: bodyTextStyle(context)),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
