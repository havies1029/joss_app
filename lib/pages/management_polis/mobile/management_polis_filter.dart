import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/gen_cob_app/button_group_cob_aset.dart';
import 'package:joss_app/pages/gen_status_aset/button_group_status_aset.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../blocs/loading_flow/loading_flow_bloc.dart';
import '../../../common/loading_indicator.dart';
import '../../../helper/expert_helper.dart';
import '../../../helper/mobile_expert_helper.dart';
import '../../../helper/share_position_origin_helper.dart';
import '../../../widgets/EmptyStateWidget.dart';
import '../../../widgets/apptheme/polis_button.dart';
import '../../../widgets/apptheme/popup_widget.dart';
import 'cob_polis/health/health_cob_table.dart';
import 'cob_polis/hull/hull_cob_table.dart';
import 'cob_polis/others/kargo_cob_table.dart';
import 'cob_polis/kendaraan/kendaraan_cob_table.dart';
import 'cob_polis/properti/property_cob_table.dart';
import 'cob_polis/ringkasan_cob_table.dart';

class ManagementPolisFilter extends StatefulWidget {
  const ManagementPolisFilter({super.key});

  @override
  State<ManagementPolisFilter> createState() => _ManagementPolisFilterState();
}

class _ManagementPolisFilterState extends State<ManagementPolisFilter> {
  final TextEditingController _searchController = TextEditingController();
  bool _bootstrapped = false;

