import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_health_state_cubit.dart';
import '../../../../../../helper/action_button_helper.dart';
import '../../../../../../models/gen_aset_health/asethealthcari_model.dart';
import '../tables/reusable_aset_table.dart';

class AsetListHealth extends StatelessWidget {
  final String searchText;
  final String? statusLabel;

  const AsetListHealth({
    super.key,
    required this.searchText,
    this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareHealthStateCubit>();

    return ReusableAsetTable<
        AsetHealthCariBloc,
        AsetHealthCariState,
        AsetHealthCariModel,
        ShareHealthStateCubit>(
      bloc: context.read<AsetHealthCariBloc>(),
      cubit: cubit,
      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asethealthId,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        // 5: IntrinsicColumnWidth(),
        // 6: IntrinsicColumnWidth(),
      },
      currentStatusFilter: statusLabel,
      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("Nama"),
        HeaderCell("Benefit"),

        HeaderCell("Status", center: true),
        // HeaderCell("Aksi"),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.nama),
        CellText(item.benefit),
        // CellText(item.polisNo),
        // CellText(item.posisi, center: true),
        CellText(item.status, center: true),
        // Padding(
        //   padding: const EdgeInsets.all(6),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: getActionButtonsByStatus(
        //       item.status,
        //       namaItem: item.nama,
        //       context: context,
        //       itemData: item,
        //       onProcessTap: () async {
        //         final bloc = context.read<AsetHealthCariBloc>();
        //         debugPrint("🔍 [Lacak Nama] Request data untuk: ${item.nama}");
        //
        //         bloc.add(
        //           DebugFetchAsetHealthCariEvent(
        //             searchText: item.nama,
        //             statusId: '10001',
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
      onFetchMore: () {
        context.read<AsetHealthCariBloc>().add(FetchAsetHealthCariEvent());
      },
      emptyStatusLabel: statusLabel,
    );
  }
}
