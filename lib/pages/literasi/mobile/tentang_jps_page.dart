import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/literasi/mobile/testimoni_page.dart';

import '../widgets/company_profile_widget.dart';
import '../../../widgets/klien_jps_widget.dart';
import '../widgets/tentang_jps_widget.dart';
import '../widgets/testimoni_widget2.dart';

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
    "Tentang",
    "Profil Perusahaan",
    "Testimoni",
  ];

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
    }
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            padding: const EdgeInsets.fromLTRB(
              hPadding * 1.5,
              vPadding,
              hPadding * 1.5,
              vPadding,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        chipItems.length,
                            (index) => buildChip(chipItems[index], index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [

                    Container(
                      key: tentangKey,
                      child: TentangCardWidget(),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      key: companyProfileKey,
                      child: CompanyProfileCard(),
                    ),
                    const SizedBox(height: 40),

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