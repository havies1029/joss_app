import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/hakakses/hakaksescrud_bloc.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import '../../base/base_background_sidepage.dart';
import '../../calpar/mobile/calpar_main_page_remake.dart';
import '../../calmv/mobile/calmv_main_page_remake.dart';
import '../../regother/mobile/regother_form/regother_form1.dart';

enum CariAsuransiType { page, menu }

class CariAsuransiWidget extends StatelessWidget {
  final CariAsuransiType type;

  const CariAsuransiWidget({
    super.key,
    this.type = CariAsuransiType.page,
  });

  const CariAsuransiWidget.page({super.key})
      : type = CariAsuransiType.page;

  const CariAsuransiWidget.menu({super.key})
      : type = CariAsuransiType.menu;

  static const String cobProperti = '10002';
  static const String cobKendaraan = '10003';
  static const String cobLainnya = '10004';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        final userType = authState is AuthenticationAuthenticated
            ? authState.user.userType.toUpperCase()
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
      child: Column(
        children: [
          const SizedBox(height: hPadding),
          Expanded(
            child: _buildContent(
              context,
              userType: userType,
              title: "Beli Polis",
              subtitle: "Pilih jenis asuransi dan hitung premi langsung di sini.",
            ),
          ),
          const SizedBox(height: hPadding),
        ],
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
            decoration: const BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: hPadding),
                Expanded(
                  child: _buildContent(
                    context,
                    userType: userType,
                    title: "Cari Asuransi",
                    subtitle: "Pilih jenis asuransi dan hitung premi langsung di sini.",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, {
        required String userType,
        required String title,
        required String subtitle,
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
            title: title,
            subtitle: subtitle,
          ),
          const SizedBox(height: hPadding),
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

  bool _isClient(String userType) {
    return userType.toUpperCase() == 'C';
  }

  bool _hasCobAccess({
    required String userType,
    required Set<String> excludedCobSet,
    required String cobId,
  }) {
    if (!_isClient(userType)) return true;
    return !excludedCobSet.contains(cobId);
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
        context.watch<HakaksesCrudBloc>().state.record?.excludeCOB ?? '';
    final excludedCobSet = _parseExcludeCob(excludeCOB);

    final kendaraanHasAccess = _hasCobAccess(
      userType: userType,
      excludedCobSet: excludedCobSet,
      cobId: cobKendaraan,
    );

    final propertiHasAccess = _hasCobAccess(
      userType: userType,
      excludedCobSet: excludedCobSet,
      cobId: cobProperti,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: hPadding),
          decoration: const BoxDecoration(
            color: secondaryBlackColor,
          ),
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
          padding: const EdgeInsets.symmetric(
            vertical: hPadding,
            horizontal: hPadding * 1.5,
          ),
          decoration: const BoxDecoration(
            color: secondaryBlackColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildRestrictedCategory(
                      context: context,
                      userType: userType,
                      hasAccess: kendaraanHasAccess,
                      child: _buildCategory(
                        context,
                        svgPath: "assets/icons/kendaraan.svg",
                        label: "Kendaraan",
                        targetPage: const CalmvMainPageRemake(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRestrictedCategory(
                      context: context,
                      userType: userType,
                      hasAccess: propertiHasAccess,
                      child: _buildCategory(
                        context,
                        svgPath: "assets/icons/properti.svg",
                        label: "Properti",
                        targetPage: const CalparMainPageRemake(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCategory(
                context,
                svgPath: null,
                label: "Lainnya",
                targetPage: const Regother1CrudFormPage(
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
    if (!_isClient(userType) || hasAccess) {
      return child;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      onTap: () => showAccessDeniedDialog(context),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.45,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 1, 0,
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
      BuildContext context, {
        required String? svgPath,
        required String label,
        required Widget? targetPage,
      }) {
    final hasIcon = svgPath != null && svgPath.trim().isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      onTap: targetPage == null
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
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
            SvgPicture.asset(
              svgPath,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: bodyTextStyle(context),
              ),
            ),
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