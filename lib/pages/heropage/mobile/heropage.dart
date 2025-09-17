import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, authState) {
                      final custType = authState is AuthenticationAuthenticated
                          ? authState.user.custType
                          : '';

                      if (custType == 'C') {
  // 🔹 Client → ambil dari UserProfileCubit
                        return BlocBuilder<UserProfileCubit, UserProfileState>(
                          buildWhen: (prev, curr) =>
                          prev.nama != curr.nama || prev.fotoBytes != curr.fotoBytes,
                          builder: (context, profileState) {
                            final displayName =
                            (profileState.nama?.trim().isNotEmpty ?? false)
                                ? profileState.nama!.trim()
                                : 'Client User'; // default kalau masih kosong

                            final bytes = (profileState.fotoBytes != null &&
                                profileState.fotoBytes!.isNotEmpty)
                                ? profileState.fotoBytes
                                : null; // default kalau belum ada foto

                            return _buildHeroContent(
                              displayName: displayName,
                              custType: custType,
                              bytes: bytes,
                            );
                          },
                        );
                      } else if (custType == 'U') {
  // 🔹 User baru → ambil dari RegUserProfileCubit
                        return BlocBuilder<RegUserProfileCubit, RegUserProfileState>(
                          buildWhen: (prev, curr) => prev.email != curr.email,
                          builder: (context, regState) {
                            final displayName = regState.email.isNotEmpty
                                ? regState.email
                                : 'New User'; // default kalau email kosong

                            return _buildHeroContent(
                              displayName: displayName,
                              custType: custType,
                              bytes: null, // user baru belum ada foto
                            );
                          },
                        );
                      }

  // 🔹 Default (belum login / state lain) → render placeholder juga
                      return _buildHeroContent(
                        displayName: 'Guest', // fallback
                        custType: '',
                        bytes: null,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper untuk bangun HeroPage UI
  Widget _buildHeroContent({
    required String displayName,
    required String custType,
    Uint8List? bytes,
  }) {
    return Column(
      children: [
        HeroCardWidget(
          userName: displayName,
          imageBytes: bytes,
          premiumAmount: '4.500.000',
          polisCount: 21,
          onDetailTap: () => debugPrint('Detail tapped'),
          onNasabahTap: () => debugPrint('Nasabah tapped'),
          custType: custType,
        ),
        const SizedBox(height: vPadding - 3),
        ListMenuWidget(custType: custType),
        const SizedBox(height: vPadding - 3),
        const CarouselMenuWidget(),
        const SizedBox(height: vPadding - 3),
        if (custType == 'C') const TransaksiListWidget(),
      ],
    );
  }
}
