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
    context.select((CobManPolBloc b) => b.state.selectedCOBId);
    context.select((StatusAsetCariBloc b) => b.state.selectedStatusId);

    // trigger untuk selection per cob (biar tombol enable/disable ikut update)
    context.select((AsetParCariBloc b) => b.state.selectedId);
    context.select((AsetMvCariBloc b) => b.state.selectedId);
    context.select((AsethullCariBloc b) => b.state.selectedId);
    context.select((AsetHealthCariBloc b) => b.state.selectedId);
    context.select((AsetothersCariBloc b) => b.state.selectedId);

    // trigger untuk file polis id
    context.select((AsetParCariBloc b) => b.state.selectedFilePolisParId);
    context.select((AsetParCariBloc b) => b.state.selectedFilePolisEqId);
    context.select((AsetMvCariBloc b) => b.state.selectedFilePolisId);
    context.select((AsethullCariBloc b) => b.state.selectedFilePolisId);
    context.select((AsetHealthCariBloc b) => b.state.selectedFilePolisId);
    context.select((AsetothersCariBloc b) => b.state.selectedFilePolisId);

    final selectedItemsList = _selectedModelsFromState(context);
    final currentStatusFilter =
        context.read<StatusAsetCariBloc>().state.selectedStatusId;

    // 1) actions dasar dari status/selection
    final baseActions = FabActionHelper.getAvailableActions(
      currentStatusFilter: currentStatusFilter,
      selectedItems: selectedItemsList,
    );

    // 2) actions polis berdasarkan COB (diambil dari state dalam method)
    final polisActions = _polisActionsFromState(
      context: context,
      base: FabActionHelper.masterActions,
      disableBecauseMultiSelect: false, // nanti kalau multi-select, tinggal hitung dari state
    );

    // 3) gabungkan base + polis (hindari duplikat)
    final merged = _mergeActionsByType(baseActions, polisActions);

    // 4) FILTER: tampilkan hanya action yang relevan untuk COB aktif (diambil dari state)
    final availableActions = _filterActionsByCobFromState(context, merged);

    return FloatingActionMenuWidget(
      availableActions: availableActions,
      selectedItems: selectedItemsList,
      onActionTap: (actionType, selectedItems) {
        FabActionHelper.handleAction(
          context: context,
          actionType: actionType,
          selectedItems: selectedItems,
          onActionComplete: () {
            _clearSelectionFromState(context);
            _refreshFromState(context);
          },
        );
      },
    );
  }

  List<ActionMenuItem> _polisActionsFromState({
    required BuildContext context,
    required List<ActionMenuItem> base,
    required bool disableBecauseMultiSelect,
  }) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;

    ActionMenuItem? pick(ActionType t, {required bool enabled}) {
      final idx = base.indexWhere((x) => x.type == t);
      if (idx == -1) return null;
      return base[idx].copyWith(isEnabled: enabled);
    }

    if (cobId == "10002") {
      final parState = context.read<AsetParCariBloc>().state;
      final actions = <ActionMenuItem>[];

      if (parState.selectedFilePolisParId.isNotEmpty) {
        final a = pick(
          ActionType.lihatPolisPar,
          enabled: !disableBecauseMultiSelect,
        );
        if (a != null) actions.add(a);
      }

      if (parState.selectedFilePolisEqId.isNotEmpty) {
        final a = pick(
          ActionType.lihatPolisEq,
          enabled: !disableBecauseMultiSelect,
        );
        if (a != null) actions.add(a);
      }

      return actions;
    }

    final singlePolisId = switch (cobId) {
      "10003" => context.read<AsetMvCariBloc>().state.selectedFilePolisId,
      "10004" => context.read<AsethullCariBloc>().state.selectedFilePolisId,
      "10005" => context.read<AsetHealthCariBloc>().state.selectedFilePolisId,
      "10006" => context.read<AsetothersCariBloc>().state.selectedFilePolisId,
      _ => "",
    };

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
  // FILTER by COB (STATE-DRIVEN)
  // =========================
  List<ActionMenuItem> _filterActionsByCobFromState(
      BuildContext context,
      List<ActionMenuItem> actions,
      ) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;

    final allowed = switch (cobId) {
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
      "10003" || "10004" || "10005" || "10006" => <ActionType>{
        ActionType.beliPolis,
        ActionType.unduhPolis,
        ActionType.lacakPolis,
        ActionType.endorse,
        ActionType.perpanjangan,
        ActionType.aktifkanKembali,
        ActionType.lihatPolis,
      },
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
  // selections (STATE-DRIVEN)
  // =========================
  List<dynamic> _selectedModelsFromState(BuildContext c) {
    final cobId = c.read<CobManPolBloc>().state.selectedCOBId;

    final selectedId = switch (cobId) {
      "10002" => c.read<AsetParCariBloc>().state.selectedId,
      "10003" => c.read<AsetMvCariBloc>().state.selectedId,
      "10004" => c.read<AsethullCariBloc>().state.selectedId,
      "10005" => c.read<AsetHealthCariBloc>().state.selectedId,
      "10006" => c.read<AsetothersCariBloc>().state.selectedId,
      _ => "",
    };

    if (selectedId.isEmpty) return const [];

    try {
      final item = switch (cobId) {
        "10002" => c.read<AsetParCariBloc>().state.items
            .firstWhere((x) => x.asetParId == selectedId),
        "10003" => c.read<AsetMvCariBloc>().state.items
            .firstWhere((x) => x.asetMvId == selectedId),
        "10004" => c.read<AsethullCariBloc>().state.items
            .firstWhere((x) => x.asetHullId == selectedId),
        "10005" => c.read<AsetHealthCariBloc>().state.items
            .firstWhere((x) => x.asethealthId == selectedId),
        "10006" => c.read<AsetothersCariBloc>().state.items
            .firstWhere((x) => x.asetOthersId == selectedId),
        _ => null,
      };
      return item == null ? const [] : [item];
    } catch (_) {
      return const [];
    }
  }

  // =========================
  // clear selection (STATE-DRIVEN)
  // =========================
  void _clearSelectionFromState(BuildContext context) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;

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

  // =========================
  // refresh (STATE-DRIVEN)
  // =========================
  void _refreshFromState(BuildContext context) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;
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


/*

class FloatingMenuWrapper extends StatelessWidget {
  const FloatingMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final cobId = context.select((CobManPolBloc b) => b.state.selectedCOBId);

    final String selectedId = switch (cobId) {
      "10002" => context.select((AsetParCariBloc b) => b.state.selectedId),
      "10003" => context.select((AsetMvCariBloc b) => b.state.selectedId),
      "10004" => context.select((AsethullCariBloc b) => b.state.selectedId),
      "10005" => context.select((AsetHealthCariBloc b) => b.state.selectedId),
      "10006" => context.select((AsetothersCariBloc b) => b.state.selectedId),
      _ => "",
    };

    final selectedItemsList = _selectedModelsByCob(context, cobId, selectedId);

    final currentStatusFilter =
    context.select((StatusAsetCariBloc b) => b.state.selectedStatusId);

    final bool disableViewPolisBecauseMultiSelect = false;

    final parPolisParId = cobId == "10002"
        ? context.select((AsetParCariBloc b) => b.state.selectedFilePolisParId)
        : "";

    final parPolisEqId = cobId == "10002"
        ? context.select((AsetParCariBloc b) => b.state.selectedFilePolisEqId)
        : "";

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

    // 4) FILTER: tampilkan hanya action yang relevan untuk COB aktif
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
      if (idx == -1) return null; // anti "Bad state: No element"
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
  // selections & refresh (sekarang pakai selectedId)
  // =========================

  List<dynamic> _selectedModelsByCob(BuildContext c, String cobId, String id) {
    if (id.isEmpty) return [];

    try {
      return [
        switch (cobId) {
          "10002" => c.read<AsetParCariBloc>().state.items
              .firstWhere((x) => x.asetParId == id),
          "10003" => c.read<AsetMvCariBloc>().state.items
              .firstWhere((x) => x.asetMvId == id),
          "10004" => c.read<AsethullCariBloc>().state.items
              .firstWhere((x) => x.asetHullId == id),
          "10005" => c.read<AsetHealthCariBloc>().state.items
              .firstWhere((x) => x.asethealthId == id),
          "10006" => c.read<AsetothersCariBloc>().state.items
              .firstWhere((x) => x.asetOthersId == id),
          _ => null,
        }
      ]..removeWhere((e) => e == null);
    } catch (_) {
      return [];
    }
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
*/
