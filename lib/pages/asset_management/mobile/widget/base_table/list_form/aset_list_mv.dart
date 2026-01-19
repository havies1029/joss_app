import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_mv_state_cubit.dart';
import '../../../../../../helper/action_button_helper.dart';
import '../../../../../../models/gen_aset_mv/asetmvcari_model.dart';
import '../tables/reusable_aset_table.dart';

class AsetListMv extends StatelessWidget {
  final String searchText;
  final String? statusLabel;
  const AsetListMv({super.key, required this.searchText, this.statusLabel,});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareMvStateCubit>();

    return ReusableAsetTable<
        AsetMvCariBloc,
        AsetMvCariState,
        AsetMvCariModel,
        ShareMvStateCubit>(
      bloc: context.read<AsetMvCariBloc>(),
      cubit: cubit,
      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asetMvId,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        5: IntrinsicColumnWidth(),
        6: IntrinsicColumnWidth(),
        7: IntrinsicColumnWidth(),
        8: IntrinsicColumnWidth(),
        // 9: IntrinsicColumnWidth(),
        // 8: IntrinsicColumnWidth(),
        // 9: IntrinsicColumnWidth(),
        // 10: IntrinsicColumnWidth(),
        // 11: IntrinsicColumnWidth(),
        // 12: IntrinsicColumnWidth(),
        // 13: IntrinsicColumnWidth(),
        // 14: IntrinsicColumnWidth(),
      },
      currentStatusFilter: statusLabel,
      headerCells: const [
        HeaderCell("No", center: true),
        // HeaderCell("Currency"),
        // HeaderCell("Jenis MV"),
        HeaderCell("Tertanggung"),
        // HeaderCell("Periode"),
        HeaderCell("Merk Kendaraan "),
        HeaderCell("Nomor Polisi"),
        // HeaderCell("Polis No"),
        HeaderCell("Nilai Tertanggung"),
        HeaderCell("Premi"),
        // HeaderCell("Tahun", center: true),
        // HeaderCell("Tipe", center: true),
        HeaderCell("Status", center: true),
        // HeaderCell("Aksi"),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.tertanggung),
        // CellText(item.periodeAkhir),
        // CellText(item.curr),
        // CellText(item.jenisMv),
        CellText(item.merk),
        CellText(item.noPolisi),
        // CellText(item.polisNo),
        CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.sumInsured),
        ),
        CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.premi),
        ),
        // CellText("${item.tahun}", center: true),
        // CellText(item.tipe, center: true),
        CellText(item.status, center: true),
        // Padding(
        //   padding: const EdgeInsets.all(6),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: getActionButtonsByStatus(
        //       item.status,
        //       namaItem: item.noPolisi,
        //       context: context,
        //       itemData: item,
        //       onProcessTap: () async {
        //         final bloc = context.read<AsetMvCariBloc>();
        //         debugPrint("📡 Klik Lacak Polis untuk: ${item.noPolisi}");
        //
        //         bloc.add(
        //           DebugFetchAsetMvCariEvent(
        //             searchText: item.noPolisi,
        //             statusId: '10001',
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),

      ],
      onFetchMore: () {
        context.read<AsetMvCariBloc>().add(FetchAsetMvCariEvent());
      },
      emptyStatusLabel: statusLabel,
    );
  }
}
