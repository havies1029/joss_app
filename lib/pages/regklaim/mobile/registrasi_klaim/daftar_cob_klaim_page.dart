import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../widgets/apptheme/header_card.dart';
import '../../../base/base_background_sidepage.dart';
import '../../../base/base_background_firstpage.dart';
import 'button_klaim/button_cob_klaim.dart';

enum DaftarCobKlaimType { page, menu }

class DaftarCobKlaimWidget extends StatefulWidget {
  final DaftarCobKlaimType type;

  const DaftarCobKlaimWidget({
    super.key,
    this.type = DaftarCobKlaimType.page,
  });

  const DaftarCobKlaimWidget.page({super.key})
      : type = DaftarCobKlaimType.page;

  const DaftarCobKlaimWidget.menu({super.key})
      : type = DaftarCobKlaimType.menu;

  @override
  State<DaftarCobKlaimWidget> createState() => _DaftarCobKlaimWidgetState();
}

class _DaftarCobKlaimWidgetState extends State<DaftarCobKlaimWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return widget.type == DaftarCobKlaimType.page
        ? _buildAsPage(context)
        : _buildAsMenu(context);
  }

  Widget _buildAsPage(BuildContext context) {
    return SafeArea(
      child: BaseBackgroundSidePage(
        title: 'Klaim Baru',
        child: Scaffold(
          backgroundColor: secondaryBlackColor,
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildAsMenu(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: size.height,
            ),
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (widget.type == DaftarCobKlaimType.page) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
        child: Column(
          children: [
            const SizedBox(height: vPadding),
            Text(
              "Ajukan Klaim",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryLightColor,
                fontSize: getResponsiveFont(context, 20),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: hPadding),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: hPadding),
        HeaderCard(
          iconPath: "assets/icons/menu_lapor_klaim.svg",
          title: "Klaim",
          subtitle: "Masukkan klaim Anda sesuai dengan kategori asuransi yang tersedia.",
        ),
      ],
    );
  }


  Widget _buildContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: vPadding),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding * 1.5,
                vertical: hPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(
                    "Pilih Jenis Klaim yang ingin kamu ajukan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: greyKlaim,
                      fontSize: getResponsiveFont(context, 16),
                    ),
                  ),

                  const SizedBox(height: vPadding),

                  const ButtonCobKlaimWidget(),

                  // next widgets here
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}

class DaftarCobKlaimPage extends DaftarCobKlaimWidget {
  const DaftarCobKlaimPage({super.key}) : super(type: DaftarCobKlaimType.page);
}

class DaftarCobKlaimMenu extends DaftarCobKlaimWidget {
  const DaftarCobKlaimMenu({super.key}) : super(type: DaftarCobKlaimType.menu);
}
