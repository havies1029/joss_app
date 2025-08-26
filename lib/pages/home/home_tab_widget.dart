import 'package:flutter/material.dart';
import 'package:joss_app/pages/testpage/testpage0.dart';
import 'package:joss_app/pages/testpage/testpage1.dart';
import 'package:joss_app/pages/testpage/testpage2.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

class HomeTabWidget extends StatelessWidget {
  final UserRepository userRepository;
  const HomeTabWidget({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'JPS Insurance Broker',
          ),
        ),
        body: const TabBarView(
          children: [ReportTab(), HomeTab(), SettingsTab()],
        ),
        bottomNavigationBar: Material(
          // beri latar agar indikator & label terlihat
          color: Theme.of(context).colorScheme.surface,
          child: const SafeArea(
            top: false, // fokus ke area bawah saja
            child: TabBar(
              // isScrollable: true, // aktifkan jika label panjang/lebih dari 3–4 tab
              tabs: [
                Tab(icon: Icon(Icons.pie_chart), text: 'Report'),
                Tab(icon: Icon(Icons.home), text: 'Home'),
                Tab(icon: Icon(Icons.settings), text: 'Settings'),
              ],
              // opsional: gaya indikator/label
              // indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
      ),
    );
  }
}
