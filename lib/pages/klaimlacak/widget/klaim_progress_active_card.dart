import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:joss_app/pages/klaimlacak/klamlacak_imagethumb.dart';
import 'package:joss_app/pages/klaimlacak/widget/jadwal_bayar_table.dart';
import 'package:joss_app/pages/klaimlacak/widget/metode_ganti_klaim.dart';
import 'package:joss_app/pages/klaimlacak/widget/nilaiklaim_card.dart';
import 'package:flutter/material.dart';

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
    const double gap = 12;

    final hasThumb = (imageUrl != null && imageUrl!.trim().isNotEmpty);

    // padding kanan supaya teks/tabel tidak ketabrak thumbnail
    final rightPad = hasThumb ? (thumbW + gap) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          // ===== Konten utama (full height), tapi diberi padding kanan bila ada thumbnail =====
          Padding(
            padding: EdgeInsets.only(right: rightPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progressNama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dateText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  progressDesc,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                if (showNilaiKlaim && infoNilaiKlaim != null) ...[
                  const SizedBox(height: 12),
                  NilaiKlaimCard(
                    curr: infoNilaiKlaim!.curr,
                    klaimAmount: infoNilaiKlaim!.klaimAmount,
                  ),
                ],

                if (showMetodeGantiKlaim && klaimProgressInfo != null) ...[
                  const SizedBox(height: 10),
                  MetodeGantiKlaimWidget(metodeGantiKlaimId: klaimProgressInfo!.metodeKlaimId ?? ''),
                ],

                if (showJadwalBayar && (jadwalBayarItems?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: 12),
                  JadwalBayarTable(items: jadwalBayarItems!),

                ],
              ],
            ),
          ),

          // ===== Thumbnail (selalu kanan atas), tidak ikut layout Column =====
          if (hasThumb)
            Positioned(
              top: 0,
              right: 0,
              child: KlaimLacakAuthedImageThumb(
                url: imageUrl,
                headers: headers,
                width: thumbW,
                height: thumbH,
              ),
            ),
        ],
      ),
    );
  }
}