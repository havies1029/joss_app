import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/testpage/testpage1.dart';
import 'package:joss_app/pages/testpage/testpage2.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

import '../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../blocs/profile/profile_download_foto_bloc.dart';
import '../../blocs/user_profile/user_profile_cubit.dart';
import '../../common/constants.dart';
import '../../widgets/menus/bottom_nav.dart' as bottom_nav;
import '../../widgets/menus/navbar.dart' as web_nav;
import '../../widgets/menus/top_nav.dart';
import '../heropage/mobile/heropage.dart';
import '../qontak/mobile/customer_service_page.dart';

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
      const ReportTab(),
      const CustomerServicePage(),
      const SettingsTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // 🌸 Seed Data (sekali setelah frame pertama)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Seed FOTO
          final fotoState = context.read<ProfileDownloadFotoBloc>().state;
          final currentBytes = context.read<UserProfileCubit>().state.fotoBytes;

          if (fotoState is ProfileDownloadFotoLoaded) {
            if (currentBytes == null || currentBytes.isEmpty) {
              context.read<UserProfileCubit>()
                  .setProfile(fotoBytes: fotoState.imageBytes);
              debugPrint('[SeedFoto] setProfile len=${fotoState.imageBytes.length}');
            }
          } else if (fotoState is! ProfileDownloadFotoLoading) {
            context.read<ProfileDownloadFotoBloc>().add(LoadSecureImage());
            debugPrint('[Foto] LoadSecureImage() dipanggil dari seed');
          }

          // Seed NAMA
          final rekanState = context.read<MRekan1CrudBloc>().state;
          final currentName = context.read<UserProfileCubit>().state.nama;
          final nama = rekanState.record?.rekanNama?.trim();

          if (rekanState.isLoaded &&
              (currentName == null || currentName.isEmpty) &&
              (nama != null && nama.isNotEmpty)) {
            context.read<UserProfileCubit>().setProfile(nama: nama);
            debugPrint('[SeedNama] $nama');
          }
        });

        return MultiBlocListener(
          listeners: [
            BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
              listenWhen: (prev, curr) =>
              curr.isLoaded && (prev.record?.rekanNama != curr.record?.rekanNama),
              listener: (context, state) {
                final nama = state.record?.rekanNama?.trim();
                if (nama != null && nama.isNotEmpty) {
                  context.read<UserProfileCubit>().setProfile(nama: nama);
                  debugPrint('[ListenerNama] $nama');
                }
              },
            ),
            BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
              listenWhen: (prev, curr) => curr is ProfileDownloadFotoLoaded,
              listener: (context, state) {
                final bytes = (state as ProfileDownloadFotoLoaded).imageBytes;
                if (bytes.isNotEmpty) {
                  context.read<UserProfileCubit>().setProfile(fotoBytes: bytes);
                  debugPrint('[ListenerFoto] setProfile len=${bytes.length}');
                } else {
                  debugPrint('[ListenerFoto] bytes kosong, skip');
                }
              },
            ),
          ],
          child: !pIsWeb
              ? Scaffold(
            extendBody: true,
            body: Column(
              children: [
                web_nav.WebNavbar(
                  currentIndex: selectedIndex,
                  onTap: (idx) => setState(() => selectedIndex = idx),
                ),
                Expanded(
                  child: IndexedStack(index: selectedIndex, children: pages),
                ),
              ],
            ),
          )
              : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: MobileTopNavigationBar(context: context),
            body: pages[selectedIndex],
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
      },
    );
  }
}

class NavBarItem {
  final String iconPath;
  final String label;
  const NavBarItem({required this.iconPath, required this.label});
}