import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: primaryBlackColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: pGrey,
              border: Border.all(color: sGrey),
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
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

                SizedBox(
                  height: 263,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: 80,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(color: sGrey, strokeWidth: 0.5);
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, meta) {
                              if (value == 0 ||
                                  value == 20 ||
                                  value == 40 ||
                                  value == 60 ||
                                  value == 80) {
                                return Text(
                                  value.toInt().toString(),
                                  style: bodyTextStyle(
                                    context,
                                    fontSize: 12,
                                  ).copyWith(color: primaryLightColor),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            reservedSize: 28,
                            interval: 20,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, meta) {
                              final idx = value.toInt();
                              if (idx >= 0 && idx < milestones.length) {
                                return Text(
                                  milestones[idx].year,
                                  style: bodyTextStyle(
                                    context,
                                  ).copyWith(color: primaryLightColor),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            reservedSize: 32,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: sGrey, width: 0.5),
                          bottom: BorderSide(color: sGrey, width: 0.5),
                        ),
                      ),
                      barGroups: List.generate(
                        milestones.length,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: milestones[i].value.toDouble(),
                              width: 24,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              color: primaryColor,
                              gradient: LinearGradient(
                                colors: [primaryColor, const Color(0xFFFFB84D)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ],
                        ),
                      ),
                      barTouchData: BarTouchData(enabled: false),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ...milestones.map((m) => _MilestoneTile(m)).toList(),
        ],
      ),
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
