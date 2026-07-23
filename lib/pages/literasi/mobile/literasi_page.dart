import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_berita/berita1cari_bloc.dart';
import 'package:joss_app/blocs/gen_berita/beritakecilcari_bloc.dart';
import 'package:joss_app/blocs/gen_berita/beritalaincari_bloc.dart';
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
    {'label': 'Tentang', 'page': const TentangJPSPage()},
    {
      'label': 'Artikel',
      'page': const ArtikelPage(constraints: BoxConstraints()),
    },
    // {'label': 'Testimoni', 'page': const TestimoniPage()},
    {'label': 'Rating', 'page': const TestimoniPage2()},
  ];

  void _ensureArtikelLoaded() {
    final beritaBesarBloc = context.read<Berita1CariBloc>();
    final beritaKecilBloc = context.read<BeritaKecilCariBloc>();
    final beritaLainBloc = context.read<BeritaLainCariBloc>();

    if (beritaBesarBloc.state.status == ListStatus.initial) {
      beritaBesarBloc.add(const RefreshBerita1CariEvent(1));
    }
    if (beritaKecilBloc.state.status == ListStatus.initial) {
      beritaKecilBloc.add(const RefreshBeritaKecilCariEvent(2));
    }
    if (beritaLainBloc.state.status == ListStatus.initial) {
      beritaLainBloc.add(const RefreshBeritaLainCariEvent(3));
    }
  }

  void _selectTab(int index) {
    if (selectedTab == index) {
      return;
    }
    if (index == 1) {
      _ensureArtikelLoaded();
    }
    setState(() => selectedTab = index);
  }

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
                        onTap: () => _selectTab(i),
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
