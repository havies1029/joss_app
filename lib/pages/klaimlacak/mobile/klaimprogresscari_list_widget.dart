import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/klaimlacak/klaimnilaicrud_bloc.dart';
// import 'package:joss_app/pages/klaimlacak/klaimnilaicrud_form.dart';
// import 'package:joss_app/pages/klaimlacak/widget/klaim_progress_cari_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimlacak/klaimprogresscari_bloc.dart';
import 'package:joss_app/pages/klaimlacak/mobile/widget/klaim_progress_cari_tile.dart';

import '../../../common/loading_indicator.dart';
import 'klaimnilaicrud_form.dart';

class KlaimprogresscariListWidget extends StatefulWidget {
  final String klaim1Id;
  final String statusDesc;
  const KlaimprogresscariListWidget({super.key, required this.klaim1Id, required this.statusDesc});

  @override
  KlaimprogresscariListWidgetState createState() => KlaimprogresscariListWidgetState();
}

class KlaimprogresscariListWidgetState extends State<KlaimprogresscariListWidget> {
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
    klaimprogresscariBloc = BlocProvider.of<KlaimprogresscariBloc>(context);
    return BlocBuilder<KlaimprogresscariBloc, KlaimprogresscariState>(
      buildWhen: (prev, curr) => prev.status != curr.status || prev.items != curr.items,
      builder: (context, stateProgress) {
        if (stateProgress.status == ListStatus.success && stateProgress.items.isNotEmpty) {

          final showButton = (stateProgress.klaimProgressInfo?.groupStatusId == "20");

          final extra = showButton ? 1 : 0;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            controller: _scrollController,
            itemCount: stateProgress.items.length + extra,
            itemBuilder: (_, index) {
              if (showButton && index == stateProgress.items.length) {
                return BlocSelector<KlaimnilaicrudBloc, KlaimnilaicrudState, bool>(
                    selector: (s) {
                      final groupStatusId = stateProgress.klaimProgressInfo?.groupStatusId ?? '';
                      final klaimProgressNilaiId = (stateProgress.klaimProgressInfo?.klaimNilaiId ?? '').trim();
                      final klaimCrudNilaiId = s.klaimNilaiId.trim();
                      return groupStatusId == "20" && klaimProgressNilaiId.isEmpty && klaimCrudNilaiId.isEmpty;
                    },
                    builder: (context, enabledByBloc) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: AppButton.iconLeft(
                          width: 120,
                          text: 'Masukan',
                          icon: SvgPicture.asset(
                            'assets/icons/masukan.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              primaryLightColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          height: 26,
                          borderRadius: 4,
                          backgroundColor: enabledByBloc ? sYellow : sGrey,
                          textColor: enabledByBloc
                              ? primaryLightColor
                              : const Color(0xFF6B4B10),
                          iconTextSpacing: 4,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          onPressed: () {
                            if (enabledByBloc) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return KlaimnilaicrudFormPage(
                                      klaim1Id: widget.klaim1Id,
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                );
              }

              final curr = stateProgress.items[index];
              final currActive = curr.klaimprogressId.trim().isNotEmpty;
              final nextIsPlaceholder = (index < stateProgress.items.length - 1)
                  ? stateProgress.items[index + 1].klaimprogressId.trim().isEmpty
                  : true;

              final isLastActive = currActive && nextIsPlaceholder;
              final isLastRow = index == stateProgress.items.length - 1;
              return KlaimProgressCariTileWidget(
                item: curr,
                isLast: isLastRow,
                isLastActive: isLastActive,
                isProgressColor : widget.statusDesc,
                infoNilaiKlaim: curr.actioncode.trim().toLowerCase() == 'nilai_klaim' ? stateProgress.nilaiKlaim : null,
                jadwalBayarItems: curr.actioncode.trim().toLowerCase() == 'table_payment' ? stateProgress.jadwalBayar : null,
                klaimProgressInfo: curr.actioncode.trim().toLowerCase() == 'table_payment' ? stateProgress.klaimProgressInfo : null,
              );
            },
          );
        }
        return const Center(
          child: LoadingIndicator(),
        );
      },
    );

  }
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      klaimprogresscariBloc.add(FetchKlaimprogresscariEvent());
    }
  }

}