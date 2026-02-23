import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class MilestoneJPSWidget extends StatelessWidget {
  MilestoneJPSWidget({super.key});

  final List<_Milestone> milestones = [
    _Milestone(
      year: "2001",
      value: 15,
      title: "Awal Berdiri",
      desc:
          "JPS didirikan sebagai perusahaan asuransi dengan fokus pada pelayanan cepat, mudah, dan jelas.",
    ),
    _Milestone(
      year: "2016",
      value: 25,
      title: "ISO 9001",
      desc:
          "Meraih sertifikasi ISO 9001 sebagai standar internasional sistem manajemen mutu.",
      highlight: "ISO 9001",
    ),
    _Milestone(
      year: "2019",
      value: 35,
      title: "Akselerasi Bisnis",
      desc:
          "Menjadi tonggak percepatan pertumbuhan bisnis dengan ekspansi di berbagai lini layanan.",
    ),
    _Milestone(
      year: "2023",
      value: 50,
      title: "Pemulihan & Pertumbuhan",
      desc:
          "Basis klien tumbuh pesat, bisnis bangkit, dan nilai klaim tembus 500 miliar.",
      highlight: "500 miliar",
    ),
    _Milestone(
      year: "2024",
      value: 65,
      title: "Proyek BUMN & ISO 27001:2022",
      desc:
          "Mendapat proyek BUMN, sertifikasi ISO 27001:2022 untuk keamanan & manajemen risiko, serta terdaftar di seluruh Himbara.",
      highlight: "ISO 27001:2022",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 10,
            top: 26,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              Text(
                "Timeline Pencapaian JPS",
                style: bodyTextStyle(
                  context,
                  fontSize: 22,
                ).copyWith(color: primaryLightColor),
              ),
              const SizedBox(height: 2),
              Text(
                "2001 - 2024",
                style: bodyTextStyle(
                  context,
                ).copyWith(color: primaryLightColor),
              ),
              const SizedBox(height: 28),

              SvgPicture.asset(
                'assets/icons/Milestone.svg',
                height: 325,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        ...milestones.map((m) => _MilestoneTile(m)),
      ],
    );
  }
}

class _Milestone {
  final String year;
  final double value;
  final String title;
  final String desc;
  final String? highlight;

  _Milestone({
    required this.year,
    required this.value,
    required this.title,
    required this.desc,
    this.highlight,
  });
}

class _MilestoneTile extends StatelessWidget {
  final _Milestone m;
  const _MilestoneTile(this.m);

  @override
  Widget build(BuildContext context) {
    final descParts =
        m.highlight != null && m.desc.contains(m.highlight!)
            ? m.desc.split(m.highlight!)
            : [m.desc];

    return Container(
      margin: EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4, right: 12),
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${m.year} - ${m.title}', style: bodyTextStyle(context)),
                const SizedBox(height: 9),

                m.highlight == null
                    ? Text(
                      m.desc,
                      style: bodyTextStyle(
                        context,
                        fontSize: 16,
                      ).copyWith(color: hintGrey),
                    )
                    : RichText(
                      text: TextSpan(
                        style: bodyTextStyle(
                          context,
                          fontSize: 16,
                        ).copyWith(fontFamily: 'Delm-Regular', color: hintGrey),
                        children: [
                          TextSpan(text: descParts[0]),
                          TextSpan(
                            text: m.highlight!,
                            style: bodyTextStyle(
                              context,
                              fontSize: 16,
                            ).copyWith(color: primaryColor),
                          ),
                          if (descParts.length > 1)
                            TextSpan(text: descParts[1]),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
