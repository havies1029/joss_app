import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/dashboard/sumdash_bloc.dart';
import 'package:joss_app/pages/heropage/mobile/widget/detail_premi.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../blocs/reguser/reguser_bloc.dart';
import '../../../common/app_data.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';

import 'widget/hero_card_widget.dart';
import 'widget/list_menu_widget.dart';
import 'widget/carousel_menu_widget.dart';
import 'widget/transaksi_list_widget.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {

  @override
  void initState() {
    super.initState();
    context.read<SumdashBloc>().add(SumdashLihatEvent());
  }

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
                              ? (authState.user.userType).toUpperCase()
                              : '';

                          if (userType == 'C') {
                            return BlocBuilder<MRekan1CrudBloc, MRekan1CrudState>(
                              buildWhen: (prev, curr) =>
                              prev.record?.rekanNama != curr.record?.rekanNama,
                              builder: (context, rekanState) {
                                final nama = rekanState.record?.rekanNama.trim();
                                final displayName =
                                (nama != null && nama.isNotEmpty) ? nama : AppData.user.nama ?? "Klien Baru";

                                return BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
                                  buildWhen: (prev, curr) =>
                                  curr is ProfileDownloadFotoLoaded ||
                                      (prev is ProfileDownloadFotoLoaded &&
                                          curr is! ProfileDownloadFotoLoaded),
                                  builder: (context, fotoState) {
                                    final bytes = (fotoState is ProfileDownloadFotoLoaded &&
                                        fotoState.imageBytes.isNotEmpty)
                                        ? fotoState.imageBytes
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
                              },
                            );
                          } else if (userType == 'U') {
                            return BlocBuilder<RegUserBloc, RegUserState>(
                              buildWhen: (prev, curr) =>
                              prev.record?.email != curr.record?.email ||
                                  prev.record?.personalNama != curr.record?.personalNama ||
                                  prev.record?.userNama != curr.record?.userNama,
                              builder: (context, regState) {
                                final email = (regState.record?.email ?? '').trim();
                                final personalNama = (regState.record?.personalNama ?? '').trim();
                                final userNama = (regState.record?.userNama ?? '').trim();

                                final displayName = email.isNotEmpty
                                    ? email
                                    : (personalNama.isNotEmpty ? personalNama : (userNama.isNotEmpty ? userNama : 'New User'));

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

        (userType == 'C')
            ? Column(
          children: [
            SizedBox(height: vPadding - 3),
            const TransaksiListWidget(),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: vPadding - 3),
            Container(
              padding: const EdgeInsets.all(hPadding),
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