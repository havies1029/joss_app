import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_hull_state_cubit.dart';
import '../../../../../../helper/action_button_helper.dart';
import '../../../../../../models/gen_aset_hull/asethullcari_model.dart';
import '../tables/reusable_aset_table.dart';

/// 🚢 AsetListHull
/// Widget list untuk aset tipe Hull (Marine Vessel).
class AsetListHull extends StatelessWidget {
  final String searchText;
  final String? statusLabel;
  const AsetListHull({
    super.key,
    required this.searchText,
    this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareHullStateCubit>();

    return ReusableAsetTable<
        AsethullCariBloc,
        AsethullCariState,
        AsethullCariModel,
        ShareHullStateCubit>(
      bloc: context.read<AsethullCariBloc>(),
      cubit: cubit,
      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asetHullId,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        5: IntrinsicColumnWidth(),
        6: IntrinsicColumnWidth(),
        7: IntrinsicColumnWidth(),
        // 8: IntrinsicColumnWidth(),
        // 9: IntrinsicColumnWidth(),
      },
      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("Tertanggung"),
        HeaderCell("Detail Rangka Kapal"),
        // HeaderCell("Mata Uang"),
        // HeaderCell("Polis No"),
        HeaderCell("Nilai Tertanggung"),
        HeaderCell("Premi"),
        HeaderCell("Status", center: true),
        HeaderCell("Aksi"),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        /// Kolom 1: Nomor urut
        CellText("$rowNumber", center: true),
        
        CellText(item.tertanggung),

        /// Kolom 2: Nama kapal
        CellText(item.namaKapal),

        /// Kolom 3: Currency
        // CellText(item.curr),

        /// Kolom 4: No polis
        // CellText(item.polisNo),

        /// Kolom 5: TSI (Total Sum Insured)
        CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.tsi),
        ),

        /// Kolom 6: Premi
        CellText(
          NumberFormat.currency(locale: 'id', symbol: 'IDR ')
              .format(item.premi),
        ),

        /// Kolom 7: Status
        CellText(item.status, center: true),

        /// Kolom 8: Aksi tombol
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: getActionButtonsByStatus(
              item.status,
              namaItem: item.namaKapal, // ⚓ nama kapal jadi identifier
              context: context,
              itemData: item,
              onProcessTap: () {
                final bloc = context.read<AsethullCariBloc>();
                debugPrint("📡 Klik Lacak Polis untuk kapal: ${item.namaKapal}");

                bloc.add(
                  DebugFetchAsethullCariEvent(
                    searchText: item.namaKapal,
                    statusId: '10001',
                  ),
                );
              },
            ),
          ),
        ),
      ],
      onFetchMore: () {
        context.read<AsethullCariBloc>().add(FetchAsethullCariEvent());
      },
      emptyStatusLabel: statusLabel,
    );
  }
}
