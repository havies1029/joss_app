import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:joss_app/blocs/share_cubit/share_dnsppa_state_cubit.dart';
import 'package:joss_app/pages/payment/mobile/ringkasan/reusable_payment_table.dart';

import '../../../../../blocs/payment/dnsppacari_bloc.dart';
import '../../../../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
import '../../../../../models/payment/dnsppacari_model.dart';
import '../../../ringkasan/detail/dnsppacari_list.dart';

class RingkasanDetailPage extends StatefulWidget {
  final List<DnsppaCariModel>? overrideItems;

  const RingkasanDetailPage({
    super.key,
    this.overrideItems,
  });

  @override
  State<RingkasanDetailPage> createState() => _RingkasanDetailPageState();
}

class _RingkasanDetailPageState extends State<RingkasanDetailPage> {

  late DnsppaCariBloc dnsppaCariBloc;
  void initState() {
    super.initState();
    dnsppaCariBloc = context.read<DnsppaCariBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }
  void refreshData() {
    final cobCubit = context.read<ShareDnrekapcobStateCubit>();
    final ids = cobCubit.selectedCobIds;   // <-- ambil semua COB ID

    if (ids.isEmpty) {
      print("BELUM ADA COB YANG DIPILIH");
      return;
    }

    dnsppaCariBloc.add(
      RefreshDnsppaCariEvent(
        listcobId: ids,
        currId: "001",
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareDnsppaStateCubit>();

    return ReusablePaymentTable<
        DnsppaCariBloc,
        DnsppaCariState,
        DnsppaCariModel,
        ShareDnsppaStateCubit>(
      bloc: context.read<DnsppaCariBloc>(),
      cubit: cubit,

      hasMore: (state) => !state.hasReachedMax,
      getItems: (state) => widget.overrideItems ?? state.items,
      getStatus: (state) => state.status,

      getItemId: (item) => item.sppa1Id,

      columnWidths: const {
        0: FixedColumnWidth(110),
        1: FixedColumnWidth(160),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(170),
        4: FixedColumnWidth(150),
        5: FixedColumnWidth(160),
      },

      headerCells: const [
        HeaderCell("No", center: true),
        HeaderCell("DN ID", center: true),
        HeaderCell("No Polis"),
        HeaderCell("Currency"),
        HeaderCell("Periode"),
        HeaderCell("Outstanding"),
        HeaderCell("SPPA ID"),
      ],

      rowBuilder: (context, item, rowNumber, cubit) => [
        CellText("$rowNumber", center: true),

        CellText(item.dn1Id, center: true),

        GestureDetector(
          onTap: () => _navigateToDetail(context, item),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              item.noPolis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        CellText(item.currSimbol),

        CellText(
          "${DateFormat('dd/MM/yy').format(item.polisMulai)} "
              "- ${DateFormat('dd/MM/yy').format(item.polisAkhir)}",
          center: true,
        ),

        CellText(
          NumberFormat.currency(
            locale: 'id',
            symbol: item.currSimbol,
            decimalDigits: 0,
          ).format(item.dnOs),
        ),

        CellText(item.sppa1Id),
      ],

      onFetchMore: () {
        context.read<DnsppaCariBloc>().add(FetchDnsppaCariEvent());
      },
    );
  }

  void _navigateToDetail(
      BuildContext context,
      DnsppaCariModel item,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DnsppaCariPage(
          listcobId: item.sppa1Id,
          currId: item.currSimbol,
        ),
      ),
    );
  }
}
