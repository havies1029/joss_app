import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:flutter/material.dart';

import 'klaimlacak_typedata/klaimlacak_image.dart';
import 'klaimlacak_typedata/klaimlacak_jadwal.dart';
import 'klaimlacak_typedata/klaimlacak_nilai.dart';
import 'klaimlacak_typedata/klaimlacak_file.dart';

class KlaimActivecardPage extends StatelessWidget {
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

  final bool showFile;
  final VoidCallback? onOpenFile;

  const KlaimActivecardPage({
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
    required this.showFile,
    this.onOpenFile,
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

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progressNama,
                      style: bodyTextStyle(context, fontSize: getResponsiveFont(context, 16)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateText.isEmpty ? '-' : dateText,
                      style: bodyTextStyle(context, fontSize: getResponsiveFont(context,14))
                          .copyWith(color: hintGrey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      progressDesc,
                      softWrap: true,
                      style: bodyTextStyle(context, fontSize: getResponsiveFont(context, 14)),
                    ),

                  ],
                ),
              ),

              if (hasThumb) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: thumbW,
                  height: thumbH,
                  child: KlaimLacakImage(
                    url: imageUrl,
                    headers: headers,
                    width: thumbW,
                    height: thumbH,
                  ),
                ),
              ],
            ],
          ),

          if (showNilaiKlaim && infoNilaiKlaim != null) ...[
            const SizedBox(height: 12),
            KlaimLacakNilai(
              curr: infoNilaiKlaim!.curr,
              klaimAmount: infoNilaiKlaim!.klaimAmount,
            ),
          ],

          if (showJadwalBayar && (jadwalBayarItems?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 12),
            KlaimLacakJadwal(items: jadwalBayarItems!),
          ],

          if (showFile && imageUrl != null && imageUrl!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            KlaimLacakFile(
              fileUrl: imageUrl!,
              onTap: onOpenFile,
            ),
          ],
        ],
      ),
    );
  }
}