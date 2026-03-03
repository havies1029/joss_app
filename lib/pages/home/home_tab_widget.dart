import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/home/draggable_chat_button.dart';
import 'package:joss_app/pages/literasi/mobile/literasi_page.dart';
import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

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
  const HomeTabWidget({super.key, required this.userRepository});

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  int selectedIndex = 0;

  // track tab yang sudah pernah dibuka (biar baru dibuild saat pertama kali)
  final Set<int> _visited = {0};

  // jumlah tab
  static const int _tabCount = 5;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HeroPage();
      case 1:
        return const CariAsuransiWidget.menu();
      case 2:
        return const DaftarCobKlaimMenu();
      case 3:
        return const LiterasiPage();
      case 4:
        return const SettingsPage();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onTapTab(int idx) {
    setState(() {
      selectedIndex = idx;
      _visited.add(idx); // <- baru dibuat ketika user klik tab ini
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
          listenWhen: (prev, curr) => curr is ProfileDownloadFotoLoaded,
          listener: (context, state) {},
        ),
        BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
          listenWhen: (prev, curr) =>
          curr.isLoaded && prev.record?.mrekan1Id != curr.record?.mrekan1Id,
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
        appBar:
        MobileTopNavigationBar(context: context, selectedIndex: selectedIndex),
        body: Stack(
          children: [
            IndexedStack(
              index: selectedIndex,
              children: List.generate(_tabCount, (idx) {
                // tab yang belum pernah dibuka: jangan build page-nya
                if (!_visited.contains(idx)) return const SizedBox.shrink();
                return _buildPage(idx);
              }),
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
              onTap: _onTapTab, // <- pakai handler ini
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