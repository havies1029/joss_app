import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_flat_mapper.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
import '../../../../common/constants.dart';
import '../ringkasan/reusable_payment_table.dart';

class PaymentRincianList extends StatelessWidget {
  const PaymentRincianList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DnRekap2invBloc>();
    final cubit = context.read<ShareRincianStateCubit>();

    return ReusablePaymentTable<
        DnRekap2invBloc,
        DnRekap2invState,
        RincianFlatItem,
        ShareRincianStateCubit>(
      bloc: bloc,
      cubit: cubit,

      getItems: (state) => state.rincianFlatItems,
      getStatus: (_) => ListStatus.success,
      hasMore: (_) => false,

      getItemId: (item) => item.dn1Id,
      showCheckbox: true,

      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(140),
        2: FixedColumnWidth(160),
        3: FixedColumnWidth(220),
        4: FixedColumnWidth(80),
        5: FixedColumnWidth(160),
        6: FixedColumnWidth(200),
      },

      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("COB"),
        HeaderCell("No Polis"),
        HeaderCell("Object"),
        HeaderCell("Curr"),
        HeaderCell("Outstanding"),
        HeaderCell("Periode"),
      ],

      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.cobNama),
        CellText(item.noPolis),
        CellText(item.objectDesc),
        CellText(item.currSimbol),
        CellText(NumberFormat.decimalPattern().format(item.dnOs)),
        CellText(
          "${item.polisMulai.toString().substring(0, 10)} → "
              "${item.polisAkhir.toString().substring(0, 10)}",
        ),
      ],
    );
  }
}
