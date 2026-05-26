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
    return BaseBackgroundSidePage(
      title: 'Tagihan Pembayaran',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const HeaderCard(
              iconPath: "assets/icons/menu_tagihan_pembayaran.svg",
              title: "Tagihan Pembayaran",
              subtitle: "Lihat dan kelola tagihan pembayaran Anda di sini.",
            ),

            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(cardBorderRadius2),
                topRight: Radius.circular(cardBorderRadius2),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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

            Expanded(
              child: tabItems[selectedTab]['page'] as Widget,
            ),
          ],
        ),
      ),
    );
  }
}
