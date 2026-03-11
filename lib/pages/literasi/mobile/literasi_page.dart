import 'package:flutter/material.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/pages/literasi/mobile/artikel/artikel_page.dart';
import 'package:joss_app/pages/literasi/mobile/tentang_jps_page.dart';
import 'package:joss_app/pages/literasi/mobile/testimoni_page.dart';
import 'package:joss_app/common/constants.dart';

class LiterasiPage extends StatefulWidget {
  const LiterasiPage({super.key});

  @override
  State<LiterasiPage> createState() => _LiterasiPageState();
}

class _LiterasiPageState extends State<LiterasiPage> {
  int selectedTab = 0;

  final List<Map<String, dynamic>> tabItems = [
    {'label': 'Tentang JPS', 'page': const TentangJPSPage()},
    {
      'label': 'Artikel',
      'page': const ArtikelPage(constraints: BoxConstraints()),
    },
    // {'label': 'Testimoni', 'page': const TestimoniPage()},
    {'label': 'Rating', 'page': const TestimoniPage2()},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseBackgroundFirstPage(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryBlackColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
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
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: tabItems.map((e) => e['page'] as Widget).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
