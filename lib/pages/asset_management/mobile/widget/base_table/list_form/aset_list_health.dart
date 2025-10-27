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
    final bloc = context.read<AsetHealthCariBloc>();

    return ReusableAsetTable<
        AsetHealthCariBloc,
        AsetHealthCariState,
        AsetHealthCariModel,
        ShareHealthStateCubit>(
      bloc: bloc,
      cubit: cubit,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asethealthId,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        5: IntrinsicColumnWidth(),
        6: IntrinsicColumnWidth(),
      },
      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("Nama"),
        HeaderCell("Nomor Polis"),
        HeaderCell("Posisi", center: true),
        HeaderCell("Status", center: true),
        HeaderCell("Aksi"),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.nama),
        CellText(item.polisNo),
        CellText(item.posisi, center: true),
        CellText(item.status, center: true),

        // Tombol-tombol aksi
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: getActionButtonsByStatus(
              item.status,
              namaItem: item.nama,
              context: context,
              itemData: item,
              onProcessTap: () async {
                debugPrint("🔍 [Lacak Polis] Request data untuk: ${item.nama}");

                // ⏳ kirim event refresh (tanpa trigger rebuild UI)
                bloc.add(
                  DebugFetchAsetHealthCariEvent(
                    searchText: item.nama,
                    statusId: '10001',
                  ),
                );
              },
            ),
          ),
        ),
      ],
      onFetchMore: () {
        bloc.add(FetchAsetHealthCariEvent());
      },
      emptyStatusLabel: statusLabel,
    );
  }
}
