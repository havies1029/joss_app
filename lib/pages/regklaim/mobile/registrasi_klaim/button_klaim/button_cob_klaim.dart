import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../../blocs/hakakses/hakaksescrud_bloc.dart';
import '../../../../../blocs/regklaim/cobklaimcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../models/regklaim/cobklaimcari_model.dart';
import '../cob_klaim_page/registrasi_klaim.dart';

class ButtonCobKlaimWidget extends StatefulWidget {
  const ButtonCobKlaimWidget({super.key});

  @override
  State<ButtonCobKlaimWidget> createState() => _ButtonCobKlaimWidgetState();
}

class _ButtonCobKlaimWidgetState extends State<ButtonCobKlaimWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CobklaimcariBloc>().add(RefreshCobklaimcariEvent());
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

  String _iconPath(String id) {
    switch (id) {
      case "10001":
        return "assets/icons/properti.svg";
      case "10002":
        return "assets/icons/kendaraan.svg";
      case "10003":
        return "assets/icons/lainnya.svg";
      default:
        return "assets/icons/lainnya.svg";
    }
  }

  void _navigateByCob(BuildContext context, String cobId, String cobNama) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrasiKlaim(
          cobKlaimId: cobId,
          cobKlaimNama: cobNama,
        ),
      ),
    );
  }

  Widget _buildRestrictedTile({
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CobklaimcariBloc, CobklaimcariState>(
      builder: (context, state) {
        final authState = context.watch<AuthenticationBloc>().state;
        final userType = authState is AuthenticationAuthenticated
            ? (authState.user.userType).toUpperCase()
            : '';

        final excludeCOB =
            context.read<HakaksesCrudBloc>().state.record?.excludeCOB ?? '';
        final cobSet = _parseExcludeCob(excludeCOB);

        if (state.status == ListStatus.initial) {
          return const SizedBox(
            height: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LoadingIndicator(),
            ),
          );
        }

        if (state.status == ListStatus.failure) {
          return const Text(
            "Gagal memuat data",
            style: TextStyle(color: Colors.red),
          );
        }

        if (state.status == ListStatus.success) {
          final items = state.items;

          if (items.isEmpty) return const SizedBox.shrink();

          return Column(
            children: items.map((item) {
              final isSelected =
                  state.selectedItem?.mcobklaim1Id == item.mcobklaim1Id;

              // final hasAccess =
              //     userType != 'C' || !cobSet.contains(item.mcobklaim1Id);

              final hasAccess = true;

              return Padding(
                padding: const EdgeInsets.only(bottom: hPadding),
                child: _buildRestrictedTile(
                  context: context,
                  userType: userType,
                  hasAccess: hasAccess,
                  child: _CobKlaimTile(
                    item: item,
                    iconPath: _iconPath(item.mcobklaim1Id),
                    isSelected: isSelected,
                    onTap: () {
                      context.read<CobklaimcariBloc>().add(
                        CobklaimcariItemSelectedEvent(selectedItem: item),
                      );

                      _navigateByCob(
                        context,
                        item.mcobklaim1Id,
                        item.cobNama,
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CobKlaimTile extends StatelessWidget {
  final CobklaimcariModel item;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _CobKlaimTile({
    required this.item,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(
              color: sGrey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.cobNama,
                  style: TextStyle(
                    color: primaryLightColor,
                    fontSize: getResponsiveFont(context, 18),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: primaryLightColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}