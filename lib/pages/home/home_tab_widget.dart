import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/literasi/mobile/literasi_page.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

import '../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../blocs/gen_profile/mrekancontactcrud_bloc.dart';
import '../../blocs/login/emailverification_bloc.dart';
import '../../blocs/profile/profile_download_foto_bloc.dart';
import '../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../blocs/user_profile/user_profile_cubit.dart';
import '../../common/constants.dart';
import '../../widgets/menus/bottom_nav.dart' as bottom_nav;
import '../../widgets/menus/navbar.dart' as web_nav;
import '../../widgets/menus/top_nav.dart';
import '../cari_asuransi/mobile/cari_asuransi_page.dart';
import '../gen_klaim/mobile/klaim_main_page.dart';
import '../heropage/mobile/heropage.dart';
import '../qontak/mobile/chat_init_service.dart';
import '../qontak/mobile/customer_service_page.dart';
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
        // Listener Foto Profil
        BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
          listenWhen: (prev, curr) => curr is ProfileDownloadFotoLoaded,
          listener: (context, state) {
            final bytes = (state as ProfileDownloadFotoLoaded).imageBytes;
            // if (bytes.isNotEmpty) {
            //   context.read<UserProfileCubit>().setProfile(fotoBytes: bytes);
            // }
          },
        ),
        BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
          listenWhen: (prev, curr) =>
          curr.isLoaded && prev.record?.mrekan1Id != curr.record?.mrekan1Id,
          listener: (context, state) {
            final nama = state.record?.rekanNama?.trim();
            final mrekan1Id = state.record?.mrekan1Id;
            final mjnsclientId = state.record?.mjnsclientId; // 👈 ambil di sini

            // if (nama != null && nama.isNotEmpty) {
            //   context.read<UserProfileCubit>().setProfile(
            //     nama: nama,
            //     mjnsclientId: mjnsclientId, // 👈 simpan juga
            //   );
            // }

            if (mrekan1Id != null && mrekan1Id.isNotEmpty) {
              context.read<MRekanContactCrudBloc>().add(
                MRekanContactCrudLihatEvent(),
              );
            }
          },
        ),

        BlocListener<EmailVerificationBloc, EmailVerificationState>(
          listenWhen: (prev, curr) =>
          prev.record != curr.record && curr.record != null && !curr.hasFailure,
          listener: (context, state) {
            final record = state.record!;
            // if (record.email.isNotEmpty) {
            //   context.read<RegUserProfileCubit>().setProfile(
            //     email: record.email,
            //   );
            // }
          },
        ),

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
}

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}