import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/pages/home/draggable_chat_button.dart';
import 'package:joss_app/pages/literasi/mobile/literasi_page.dart';
import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../blocs/gen_profile/mrekancontactcrud_bloc.dart';
import '../../blocs/login/emailverification_bloc.dart';
import '../../blocs/profile/profile_download_foto_bloc.dart';
import '../../common/constants.dart';
import '../../widgets/menus/bottom_nav.dart' as bottom_nav;
import '../../widgets/menus/top_nav.dart';
import '../cari_asuransi/mobile/cari_asuransi_page.dart';
import '../heropage/mobile/heropage.dart';
import '../regklaim/mobile/registrasi_klaim/daftar_cob_klaim_page.dart';
import '../settingpage/mobile/settingpage.dart';

class HomeTabWidget extends StatefulWidget {
  final UserRepository userRepository;
  final int initialIndex;

  const HomeTabWidget({
    super.key,
    required this.userRepository,
    this.initialIndex = 0,
  });

  @override
  State<HomeTabWidget> createState() => HomeTabWidgetState();
}

class HomeTabWidgetState extends State<HomeTabWidget> {
  late int selectedIndex;
  late final List<Widget> pages;

  void goToHeroPage() {
    setState(() {
      selectedIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    selectedIndex = widget.initialIndex;

    pages = [
      const HeroPage(),
      const CariAsuransiWidget.menu(),
      const DaftarCobKlaimMenu(),
      const LiterasiPage(),
      const SettingsPage(),
    ];
  }

  Future<bool?> showLogoutConfirmDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
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
                  Text(
                    "Keluar Sekarang?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kamu bisa login lagi kapan pun kok.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
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
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pSlowRed,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: Text(
                              "Iya, Keluar",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Future<void> handleLogout(BuildContext context) async {
    final shouldLogout = await showLogoutConfirmDialog(context);
    if (!context.mounted) return;

    if (shouldLogout == true) {
      context.read<AuthenticationBloc>().add(LoggedOut());
      context.read<ProfileDownloadFotoBloc>().add(ClearSecureImage());
      ChatInitService.I.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IosLeftEdgeSwipe(
      onSwipeBack: () async {
        await handleLogout(context);
      },
      child: PopScope(
        canPop: Platform.isAndroid ? false : true,
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS) return;
          if (didPop) return;

          await handleLogout(context);
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
              listenWhen: (prev, curr) => curr is ProfileDownloadFotoLoaded,
              listener: (context, state) {},
            ),
            BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
              listenWhen: (prev, curr) =>
                  curr.isLoaded &&
                  prev.record?.mrekan1Id != curr.record?.mrekan1Id,
              listener: (context, state) {
                final mrekan1Id = state.record?.mrekan1Id;
                if (mrekan1Id != null && mrekan1Id.isNotEmpty) {
                  context.read<MRekanContactCrudBloc>().add(
                        MRekanContactCrudLihatEvent(),
                      );
                }
              },
            ),
            BlocListener<EmailVerificationBloc, EmailVerificationState>(
              listenWhen: (prev, curr) =>
                  prev.record != curr.record &&
                  curr.record != null &&
                  !curr.hasFailure,
              listener: (context, state) {},
            ),
          ],
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: MobileTopNavigationBar(
                context: context, selectedIndex: selectedIndex),
            body: Stack(
              children: [
                IndexedStack(
                  index: selectedIndex,
                  children: pages,
                ),
                DraggableChatButton(
                  onTap: () {
                    if (ChatInitService.I.isInitialized) {
                      Navigator.pushNamed(context, 'chat');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Chat belum siap, coba lagi')),
                      );
                    }
                  },
                ),
              ],
            ),
            bottomNavigationBar: Material(
              color: primaryBlackColor,
              child: SafeArea(
                top: false,
                child: bottom_nav.MobileBottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (idx) => setState(() => selectedIndex = idx),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}
