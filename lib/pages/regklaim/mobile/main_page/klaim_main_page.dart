import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/regklaim/mobile/floating_action_klaim.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';

import 'klaim_rincian_tab.dart';
import 'klaim_ringkasan_tab.dart';

class KlaimMainPage extends StatefulWidget {
  const KlaimMainPage({super.key});

  @override
  KlaimMainPageState createState() => KlaimMainPageState();
}

class KlaimMainPageState extends State<KlaimMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final List<Widget> _pages;

  final _formKey = GlobalKey<FormState>();

  int selectedTab = 0;

  final List<Map<String, dynamic>> tabItems = [
    {'label': 'Ringkasan', 'page': const KlaimRingkasanTab()},
    {
      'label': 'Rincian', 'page': const KlaimRincianTab(),
    },
    // {'label': 'Rasio', 'page': const KlaimRasioTab()},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
    _pages = tabItems.map((e) => e['page'] as Widget).toList(growable: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryBlackColor,
      body: SafeArea(
        child: Stack(
          children: [
            BaseBackgroundSidePage(
              title: 'Klaim',
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const HeaderCard(
                      iconPath: "assets/icons/menu_klaim.svg",
                      title: "Klaim",
                      subtitle:
                      "Masukan klaim Anda sesuai dengan kategori asuransi yang tersedia.",
                    ),
                    SafeArea(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(cardBorderRadius2),
                          topRight: Radius.circular(cardBorderRadius2),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: secondaryBlackColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(cardBorderRadius2),
                              topRight: Radius.circular(cardBorderRadius2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(tabItems.length, (i) {
                              final isActive = i == selectedTab;

                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => selectedTab = i),
                                  child: Container(
                                    height: 54,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: isActive ? primaryColor : unselectedColor,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tabItems[i]['label'],
                                      style: bodyTextStyle(context).copyWith(
                                        color: isActive ? primaryColor : unselectedColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: selectedTab,
                        children: _pages,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FabActionKlaim(
        selectedTab: selectedTab,
      ),

    );
  }
}