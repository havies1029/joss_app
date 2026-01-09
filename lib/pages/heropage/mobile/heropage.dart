import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/pages/heropage/mobile/widget/detail_premi.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../blocs/user_profile/user_profile_state.dart';
import '../../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../../blocs/reguser_profile/reguser_profile_state.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';

import 'widget/hero_card_widget.dart';
import 'widget/list_menu_widget.dart';
import 'widget/carousel_menu_widget.dart';
import 'widget/transaksi_list_widget.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, authState) {
                          final userType =
                          authState is AuthenticationAuthenticated
                              ? (authState.user.userType ?? '').toUpperCase()
                              : '';

                          if (userType == 'C') {
                            // 🔹 Client → ambil dari UserProfileCubit
                            return BlocBuilder<UserProfileCubit, UserProfileState>(
                              buildWhen:
                                  (prev, curr) =>
                              prev.nama != curr.nama ||
                                  prev.fotoBytes != curr.fotoBytes,
                              builder: (context, profileState) {
                                final displayName =
                                (profileState.nama?.trim().isNotEmpty ?? false)
                                    ? profileState.nama!.trim()
                                    : 'Client User';

                                final bytes =
                                (profileState.fotoBytes != null &&
                                    profileState.fotoBytes!.isNotEmpty)
                                    ? profileState.fotoBytes
                                    : null;

                                return _buildHeroContent(
                                  context,
                                  displayName: displayName,
                                  userType: userType,
                                  bytes: bytes,
                                  screenHeight: screenHeight,
                                );
                              },
                            );
                          } else if (userType == 'U') {
                            // 🔹 User baru → ambil dari RegUserProfileCubit
                            return BlocBuilder<
                                RegUserProfileCubit,
                                RegUserProfileState
                            >(
                              buildWhen: (prev, curr) => prev.email != curr.email,
                              builder: (context, regState) {
                                final displayName =
                                regState.email.isNotEmpty
                                    ? regState.email
                                    : 'New User';

                                return _buildHeroContent(
                                  context,
                                  displayName: displayName,
                                  userType: userType,
                                  bytes: null,
                                  screenHeight: screenHeight,
                                );
                              },
                            );
                          } else {
                            // 🔹 userType kosong / tidak dikenal
                            final fallbackEmail =
                            authState is AuthenticationAuthenticated
                                ? (authState.user.email?.trim() ?? 'Guest User')
                                : 'Guest User';

                            return _buildHeroContent(
                              context,
                              displayName: fallbackEmail,
                              userType: userType.isEmpty ? '(Unknown)' : userType,
                              bytes: null,
                              screenHeight: screenHeight,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Helper untuk bangun HeroPage UI
  Widget _buildHeroContent(
      BuildContext context, {
        required String displayName,
        required String userType,
        Uint8List? bytes,
        required double screenHeight,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroCardWidget(
          userName: displayName,
          imageBytes: bytes,
          premiumAmount: userType == 'C' ? '10.500.000.000' : '0',
          polisCount: userType == 'C' ? 21 : 0,
          onDetailTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DetailPremiPage(sppa1Id: ''),
              ),
            );
          },
          userType: userType,
        ),
        const SizedBox(height: vPadding - 3),
        ListMenuWidget(userType: userType),
        const SizedBox(height: vPadding - 3),
        const CarouselMenuWidget(),
        const SizedBox(height: vPadding - 3),

        if (userType == 'C')
          const TransaksiListWidget()
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Berizin dan Diawasi Oleh:',
                      style: bodyTextStyle(context, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Image.asset(
                      'assets/images/ojk.png',
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}