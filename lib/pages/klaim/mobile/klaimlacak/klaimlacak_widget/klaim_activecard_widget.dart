import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:flutter/material.dart';

import 'klaimlacak_typedata/klaimlacak_image.dart';
import 'klaimlacak_typedata/klaimlacak_jadwal.dart';
import 'klaimlacak_typedata/klaimlacak_nilai.dart';
import 'klaimlacak_typedata/klaimlacak_file.dart';

enum KlaimActivecardAttachmentKind { image, file }

class KlaimActivecardAttachment {
  final String name;
  final String url;
  final KlaimActivecardAttachmentKind kind;
  final VoidCallback? onTap;

  const KlaimActivecardAttachment({
    required this.name,
    required this.url,
    required this.kind,
    this.onTap,
  });
}

class KlaimActivecardPage extends StatelessWidget {
  final String progressNama;
  final String progressDesc;
  final String dateText;

  final String? imageUrl;
  final String? fileUrl;
  final List<KlaimActivecardAttachment> attachments;
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
  final VoidCallback? onOpenImage;
  final VoidCallback? onOpenFile;

  const KlaimActivecardPage({
    super.key,
    required this.progressNama,
    required this.progressDesc,
    required this.dateText,
    required this.imageUrl,
    this.fileUrl,
    this.attachments = const [],
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
    this.onOpenImage,
    this.onOpenFile,
  });

  @override
  Widget build(BuildContext context) {
    const double thumbW = 124;
    const double thumbH = 90;

    final hasThumb = (imageUrl != null && imageUrl!.trim().isNotEmpty);
    final visibleAttachments = attachments.isNotEmpty
        ? attachments
        : [
            if (hasThumb)
              KlaimActivecardAttachment(
                name: 'Lampiran Klaim',
                url: imageUrl!,
                kind: KlaimActivecardAttachmentKind.image,
                onTap: onOpenImage,
              ),
            if (showFile && fileUrl != null && fileUrl!.trim().isNotEmpty)
              KlaimActivecardAttachment(
                name: 'Lampiran Klaim',
                url: fileUrl!,
                kind: KlaimActivecardAttachmentKind.file,
                onTap: onOpenFile,
              ),
          ];

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progressNama,
                style: bodyTextStyle(
                  context,
                  fontSize: getResponsiveFont(context, 16),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateText.isEmpty ? '-' : dateText,
                style: bodyTextStyle(
                  context,
                  fontSize: getResponsiveFont(context, 14),
                ).copyWith(color: hintGrey),
              ),
              const SizedBox(height: 5),
              Text(
                progressDesc,
                softWrap: true,
                style: bodyTextStyle(
                  context,
                  fontSize: getResponsiveFont(context, 14),
                ),
              ),
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
          if (visibleAttachments.isNotEmpty) ...[
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final screenWidth = MediaQuery.sizeOf(context).width;

                final useTwoColumns =
                    screenWidth >= 390 && visibleAttachments.length > 1;

                final widthFactor = useTwoColumns ? 0.48 : 1.0;
                final itemAspectRatio = useTwoColumns ? 1.35 : 2.8;

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: visibleAttachments.map((attachment) {
                    return FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: AspectRatio(
                        aspectRatio: itemAspectRatio,
                        child: attachment.kind == KlaimActivecardAttachmentKind.image
                            ? InkWell(
                          onTap: attachment.onTap,
                          borderRadius: BorderRadius.circular(14),
                          child: KlaimLacakImage(
                            url: attachment.url,
                            headers: headers,
                          ),
                        )
                            : KlaimLacakFile(
                          fileUrl: attachment.url,
                          fileName: attachment.name,
                          onTap: attachment.onTap,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
