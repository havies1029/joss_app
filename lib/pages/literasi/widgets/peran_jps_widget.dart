import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class PeranJPSWidget extends StatefulWidget {
  const PeranJPSWidget({super.key});

  @override
  State<PeranJPSWidget> createState() => _PeranJPSWidgetState();
}

class _PeranJPSWidgetState extends State<PeranJPSWidget> {
  int? expandedIndex;

  final List<PeranJPS> peranList = [
    PeranJPS(
      title: "Peniaian",
      icon: 'assets/icons/penilaian.svg',
      points: [
        "Mengumpulkan informasi yang relevan dan mendalam",
        "Mengidentifikasi kebutuhan dan potensi risiko klien",
        "Menganalisis kondisi dan eksposur aset yang dimiliki",
        "Menyusun ringkasan data sebagai dasar program asuransi",
      ],
    ),
    PeranJPS(
      title: "Arsitek",
      icon: 'assets/icons/arsitek.svg',
      points: [
        "Merancang syarat dan ketentuan perlindungan.",
        "Menyusun struktur program asuransi secara menyeluruh.",
        "Menempatkan polis ke perusahaan asuransi yang tepat.",
        "Memberikan saran opsi terbaik dan mengelola perpanjangan.",
      ],
    ),
    PeranJPS(
      title: "Konsultan",
      icon: 'assets/icons/konsultan.svg',
      points: [
        "Memberikan rekomendasi strategi perlindungan risiko.",
        "Menjadi pendamping diskusi antara klien dan asuransi.",
        "Menyampaikan hasil analisis risiko secara terbuka.",
        "Membantu pengambilan keputusan berbasis data.",
      ],
    ),
    PeranJPS(
      title: "Pengacara",
      icon: 'assets/icons/pengacara.svg',
      points: [
        "Memberikan masukan hukum demi hasil terbaik.",
        "Menyusun dokumentasi pendukung klaim yang akurat.",
        "Menjaga kelancaran proses klaim agar efisien dan adil.",
        "Membantu negosiasi dengan pihak asuransi.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & subtitle
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/handshake.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 6),
              Text("Peran JPS", style: bodyTextStyle(context, fontSize: 24)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "Broker JPS membawahi empat peran utama.",
            style: bodyTextStyle(context).copyWith(color: hintGrey),
          ),
          const SizedBox(height: 18),
          ...List.generate(peranList.length, (i) {
            final peran = peranList[i];
            final isExpanded = expandedIndex == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: pGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                border: Border.all(color: sGrey),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : i;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Icon
                            Container(
                              width: 34,
                              height: 34,
                              padding: const EdgeInsets.all(6.8),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6.8),
                              ),
                              child: SvgPicture.asset(
                                peran.icon,
                                width: 20.4,
                                height: 20.4,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Title
                            Expanded(
                              child: Text(
                                peran.title,
                                style: bodyTextStyle(context, fontSize: 20),
                              ),
                            ),
                            // Arrow
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 300),
                              turns: isExpanded ? 0.5 : 0.0,
                              child: SvgPicture.asset(
                                'assets/icons/arrow_down.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                        // Expanded content
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 350),
                          crossFadeState:
                              isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(
                              left: 6,
                              top: 12,
                              bottom: 2,
                              right: 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  peran.points
                                      .map(
                                        (point) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "• ",
                                              style: bodyTextStyle(context),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                point,
                                                style: bodyTextStyle(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PeranJPS {
  final String title;
  final String icon;
  final List<String> points;

  PeranJPS({required this.title, required this.icon, required this.points});
}