  String _cobId() => context.read<CobManPolBloc>().state.selectedCOBId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrapped = true;
      context.read<CobManPolBloc>().add(RefreshCobManPolEvent());
      context.read<StatusAsetCariBloc>().add(RefreshStatusAsetCariEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _hintByCob(String cobId, String statusCobId) {
    switch (cobId) {
      case "10002":
        return statusCobId == "10002"
            ? "No Proses/No Polis/Tertanggung"
            : "No Polis/Tertanggung";

      case "10003":
        return statusCobId == "10002"
            ? "No Proses/No Polis/Tertanggung"
            : "No Polis/Tertanggung";

      case "10004":
        return statusCobId == "10002"
            ? "No Proses/No Polis/Tertanggung"
            : "No Polis/Tertanggung";

      case "10005":
        return statusCobId == "10002"
            ? "No Proses/No Polis/Tertanggung"
            : "No Polis/Tertanggung";

      default:
        return statusCobId == "10002"
            ? "No Proses/No Polis/Tertanggung"
            : "No Polis/Tertanggung";
    }
  }

  // String _hintByCob(String cobId, String statusCobId) {
  //   switch (cobId) {
  //     case "10002":
  //       return "Tertanggung/No Polis";
  //
  //     case "10003":
  //       return "Tertanggung/No Polis/Merk";
  //
  //     case "10004":
  //       return "No Polis/Tertanggung";
  //
  //     case "10005":
  //       return "No Polis/Tertanggung";
  //
  //     default:
  //       return "No Polis/Tertanggung";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MultiBlocListener(
          listeners: [
            BlocListener<CobManPolBloc, CobManPolState>(
              listenWhen: (prev, curr) =>
                  prev.status != curr.status ||
                  prev.items != curr.items ||
                  prev.selectedCOBId != curr.selectedCOBId,
              listener: (context, state) {
                if (state.status == ListStatus.success &&
                    state.selectedCOBId.isEmpty &&
                    state.items.isNotEmpty) {
                  context
                      .read<CobManPolBloc>()
                      .add(SelectCobButton(state.items.first.mCobApp1Id));
                  return;
                }

                if (!_bootstrapped) return;
                if (state.selectedCOBId.isNotEmpty) refreshData();
              },
            ),
            BlocListener<StatusAsetCariBloc, StatusAsetCariState>(
              listenWhen: (prev, curr) =>
                  prev.status != curr.status ||
                  prev.items != curr.items ||
                  prev.selectedStatusId != curr.selectedStatusId,
              listener: (context, state) {
                if (state.status == ListStatus.success &&
                    state.selectedStatusId.isEmpty &&
                    state.items.isNotEmpty) {
                  final allowedIds = {"10001", "10002", "10003", "10004"};
                  final selected = state.items.firstWhere(
                    (item) => allowedIds.contains(item.mstatusasetId),
                    orElse: () => state.items.first,
                  );

                  context
                      .read<StatusAsetCariBloc>()
                      .add(SelectStatusAsetButton(selected.mstatusasetId));
                  return;
                }

                if (!_bootstrapped) return;
                refreshData();
              },
            ),
          ],
          child: Builder(builder: _buildContent),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final cobState = context.watch<CobManPolBloc>().state;
    final statusState = context.watch<StatusAsetCariBloc>().state;
    final flowState = context.watch<LoadingFlowBloc>().state;
    final cobId = cobState.selectedCOBId;
    final statusId = statusState.selectedStatusId;
    final targetStatus = _targetStatus(context, cobId);
    final targetEmpty = _targetIsEmpty(context, cobId);

    final isMasterLoading =
        _isListLoading(cobState.status) || _isListLoading(statusState.status);
    final isSelectionWaiting = cobState.status == ListStatus.success &&
        statusState.status == ListStatus.success &&
        (cobId.trim().isEmpty || statusId.trim().isEmpty);
    final isTargetLoading = _isListLoading(targetStatus);
    final isFlowLoading = flowState.status == LoadingFlowStatus.loading;

    if (isMasterLoading ||
        isSelectionWaiting ||
        isTargetLoading ||
        isFlowLoading) {
      return _fullState(const LoadingIndicator());
    }

    if (cobState.status == ListStatus.failure ||
        statusState.status == ListStatus.failure ||
        targetStatus == ListStatus.failure) {
      return _fullState(const Text('Failed to fetch data'));
    }

    if (targetStatus == ListStatus.success && targetEmpty) {
      return _fullState(EmptyStateWidget(statusId: statusId));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        _buildBodyByCob(context, cobState),
      ],
    );
  }

  bool _isListLoading(ListStatus status) {
    return status == ListStatus.initial || status == ListStatus.loadingMore;
  }

  Widget _fullState(Widget child) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.55,
      color: secondaryBlackColor,
      child: Center(child: child),
    );
  }

  ListStatus _targetStatus(BuildContext context, String cobId) {
    switch (cobId) {
      case "10001":
        return context.watch<AsetRingkasanCariBloc>().state.status;
      case "10002":
        return context.watch<AsetParCariBloc>().state.status;
      case "10003":
        return context.watch<AsetMvCariBloc>().state.status;
      case "10004":
        return context.watch<AsethullCariBloc>().state.status;
      case "10005":
        return context.watch<AsetHealthCariBloc>().state.status;
      default:
        if (cobId.trim().isEmpty) return ListStatus.initial;
        return context.watch<AsetothersCariBloc>().state.status;
    }
  }

  bool _targetIsEmpty(BuildContext context, String cobId) {
    switch (cobId) {
      case "10001":
        return context.watch<AsetRingkasanCariBloc>().state.items.isEmpty;
      case "10002":
        return context.watch<AsetParCariBloc>().state.items.isEmpty;
      case "10003":
        return context.watch<AsetMvCariBloc>().state.items.isEmpty;
      case "10004":
        return context.watch<AsethullCariBloc>().state.items.isEmpty;
      case "10005":
        return context.watch<AsetHealthCariBloc>().state.items.isEmpty;
      default:
        if (cobId.trim().isEmpty) return true;
        return context.watch<AsetothersCariBloc>().state.items.isEmpty;
    }
  }

  Widget _buildHeader(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(cardBorderRadius2),
        topRight: Radius.circular(cardBorderRadius2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: hPadding * 1.5,
          vertical: hPadding,
        ),
        decoration: const BoxDecoration(
          color: secondaryBlackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cardBorderRadius2),
            topRight: Radius.circular(cardBorderRadius2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ButtonGroupCobAsetWidget(),
            const SizedBox(height: hPadding),
            BlocSelector<CobManPolBloc, CobManPolState, String>(
              selector: (state) => state.selectedCOBId,
              builder: (context, selectedCobId) {
                final selectedStatusCobId =
                    context.watch<StatusAsetCariBloc>().state.selectedStatusId;

                final hideSearch = selectedCobId == "10001";

                return Row(
                  mainAxisAlignment: hideSearch
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!hideSearch) ...[
                      Expanded(
                        child: ListPageFilterBarUIWidget(
                          searchController: _searchController,
                          searchButton: buildSearchButton(),
                          hintText: _hintByCob(
                            selectedCobId,
                            selectedStatusCobId,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    PolisButton(
                      assetPath: "assets/icons/unduh.svg",
                      bgColor: bGrey,
                      borderColor: bdGrey,
                      onTap: () => _showExportDialog(context),
                      iconSize: 16,
                      height: 36,
                      width: 36,
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (shareButtonContext) {
                        return PolisButton(
                          assetPath: "assets/icons/bagikan.svg",
                          bgColor: bBlue,
                          borderColor: bdBlue,
                          onTap: () => _onShare(shareButtonContext),
                          iconSize: 16,
                          height: 36,
                          width: 36,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: hPadding),
            const ButtonGroupStatusAsetWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyByCob(BuildContext context, CobManPolState state) {
    if (state.status == ListStatus.initial) {
      return const Center(child: LoadingIndicator());
    }
    if (state.status == ListStatus.failure) {
      return const Center(child: Text('Failed to fetch data'));
    }
    if (state.items.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    final cobId = state.selectedCOBId;

    switch (cobId) {
      case "10001":
        return SizedBox(height: 400, child: _buildRingkasanTable(context));
      case "10002":
        return SizedBox(height: 400, child: _buildParTable(context));
      case "10003":
        return SizedBox(height: 400, child: _buildMvTable(context));
      case "10004":
        return SizedBox(height: 400, child: _buildHullTable(context));
      case "10005":
        return SizedBox(height: 400, child: _buildHealthTable(context));
      default:
        // selain 10001-10005 => Others/Kargo
        return SizedBox(height: 400, child: _buildOthersTable(context));
    }
  }

  // --------------------------
  // Shared guard: loading/fail/empty
  // --------------------------
  Widget _guardList({
    required ListStatus status,
    required bool isEmpty,
    required String statusId,
    required Widget child,
  }) {
    if (status == ListStatus.initial || status == ListStatus.loadingMore) {
      return const Center(child: LoadingIndicator());
    }
    if (status == ListStatus.failure) {
      return const Center(child: Text('Failed to fetch data'));
    }
    if (status == ListStatus.success && isEmpty) {
      return EmptyStateWidget(statusId: statusId);
    }
    return child;
  }

  // --------------------------
  // Builders per COB
  // --------------------------

  Widget _buildRingkasanTable(BuildContext context) {
    return BlocBuilder<AsetRingkasanCariBloc, AsetRingkasanCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
            (b) => b.state.selectedStatusId);

        return _guardList(
          status: s.status,
          isEmpty: s.items.isEmpty,
          statusId: statusId,
          child: RingkasanCobTable(items: s.items),
        );
      },
    );
  }

  Widget _buildParTable(BuildContext context) {
    return BlocBuilder<AsetParCariBloc, AsetParCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
            (b) => b.state.selectedStatusId);

        return _guardList(
          status: s.status,
          isEmpty: s.items.isEmpty,
          statusId: statusId,
          child: PropertyCobTable(
            items: s.items,
            selectedIds: s.selectedIds.toList(),
            selectedItem: s.selectedItem,
            statusId: statusId,
            onSelectItem: (item) {
              context
                  .read<AsetParCariBloc>()
                  .add(SelectParCariEvent(selectedItem: item));
            },
            onClearSelectedItem: () {
              context.read<AsetParCariBloc>().add(ClearSelectedItemEvent());
            },
            selectedProsesId: (id) {
              context.read<AsetParCariBloc>().add(SelectProsesParIdEvent(id));
            },
            onSelect: (id) {
              final bloc = context.read<AsetParCariBloc>();
              bloc.add(SelectDetailEvent(id));
              bloc.add(SelectSingleParDetailEvent(id));
            },
            onUnselect: (id) {
              final bloc = context.read<AsetParCariBloc>();
              bloc.add(UnselectDetailEvent(id));
              bloc.add(UnselectSingleParDetailEvent(id));
            },
            onSelectFilePolisParId: (id) => context
                .read<AsetParCariBloc>()
                .add(SelectPolisParDetailEvent(id)),
            onUnselectFilePolisParId: (id) => context
                .read<AsetParCariBloc>()
                .add(UnselectPolisParDetailEvent(id)),
            onSelectFilePolisEqId: (id) => context
                .read<AsetParCariBloc>()
                .add(SelectPolisEqDetailEvent(id)),
            onUnselectFilePolisEqId: (id) => context
                .read<AsetParCariBloc>()
                .add(UnselectPolisEqDetailEvent(id)),
            readOnly: false,
          ),
        );
      },
    );
  }

  Widget _buildMvTable(BuildContext context) {
    return BlocBuilder<AsetMvCariBloc, AsetMvCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
            (b) => b.state.selectedStatusId);

        return _guardList(
          status: s.status,
          isEmpty: s.items.isEmpty,
          statusId: statusId,
          child: KendaraanCobTable(
            items: s.items,
            selectedIds: s.selectedIds.toList(),
            selectedItem: s.selectedItem,
            statusId: statusId,
            onClearSelectedItem: () {
              context.read<AsetMvCariBloc>().add(ClearSelectedMvItemEvent());
            },
            onSelectItem: (item) {
              context
                  .read<AsetMvCariBloc>()
                  .add(SelectMvCariEvent(selectedItem: item));
            },
            selectedProsesId: (id) {
              context.read<AsetMvCariBloc>().add(SelectProsesMvIdEvent(id));
            },
            onSelect: (id) {
              final bloc = context.read<AsetMvCariBloc>();
              bloc.add(SelectMvDetailEvent(id));
              bloc.add(SelectSingleMvDetailEvent(id));
            },
            onUnselect: (id) {
              final bloc = context.read<AsetMvCariBloc>();
              bloc.add(UnselectMvDetailEvent(id));
              bloc.add(UnselectSingleMvDetailEvent(id));
            },
            onSelectFilePolisMvId: (id) => context
                .read<AsetMvCariBloc>()
                .add(SelectPolisMvDetailEvent(id)),
            onUnselectFilePolisMvId: (id) => context
                .read<AsetMvCariBloc>()
                .add(UnselectPolisMvDetailEvent(id)),
            readOnly: false,
          ),
        );
      },
    );
  }

  Widget _buildHullTable(BuildContext context) {
    return BlocBuilder<AsethullCariBloc, AsethullCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
            (b) => b.state.selectedStatusId);

        return _guardList(
          status: s.status,
          isEmpty: s.items.isEmpty,
          statusId: statusId,
          child: HullCobTable(
            items: s.items,
            selectedIds: s.selectedIds.toList(),
            selectedItem: s.selectedItem,
            statusId: statusId,
            onClearSelectedItem: () {
              context
                  .read<AsethullCariBloc>()
                  .add(ClearSelectedHullItemEvent());
            },
            onSelectItem: (item) {
              context
                  .read<AsethullCariBloc>()
                  .add(SelectHullCariEvent(selectedItem: item));
            },
            selectedProsesId: (id) {
              context.read<AsethullCariBloc>().add(SelectProsesHullIdEvent(id));
            },
            onSelect: (id) {
              final bloc = context.read<AsethullCariBloc>();
              bloc.add(SelectHullDetailEvent(id));
              bloc.add(SelectSingleHullDetailEvent(id));
            },
            onUnselect: (id) {
              final bloc = context.read<AsethullCariBloc>();
              bloc.add(UnselectHullDetailEvent(id));
              bloc.add(UnselectSingleHullDetailEvent(id));
            },
            onSelectFilePolisHullId: (id) => context
                .read<AsethullCariBloc>()
                .add(SelectPolisHullDetailEvent(id)),
            onUnselectFilePolisHullId: (id) => context
                .read<AsethullCariBloc>()
                .add(UnselectPolisHullDetailEvent(id)),
            readOnly: false,
          ),
        );
      },
    );
  }

  Widget _buildHealthTable(BuildContext context) {
    return BlocBuilder<AsetHealthCariBloc, AsetHealthCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
            (b) => b.state.selectedStatusId);

        return _guardList(
          status: s.status,
          isEmpty: s.items.isEmpty,
          statusId: statusId,
          child: HealthCobTable(
            items: s.items,
            selectedIds: s.selectedIds.toList(),
            selectedItem: s.selectedItem,
            statusId: statusId,
            onClearSelectedItem: () {
              context
                  .read<AsetHealthCariBloc>()
                  .add(ClearSelectedHealthItemEvent());
            },
            onSelectItem: (item) {
              context
                  .read<AsetHealthCariBloc>()
                  .add(SelectHealthCariEvent(selectedItem: item));
            },
            selectedProsesId: (id) {
              context
                  .read<AsetHealthCariBloc>()
                  .add(SelectProsesHealthIdEvent(id));
            },
            onSelect: (id) {
              final bloc = context.read<AsetHealthCariBloc>();
              bloc.add(SelectHealthDetailEvent(id));
              bloc.add(SelectSingleHealthDetailEvent(id));
            },
            onUnselect: (id) {
              final bloc = context.read<AsetHealthCariBloc>();
              bloc.add(UnselectHealthDetailEvent(id));
              bloc.add(UnselectSingleHealthDetailEvent(id));
            },
            onSelectFilePolisHealthId: (id) => context
                .read<AsetHealthCariBloc>()
                .add(SelectPolisHealthDetailEvent(id)),
            onUnselectFilePolisHealthId: (id) => context
                .read<AsetHealthCariBloc>()
                .add(UnselectPolisHealthDetailEvent(id)),
            readOnly: false,
          ),
        );
      },
    );
  }

  Widget _buildOthersTable(BuildContext context) {
    return BlocBuilder<AsetothersCariBloc, AsetothersCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
            (b) => b.state.selectedStatusId);

        return _guardList(
          status: s.status,
          isEmpty: s.items.isEmpty,
          statusId: statusId,
          child: KargoCobTable(
            items: s.items,
            selectedIds: s.selectedIds.toList(),
            selectedItem: s.selectedItem,
            statusId: statusId,
            onClearSelectedItem: () {
              context
                  .read<AsetothersCariBloc>()
                  .add(ClearSelectedOthersItemEvent());
            },
            onSelectItem: (item) {
              context
                  .read<AsetothersCariBloc>()
                  .add(SelectOthersCariEvent(selectedItem: item));
            },
            selectedProsesId: (id) {
              context
                  .read<AsetothersCariBloc>()
                  .add(SelectProsesOthersIdEvent(id));
            },
            onSelect: (id) {
              final bloc = context.read<AsetothersCariBloc>();
              bloc.add(SelectOthersDetailEvent(id));
              bloc.add(SelectSingleOthersDetailEvent(id));
            },
            onUnselect: (id) {
              final bloc = context.read<AsetothersCariBloc>();
              bloc.add(UnselectOthersDetailEvent(id));
              bloc.add(UnselectSingleOthersDetailEvent(id));
            },
            onSelectFilePolisHealthId: (id) => context
                .read<AsetothersCariBloc>()
                .add(SelectPolisOthersDetailEvent(id)),
            onUnselectFilePolisHealthId: (id) => context
                .read<AsetothersCariBloc>()
                .add(UnselectPolisOthersDetailEvent(id)),
            readOnly: false,
          ),
        );
      },
    );
  }

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: refreshData,
    );
  }

  void refreshData() {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;
    final statusId = context.read<StatusAsetCariBloc>().state.selectedStatusId;
    final searchText = _searchController.text;

    if (cobId.trim().isEmpty || statusId.trim().isEmpty) {
      return;
    }

    final cleanCobId = cobId.trim();

    context.read<LoadingFlowBloc>().add(
          LoadingFlowStartEvent(
            cobId: cleanCobId,
            statusId: statusId,
            searchText: searchText,
            timeoutMs: 15000,
          ),
        );
  }

  bool hasSelected(BuildContext context) {
    final cobId = _cobId();

    if (cobId == "10002") {
      return context
          .select((AsetParCariBloc b) => b.state.selectedIds.isNotEmpty);
    }
    if (cobId == "10003") {
      return context
          .select((AsetMvCariBloc b) => b.state.selectedIds.isNotEmpty);
    }
    if (cobId == "10004") {
      return context
          .select((AsethullCariBloc b) => b.state.selectedIds.isNotEmpty);
    }
    if (cobId == "10005") {
      return context
          .select((AsetHealthCariBloc b) => b.state.selectedIds.isNotEmpty);
    }

    // ringkasan 10001 (kalau nanti kamu punya selectedIds di ringkasan, tinggal tambah)
    // default => others
    return context
        .select((AsetothersCariBloc b) => b.state.selectedIds.isNotEmpty);
  }

  String fmtDate(DateTime? v) =>
      v == null ? "-" : DateFormat('dd MMM yyyy').format(v);

  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  String fmtMoney(String curr, num? value) => "$curr ${formatNum(value)}";

  String _selectionId({
    required String statusId,
    required String assetId,
    required String prosesId,
  }) {
    final cleanProsesId = prosesId.trim();
    if (statusId == "10002" && cleanProsesId.isNotEmpty) {
      return cleanProsesId;
    }
    return assetId;
  }

  List<Map<String, dynamic>> _exportRows() {
    final cobId = _cobId();

    if (cobId == "10002") {
      final st = context.read<AsetParCariBloc>().state;

      final dataSource = st.selectedIds.isNotEmpty
          ? st.items.where((x) => st.selectedIds.contains(_selectionId(
                statusId: st.statusId,
                assetId: x.asetParId,
                prosesId: x.prosesId,
              )))
          : st.items;

      return dataSource
          .map((d) => {
                "No": d.nomor,
                "Polis No": d.polisNo,
                "Jumlah Objek": d.jmlObject,
                "Tertanggung": d.tertanggung,
                "Periode":
                    "${fmtDate(d.periodeMulai)} - ${fmtDate(d.periodeAkhir)}",
                "Nilai Pertanggungan": fmtMoney(d.curr, d.sumInsured),
                "Premi": fmtMoney(d.curr, d.premi),
              })
          .toList();
    }

    if (cobId == "10003") {
      final st = context.read<AsetMvCariBloc>().state;

      final dataSource = st.selectedIds.isNotEmpty
          ? st.items.where((x) => st.selectedIds.contains(_selectionId(
                statusId: st.statusId,
                assetId: x.asetMvId,
                prosesId: x.prosesId,
              )))
          : st.items;

      return dataSource
          .map((d) => {
                "No": d.nomor,
                "No Polis": d.polisNo,
                "Jumlah Objek": d.jmlObject,
                "Tertanggung": d.tertanggung,
                "Periode":
                    "${fmtDate(d.periodeMulai)} - ${fmtDate(d.periodeAkhir)}",
                "Nilai Pertanggungan": fmtMoney(d.curr, d.sumInsured),
                "Premi": fmtMoney(d.curr, d.premi),
              })
          .toList();
    }

    if (cobId == "10004") {
      final st = context.read<AsethullCariBloc>().state;

      final dataSource = st.selectedIds.isNotEmpty
          ? st.items.where((x) => st.selectedIds.contains(_selectionId(
                statusId: st.statusId,
                assetId: x.asetHullId,
                prosesId: x.prosesId,
              )))
          : st.items;

      return dataSource
          .map((d) => {
                "No": st.items.indexOf(d) + 1,
                "No Polis": d.polisNo,
                "Jumlah Objek": d.jmlObject,
                "Tertanggung": d.tertanggung,
                "Nilai Pertanggungan": fmtMoney(d.curr, d.tsi),
                "Premi": fmtMoney(d.curr, d.premi),
              })
          .toList();
    }

    if (cobId == "10005") {
      final st = context.read<AsetHealthCariBloc>().state;

      final dataSource = st.selectedIds.isNotEmpty
          ? st.items.where((x) => st.selectedIds.contains(_selectionId(
                statusId: st.statusId,
                assetId: x.asethealthId,
                prosesId: x.prosesId,
              )))
          : st.items;

      return dataSource
          .map((d) => {
                "No": d.nomor,
                // "No Polis": d.polisNo,
                "Nilai Pertanggungan": d.jmlObject,
                "Status": d.status,
              })
          .toList();
    }

    if (cobId == "10001") {
      final st = context.read<AsetRingkasanCariBloc>().state;

      return st.items
          .map((d) => {
                "No": st.items.indexOf(d) + 1,
                "Jenis Polis": d.asetNama,
                "Jumlah Polis": d.jmlPolis,
                "Nilai Pertanggungan": fmtMoney(d.curr, d.nilaiAset),
                "Total Premi": fmtMoney(d.curr, d.nilaiPremi),
              })
          .toList();
    }

    final st = context.read<AsetothersCariBloc>().state;

    final dataSource = st.selectedIds.isNotEmpty
        ? st.items.where((x) => st.selectedIds.contains(_selectionId(
              statusId: st.statusId,
              assetId: x.asetOthersId,
              prosesId: x.prosesId,
            )))
        : st.items;

    return dataSource
        .map((d) => {
              "No": d.nomor,
              "No Polis": d.polisNo,
              "Jumlah Objek": d.jmlObject,
              "Nilai Pertanggungan": fmtMoney(d.curr, d.sumInsured),
              "Premi": fmtMoney(d.curr, d.premi),
            })
        .toList();
  }

  String _exportLabel() {
    final cobId = _cobId();
    if (cobId == "10001") return "RINGKASAN";
    if (cobId == "10002") return "PROPERTY";
    if (cobId == "10003") return "MV";
    if (cobId == "10004") return "HULL";
    if (cobId == "10005") return "HEALTH";
    return "OTHERS";
  }

  CategoryType _exportCategory() {
    final cobId = _cobId();
    if (cobId == "10002") return CategoryType.properti;
    if (cobId == "10003") return CategoryType.kendaraan;
    if (cobId == "10004") return CategoryType.hull;
    if (cobId == "10005") return CategoryType.kesehatan;
    return CategoryType.lain_lain;
  }

  void _showExportDialog(BuildContext context) {
    final rows = _exportRows();

    if (rows.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk diekspor"));
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: IntrinsicHeight(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                Navigator.pop(context);
                await _exportData(context, format, rows);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _stripTimeFromDateValues(
      List<Map<String, dynamic>> rows) {
    String dateOnly(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

    dynamic normalize(dynamic v) {
      if (v == null) return null;

      if (v is DateTime) return dateOnly(v);

      if (v is String) {
        final d = DateTime.tryParse(v);
        if (d != null) return dateOnly(d);
        return v;
      }

      return v;
    }

    return rows
        .map((row) => row.map((k, v) => MapEntry(k, normalize(v))))
        .toList();
  }

  Future<void> _exportData(
    BuildContext context,
    ExportFormat format,
    List<Map<String, dynamic>> rows,
  ) async {
    final cleanedRows = _stripTimeFromDateValues(rows);

    final ext = (format == ExportFormat.excel) ? "xlsx" : "pdf";
    final exportFormat = (format == ExportFormat.excel) ? "excel" : "pdf";
    final fileName =
        "Aset_${_exportLabel()}_${DateTime.now().millisecondsSinceEpoch}.$ext";

    try {
      if (kIsWeb) {
        await ExportHelper.export(exportFormat, cleanedRows, _exportCategory());
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: fileName,
          data: cleanedRows,
          format: exportFormat,
          reportTitle: "Polis",
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar("Berhasil ekspor ${rows.length} item"),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar("Gagal ekspor: $e"),
        );
      }
    }
  }

  Future<void> _onShare(BuildContext context) async {
    final rows = _exportRows();

    if (rows.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk diekspor"));
      return;
    }

    try {
      final cleanedRows = _stripTimeFromDateValues(rows);

      // WEB → tetap export biasa
      if (kIsWeb) {
        await ExportHelper.export(
          "pdf",
          cleanedRows,
          _exportCategory(),
        );
        return;
      }

      // MOBILE → generate PDF dulu
      final fileName =
          "Aset_${_exportLabel()}_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final file = await MobileDownloadHelper.generatePdfFile(
        fileName: fileName,
        data: cleanedRows,
        reportTitle: "Polis",
      );

      debugPrint("PDF saved at: ${file.path}");
      if (!context.mounted) return;

      // buka native share sheet
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: "Rincian ${_exportLabel()}",
        text: rows.length == 1
            ? "Berikut terlampir rincian ${_exportLabel()}."
            : "Berikut terlampir ${rows.length} data ${_exportLabel()} terpilih.",
        sharePositionOrigin: sharePositionOrigin(context),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar("Gagal membagikan file: $e"));
      }
    }
  }
}
