import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
// import 'package:joss_app/pages/klaimlacak/klamlacak_imagethumb.dart';
// import 'package:joss_app/pages/klaimlacak/widget/jadwal_bayar_table.dart';
// import 'package:joss_app/pages/klaimlacak/widget/metode_ganti_klaim.dart';
// import 'package:joss_app/pages/klaimlacak/widget/nilaiklaim_card.dart';
import 'package:flutter/material.dart';

import '../klamlacak_imagethumb.dart';
import 'jadwal_bayar_table.dart';
import 'metode_ganti_klaim.dart';
import 'nilaiklaim_card.dart';

class KlaimProgressActiveCard extends StatelessWidget {
  final String progressNama;
  final String progressDesc;
  final String dateText;

  final String? imageUrl;
  final Map<String, String> headers;

  final Color cardBg;
  final Color border;

  final bool showNilaiKlaim;
  final KlaimProgressNilaiKlaimModel? infoNilaiKlaim;

  final bool showJadwalBayar;
  final List<KlaimProgressJadwalBayarModel>? jadwalBayarItems;

  final bool showMetodeGantiKlaim;
  final KlaimProgressInfoModel? klaimProgressInfo;

  const KlaimProgressActiveCard({
    super.key,
    required this.progressNama,
    required this.progressDesc,
    required this.dateText,
    required this.imageUrl,
    required this.headers,
    required this.cardBg,
    required this.border,
    required this.showNilaiKlaim,
    required this.infoNilaiKlaim,
    required this.showJadwalBayar,
    required this.jadwalBayarItems,
    required this.showMetodeGantiKlaim,
    required this.klaimProgressInfo,
  });

  @override
  Widget build(BuildContext context) {
    const double thumbW = 108;
    const double thumbH = 78;

    final hasThumb = (imageUrl != null && imageUrl!.trim().isNotEmpty);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ===== Row: info teks + thumbnail =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Kolom kiri: teks + metode ganti klaim
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progressNama,
                      style: bodyTextStyle(context, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateText,
                      style: bodyTextStyle(context, fontSize: 14)
                          .copyWith(color: hintGrey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      progressDesc,
                      softWrap: true,
                      style: bodyTextStyle(context, fontSize: 14),
                    ),
                    if (showMetodeGantiKlaim && klaimProgressInfo != null) ...[
                      const SizedBox(height: 10),
                      MetodeGantiKlaimWidget(
                        metodeGantiKlaimId:
                        klaimProgressInfo!.metodeKlaimId ?? '',
                      ),
                    ],
                  ],
                ),
              ),

              // Thumbnail (kanan atas)
              if (hasThumb) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: thumbW,
                  height: thumbH,
                  child: KlaimLacakAuthedImageThumb(
                    url: imageUrl,
                    headers: headers,
                    width: thumbW,
                    height: thumbH,
                  ),
                ),
              ],
            ],
          ),

          // ===== Nilai Klaim =====
          if (showNilaiKlaim && infoNilaiKlaim != null) ...[
            const SizedBox(height: 12),
            NilaiKlaimCard(
              curr: infoNilaiKlaim!.curr,
              klaimAmount: infoNilaiKlaim!.klaimAmount,
            ),
          ],

          // ===== Jadwal Bayar =====
          if (showJadwalBayar && (jadwalBayarItems?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 12),
            JadwalBayarTable(items: jadwalBayarItems!),
          ],
        ],
      ),
    );
  }
}