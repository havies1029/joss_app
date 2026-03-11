import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';

class TentangCardWidget extends StatefulWidget {
  const TentangCardWidget({super.key});

  @override
  State<TentangCardWidget> createState() => _TentangCardWidgetState();
}

class _TentangCardWidgetState extends State<TentangCardWidget> {
  bool expanded = false;

  static const String deskripsi =
      "JPS (PT. Jaya Proteksindo Sakti) adalah broker asuransi berpengalaman yang berdiri sejak 2 Januari 2001. Kami berkomitmen untuk menghadirkan solusi perlindungan terbaik melalui keputusan strategis, layanan profesional, serta pendampingan menyeluruh bagi setiap klien.\n\n"
      "Sebagai konsultan dan fasilitator, JPS membantu merancang kebutuhan asuransi khusus agar klien memperoleh manfaat maksimal berupa perlindungan luas, harga kompetitif, dan kemudahan dalam proses klaim.\n\n"
      "Fokus layanan kami mencakup penempatan asuransi umum seperti properti, manfaat karyawan, mesin, rekayasa (engineering), konstruksi, kendaraan bermotor, pengangkutan laut (marine cargo), penerbangan, kredit perdagangan, serta produk asuransi khusus lainnya.\n\n"
      "Sebagai bukti legalitas dan kepercayaan, JPS telah memiliki izin usaha dari Otoritas Jasa Keuangan (OJK) berdasarkan Keputusan Menteri Keuangan No. 431/KM.17/2000.";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/jps_header_literasi.png",
            fit: BoxFit.cover,
            height: 132,
            width: double.infinity,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;

              if (frame == null) {
                return Container(
                  height: 132,
                  width: double.infinity,
                  color: secondaryBlackColor,
                  child: const Center(
                    child: LoadingIndicator(),
                  ),
                );
              }

              return child;
            },
          ),
        ),
        const SizedBox(height: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/verified.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 5),
                Text(
                  "Asuransi Terpercaya",
                  style: bodyTextStyle(
                    context,
                    fontSize: 20,
                  ).copyWith(color: pGreen),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // Company Name
            Text(
              "PT Jaya Proteksindo Sakti",
              style: headingStyle(context, fontSize: 22),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/website.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  "Broker Terpercaya di ",
                  style: bodyTextStyle(context, fontSize: 16),
                ),
                Text(
                  "Indonesia",
                  style: inputTextStyle(context).copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Rating
            Row(
              children: [
                ...List.generate(
                  4,
                  (i) => const Icon(Icons.star, color: Colors.amber, size: 15),
                ),
                const Icon(Icons.star_half, color: Colors.amber, size: 15),
                const SizedBox(width: 5),
                Text("4.5/5.0", style: bodyTextStyle(context, fontSize: 14)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Card
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: pGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                border: Border.all(color: sGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: hPadding,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deskripsi Perusahaan",
                      style: headingStyle(context, fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 400),
                      firstChild: _buildTrimmedText(),
                      secondChild: _buildFullText(),
                      crossFadeState:
                          expanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                    ),
                    const SizedBox(height: hPadding),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton.adaptive(
                        text: expanded ? "Lebih Sedikit" : "Lihat Semua",
                        icon: SvgPicture.asset(
                          expanded
                              ? 'assets/icons/arrow_up.svg'
                              : 'assets/icons/arrow_down.svg',
                          width: 20,
                          height: 20,
                        ),
                        iconLeft: false,
                        textStyle: bodyTextStyle(context).copyWith(
                          fontSize: 18,
                        ),
                        iconTextSpacing: 6,
                        onPressed: () => setState(() => expanded = !expanded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrimmedText() {
    return Text(
      deskripsi,
      maxLines: 12,
      overflow: TextOverflow.ellipsis,
      style: bodyTextStyle(context),
    );
  }

  Widget _buildFullText() {
    return Text(deskripsi, style: bodyTextStyle(context));
  }
}
