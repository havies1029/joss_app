import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_health_state_cubit.dart';
import '../../../../../../models/gen_aset_health/asethealthcari_model.dart';
import '../list_form/aset_list_health.dart';
import '../tables/template_table_form_widget.dart';

class TableHealthWidget extends StatelessWidget {
  const TableHealthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateTableFormWidget<
        AsetHealthCariModel,
        AsetHealthCariBloc,
        AsetDashboardCariBloc,
        ShareHealthStateCubit
    >(
      cobType: 'Health',
      shareCubitBuilder: () => ShareHealthStateCubit(),
      listBuilder: (searchText, [statusLabel]) => AsetListHealth(
        searchText: searchText,
        statusLabel: statusLabel ?? 'Aktif',),
      onRefreshRequested: (statusId, searchText) {
        context.read<AsetHealthCariBloc>().add(
          RefreshAsetHealthCariEvent(statusId: statusId, searchText: searchText),
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