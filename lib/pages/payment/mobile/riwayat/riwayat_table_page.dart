import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/payment/pay1list_bloc.dart';
import 'package:joss_app/blocs/payment/pay1crud_bloc.dart';

import '../../../../blocs/payment/pay2cari_bloc.dart';
import '../../../../models/payment/pay1list_model.dart';
import 'detail_riwayat/riwayat_detail_table_page.dart';

class RiwayatTablePage extends StatefulWidget {
  final String searchText;
  const RiwayatTablePage({super.key, required this.searchText});

  @override
  RiwayatTablePageState createState() => RiwayatTablePageState();
}

class RiwayatTablePageState extends State<RiwayatTablePage> {
  late Pay1ListBloc pay1ListBloc;
  late Pay1CrudBloc pay1CrudBloc;

  final ScrollController _scrollController = ScrollController();

  String formatNum(num value) =>
      NumberFormat.decimalPattern().format(value);

  String formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  void _openDetail(String ar1Id) {
    FocusScope.of(context).requestFocus(FocusNode());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: context.read<Pay2CariBloc>(),
          child: RiwayatDetailTablePage(ar1Id: ar1Id),
        );
      },
      useSafeArea: true,
    );
  }

  Widget _rowTapWrapper(Pay1ListModel d, {required Widget child}) {
    return InkWell(
      onTap: () => _openDetail(d.ar1Id),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: child,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pay1ListBloc = BlocProvider.of<Pay1ListBloc>(context);
    pay1CrudBloc = BlocProvider.of<Pay1CrudBloc>(context);

    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocConsumer<Pay1ListBloc, Pay1ListState>(
      buildWhen: (p, c) => c.status == ListStatus.success,
      listener: (_, __) {},
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty) {
          return const Center(
            child: Text(
              "No Data Available!!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return SizedBox(child: isNarrow
            ? _buildTableCompact(state.items)
            : _buildTableNormal(state.items));
      },
    );
  }

  // ========= TABLE COMPACT (NARROW) =========

  Widget _buildTableCompact(List<Pay1ListModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - (hPadding * 3),
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: _tableBorder(),
              columnWidths: const {
                0: FixedColumnWidth(50),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
                4: IntrinsicColumnWidth(),
              },
              children: [
                _headerRow(),
                ...items.asMap().entries.map(
                      (e) => _row(e.value, e.key, compact: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========= TABLE NORMAL =========

  Widget _buildTableNormal(List<Pay1ListModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder(),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(3),
            // 4: FlexColumnWidth(2),
          },
          children: [
            _headerRow(),

            ...items.asMap().entries.map(
                  (e) => _row(
                e.value,
                e.key,
                compact: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========= SHARED PARTS =========

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: formGrey,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: const Border(
        top: BorderSide(color: sGrey, width: 1),
        left: BorderSide(color: sGrey, width: 1),
        right: BorderSide(color: sGrey, width: 1),
        bottom: BorderSide(color: sGrey, width: 0.5),
      ),
    );
  }

  TableBorder _tableBorder() {
    return const TableBorder(
      horizontalInside: BorderSide(color: sGrey, width: 1),
      verticalInside: BorderSide(color: sGrey, width: 1),
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        _headerCell("NO"),
        _headerCell("NO PEMBAYARAN"),
        _headerCell("TANGGAL\nDIBAYAR"),
        _headerCell("JUMLAH\nPOLIS"),
        _headerCell("TOTAL PEMBAYARAN"),
        // _headerCell("Aksi"),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: primaryLightColor,
        ),
      ),
    );
  }

  TableRow _row(
      Pay1ListModel d,
      int index, {
        required bool compact,
      }) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _rowTapWrapper(
          d,
          child: _cell((index + 1).toString()),
        ),

        _rowTapWrapper(
          d,
          child: _cell(d.ar1Id),
        ),

        _rowTapWrapper(
          d,
          child: _cell(formatDate(d.arTgl)),
        ),

        _rowTapWrapper(
          d,
          child: _cell(d.sppaCount.toString()),
        ),

        _rowTapWrapper(
          d,
          child: _cell(formatNum(d.totalOs)),
        ),

        // kolom aksi tetap terpisah — TIDAK ikut trigger detail
        // Padding(
        //   padding: const EdgeInsets.all(6),
        //   child: Row(
        //     children: [
        //       IconButton(
        //         icon: const Icon(Icons.edit, color: Colors.green),
        //         onPressed: () {
        //           _openDetail(d.ar1Id);
        //         },
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.delete, color: Colors.red),
        //         onPressed: () => showDialogHapus(d.ar1Id),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(color: primaryLightColor, fontSize: 15),
      ),
    );
  }

  // ========= SCROLL / DELETE HELPERS =========

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      pay1ListBloc.add(FetchPay1ListEvent());
    }
  }

  onHapusFunction(String recordId) {
    pay1CrudBloc.add(Pay1CrudHapusEvent(recordId: recordId));
  }

  void showDialogHapus(String recordId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ShowDialogHapusWidget(
          onHapusFunction: onHapusFunction,
          recordId: recordId,
        );
      },
    ).then((_) {
      pay1ListBloc.add(CloseDialogPay1ListEvent());
    });
  }
}
