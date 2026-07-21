import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/hakakses/hakaksescrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/navigation_keys.dart';

class CobAccessGuard {
  static const String cobProperti = '10002';
  static const String cobKendaraan = '10003';

  static bool _isAccessDeniedDialogOpen = false;

  static BlocListener<HakaksesCrudBloc, HakaksesCrudState>
      buildHakaksesListener({
    required String cobId,
    required bool Function() isDialogShown,
    required VoidCallback markDialogShown,
    FutureOr<void> Function()? onAccessDeniedReturn,
  }) {
    return BlocListener<HakaksesCrudBloc, HakaksesCrudState>(
      listenWhen: (previous, current) {
        if (!current.isLoaded || current.record == null) return false;

        return previous.isLoaded != current.isLoaded ||
            previous.record?.excludeCOB != current.record?.excludeCOB;
      },
      listener: (context, state) {
        if (_isAccessDeniedDialogOpen || isDialogShown()) return;

        final authState = context.read<AuthenticationBloc>().state;
        final userType = authState is AuthenticationAuthenticated
            ? authState.user.userType
            : '';

        if (!isCobAccessDenied(
          userType: userType,
          excludeCOB: state.record?.excludeCOB,
          cobId: cobId,
        )) {
          return;
        }

        markDialogShown();
        _isAccessDeniedDialogOpen = true;
        unawaited(
          showAccessDeniedDialog(
            context,
            onReturn: onAccessDeniedReturn,
          ).whenComplete(() {
            _isAccessDeniedDialogOpen = false;
          }),
        );
      },
    );
  }

  static bool isCobAccessDenied({
    required String userType,
    required String? excludeCOB,
    required String cobId,
  }) {
    if (userType.toUpperCase() != 'C') return false;
    return _parseExcludeCob(excludeCOB).contains(cobId);
  }

  static Set<String> _parseExcludeCob(String? raw) {
    if (raw == null || raw.trim().isEmpty) return <String>{};

    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  static Future<void> showAccessDeniedDialog(
    BuildContext context, {
    FutureOr<void> Function()? onReturn,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
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
                      'assets/icons/bi_exclamation-circle.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Akses Ditolak',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anda tidak memiliki akses untuk memilih kategori ini.',
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
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                        if (onReturn != null) {
                          await onReturn();
                          return;
                        }
                        returnToHome(context);
                      },
                      child: Text(
                        'Kembali',
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

  static void returnToHome(BuildContext context) {
    final homeState = homeTabKey.currentState;

    if (homeState != null) {
      homeState.goToHeroPage();
    }

    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
  }
}
