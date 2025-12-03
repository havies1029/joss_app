import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_mv_state_cubit.dart';
import '../../../../../../models/gen_aset_mv/asetmvcari_model.dart';
import '../list_form/aset_list_mv.dart';
import '../tables/template_table_form_widget.dart';

class TableMvWidget extends StatelessWidget {
  const TableMvWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateTableFormWidget<
        AsetMvCariModel,
        AsetMvCariBloc,
        AsetDashboardCariBloc,
        ShareMvStateCubit
    >(
      cobType: 'Mv',
      shareCubitBuilder: () => ShareMvStateCubit(),
      listBuilder: (searchText, [statusLabel]) => AsetListMv(
        searchText: searchText,
        statusLabel: statusLabel ?? 'Aktif',),
      onRefreshRequested: (statusId, searchText) {
        context.read<AsetMvCariBloc>().add(
          RefreshAsetMvCariEvent(statusId: statusId, searchText: searchText),
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