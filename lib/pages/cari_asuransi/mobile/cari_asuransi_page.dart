import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/hakakses/hakaksescrud_bloc.dart';
import '../../../common/constants.dart';
import '../../base/base_background_sidepage.dart';
import '../../base/base_background_firstpage.dart';
import '../../calpar/mobile/calpar_main_page_remake.dart';
import '../../gen_calmv/mobile/calmv_main_page_remake.dart';
import '../../regother/mobile/regother_form/regother_form1.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CariAsuransiType { page, menu }

class CariAsuransiWidget extends StatelessWidget {
  final CariAsuransiType type;

  const CariAsuransiWidget({super.key, this.type = CariAsuransiType.page});

  const CariAsuransiWidget.page({super.key})
      : type = CariAsuransiType.page;

  const CariAsuransiWidget.menu({super.key})
      : type = CariAsuransiType.menu;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder< AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        final userType = authState is AuthenticationAuthenticated
            ? (authState.user.userType).toUpperCase()
            : '';

        return type == CariAsuransiType.page
            ? _buildAsPage(context, userType: userType)
            : _buildAsMenu(context, userType: userType);
      },
    );
  }

  Widget _buildAsPage(
      BuildContext context, {
        required String userType,
      }) {
    return BaseBackgroundSidePage(
      title: "Beli Polis",
      child: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: hPadding),
          child: _buildContent(
            context,
            userType: userType,
          ),
        ),
      ),
    );
  }

  Widget _buildAsMenu(
      BuildContext context, {
        required String userType,
      }) {
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
                  _buildContentAsMenu(
                    context,
                    userType: userType,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, {
        required String userType,
      }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderCard(
            iconPath: "assets/icons/menu_cari_asuransi.svg",
            title: "Beli Polis",
            subtitle: "Pilih jenis asuransi dan hitung premi langsung di sini.",
          ),
          SizedBox(height: hPadding),
          Container(
            color: secondaryBlackColor,
            child: _buildKategoriSection(
              context,
              userType: userType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentAsMenu(
      BuildContext context, {
        required String userType,
      }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderCard(
            iconPath: "assets/icons/menu_cari_asuransi.svg",
            title: "Cari Asuransi",
            subtitle: "Pilih jenis asuransi dan hitung premi langsung di sini.",
          ),
          SizedBox(height: hPadding),
          Container(
            color: secondaryBlackColor,
            child: _buildKategoriSection(
              context,
              userType: userType,
            ),
          ),
        ],
      ),
    );
  }

  Set<String> _parseExcludeCob(String? raw) {
    if (raw == null || raw.trim().isEmpty) return <String>{};
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  Future<void> showAccessDeniedDialog(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: SvgPicture.asset(
                      "assets/icons/bi_exclamation-circle.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Akses Ditolak",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Anda tidak memiliki akses untuk memilih kategori ini.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sGrey,
                        foregroundColor: primaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(cardBorderRadius),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Kembali",
                        style: TextStyle(
                          fontSize: getResponsiveFont(context, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildKategoriSection(
      BuildContext context, {
        required String userType,
      }) {
    final excludeCOB =
        context.read<HakaksesCrudBloc>().state.record?.excludeCOB ?? '';

    final cobSet = _parseExcludeCob(excludeCOB);

    final isPropertiExcluded = cobSet.contains('10002');
    final isKendaraanExcluded = cobSet.contains('10003');

    final isClient = userType.toUpperCase() == 'C';

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: hPadding),
          decoration: BoxDecoration(color: secondaryBlackColor),
          child: Column(
            children: [
              const SizedBox(height: hPadding),
              Text(
                "Kategori Asuransi",
                style: bodyTextStyle(context),
                textAlign: type == CariAsuransiType.page
                    ? TextAlign.center
                    : TextAlign.left,
              ),
              const SizedBox(height: vPadding),
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
                    child: _buildRestrictedCategory(
                      context: context,
                      userType: userType,
                      hasAccess: !isClient || !isKendaraanExcluded,
                      child: _buildCategory(
                        context,
                        "assets/icons/kendaraan.svg",
                        "Kendaraan",
                        const CalmvMainPageRemake(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRestrictedCategory(
                      context: context,
                      userType: userType,
                      hasAccess: !isClient || !isPropertiExcluded,
                      child: _buildCategory(
                        context,
                        "assets/icons/properti.svg",
                        "Properti",
                        const CalparMainPageRemake(),
                      ),
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

  Widget _buildRestrictedCategory({
    required BuildContext context,
    required String userType,
    required bool hasAccess,
    required Widget child,
  }) {
    final isClient = userType.toUpperCase() == 'C';

    if (!isClient) {
      return child;
    }

    if (hasAccess) {
      return child;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      onTap: () {
        showAccessDeniedDialog(context);
      },
      child: Stack(
        children: [
          Opacity(
            opacity: 0.45,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]),
              child: AbsorbPointer(
                absorbing: true,
                child: child,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(cardBorderRadius),
              ),
            ),
          ),
        ],
      ),
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