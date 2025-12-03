import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';

import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_ringkasan_state_cubit.dart';
import '../../../../../../models/gen_aset_ringkasan/asetringkasancari_model.dart';
import '../list_form/aset_list_ringkasan.dart';
import '../tables/template_table_form_widget.dart';

class TableRingkasanWidget extends StatelessWidget {
  const TableRingkasanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateTableFormWidget<
        AsetRingkasanCariModel,
        AsetRingkasanCariBloc,
        AsetDashboardCariBloc,
        ShareRingkasanStateCubit
    >(
      cobType: 'ringkasan',
      shareCubitBuilder: () => ShareRingkasanStateCubit(),
      listBuilder: (searchText, [statusLabel]) =>
          AsetListRingkasan(
            searchText: searchText,
            statusLabel: statusLabel ?? 'Aktif',
          ),
      onRefreshRequested: (statusId, searchText) {
        context.read<AsetRingkasanCariBloc>().add(
          RefreshAsetRingkasanCariEvent(statusId: statusId, searchText: searchText),
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