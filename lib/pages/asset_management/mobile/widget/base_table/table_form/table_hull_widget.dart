import 'package:flutter/cupertino.dart';
import 'package:joss_app/blocs/share_cubit/share_hull_state_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../../../../models/gen_aset_hull/asethullcari_model.dart';
import '../list_form/aset_list_hull.dart';
import '../tables/template_table_form_widget.dart';

class TableHullWidget extends StatelessWidget {
  const TableHullWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateTableFormWidget<
        AsethullCariModel,
        AsethullCariBloc,
        AsetDashboardCariBloc,
        ShareHullStateCubit
    >(
      cobType: 'Angkutan',
      shareCubitBuilder: () => ShareHullStateCubit(),
      listBuilder: (searchText, [statusLabel]) => AsetListHull(
        searchText: searchText,
        statusLabel: statusLabel ?? 'Aktif',
      ),
      onRefreshRequested: (statusId, searchText) {
        context.read<AsethullCariBloc>().add(
          RefreshAsethullCariEvent(statusId: statusId, searchText: searchText),
        );
      },
      onDashboardRefresh: (cobAppId) {
        context.read<AsetDashboardCariBloc>().add(
          RefreshAsetDashboardCariEvent(cobAppId: cobAppId),
        );
      },
    );
  }
}
