import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';

import '../../../helper/fab_action_helper.dart'; // untuk masterActions + download items

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

    return BlocListener<StatusAsetCariBloc, StatusAsetCariState>(
      listenWhen: (prev, curr) => prev.statusChangeTick != curr.statusChangeTick,
      listener: (context, state) {
        _clearSelectionFromState(context);
      },
      child: Builder(
        builder: (context) {
          final cobId = context.select((CobManPolBloc b) => b.state.selectedCOBId);
          final statusId = context.select((StatusAsetCariBloc b) => b.state.selectedStatusId);

          final selectedItem = _selectedItemByCob(context, cobId);

          final actions = policy.computeActions(
            cobId: cobId,
            statusId: statusId,
            selectedItem: selectedItem,
          );

          final selectedItems =
          selectedItem == null ? const <dynamic>[] : <dynamic>[selectedItem];

          return FloatingActionMenuWidget(
            availableActions: actions,
            selectedItems: selectedItems,
            onActionTap: (actionType, _) {
              executor.run(
                context: context,
                actionType: actionType,
                selectedItem: selectedItem,
                onDone: () {
                  _clearSelectionFromState(context);
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
    return switch (cobId) {
      "10002" => context.select((AsetParCariBloc b) => b.state.selectedItem),
      "10003" => context.select((AsetMvCariBloc b) => b.state.selectedItem),
      "10004" => context.select((AsethullCariBloc b) => b.state.selectedItem),
      "10005" => context.select((AsetHealthCariBloc b) => b.state.selectedItem),
      "10006" => context.select((AsetothersCariBloc b) => b.state.selectedItem),
      _ => null,
    };
  }

  void _clearSelectionFromState(BuildContext context) {
    final cobId = context.read<CobManPolBloc>().state.selectedCOBId;

    if (cobId == "10002") {
      final bloc = context.read<AsetParCariBloc>();
      bloc.add(ClearSelectedItemEvent());
      bloc.add(const ClearParSelectionEvent());
      bloc.add(const ClearPolisParSelectionEvent());
      bloc.add(const ClearPolisEqSelectionEvent());
    } else if (cobId == "10003") {
      final bloc = context.read<AsetMvCariBloc>();
      bloc.add(ClearSelectedMvItemEvent());
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
