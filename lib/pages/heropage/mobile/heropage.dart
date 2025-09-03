import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import 'package:joss_app/blocs/user_profile/user_profile_cubit.dart';

import 'widget/hero_card_widget.dart';
import 'widget/list_menu_widget.dart';
import 'package:joss_app/pages/heropage/mobile/widget/carousel_menu_widget.dart';
import 'package:joss_app/pages/heropage/mobile/widget/transaksi_list_widget.dart';

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
                    return BlocBuilder<UserProfileCubit, UserProfileState>(
                      buildWhen:
                          (prev, curr) =>
                              prev.nama != curr.nama ||
                              prev.fotoBytes != curr.fotoBytes,
                      builder: (context, profileState) {
                        final custType =
                            authState is AuthenticationAuthenticated
                                ? authState.user.custType
                                : '';

                        final displayName =
                            (profileState.nama?.trim().isNotEmpty ?? false)
                                ? profileState.nama!.trim()
                                : 'User Test';

                        final bytes =
                            (profileState.fotoBytes != null &&
                                    profileState.fotoBytes!.isNotEmpty)
                                ? profileState.fotoBytes
                                : null;

                        return HeroCardWidget(
                          userName: displayName,
                          imageBytes: bytes,
                          premiumAmount: '4.500.000',
                          polisCount: 21,
                          onDetailTap: () => debugPrint('Detail tapped'),
                          onNasabahTap: () => debugPrint('Nasabah tapped'),
                          custType:
                              custType, // custType dari AuthenticationBloc
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: vPadding - 3),
                const ListMenuWidget(),
                const SizedBox(height: vPadding - 3),
                const CarouselMenuWidget(),
                const SizedBox(height: vPadding - 3),
                const TransaksiListWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
