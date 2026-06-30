import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:joss_app/blocs/klaimlacak/klaimnilaicrud_bloc.dart';
import 'package:joss_app/blocs/klaimlacak/klaimprogresscari_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/models/klaimlacak/klaim_lacak_attachment_item.dart';
import 'package:joss_app/pages/klaimlacak/mobile/klaimnilaicrud_form.dart';

import '../klaimlacak_file/klaim_lacak_attachment_preview_page.dart';
import '../klaimlacak_widget/klaim_activecard_widget.dart';
import '../klaimlacak_widget/klaim_placeholder_widget.dart';
import '../klaimlacak_widget/klaim_timeline_widget.dart';

class KlaimLacakList extends StatefulWidget {
  final String klaim1Id;
  final String statusDesc;

  const KlaimLacakList({
    super.key,
    required this.klaim1Id,
    required this.statusDesc,
  });

  @override
  State<KlaimLacakList> createState() => _KlaimLacakListState();
}

class _KlaimLacakListState extends State<KlaimLacakList> {
  late KlaimprogresscariBloc klaimprogresscariBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    klaimprogresscariBloc = context.read<KlaimprogresscariBloc>();

    return BlocBuilder<KlaimprogresscariBloc, KlaimprogresscariState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.items != curr.items ||
          prev.nilaiKlaim != curr.nilaiKlaim ||
          prev.jadwalBayar != curr.jadwalBayar ||
          prev.klaimProgressInfo != curr.klaimProgressInfo,
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text(
                'Data progress klaim tidak ditemukan.',
                style: TextStyle(color: primaryLightColor),
              ),
            );
          }

          return _buildSuccessList(state);
        }

        if (state.status == ListStatus.failure) {
          return const Center(
            child: Text(
              'Gagal memuat progress klaim.',
              style: TextStyle(color: primaryLightColor),
            ),
          );
        }

        return const Center(
          child: LoadingIndicator(),
        );
      },
    );
  }

  Widget _buildSuccessList(KlaimprogresscariState state) {
    final showButton = state.klaimProgressInfo?.groupStatusId == "20";
    final extra = showButton ? 1 : 0;

    final lastActiveIndex = state.items.lastIndexWhere(
      (e) => e.klaimprogressId.trim().isNotEmpty,
    );

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: state.items.length + extra,
      itemBuilder: (_, index) {
        if (showButton && index == state.items.length) {
          return _buildInputButton(state);
        }

        final item = state.items[index];
        final isPlaceholder = item.klaimprogressId.trim().isEmpty;
        final active = !isPlaceholder;

        final isLast = index == state.items.length - 1;
        final isLastActive = active && index == lastActiveIndex;

        final actionCode = item.actioncode.trim().toLowerCase();

        final baseText = primaryLightColor;
        final dotColor = active ? hintGrey : sGrey;
        final lineColor = sGrey;

        final headers = <String, String>{
          'Authorization': 'Bearer ${AppData.userToken}',
        };

        final title = item.progressNama.trim().isEmpty
            ? '(Tanpa Judul)'
            : item.progressNama.trim();

        final dateText = item.progressTgl != null
            ? DateFormat('dd MMM yyyy').format(item.progressTgl!)
            : '';

        final attachments = _buildAttachments(item, headers);

        final showNilaiKlaim = actionCode == 'nilai_klaim';
        final showJadwalBayar = actionCode == 'table_payment';

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlaimTimelineWidget(
                isProgressColor: widget.statusDesc,
                isLast: isLast,
                isLastActive: isLastActive,
                dotColor: dotColor,
                lineColor: lineColor,
              ),
              const SizedBox(width: hPadding),
              Expanded(
                child: isPlaceholder
                    ? KlaimPlaceholderWidget(
                        title: title,
                        baseText: baseText,
                      )
                    : KlaimActivecardPage(
                        progressNama: title,
                        progressDesc: item.progressDesc,
                        dateText: dateText,
                        imageUrl: null,
                        attachments: attachments,
                        headers: headers,
                        cardBg: pGrey,
                        border: sGrey,
                        showNilaiKlaim: showNilaiKlaim,
                        infoNilaiKlaim:
                            showNilaiKlaim ? state.nilaiKlaim : null,
                        showJadwalBayar: showJadwalBayar,
                        jadwalBayarItems:
                            showJadwalBayar ? state.jadwalBayar : null,
                        showMetodeGantiKlaim:
                            showJadwalBayar && state.klaimProgressInfo != null,
                        klaimProgressInfo:
                            showJadwalBayar ? state.klaimProgressInfo : null,
                        showFile: attachments.isNotEmpty,
                        fileUrl: null,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputButton(KlaimprogresscariState state) {
    return BlocSelector<KlaimnilaicrudBloc, KlaimnilaicrudState, bool>(
      selector: (s) {
        final groupStatusId = state.klaimProgressInfo?.groupStatusId ?? '';

        final progressNilaiId =
            (state.klaimProgressInfo?.klaimNilaiId ?? '').trim();

        final crudNilaiId = s.klaimNilaiId.trim();

        return groupStatusId == '20' &&
            progressNilaiId.isEmpty &&
            crudNilaiId.isEmpty;
      },
      builder: (context, enabled) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AppButton.iconLeft(
            text: 'Masukan',
            width: 120,
            height: 26,
            borderRadius: 4,
            backgroundColor: enabled ? sYellow : sGrey,
            icon: SvgPicture.asset(
              'assets/icons/masukan.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                primaryLightColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: enabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KlaimnilaicrudFormPage(
                          klaim1Id: widget.klaim1Id,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120) {
      klaimprogresscariBloc.add(
        FetchKlaimprogresscariEvent(),
      );
    }
  }

  String _fileNameFromItem(String? name, String? url) {
    final itemName = (name ?? '').trim();
    if (itemName.isNotEmpty) return itemName;

    final value = (url ?? '').trim();
    if (value.isEmpty) return 'Lampiran Klaim';

    final path = Uri.tryParse(value)?.path;
    final fallbackName = (path == null || path.isEmpty)
        ? value.split('/').last
        : path.split('/').last;

    return fallbackName.trim().isEmpty ? 'Lampiran Klaim' : fallbackName;
  }

  KlaimAttachmentKind _attachmentKindFromName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.pdf')) return KlaimAttachmentKind.pdf;
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp')) {
      return KlaimAttachmentKind.image;
    }
    return KlaimAttachmentKind.file;
  }

  List<KlaimActivecardAttachment> _buildAttachments(
    dynamic item,
    Map<String, String> headers,
  ) {
    final List<dynamic> sourceFiles = item.listFile.isNotEmpty
        ? (List<dynamic>.of(item.listFile)
          ..sort((a, b) {
            final aOrder = a.noUrut ?? 0;
            final bOrder = b.noUrut ?? 0;
            return aOrder.compareTo(bOrder);
          }))
        : [];

    if (sourceFiles.isEmpty) {
      final attachment = _buildAttachment(
        name: null,
        url: item.fileUrl,
        headers: headers,
      );
      return attachment == null ? [] : [attachment];
    }

    return sourceFiles
        .map(
          (file) => _buildAttachment(
            name: file.keterangan,
            url: file.fileUrl,
            headers: headers,
          ),
        )
        .whereType<KlaimActivecardAttachment>()
        .toList();
  }

  KlaimActivecardAttachment? _buildAttachment({
    required String? name,
    required String? url,
    required Map<String, String> headers,
  }) {
    final trimmedUrl = url?.trim();
    if (trimmedUrl == null || trimmedUrl.isEmpty) return null;

    final fileName = _fileNameFromItem(name, trimmedUrl);
    final fileKind = _attachmentKindFromName(fileName);
    final activecardKind = fileKind == KlaimAttachmentKind.image
        ? KlaimActivecardAttachmentKind.image
        : KlaimActivecardAttachmentKind.file;

    return KlaimActivecardAttachment(
      name: fileName,
      url: trimmedUrl,
      kind: activecardKind,
      onTap: () => openKlaimLacakAttachmentPreview(
        context,
        KlaimLacakAttachmentItem(
          name: fileName,
          source: trimmedUrl,
          sourceType: KlaimAttachmentSourceType.url,
          kind: fileKind,
          headers: headers,
        ),
      ),
    );
  }
}
