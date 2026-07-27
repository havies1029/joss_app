import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/literasi/mobile/testimoni_page.dart';

import '../widgets/company_profile_widget.dart';
import '../../../widgets/klien_jps_widget.dart';
import '../widgets/tentang_jps_widget.dart';

class TentangJPSPage extends StatefulWidget {
  const TentangJPSPage({super.key});

  @override
  State<TentangJPSPage> createState() => _TentangJPSPageState();
}

class _TentangJPSPageState extends State<TentangJPSPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey tentangKey = GlobalKey();
  final GlobalKey companyProfileKey = GlobalKey();
  final GlobalKey testimoniKey = GlobalKey();

  int selectedChip = 0;
  int? pressedChip;

  final List<String> chipItems = [
    "Proteksi Plus",
    "Profil Perusahaan",
    "Testimoni",
  ];

  Future<void> scrollToSection(GlobalKey key) async {
    final context = key.currentContext;
    if (!mounted || context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
  }

  Widget buildChip(String label, int index) {
    final bool isSelected = selectedChip == index;
    final bool isPressed = pressedChip == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => pressedChip = index),
      onTapUp: (_) => setState(() => pressedChip = null),
      onTapCancel: () => setState(() => pressedChip = null),
      onTap: () {
        setState(() {
          selectedChip = index;
        });

        if (index == 0) {
          scrollToSection(tentangKey);
        } else if (index == 1) {
          scrollToSection(companyProfileKey);
        } else if (index == 2) {
          scrollToSection(testimoniKey);
        }
      },
      child: AnimatedScale(
        scale: isPressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Text(
            label,
            style: bodyTextStyle(context).copyWith(
              color: isSelected ? Colors.white : primaryLightColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: hPadding,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  chipItems.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == chipItems.length - 1 ? 0 : 10,
                    ),
                    child: buildChip(
                      chipItems[index],
                      index,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  hPadding * 1.5,
                  0,
                  hPadding * 1.5,
                  hPadding,
                ),
                child: Column(
                  children: [
                    Container(
                      key: tentangKey,
                      child: TentangCardWidget(),
                    ),
                    const SizedBox(height: 40 * 2.5),

                    Container(
                      key: companyProfileKey,
                      child: CompanyProfileCard(),
                    ),
                    Container(
                      key: testimoniKey,
                      child: TestimoniPage1(),
                    ),
                    const SizedBox(height: 40),
                    ClientSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
