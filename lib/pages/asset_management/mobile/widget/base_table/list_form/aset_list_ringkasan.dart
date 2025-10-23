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
  const AsetListRingkasan({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareRingkasanStateCubit>();

    return ReusableAsetTable<
        AsetRingkasanCariBloc,
        AsetRingkasanCariState,
        AsetRingkasanCariModel>(
      bloc: context.read<AsetRingkasanCariBloc>(),
      cubit: cubit, // Cubit dengan state Map<String, dynamic>
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
        _HeaderCell("No", center: true),
        _HeaderCell("Nama Aset"),

        _HeaderCell("Currency"),
        _HeaderCell("Jumlah"),
        _HeaderCell("Nilai"),
        _HeaderCell("Premi"),
        _HeaderCell("Nomor Urut", center: true),
        _HeaderCell("Satuan", center: true),
      ],
      rowBuilder: (context, item, rowNumber, cubit) => [
        _CellText("$rowNumber", center: true),
        _CellText(item.asetNama),

        _CellText(item.curr),
        _CellText("${item.jmlAset} ${item.satuan}"),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.nilaiAset)),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.nilaiPremi)),
        _CellText("${item.noUrut}", center: true),
        _CellText(item.satuan, center: true),
      ],
    );
  }
}

// 🔹 Tetap bisa pakai komponen text ini buat gaya konsisten
class _HeaderCell extends StatelessWidget {
  final String text;
  final bool center;
  const _HeaderCell(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: getResponsiveFont(context, 16),
          color: primaryLightColor,
        ),
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;
  final bool center;
  const _CellText(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: getResponsiveFont(context, 14),
          color: primaryLightColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
