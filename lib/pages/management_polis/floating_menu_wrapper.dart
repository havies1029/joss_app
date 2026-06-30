import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';

import '../../../helper/fab_action_helper.dart';

import '../../helper/fab_action_executor.dart';
import '../../helper/fab_action_policy.dart';
import 'floating_action_menu_widget.dart';

class FloatingMenuWrapper extends StatelessWidget {
  const FloatingMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final policy = FabActionPolicy(
      masterActions: FabActionHelper.masterActions,
      downloadPolisItem: FabActionHelper.downloadPolisItem,
      downloadParItem: FabActionHelper.downloadParItem,
      downloadEqItem: FabActionHelper.downloadEqItem,
    );
    final executor = FabActionExecutor(policy);

    return MultiBlocListener(
      listeners: [
        BlocListener<StatusAsetCariBloc, StatusAsetCariState>(
          listenWhen: (prev, curr) =>
              prev.selectedStatusId != curr.selectedStatusId,
          listener: (context, state) {
            _clearAllSelections(context);
          },
        ),
        BlocListener<CobManPolBloc, CobManPolState>(
          listenWhen: (prev, curr) => prev.selectedCOBId != curr.selectedCOBId,
          listener: (context, state) {
            _clearAllSelections(context);
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final cobId =
              context.select((CobManPolBloc b) => b.state.selectedCOBId);
          final statusId = context
              .select((StatusAsetCariBloc b) => b.state.selectedStatusId);

          final selectedItem = _selectedItemByCob(context, cobId);

          final actions = policy.computeActions(
            cobId: cobId,
            statusId: statusId,
            selectedItem: selectedItem,
          );

          final selectedItems = selectedItem == null
              ? const <dynamic>[]
              : <dynamic>[selectedItem];

          return FloatingActionMenuWidget(
            availableActions: actions,
            selectedItems: selectedItems,
            autoCollapseKey: '$cobId|$statusId',
            onActionTap: (actionType, _) {
              debugPrint(
                'WRAPPER onActionTap => actionType=$actionType, '
                'selectedItemNull=${selectedItem == null}',
              );

              final needsSelectedItem = actionType != ActionType.beliPolis &&
                  actionType != ActionType.hubungiJps;

              if (needsSelectedItem && selectedItem == null) {
                debugPrint('WRAPPER blocked => selectedItem required');
                return;
              }

              debugPrint('WRAPPER run executor => $actionType');

              executor.run(
                context: context,
                actionType: actionType,
                selectedItem: selectedItem,
                onDone: () {
                  _clearAllSelections(context);
                  _refreshFromState(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  dynamic _selectedItemByCob(BuildContext context, String cobId) {
    switch (cobId) {
      case "10001":
        return null;

      case "10002":
        final s = context.select((AsetParCariBloc b) => b.state);
        return s.selectedIds.isNotEmpty ? s.selectedItem : null;

      case "10003":
        final s = context.select((AsetMvCariBloc b) => b.state);
        return s.selectedIds.isNotEmpty ? s.selectedItem : null;

      case "10004":
        final s = context.select((AsethullCariBloc b) => b.state);
        return s.selectedIds.isNotEmpty ? s.selectedItem : null;

      case "10005":
        final s = context.select((AsetHealthCariBloc b) => b.state);
        return s.selectedIds.isNotEmpty ? s.selectedItem : null;

      default:
        final s = context.select((AsetothersCariBloc b) => b.state);
        return s.selectedIds.isNotEmpty ? s.selectedItem : null;
    }
  }

  void _clearAllSelections(BuildContext context) {
    context.read<AsetParCariBloc>()
      ..add(ClearSelectedItemEvent())
      ..add(const ClearParSelectionEvent())
      ..add(const ClearPolisParSelectionEvent())
      ..add(const ClearPolisEqSelectionEvent());

    context.read<AsetMvCariBloc>()
      ..add(ClearSelectedMvItemEvent())
      ..add(const ClearMvSelectionEvent())
      ..add(const ClearPolisMvSelectionEvent());

    context.read<AsethullCariBloc>()
      ..add(ClearSelectedHullItemEvent())
      ..add(const ClearHullSelectionEvent())
      ..add(const ClearPolisHullSelectionEvent());

    context.read<AsetHealthCariBloc>()
      ..add(ClearSelectedHealthItemEvent())
      ..add(const ClearHealthSelectionEvent())
      ..add(const ClearPolisHealthSelectionEvent());

    context.read<AsetothersCariBloc>()
      ..add(ClearSelectedOthersItemEvent())
      ..add(const ClearOthersSelectionEvent())
      ..add(const ClearPolisOthersSelectionEvent());
  }

  void _refreshFromState(BuildContext context) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;
    final statusId = context.read<StatusAsetCariBloc>().state.selectedStatusId;
    const searchText = "";

    if (cobId.isEmpty || statusId.isEmpty) {
      return;
    }

    if (cobId == "10002") {
      context.read<AsetParCariBloc>().add(
            RefreshAsetParCariEvent(statusId: statusId, searchText: searchText),
          );
      return;
    }

    if (cobId == "10003") {
      context.read<AsetMvCariBloc>().add(
            RefreshAsetMvCariEvent(statusId: statusId, searchText: searchText),
          );
      return;
    }

    if (cobId == "10004") {
      context.read<AsethullCariBloc>().add(
            RefreshAsethullCariEvent(
                statusId: statusId, searchText: searchText),
          );
      return;
    }

    if (cobId == "10005") {
      context.read<AsetHealthCariBloc>().add(
            RefreshAsetHealthCariEvent(
                statusId: statusId, searchText: searchText),
          );
      return;
    }

    context.read<AsetothersCariBloc>().add(
          RefreshAsetothersCariEvent(
            statusId: statusId,
            searchText: searchText,
            cobId: cobId,
          ),
        );
  }
}
