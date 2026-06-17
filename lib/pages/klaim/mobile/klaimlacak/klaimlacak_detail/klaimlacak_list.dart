import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:joss_app/blocs/klaimlacak/klaimnilaicrud_bloc.dart';
import 'package:joss_app/blocs/klaimlacak/klaimprogresscari_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';

import '../../klaimnilai/klaimnilai_page.dart';
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
  State<KlaimLacakList> createState() =>
      _KlaimLacakListState();
}

class _KlaimLacakListState
    extends State<KlaimLacakList> {
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
    klaimprogresscariBloc =
        context.read<KlaimprogresscariBloc>();

    return BlocBuilder<
        KlaimprogresscariBloc,
        KlaimprogresscariState>(
      buildWhen: (prev, curr) =>
      prev.status != curr.status ||
          prev.items != curr.items ||
          prev.nilaiKlaim != curr.nilaiKlaim ||
          prev.jadwalBayar != curr.jadwalBayar ||
          prev.klaimProgressInfo != curr.klaimProgressInfo,
      builder: (context, state) {
        if (state.status == ListStatus.success &&
            state.items.isNotEmpty) {
          return _buildSuccessList(state);
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
            ? DateFormat('dd MMM yyyy, HH:mm:ss').format(item.progressTgl!)
            : '';

        final trimmedUrl = item.fileUrl?.trim();
        final imageUrl =
        trimmedUrl == null || trimmedUrl.isEmpty ? null : trimmedUrl;

        final showNilaiKlaim = actionCode == 'nilai_klaim';
        final showJadwalBayar = actionCode == 'table_payment';
        final showFile = actionCode == 'file';

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
                  imageUrl: imageUrl,
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
                  klaimProgressInfo: showJadwalBayar
                      ? state.klaimProgressInfo
                      : null,
                  showFile: showFile,
                  onOpenFile: showFile
                      ? () {
                    // nanti bisa open browser / webview / download
                  }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputButton(
      KlaimprogresscariState state) {
    return BlocSelector<
        KlaimnilaicrudBloc,
        KlaimnilaicrudState,
        bool>(
      selector: (s) {
        final groupStatusId =
            state.klaimProgressInfo?.groupStatusId ??
                '';

        final progressNilaiId =
        (state.klaimProgressInfo
            ?.klaimNilaiId ??
            '')
            .trim();

        final crudNilaiId =
        s.klaimNilaiId.trim();

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
            backgroundColor:
            enabled ? sYellow : sGrey,
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
                  builder: (_) =>
                      KlaimNilaiPage(
                        klaim1Id:
                        widget.klaim1Id,
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
        _scrollController
            .position.maxScrollExtent -
            120) {
      klaimprogresscariBloc.add(
        FetchKlaimprogresscariEvent(),
      );
    }
  }
}