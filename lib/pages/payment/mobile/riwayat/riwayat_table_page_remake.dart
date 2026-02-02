import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/common/constants.dart';


import '../../../../blocs/payment/historybayar2cari_bloc.dart';
import '../../../../models/payment/historybayarcari_model.dart';
import 'detail_riwayat/riwayat_detail_table_page.dart';
import 'detail_riwayat/riwayat_detail_table_page_remake.dart';

class RiwayatTablePageRemake extends StatefulWidget {
  final String searchText;
  const RiwayatTablePageRemake({super.key, required this.searchText});

  @override
  RiwayatTablePageRemakeState createState() => RiwayatTablePageRemakeState();
}

class RiwayatTablePageRemakeState extends State<RiwayatTablePageRemake> {
  late HistorybayarCariBloc historybayarCariBloc;

  final ScrollController _scrollController = ScrollController();

  String formatNum(num value) =>
      NumberFormat.decimalPattern().format(value);

  String formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  void _openDetail(String inv1Id) {
    FocusScope.of(context).requestFocus(FocusNode());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: context.read<Historybayar2CariBloc>(),
          child: RiwayatDetailTablePageRemake(inv1Id: inv1Id),
        );
      },
      useSafeArea: true,
    );
  }

  Widget _rowTapWrapper(HistorybayarCariModel d, {required Widget child}) {
    return InkWell(
      onTap: () => {
        context.read<HistorybayarCariBloc>()
            .add(SelectHistorybayarCariEvent(selected: d)),
        _openDetail(d.inv1Id)
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: child,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    historybayarCariBloc = context.read<HistorybayarCariBloc>();
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
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocConsumer<HistorybayarCariBloc, HistorybayarCariState>(
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

  Widget _buildTableCompact(List<HistorybayarCariModel> items) {
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
                5: IntrinsicColumnWidth(),
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

  Widget _buildTableNormal(List<HistorybayarCariModel> items) {
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
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(3),
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
        _headerCell("STATUS"),
        _headerCell("TOTAL PEMBAYARAN"),
        // _headerCell("Aksi"),
      ],
    );
  }
  Widget _headerCell(String text) {
    final bool isNo = text.trim().toUpperCase() == "NO";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
      child: isNo
          ? Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: primaryLightColor,
          ),
        ),
      )
          : Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: primaryLightColor,
        ),
      ),
    );
  }

  TableRow _row(
      HistorybayarCariModel d,
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
          child: _cell(
            (index + 1).toString(),
            center: true,
          ),
        ),

        _rowTapWrapper(
          d,
          child: _cell(d.inv1Id),
        ),

        _rowTapWrapper(
          d,
          child: _cell(formatDate(d.invTgl)),
        ),

        _rowTapWrapper(
          d,
          child: _cell(d.jmlPolis.toString()),
        ),

        _rowTapWrapper(
          d,
          child: _cell(d.status.toString()),
        ),

        _rowTapWrapper(
          d,
          child: _cell(formatNum(d.totalBayar)),
        ),
      ],
    );
  }

  Widget _cell(
      String text, {
        bool center = false,
      }) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: center
          ? Center(
        child: Text(
          text,
          style: TextStyle(
            color: primaryLightColor,
            fontSize: 15,
          ),
        ),
      )
          : Text(
        text,
        style: TextStyle(
          color: primaryLightColor,
          fontSize: 15,
        ),
      ),
    );
  }

  // ========= SCROLL / DELETE HELPERS =========

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      historybayarCariBloc.add(FetchHistorybayarCariEvent());
    }
  }
}
