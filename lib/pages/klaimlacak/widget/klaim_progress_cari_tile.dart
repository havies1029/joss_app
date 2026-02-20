import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'klaim_progress_active_card.dart';
import 'klaim_progress_placeholder_row.dart';
import 'klaim_progress_timeline.dart';
import 'klaim_progress_tile_styles.dart';

class KlaimProgressCariTileWidget extends StatelessWidget {
  final KlaimprogresscariModel item;
  final bool isLast;
  final bool isLastActive;
  final KlaimProgressNilaiKlaimModel? infoNilaiKlaim;
  final List<KlaimProgressJadwalBayarModel>? jadwalBayarItems;
  final KlaimProgressInfoModel? klaimProgressInfo;

  const KlaimProgressCariTileWidget({
    super.key,
    required this.item,
    required this.isLast,
    required this.isLastActive,
    this.infoNilaiKlaim,
    this.jadwalBayarItems,
    this.klaimProgressInfo,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = item.klaimprogressId.trim().isEmpty;
    final active = !isPlaceholder;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseText = isDark ? Colors.white : Colors.black;

    final dotColor = active ? KlaimProgressTileStyles.dotActive : baseText.withOpacity(0.22);
    final lineColor = baseText.withOpacity(active ? 0.25 : 0.10);

    final headers = <String, String>{
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    final title = item.progressNama.trim().isEmpty ? '(Tanpa Judul)' : item.progressNama.trim();
    final dateText = DateFormat('dd MMM yyyy, HH:mm:ss').format(item.progressTgl);

    final trimmedUrl = item.fileUrl?.trim();
    final imageUrl = (trimmedUrl == null || trimmedUrl.isEmpty) ? null : trimmedUrl;

    final showNilaiKlaim = item.actioncode.trim().toLowerCase() == 'nilai_klaim';

    final showJadwalBayar = item.actioncode.trim().toLowerCase() == 'table_payment';    

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlaimProgressTimeline(
            isLast: isLast,
            isLastActive: isLastActive,
            dotColor: dotColor,
            lineColor: lineColor,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: isPlaceholder
                ? KlaimProgressPlaceholderRow(
                    title: title,
                    baseText: baseText,
                  )
                : KlaimProgressActiveCard(
                    progressNama: title,
                    progressDesc: item.progressDesc,
                    dateText: dateText,
                    imageUrl: imageUrl,
                    headers: headers,
                    cardBg: KlaimProgressTileStyles.cardBg,
                    border: KlaimProgressTileStyles.border(),
                    showNilaiKlaim: showNilaiKlaim,
                    infoNilaiKlaim: infoNilaiKlaim,
                    showJadwalBayar: showJadwalBayar,
                    jadwalBayarItems: jadwalBayarItems,
                    showMetodeGantiKlaim: klaimProgressInfo != null,
                    klaimProgressInfo: klaimProgressInfo,                    
                  ),
          ),
        ],
      ),
    );
  }
}
