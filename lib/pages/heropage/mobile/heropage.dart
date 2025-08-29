import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/heropage/mobile/widget/carouse_menu_widget.dart';

import '../../../common/constants.dart';
import '../../base/base_background.dart';
import 'widget/hero_card_widget.dart';

// ⬇️ tambahkan import cubit-nya
import 'package:joss_app/blocs/user_profile/user_profile_cubit.dart';

import 'widget/list_menu_widget.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: BaseBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: vPadding),

                // 🔊 Ambil nama & foto dari UserProfileCubit
              BlocBuilder<UserProfileCubit, UserProfileState>(
                buildWhen: (prev, curr) =>
                prev.nama != curr.nama || prev.fotoBytes != curr.fotoBytes,
                builder: (context, state) {
                  final displayName = (state.nama?.trim().isNotEmpty ?? false)
                      ? state.nama!.trim()
                      : 'Farel test';

                  final bytes = (state.fotoBytes != null && state.fotoBytes!.isNotEmpty)
                      ? state.fotoBytes
                      : null;

                  return HeroCardWidget(
                    userName: displayName,
                    imageBytes: bytes,                 // ⬅️ jika null → widget pakai placeholder
                    // userImage: tidak perlu, biarkan widget fallback ke placeholder
                    premiumAmount: '4.500.000',     // dummy OK
                    polisCount: 21,                     // dummy OK
                    onDetailTap: () => debugPrint('Detail tapped'),
                    onNasabahTap: () => debugPrint('Nasabah tapped'),
                  );
                },
              ),

              const SizedBox(height: vPadding),

              const ListMenuWidget(),

              const SizedBox(height: vPadding),

              const CarouselMenuWidget(),

              const SizedBox(height: vPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
