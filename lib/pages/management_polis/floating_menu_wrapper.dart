import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../../../helper/fab_action_helper.dart';
import '../../../widgets/apptheme/header_card.dart';
import '../base/base_background_sidepage.dart';
import 'floating_action_menu_widget.dart';
import 'mobile/management_polis_filter.dart';

class FloatingMenuWrapper extends StatelessWidget {
  const FloatingMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final cobId = context.select((CobManPolBloc b) => b.state.selectedCOBId);

    final Set<String> selectedIds = switch (cobId) {
      "10002" => context.select((AsetParCariBloc b) => b.state.selectedIds),
      "10003" => context.select((AsetMvCariBloc b) => b.state.selectedIds),
      "10004" => context.select((AsethullCariBloc b) => b.state.selectedIds),
      "10005" => context.select((AsetHealthCariBloc b) => b.state.selectedIds),
      "10006" => context.select((AsetothersCariBloc b) => b.state.selectedIds),
      _ => const <String>{},
    };

    final selectedItemsList = _selectedModelsByCob(context, cobId, selectedIds);

    final currentStatusFilter =
    context.select((StatusAsetCariBloc b) => b.state.selectedStatusId);

    // ✅ aturan: kalau select > 1, tombol lihatPolis harus disable
    final bool disableViewPolisBecauseMultiSelect = selectedIds.length > 1;

    // === KHUSUS PAR (10002) ===
    final parPolisParId = cobId == "10002"
        ? context.select((AsetParCariBloc b) => b.state.selectedFilePolisParId)
        : "";

    final parPolisEqId = cobId == "10002"
        ? context.select((AsetParCariBloc b) => b.state.selectedFilePolisEqId)
        : "";

    // === COB lain (single polis id) ===
    // NOTE: pastikan field ini memang ada di state masing-masing.
    final selectedFilePolisIdByCob = switch (cobId) {
      "10003" => context.select((AsetMvCariBloc b) => b.state.selectedFilePolisId),
      "10004" => context.select((AsethullCariBloc b) => b.state.selectedFilePolisId),
      "10005" => context.select((AsetHealthCariBloc b) => b.state.selectedFilePolisId),
      "10006" => context.select((AsetothersCariBloc b) => b.state.selectedFilePolisId),
      _ => "",
    };

    // 1) actions dasar dari status/selection
    final baseActions = FabActionHelper.getAvailableActions(
      currentStatusFilter: currentStatusFilter,
      selectedItems: selectedItemsList,
    );

    // 2) actions polis berdasarkan COB
    final polisActions = _polisActionsByCob(
      cobId: cobId,
      base: FabActionHelper.masterActions,
      parPolisParId: parPolisParId,
      parPolisEqId: parPolisEqId,
      singlePolisId: selectedFilePolisIdByCob,
      disableBecauseMultiSelect: disableViewPolisBecauseMultiSelect,
    );

    // 3) gabungkan base + polis (hindari duplikat)
    final merged = _mergeActionsByType(baseActions, polisActions);

    // ✅ 4) FILTER: tampilkan hanya action yang relevan untuk COB aktif
    final availableActions = _filterActionsByCob(cobId, merged);

