import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_cob_app/cobmanpol_bloc.dart';

import '../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../../../helper/fab_action_helper.dart';
import 'floating_action_menu_widget.dart';


class FloatingMenuWrapper extends StatelessWidget {
  const FloatingMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    T sel<B extends StateStreamable<S>, S, T>(T Function(S s) pick) =>
        context.select<B, T>((b) => pick(b.state));
    final cobId = sel<CobManPolBloc, CobManPolState, String>((s) => s.selectedCOBId);
    final statusId = sel<StatusAsetCariBloc, StatusAsetCariState, String>((s) => s.selectedStatusId);
    final selectedItem = _selectedItemByCob(context, cobId);
    if (cobId == "10002") {
      sel<AsetParCariBloc, AsetParCariState, String>((s) => s.selectedFilePolisParId);
      sel<AsetParCariBloc, AsetParCariState, String>((s) => s.selectedFilePolisEqId);
    } else {
      switch (cobId) {
        case "10003":
          sel<AsetMvCariBloc, AsetMvCariState, String>((s) => s.selectedFilePolisId);
          break;
        case "10004":
          sel<AsethullCariBloc, AsethullCariState, String>((s) => s.selectedFilePolisId);
          break;
        case "10005":
          sel<AsetHealthCariBloc, AsetHealthCariState, String>((s) => s.selectedFilePolisId);
          break;
        case "10006":
          sel<AsetothersCariBloc, AsetothersCariState, String>((s) => s.selectedFilePolisId);
          break;
      }
    }

    final selectedItems = selectedItem == null ? const <dynamic>[] : <dynamic>[selectedItem];
    final baseActions = FabActionHelper.getAvailableActions(
      context: context,
      selectedItems: selectedItems,
    );

    final polisActions = _polisActionsFromState(
      context: context,
      base: FabActionHelper.masterActions,
      disableBecauseMultiSelect: false,
    );

    final availableActions = _filterActionsByCobFromState(
      context,
      _mergeActionsByType(baseActions, polisActions),
    );

    return FloatingActionMenuWidget(
      availableActions: availableActions,
      selectedItems: selectedItems,
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

  dynamic _selectedItemByCob(BuildContext context, String cobId) {
    return switch (cobId) {
      "10002" => context.select((AsetParCariBloc b) => b.state.selectedItem),
      "10003" => context.select((AsetMvCariBloc b) => b.state.selectedItem),
      "10004" => context.select((AsethullCariBloc b) => b.state.selectedItem),
      "10005" => context.select((AsetHealthCariBloc b) => b.state.selectedItem),
      "10006" => context.select((AsetothersCariBloc b) => b.state.selectedItem),
      _ => null,
    };
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
        final a = pick(ActionType.lihatPolisPar, enabled: !disableBecauseMultiSelect);
        if (a != null) actions.add(a);
      }

      if (parState.selectedFilePolisEqId.isNotEmpty) {
        final a = pick(ActionType.lihatPolisEq, enabled: !disableBecauseMultiSelect);
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
      final a = pick(ActionType.lihatPolis, enabled: !disableBecauseMultiSelect);
      return a == null ? const [] : [a];
    }

    return const <ActionMenuItem>[];
  }

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
      _ => <ActionType>{ActionType.beliPolis},
    };

    return actions.where((a) => allowed.contains(a.type)).toList();
  }

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