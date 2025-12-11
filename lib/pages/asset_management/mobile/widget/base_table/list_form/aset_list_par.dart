import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_par_state_cubit.dart';
import '../../../../../../helper/action_button_helper.dart';
import '../../../../../../models/gen_aset_par/asetparcari_model.dart';
import '../tables/reusable_aset_table.dart';

class AsetListPar extends StatelessWidget {
  final String searchText;
  final String? statusLabel;
  const AsetListPar({super.key, required this.searchText, this.statusLabel,});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareParStateCubit>();

    return ReusableAsetTable<
        AsetParCariBloc,
        AsetParCariState,
        AsetParCariModel,
        ShareParStateCubit>(
      bloc: context.read<AsetParCariBloc>(),
      cubit: cubit,
      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asetParId,
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
      },
      currentStatusFilter: statusLabel,
      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("Tertanggung"),
        HeaderCell("Alamat"),
        HeaderCell("Periode"),
        // HeaderCell("Currency"),
        // HeaderCell("Klausula Bank"),
        // HeaderCell("Polis No"),
        HeaderCell("Nilai Pertanggungan"),
        HeaderCell("Premi"),
        HeaderCell("Status", center: true),
        // HeaderCell("Aksi"),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.tertanggung),
        CellText(item.alamat),
        CellText(item.periode),
        // CellText(item.curr),
        // CellText(item.klausulaBank),
        // CellText(item.polisNo),
        CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.sumInsured),
        ),
        CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.premi),
        ),
        CellText(item.status, center: true),
        // Padding(
        //   padding: const EdgeInsets.all(6),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: getActionButtonsByStatus(
        //       item.status,
        //       namaItem: item.alamat, // 🏠 ambil data dari alamat
        //       context: context,
        //       itemData: item,
        //       onProcessTap: () {
        //         final bloc = context.read<AsetParCariBloc>();
        //         debugPrint("📡 Klik Lacak Polis untuk: ${item.alamat}");
        //
        //         bloc.add(
        //           DebugFetchAsetParCariEvent(
        //             searchText: item.alamat,
        //             statusId: '10001',
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
      onFetchMore: () {
        context.read<AsetParCariBloc>().add(FetchAsetParCariEvent());
      },
      emptyStatusLabel: statusLabel,
    );
  }
}