    return FloatingActionMenuWidget(
      availableActions: availableActions,
      selectedItems: selectedItemsList,
      onActionTap: (actionType, selectedItems) {
        FabActionHelper.handleAction(
          context: context,
          actionType: actionType,
          selectedItems: selectedItems,
          onActionComplete: () {
            _clearSelectionByCob(context, cobId);
            _refreshByCob(context, cobId);
          },
        );
      },
    );
  }

  // =========================
  // POLIS actions builder
  // =========================

  List<ActionMenuItem> _polisActionsByCob({
    required String cobId,
    required List<ActionMenuItem> base,
    required String parPolisParId,
    required String parPolisEqId,
    required String singlePolisId,
    required bool disableBecauseMultiSelect,
  }) {
    ActionMenuItem? pick(ActionType t, {required bool enabled}) {
      final idx = base.indexWhere((x) => x.type == t);
      if (idx == -1) return null; // ✅ anti "Bad state: No element"
      return base[idx].copyWith(isEnabled: enabled);
    }

    // KHUSUS PAR: tombol muncul hanya jika id ada
    if (cobId == "10002") {
      final actions = <ActionMenuItem>[];

      if (parPolisParId.isNotEmpty) {
        final a = pick(
          ActionType.lihatPolisPar,
          enabled: !disableBecauseMultiSelect,
        );
        if (a != null) actions.add(a);
      }

      if (parPolisEqId.isNotEmpty) {
        final a = pick(
          ActionType.lihatPolisEq,
          enabled: !disableBecauseMultiSelect,
        );
        if (a != null) actions.add(a);
      }

      return actions;
    }

    // COB lain: tombol muncul kalau single polis id ada
    if (singlePolisId.isNotEmpty) {
      final a = pick(
        ActionType.lihatPolis,
        enabled: !disableBecauseMultiSelect,
      );
      return a == null ? const [] : [a];
    }

    return const <ActionMenuItem>[];
  }

  // =========================
  // FILTER by COB (yang tampil)
  // =========================

  List<ActionMenuItem> _filterActionsByCob(String cobId, List<ActionMenuItem> actions) {
    final allowed = switch (cobId) {
    // PAR: tampilkan tombol PAR polis
      "10002" => <ActionType>{
        ActionType.beliPolis,
        ActionType.unduhPolis,
        ActionType.lacakPolis,
        ActionType.endorse,
        ActionType.perpanjangan,
        ActionType.aktifkanKembali,
        ActionType.lihatPolisPar,
        ActionType.lihatPolisEq,
      },

    // lainnya: tampilkan lihatPolis biasa
      "10003" || "10004" || "10005" || "10006" => <ActionType>{
        ActionType.beliPolis,
        ActionType.unduhPolis,
        ActionType.lacakPolis,
        ActionType.endorse,
        ActionType.perpanjangan,
        ActionType.aktifkanKembali,
        ActionType.lihatPolis,
      },

    // ringkasan / default
      _ => <ActionType>{
        ActionType.beliPolis,
      },
    };

    return actions.where((a) => allowed.contains(a.type)).toList();
  }

  // =========================
  // merge by ActionType
  // =========================

  List<ActionMenuItem> _mergeActionsByType(
      List<ActionMenuItem> a,
      List<ActionMenuItem> b,
      ) {
    final map = <ActionType, ActionMenuItem>{};
    for (final x in a) {
      map[x.type] = x;
    }
    for (final x in b) {
      map[x.type] = x;
    }
    return map.values.toList();
  }

  // =========================
  // selections & refresh (punyamu)
  // =========================

  List<dynamic> _selectedModelsByCob(
      BuildContext context,
      String cobId,
      Set<String> selectedIds,
      ) {
    if (cobId == "10002") {
      final st = context.read<AsetParCariBloc>().state;
      return st.items.where((x) => selectedIds.contains(x.asetParId)).toList();
    }
    if (cobId == "10003") {
      final st = context.read<AsetMvCariBloc>().state;
      return st.items.where((x) => selectedIds.contains(x.asetMvId)).toList();
    }
    if (cobId == "10004") {
      final st = context.read<AsethullCariBloc>().state;
      return st.items.where((x) => selectedIds.contains(x.asetHullId)).toList();
    }
    if (cobId == "10005") {
      final st = context.read<AsetHealthCariBloc>().state;
      return st.items.where((x) => selectedIds.contains(x.asethealthId)).toList();
    }
    if (cobId == "10006") {
      final st = context.read<AsetothersCariBloc>().state;
      return st.items.where((x) => selectedIds.contains(x.asetOthersId)).toList();
    }
    return [];
  }

  void _clearSelectionByCob(BuildContext context, String cobId) {
    if (cobId == "10002") {
      final bloc = context.read<AsetParCariBloc>();
      bloc.add(const ClearParSelectionEvent());
      bloc.add(const ClearPolisParSelectionEvent());
      bloc.add(const ClearPolisEqSelectionEvent());
    } else if (cobId == "10003") {
      final bloc = context.read<AsetMvCariBloc>();
      bloc.add(const ClearMvSelectionEvent());
      bloc.add(const ClearPolisMvSelectionEvent());
    } else if (cobId == "10004") {
      final bloc = context.read<AsethullCariBloc>();
      bloc.add(const ClearHullSelectionEvent());
      bloc.add(const ClearPolisHullSelectionEvent());
    } else if (cobId == "10005") {
      final bloc = context.read<AsetHealthCariBloc>();
      bloc.add(const ClearHealthSelectionEvent());
      bloc.add(const ClearPolisHealthSelectionEvent());
    } else if (cobId == "10006") {
      final bloc = context.read<AsetothersCariBloc>();
      bloc.add(const ClearOthersSelectionEvent());
      bloc.add(const ClearPolisOthersSelectionEvent());
    }
  }

  void _refreshByCob(BuildContext context, String cobId) {
    final statusId = context.read<StatusAsetCariBloc>().state.selectedStatusId;
    const searchText = "";

    if (cobId == "10002") {
      context.read<AsetParCariBloc>().add(
        RefreshAsetParCariEvent(statusId: statusId, searchText: searchText),
      );
    } else if (cobId == "10003") {
      context.read<AsetMvCariBloc>().add(
        RefreshAsetMvCariEvent(statusId: statusId, searchText: searchText),
      );
    } else if (cobId == "10004") {
      context.read<AsethullCariBloc>().add(
        RefreshAsethullCariEvent(statusId: statusId, searchText: searchText),
      );
    } else if (cobId == "10005") {
      context.read<AsetHealthCariBloc>().add(
        RefreshAsetHealthCariEvent(statusId: statusId, searchText: searchText),
      );
    } else if (cobId == "10006") {
      context.read<AsetothersCariBloc>().add(
        RefreshAsetothersCariEvent(
          statusId: statusId,
          searchText: searchText,
          cobId: cobId,
        ),
      );
    }
  }
}
