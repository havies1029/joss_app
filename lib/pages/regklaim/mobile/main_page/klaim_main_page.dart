import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

import 'package:joss_app/widgets/apptheme/header_card.dart';

import 'klaim_rasio_tab.dart';
import 'klaim_rincian_tab.dart';
import 'klaim_ringkasan_tab.dart';

class KlaimMainPage extends StatefulWidget {
  const KlaimMainPage({super.key});

  @override
  _KlaimMainPageState createState() => _KlaimMainPageState();
}

class _KlaimMainPageState extends State<KlaimMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();

  int selectedTab = 0;

  final List<Map<String, dynamic>> tabItems = [
    {'label': 'Ringkasan', 'page': const KlaimRingkasanTab()},
    {
      'label': 'Rincian',
      'page': const KlaimRincianTab(),
    },
    {'label': 'Rasio', 'page': const KlaimRasioTab()},

  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      iconPath: "assets/icons/menu_lapor_klaim.svg",
                      title: "Klaim",
                      subtitle:
                      "Pilih kategori asuransi untuk keamanan Anda dan keluarga, Yuk!",
                    ),
                    // BaseAssetWidget(),
                    SafeArea(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: secondaryBlackColor,
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
                                        color:
                                        isActive ? primaryColor : unselectedColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    borderRadius:
                                    i == 0
                                        ? const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                    )
                                        : i == tabItems.length - 1
                                        ? const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                    )
                                        : null,
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
                    // Body content
                    // Expanded(
                    //   child: IndexedStack(
                    //     index: selectedTab,
                    //     children: tabItems.map((e) => e['page'] as Widget).toList(),
                    //   ),
                    // ),
                    Expanded(
                      child: tabItems[selectedTab]['page'] as Widget,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}