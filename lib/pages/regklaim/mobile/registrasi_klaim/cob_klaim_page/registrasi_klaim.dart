import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/combobox/combomjenisrugimv_model.dart';
import '../../../../../models/regklaim/sppapoliscari_model.dart';
import '../../../../../widgets/apptheme/header_card_polis.dart';
import '../../../../base/base_background_sidepage.dart';
import '../base_polis_page.dart';
import '../registrasi_form/polis_detail/user_polis_detail.dart';

class RegistrasiKlaim extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

  const RegistrasiKlaim({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
  });

  @override
  State<RegistrasiKlaim> createState() => _RegistrasiKlaimState();
}

class _RegistrasiKlaimState extends State<RegistrasiKlaim> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SppapoliscariModel? _selectedPolis;
  ComboMJenisrugimvModel? _selectedJenisKerugian;
  String _keterangan = '';
  bool _isCariPolisLoading = false;

  String get _iconPath {
    final name = widget.cobKlaimNama.trim().toLowerCase();
    return "assets/icons/$name.svg";
  }

  Color get _buttonColor {
    switch (widget.cobKlaimId) {
      case "10001":
        return pGreen;
      case "10002":
        return pBlue;
      default:
        return primaryColor;
    }
  }

  String get _headerTitle => "Klaim ${widget.cobKlaimNama}";

  String _resolvePolisSourceId(PolissourcecariState state) {
    final sourceIds = state.items
        .map((e) => e.polissourceId)
        .where((id) => id == "10" || id == "20")
        .toSet();

    if (sourceIds.length == 1) {
      return sourceIds.first;
    }

    if (sourceIds.contains(state.selectedPolissourceId)) {
      return state.selectedPolissourceId;
    }

    if (sourceIds.contains("10")) {
      return "10";
    }

    if (sourceIds.contains("20")) {
      return "20";
    }

    return "";
  }

  String _resolveUserType(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is! AuthenticationAuthenticated) {
      return "";
    }
    return authState.user.userType.trim().toUpperCase();
  }

  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  Widget _validationDialog({
    required String title,
    required String message,
  }) {
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
              Icon(
                Icons.error_outline,
                color: primaryLightColor,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryLightColor,
                  fontSize: getResponsiveFont(context, 18),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryLightColor.withOpacity(0.7),
                  fontSize: getResponsiveFont(context, 16),
                  height: 1.2,
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
                      borderRadius: BorderRadius.circular(cardBorderRadius),
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
  }

  @override
  void initState() {
    super.initState();
    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();
    mRekanGeneralCmpCrudBloc = context.read<MRekanGeneralCmpCrudBloc>();

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mjenisClient == "10") {
        mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
      } else if (mjenisClient == "20") {
        mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());
      }
    });
  }

  Future<void> showPolisRequiredDialog(BuildContext context) {
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
                    child: Icon(
                      Icons.error_outline,
                      color: primaryLightColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Data Belum Lengkap",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Silakan pilih nomor polis terlebih dahulu sebelum melanjutkan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1.2,
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
                          borderRadius: BorderRadius.circular(cardBorderRadius),
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

  Future<void> _handleCariPressed() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (_selectedPolis == null) {
      await showPolisRequiredDialog(context);
      return;
    }

    if (widget.cobKlaimId == '10002') {
      if (_selectedJenisKerugian == null) {
        await showGeneralDialog<void>(
          context: context,
          barrierDismissible: true,
          barrierLabel: "Tutup",
          barrierColor: Colors.black.withOpacity(0.45),
          transitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (context, animation, secondaryAnimation) {
            return _validationDialog(
              title: "Data Belum Lengkap",
              message: "Silakan pilih penyebab kerugian terlebih dahulu.",
            );
          },
        );
        return;
      }

      if (_keterangan.trim().isEmpty) {
        await showGeneralDialog<void>(
          context: context,
          barrierDismissible: true,
          barrierLabel: "Tutup",
          barrierColor: Colors.black.withOpacity(0.45),
          transitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (context, animation, secondaryAnimation) {
            return _validationDialog(
              title: "Data Belum Lengkap",
              message: "Silakan isi no plat terlebih dahulu.",
            );
          },
        );
        return;
      }
    }

    if (!isValid) return;

    setState(() {
      _isCariPolisLoading = true;
    });

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPolisDetail(
            cobKlaimId: widget.cobKlaimId,
            cobKlaimNama: widget.cobKlaimNama,
            sppa1Id: _selectedPolis!.sppaId,
            mjenisrugimvId: _selectedJenisKerugian?.mjenisrugimvId ?? '',
            keterangan: _keterangan.trim(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCariPolisLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userType = _resolveUserType(context);

    return SafeArea(
      child: BaseBackgroundSidePage(
        title: widget.cobKlaimNama,
        child: Scaffold(
          backgroundColor: secondaryBlackColor,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: vPadding),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: vPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormSectionHeader(
                      iconPath: _iconPath,
                      title: _headerTitle,
                      subtitle:
                          "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                    ),
                    const SizedBox(height: vPadding),
                    BasePolisPage(
                      cobKlaimId: widget.cobKlaimId,
                      cobKlaimNama: widget.cobKlaimNama,
                      userType: userType,
                      selectedPolis: _selectedPolis,
                      onPolisChanged: (value) {
                        setState(() {
                          _selectedPolis = value;
                        });
                      },
                      selectedJenisKerugian: _selectedJenisKerugian,
                      onJenisKerugianChanged: (value) {
                        setState(() {
                          _selectedJenisKerugian = value;
                        });
                      },
                      keterangan: _keterangan,
                      onKeteranganChanged: (value) {
                        setState(() {
                          _keterangan = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar:
              BlocBuilder<PolissourcecariBloc, PolissourcecariState>(
            builder: (context, state) {
              if (userType.isEmpty) {
                return const SizedBox.shrink();
              }

              if (state.status != ListStatus.success) {
                return const SizedBox.shrink();
              }

              if (_resolvePolisSourceId(state) != "10") {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                ),
                child: SafeArea(
                  child: AppButton.iconLeft(
                    text: "Cari",
                    icon: SvgPicture.asset(
                      "assets/icons/zoom1.svg",
                      width: 18,
                      height: 18,
                    ),
                    isLoading: _isCariPolisLoading,
                    backgroundColor: _buttonColor,
                    onPressed: _isCariPolisLoading
                        ? null
                        : () async {
                            await _handleCariPressed();
                          },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
