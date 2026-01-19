import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/literasi/mobile/literasi_page.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../blocs/gen_profile/mrekancontactcrud_bloc.dart';
import '../../blocs/login/emailverification_bloc.dart';
import '../../blocs/profile/profile_download_foto_bloc.dart';
import '../../blocs/reguser/reguser_bloc.dart';
import '../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../blocs/user_profile/user_profile_cubit.dart';
import '../../common/constants.dart';
import '../../common/loading_indicator.dart';
import '../../widgets/menus/bottom_nav.dart' as bottom_nav;
import '../../widgets/menus/navbar.dart' as web_nav;
import '../../widgets/menus/top_nav.dart';
import '../cari_asuransi/mobile/cari_asuransi_page.dart';
import '../gen_klaim/mobile/klaim_main_page.dart';
import '../heropage/mobile/heropage.dart';
import '../login/mobile/client/login_client_page.dart';
import '../login/mobile/client/widget/otp_client_widget.dart';
import '../login/mobile/user/login_user_page.dart';
import '../login/mobile/user/widget/otp_user_widget.dart';
import '../qontak/mobile/chat_init_service.dart';
import '../qontak/mobile/customer_service_page.dart';
import '../register/mobile/client/register_client_page.dart';
import '../settingpage/mobile/settingpage.dart';
import 'draggable_chat_button.dart';

class HomeTabWidget extends StatefulWidget {
  final UserRepository userRepository;
  const HomeTabWidget({super.key, required this.userRepository});

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HeroPage(),
      const CariAsuransiWidget.menu(),
      const KlaimMainPage.menu(),
      const LiterasiPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, __) => true, // sementara untuk test
          listener: (context, state) {

            // if (state is AuthenticationUnauthenticated) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     final nav = Navigator.of(context, rootNavigator: true);
            //     nav.pushAndRemoveUntil(
            //       MaterialPageRoute(builder: (_) => const LoginUser()),
            //           (route) => false,
            //     );
            //   });
            // }
            //
            // if (state is AuthenticationRequireLoginClient) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     final nav = Navigator.of(context, rootNavigator: true);
            //     nav.pushAndRemoveUntil(
            //       MaterialPageRoute(builder: (_) => const LoginClient()),
            //           (route) => false,
            //     );
            //   });
            // }

            // if (state is AuthenticationRequireRegisterClient) {
            //   Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (_) => RegisterClient(requestFrom: state.requiredFrom,)),
            //         (route) => false,
            //   );
            // }

            // if (state is AuthenticationRequirePinHPVerification) {
            //   Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (_) => PopupClientWidget(phoneNumber: state.hpno),),
            //         (route) => false,
            //   );
            // }
            //
            // if (state is AuthenticationRequirePinEmailVerification) {
            //   Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (_) => PopupUserWidget(email: state.email),),
            //         (route) => false,
            //   );
            // }

            if (state is AuthenticationForgotPassword) {
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (_) => ForgotPasswordPage),
              //       (route) => false,
              // );
            }
            //
            // if (state is AuthenticationPhonePinVerified) {
            //   Navigator.of(context).pop();
            //
            //   String requestFrom = context.read<RegUserBloc>().state.requestFrom;
            //   if (requestFrom == "hero_page") {
            //     BlocProvider.of<AuthenticationBloc>(context).add(
            //       LoggedOut(),
            //     );
            //   }
            // }

            if (state is AuthenticationGoogleUserAuthenticated) {
              Navigator.of(context).pop();
            }

            if (state is AuthenticationLoading) {

            }

            if (state is AuthenticationPreCheckHasToken) {

            }

            if (state is AuthenticationPostCheckHasToken) {

            }

        }),

      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MobileTopNavigationBar(context: context, selectedIndex: selectedIndex),
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
                    const SnackBar(content: Text('Chat belum siap, coba lagi')),
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
    );
  }

  bool _loginClientDialogOpen = false;

  void _showLoginClientFullscreen() {
    if (_loginClientDialogOpen) return;
    _loginClientDialogOpen = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        _loginClientDialogOpen = false;
        return;
      }

      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Login',
        pageBuilder: (_, __, ___) => const LoginClient(),
        transitionDuration: const Duration(milliseconds: 180),
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      );

      _loginClientDialogOpen = false;
    });
  }

}

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}