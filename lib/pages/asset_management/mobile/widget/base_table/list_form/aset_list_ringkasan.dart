import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
import '../../../../../../blocs/share_cubit/share_ringkasan_state_cubit.dart';
import '../tables/reusable_aset_table.dart';

class AsetListRingkasan extends StatelessWidget {
  final String searchText;
  final String? statusLabel;

  const AsetListRingkasan({
    super.key,
    required this.searchText,
    this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareRingkasanStateCubit>();


    return ReusableAsetTable<
        AsetRingkasanCariBloc,
        AsetRingkasanCariState,
        AsetRingkasanCariModel,
        ShareRingkasanStateCubit>(
      bloc: context.read<AsetRingkasanCariBloc>(),
      cubit: cubit,
      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.asetRingkasanId,
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
      },
      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("Nama Aset"),
        HeaderCell("Currency"),
        HeaderCell("Jumlah"),
        HeaderCell("Nilai"),
        HeaderCell("Premi"),
        HeaderCell("Nomor Urut", center: true),
        HeaderCell("Satuan", center: true),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.asetNama),
        CellText(item.curr),
        CellText("${item.jmlAset} ${item.satuan}"),
        CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.nilaiAset)),
        CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.nilaiPremi)),
        CellText("${item.noUrut}", center: true),
        CellText(item.satuan, center: true),
      ],
      onFetchMore: () {
        context.read<AsetRingkasanCariBloc>().add(FetchAsetRingkasanCariEvent());
      },
      emptyStatusLabel: statusLabel,
    );
  }
}

