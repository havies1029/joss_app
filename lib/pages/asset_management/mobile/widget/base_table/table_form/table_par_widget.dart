import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_par_state_cubit.dart';

import '../../../../../../models/gen_aset_par/asetparcari_model.dart';
import '../list_form/aset_list_par.dart';
import '../tables/template_table_form_widget.dart';

class TableParWidget extends StatelessWidget {
  const TableParWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateTableFormWidget<
        AsetParCariModel,
        AsetParCariBloc,
        AsetDashboardCariBloc,
        ShareParStateCubit
    >(
      cobType: 'Par',
      shareCubitBuilder: () => ShareParStateCubit(),
      listBuilder: (searchText, [statusLabel]) => AsetListPar(
        searchText: searchText,
        statusLabel: statusLabel ?? 'Aktif',),
      onRefreshRequested: (statusId, searchText) {
        context.read<AsetParCariBloc>().add(
          RefreshAsetParCariEvent(statusId: statusId, searchText: searchText),
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