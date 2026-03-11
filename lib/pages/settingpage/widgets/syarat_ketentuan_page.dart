import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

class SyaratKetentuanPage extends StatefulWidget {
  const SyaratKetentuanPage({super.key});

  @override
  State<SyaratKetentuanPage> createState() =>
      _SyaratKetentuanPageState();
}

class _SyaratKetentuanPageState extends State<SyaratKetentuanPage> {
  int? expandedIndex = 0;

  final List<_SyaratItem> items = [
    _SyaratItem(
      title: "1. Kepatuhan Regulasi",
      icon: 'assets/icons/syarat_1.svg',
      points: [
        "Kebijakan ini merupakan dokumen hukum yang mengikat dan berlaku untuk seluruh produk serta layanan asuransi yang disediakan Perusahaan.",
        "Seluruh ketentuan telah diselaraskan dengan:",
        "Regulasi Otoritas Jasa Keuangan (OJK) Republik Indonesia",
        "Undang-Undang Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP)",
        "Standar keamanan data kesehatan internasional dan lokal yang berlaku",
      ],
    ),
    _SyaratItem(
      title: "2. Penggunaan Data Pribadi",
      icon: 'assets/icons/syarat_2.svg',
      points: [
        "Data pribadi yang dikumpulkan akan digunakan secara terbatas untuk tujuan:",
        "Proses underwriting dan penilaian risiko asuransi",
        "Administrasi polis dan verifikasi keabsahan klaim",
        "Pemenuhan kewajiban pelaporan kepada otoritas regulator",
        "Peningkatan layanan dan komunikasi terkait manfaat produk kepada nasabah",
      ],
    ),
    _SyaratItem(
      title: "3. Hak Akses dan Kendali Data",
      icon: 'assets/icons/syarat_3.svg',
      points: [
        "Nasabah memiliki hak untuk:",
        "Mengakses dan memperoleh salinan data pribadi yang dikelola Perusahaan",
        "Mengajukan pemutakhiran atau perbaikan data",
        "Menarik persetujuan pemrosesan data (dengan memahami konsekuensi terhadap layanan asuransi)",
      ],
    ),
    _SyaratItem(
      title: "4. Pernyataan Persetujuan",
      icon: 'assets/icons/syarat_4.svg',
      points: [
        "Dengan melanjutkan penggunaan layanan ini, Anda menyatakan telah membaca, memahami, dan menyetujui seluruh Syarat & Ketentuan yang berlaku.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Syarat & Ketentuan",
      child: Container(
        color: secondaryBlackColor,
        padding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pGrey,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  border: Border.all(color: sGrey)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/shield.svg",
                        width: 25,
                        height: 25,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // TEXT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perlindungan Data Asuransi',
                            style: headingStyle(context, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Komitmen kami melindungi data sensitif nasabah asuransi.',
                            style: bodyTextStyle(
                              context,
                              fontSize: 16,
                            ).copyWith(color: hintGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 14),

              _alertWidget(context),

              const SizedBox(height: 14),

              ...List.generate(items.length, (i) {
                final item = items[i];
                final isExpanded = expandedIndex == i;

                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2A2A2A),
                        Color(0xFF1E1E1E),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFF3A3A3A)),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius:
                        BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            expandedIndex =
                            isExpanded ? null : i;
                          });
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: SvgPicture.asset(
                                  item.icon,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: bodyTextStyle(
                                      context,
                                      fontSize: 16)
                                      .copyWith(
                                      fontWeight:
                                      FontWeight
                                          .w600),
                                ),
                              ),
                              Container(
                                width: 34,
                                height: 34,
                                decoration:
                                BoxDecoration(
                                  color: const Color(
                                      0xFF3A3A3A),
                                  borderRadius:
                                  BorderRadius
                                      .circular(8),
                                ),
                                child: AnimatedRotation(
                                  duration:
                                  const Duration(
                                      milliseconds:
                                      250),
                                  turns: isExpanded
                                      ? 0.5
                                      : 0,
                                  child: const Icon(
                                    Icons
                                        .keyboard_arrow_down,
                                    color:
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ClipRect(
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          heightFactor: isExpanded ? 1 : 0,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: isExpanded ? 1 : 0.85,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.points.map((point) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      point,
                                      style: bodyTextStyle(context, fontSize: 14)
                                          .copyWith(color: hintGrey),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alertWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF432C1B),
        // border: Border.all(color: primaryColor),
        borderRadius:
        const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/info.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              primaryColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Perhatian Penting',
                  style: bodyTextStyle(context)
                      .copyWith(
                      color: primaryColor),
                ),
                const SizedBox(height: 4),
                Wrap(
                  children: [
                    Text(
                      'Kebijakan ini berlaku untuk semua produk asuransi dan telah disesuaikan dengan regulasi ',
                      style: bodyTextStyle(context,
                          fontSize: 14)
                          .copyWith(
                          color: hintGrey),
                    ),
                    Text(
                      'Otoritas Jasa Keuangan (OJK)',
                      style: headingStyle(context,
                          fontSize: 14)
                          .copyWith(
                          color: hintGrey),
                    ),
                    Text(
                      ' Indonesia. Mohon baca dengan seksama.',
                      style: bodyTextStyle(context,
                          fontSize: 14)
                          .copyWith(
                          color: hintGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SyaratItem {
  final String title;
  final String icon;
  final List<String> points;

  _SyaratItem({
    required this.title,
    required this.icon,
    required this.points,
  });
}