import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/payment/mobile/ringkasan/reusable_payment_table.dart';

import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
import '../../../../models/payment/dnrekapcobcari_model.dart';
import '../../ringkasan/detail/dnsppacari_list.dart';


class PaymentRingkasanList extends StatelessWidget {
  final String searchText;
  final bool showCheckbox;
  final List<DnrekapcobCariModel>? overrideItems;

  const PaymentRingkasanList({
    super.key,
    required this.searchText,
    this.showCheckbox = true,
    this.overrideItems,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareDnrekapcobStateCubit>();

    return ReusablePaymentTable<
        DnrekapcobCariBloc,
        DnrekapcobCariState,
        DnrekapcobCariModel,
        ShareDnrekapcobStateCubit>(
      bloc: context.read<DnrekapcobCariBloc>(),
      cubit: cubit,

      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => overrideItems ?? state.items,
      getStatus: (state) => state.status,
      getItemId: (item) => item.dnrekapcobId,

      showCheckbox: showCheckbox,

      columnWidths: const {
        0: IntrinsicColumnWidth(), // Checkbox
        1: FixedColumnWidth(100),  // COB ID
        2: FixedColumnWidth(150),  // COB Name (tappable)
        3: FixedColumnWidth(120),  // Currency
        4: FixedColumnWidth(100),  // Jumlah Polis
        5: FixedColumnWidth(150),  // Total Tagihan
        6: FixedColumnWidth(150),  // TSI
      },

      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("COB ID", center: true),
        HeaderCell("Nama COB"),
        HeaderCell("Currency"),
        HeaderCell("Jumlah Polis", center: true),
        HeaderCell("Total Tagihan"),
        HeaderCell("TSI"),
      ],

      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),
        CellText(item.cobId, center: true),

        // Nama COB - tappable (detail only)
        GestureDetector(
          onTap: () => _navigateToDetailCOB(context, item),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            child: Text(
              item.cobNama,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        CellText('${item.currSimbol} (${item.currId})'),
        CellText('${item.polisCount}', center: true),

        CellText(
          NumberFormat.currency(
            locale: 'id',
            symbol: item.currSimbol,
            decimalDigits: 0,
          ).format(item.polisAmount),
        ),

        CellText(
          NumberFormat.currency(
            locale: 'id',
            symbol: item.currSimbol,
            decimalDigits: 0,
          ).format(item.tsi),
        ),
      ],

      onFetchMore: () {
        context
            .read<DnrekapcobCariBloc>()
            .add(FetchDnrekapcobCariEvent());
      },
    );
  }

  void _navigateToDetailCOB(
      BuildContext context,
      DnrekapcobCariModel item,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DnsppaCariPage(
          listcobId: item.cobId,
          currId: item.currId,
        ),
      ),
    );
  }
}
