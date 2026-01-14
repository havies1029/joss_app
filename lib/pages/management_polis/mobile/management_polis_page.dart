import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../blocs/gen_cob_app/cobcari_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../../../helper/fab_action_helper.dart';
import '../../../widgets/apptheme/header_card.dart';
import '../../asset_management/floating_action_menu_widget.dart';
import '../../base/base_background_sidepage.dart';
import 'management_polis_filter.dart';

class ManagementPolisPage extends StatefulWidget {
  const ManagementPolisPage({super.key});

  @override
  _ManagementPolisPageState createState() => _ManagementPolisPageState();
}

class _ManagementPolisPageState extends State<ManagementPolisPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: Stack(
          children: [
            BaseBackgroundSidePage(
              title: 'Polis',
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      HeaderCard(
                        iconPath: "assets/icons/menu_polis.svg",
                        title: "Polis",
                        subtitle:
                        "Kelola dan pantau semua polis Anda dalam satu aplikasi.",
                      ),
                      ManagementPolisFilter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingMenuWrapper(),
    );
  }

}

class FloatingMenuWrapper extends StatelessWidget {
  const FloatingMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final cobId = context.select((CobCariBloc b) => b.state.selectedCOBId);

    // 1) subscribe selectedIds sesuai COB
    final Set<String> selectedIds = switch (cobId) {
      "10002" => context.select((AsetParCariBloc b) => b.state.selectedIds),
      "10003" => context.select((AsetMvCariBloc b) => b.state.selectedIds),
      "10004" => context.select((AsethullCariBloc b) => b.state.selectedIds),
      "10005" => context.select((AsetHealthCariBloc b) => b.state.selectedIds),
      _ => const <String>{},
    };

    // if (selectedIds.isEmpty) return const SizedBox.shrink();

    final selectedItemsList = _selectedModelsByCob(context, cobId, selectedIds);

    final currentStatusFilter =
    context.select((StatusAsetCariBloc b) => b.state.selectedStatusId);

    final availableActions = FabActionHelper.getAvailableActions(
      currentStatusFilter: currentStatusFilter,
      selectedItems: selectedItemsList,
    );

    // if (availableActions.isEmpty) return const SizedBox.shrink();

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
            _refreshByCob(context, cobId); // optional tapi biasanya kepake
          },
        );
      },
    );
  }


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
    return [];
  }

  void _clearSelectionByCob(BuildContext context, String cobId) {
    if (cobId == "10002") context.read<AsetParCariBloc>().add(ClearParSelectionEvent());
    if (cobId == "10003") context.read<AsetMvCariBloc>().add(ClearMvSelectionEvent());
    if (cobId == "10004") context.read<AsethullCariBloc>().add(ClearHullSelectionEvent());
    if (cobId == "10005") context.read<AsetHealthCariBloc>().add(ClearHealthSelectionEvent());
  }

  void _refreshByCob(BuildContext context, String cobId) {
    final statusId = context.read<StatusAsetCariBloc>().state.selectedStatusId;
    // kalau butuh searchText, ambil dari tempat yang kamu simpan (atau skip)
    const searchText = ""; // ganti kalau kamu punya source yang benar

    if (cobId == "10002") {
      context.read<AsetParCariBloc>().add(RefreshAsetParCariEvent(statusId: statusId, searchText: searchText));
    } else if (cobId == "10003") {
      context.read<AsetMvCariBloc>().add(RefreshAsetMvCariEvent(statusId: statusId, searchText: searchText));
    } else if (cobId == "10004") {
      context.read<AsethullCariBloc>().add(RefreshAsethullCariEvent(statusId: statusId, searchText: searchText));
    } else if (cobId == "10005") {
      context.read<AsetHealthCariBloc>().add(RefreshAsetHealthCariEvent(statusId: statusId, searchText: searchText));
    }
  }
}
