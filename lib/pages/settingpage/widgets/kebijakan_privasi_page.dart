import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

class KebijakanPrivasiPage extends StatefulWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  State<KebijakanPrivasiPage> createState() => _KebijakanPrivasiPageState();
}

class _KebijakanPrivasiPageState extends State<KebijakanPrivasiPage> {
  int? expandedIndex = 0;

  final List<_PrivasiItem> items = [
    _PrivasiItem(
      title: "1. Kebijakan Asuransi",
      icon: 'assets/icons/syarat_5.png',
      points: [
        "Aplikasi ini menyediakan layanan informasi dan pengelolaan polis asuransi bagi pengguna.",
        "Setiap proses pembelian polis, pembayaran premi, maupun pengajuan klaim dilakukan sesuai dengan ketentuan dan peraturan yang berlaku di perusahaan asuransi.",
        "Pengguna diwajibkan memberikan data yang benar dan lengkap agar proses layanan dapat berjalan dengan baik.",
      ],
    ),
    _PrivasiItem(
      title: "2. Privasi Nasabah",
      icon: 'assets/icons/syarat_6.svg',
      points: [
        "Kami berkomitmen untuk menjaga kerahasiaan data pribadi nasabah.",
        "Informasi seperti nama, alamat, nomor telepon, email, dan data terkait polis asuransi akan digunakan hanya untuk keperluan layanan asuransi.",
        "Data tersebut akan disimpan dengan aman dan tidak akan dibagikan kepada pihak lain tanpa persetujuan nasabah, kecuali jika diwajibkan oleh peraturan yang berlaku.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kebijakan & Privasi",
      child: Container(
        color: secondaryBlackColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER CARD
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pGrey,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  border: Border.all(color: sGrey),
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

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kebijakan dan Privasi Asuransi',
                            style: headingStyle(context, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Komitmen kami melindungi data dan layanan nasabah asuransi.',
                            style: bodyTextStyle(
                              context,
                              fontSize: 16,
                            ).copyWith(color: hintGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              /// ALERT
              _alertWidget(context),

              const SizedBox(height: 14),

              /// ACCORDION
              ...List.generate(items.length, (i) {
                final item = items[i];
                final isExpanded = expandedIndex == i;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2A2A2A),
                        Color(0xFF1E1E1E),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Column(
                    children: [

                      /// HEADER
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : i;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [

                              /// ICON
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: item.icon.toLowerCase().endsWith('.png')
                                    ? Image.asset(
                                  item.icon,
                                  fit: BoxFit.contain,
                                )
                                    : SvgPicture.asset(
                                  item.icon,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Text(
                                  item.title,
                                  style: bodyTextStyle(context, fontSize: 16)
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),

                              /// ARROW
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 250),
                                turns: isExpanded ? 0.5 : 0,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// CONTENT
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
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perhatian Penting',
                  style: bodyTextStyle(context)
                      .copyWith(color: primaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kebijakan ini berlaku untuk seluruh layanan asuransi yang tersedia di aplikasi. Mohon membaca dengan seksama agar pengguna memahami hak, kewajiban, serta ketentuan yang berlaku.',
                  style: bodyTextStyle(context, fontSize: 14)
                      .copyWith(color: hintGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivasiItem {
  final String title;
  final String icon;
  final List<String> points;

  _PrivasiItem({
    required this.title,
    required this.icon,
    required this.points,
  });
}