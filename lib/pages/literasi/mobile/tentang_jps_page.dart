import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

import '../widgets/company_profile_widget.dart';
import '../../../widgets/klien_jps_widget.dart';
import '../widgets/milestone_jps_widget.dart';
import '../widgets/peran_jps_widget.dart';
import '../widgets/tentang_jps_widget.dart';
import '../../../widgets/testimoni_widget.dart';

class TentangJPSPage extends StatefulWidget {
  const TentangJPSPage({super.key});

  @override
  State<TentangJPSPage> createState() => _TentangJPSPageState();
}

class _TentangJPSPageState extends State<TentangJPSPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> sections = [
    'Semua',
    'Tentang',
    'Company Profile',
    'Testimoni',
    'Klien',
  ];

  final Map<String, GlobalKey> sectionKeys = {};

  int selectedChip = 0;

  @override
  void initState() {
    super.initState();
    for (var section in sections) {
      if (section != 'Semua') {
        sectionKeys[section] = GlobalKey();
      }
    }
  }

  void scrollToSection(String section) {
    if (section == 'Semua') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      return;
    }
    final keyContext = sectionKeys[section]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      child: Column(
        children: [
          const SizedBox(height: 1),
          // Chips horizontal
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder:
                    (ctx, i) => ChoiceChip(
                      label: Text(
                        sections[i],
                        style: bodyTextStyle(context, fontSize: 16),
                      ),
                      selected: selectedChip == i,
                      selectedColor: primaryColor,
                      backgroundColor: pGrey,
                      showCheckmark: false,
                      side: BorderSide.none,
                      onSelected: (val) {
                        setState(() => selectedChip = i);
                        scrollToSection(sections[i]);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
              ),
            ),
          ),
          kDivider(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      key: sectionKeys['Sejarah'],
                      child: TentangCardWidget(),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      key: sectionKeys['Company Profile'],
                      child: CompanyProfileCard(
                        onDownload: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Hubungi kami untuk mendapatkan company profile'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      key: sectionKeys['Testimoni'],
                      child: TestimonialSection(),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      key: sectionKeys['Klien'],
                      child: ClientSection(),
                    ),
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
