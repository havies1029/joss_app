import 'package:flutter/material.dart';

import 'package:joss_app/pages/tagihan_pembayaran/payment_rincian_tab.dart';
import 'package:joss_app/pages/tagihan_pembayaran/payment_ringkasan_tab.dart';
import 'package:joss_app/pages/tagihan_pembayaran/payment_riwayat_tab.dart';
import '../../common/constants.dart';
import '../../widgets/apptheme/header_card.dart';
import '../base/base_background_sidepage.dart';

class TagihanPembayaranPage extends StatefulWidget {
  final int initialTab; // 0=Ringkasan, 1=Rincian, 2=Riwayat

  const TagihanPembayaranPage({super.key, required this.initialTab});

  @override
  _TagihanPembayaranPageState createState() => _TagihanPembayaranPageState();
}

class _TagihanPembayaranPageState extends State<TagihanPembayaranPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();

  int selectedTab = 0;

  final List<Map<String, dynamic>> tabItems = [
    {'label': 'Ringkasan', 'page': const PaymentRingkasanTab()},
    {
      'label': 'Rincian',
      // 'page': const DnsppaCariListWidget(),
      'page': const PaymentRincianTab(),
    },
    // {'label': 'Testimoni', 'page': const TestimoniPage()},
    {'label': 'Riwayat', 'page': const PaymentRiwayatTab()},

  ];

  @override
  void initState() {
    super.initState();
    final maxIndex = tabItems.length - 1;
    selectedTab = widget.initialTab.clamp(0, maxIndex);

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
                    //micky - 2026-02-28 pakai indexed stack biar state tiap tab tetap terjaga, kalau pakai ternary atau switch case tiap switch akan rebuild ulang widgetnya, jadi statenya hilang. Kalau pakai indexed stack, semua widget tetap hidup, cuma yang ditampilkan sesuai indexnya. Jadi state tiap tab tetap terjaga walaupun pindah-pindah tab
                    // Expanded(
                    //   child: tabItems[selectedTab]['page'] as Widget,
                    // ),
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
