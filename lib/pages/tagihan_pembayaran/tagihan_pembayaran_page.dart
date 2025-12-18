import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../widgets/apptheme/header_card.dart';
import '../base/base_background_sidepage.dart';
import '../literasi/mobile/artikel/artikel_page.dart';
import '../literasi/mobile/tentang_jps_page.dart';
import '../literasi/mobile/testimoni_page.dart';

class TagihanPembayaranPage extends StatefulWidget {
  const TagihanPembayaranPage({super.key});

  @override
  _TagihanPembayaranPageState createState() => _TagihanPembayaranPageState();
}

class _TagihanPembayaranPageState extends State<TagihanPembayaranPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();

  int selectedTab = 0;

  final List<Map<String, dynamic>> tabItems = [
    {'label': 'Ringkasan', 'page': const TentangJPSPage()},
    {
      'label': 'Rincian',
      'page': const ArtikelPage(constraints: BoxConstraints()),
    },
    // {'label': 'Testimoni', 'page': const TestimoniPage()},
    {'label': 'Riwayat', 'page': const TestimoniPage()},

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
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: Stack(
          children: [
            BaseBackgroundSidePage(
              title: 'Tagihan Pembayaran',
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const HeaderCard(
                      iconPath: "assets/icons/menu_tagihan_pembayaran.svg",
                      title: "Tagihan Pembayaran",
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
                    Expanded(
                      child: IndexedStack(
                        index: selectedTab,
                        children: tabItems.map((e) => e['page'] as Widget).toList(),
                      ),
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
