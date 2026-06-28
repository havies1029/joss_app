import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';

import '../../../../blocs/payment/historybayar2cari_bloc.dart';
import '../../../../common/loading_indicator.dart';
import 'detail_riwayat/riwayat_detail_table_page_remake.dart';

class RiwayatTablePageRemake extends StatefulWidget {
  final String searchText;
  const RiwayatTablePageRemake({super.key, required this.searchText});

  @override
  State<RiwayatTablePageRemake> createState() => _RiwayatTablePageRemakeState();
}

class _RiwayatTablePageRemakeState extends State<RiwayatTablePageRemake> {
  final ScrollController _vController = ScrollController();
  final ScrollController _hController = ScrollController();

  bool _fetchLock = false;

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);
  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  @override
  void initState() {
    super.initState();
    _vController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _vController.removeListener(_onScroll);
    _vController.dispose();
    _hController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_vController.hasClients) return;

    final bloc = context.read<HistorybayarCariBloc>();
    final state = bloc.state;

    if (state.hasReachedMax) return;

    if (state.isLoading) {
      _fetchLock = false;
      return;
    }

    final nearBottom = _vController.position.extentAfter < 200;

    if (nearBottom && !_fetchLock) {
      _fetchLock = true;
      bloc.add(FetchHistorybayarCariEvent());
    }

    if (!nearBottom) {
      _fetchLock = false;
    }
  }

  void _openDetail(String inv1Id) {
    FocusScope.of(context).requestFocus(FocusNode());

    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider.value(
          value: context.read<Historybayar2CariBloc>(),
          child: RiwayatDetailTablePageRemake(inv1Id: inv1Id),
        );
      },
    );
  }

  void _onTapRow(HistorybayarCariModel item) {
    context
        .read<HistorybayarCariBloc>()
        .add(SelectHistorybayarCariEvent(selected: item));

    _openDetail(item.inv1Id);
  }

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

  Widget _headerCell(String text) {
    final bool isNo = text.trim().toUpperCase() == "NO";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
      child: isNo
          ? Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: primaryLightColor,
          ),
        ),
      )
          : Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: primaryLightColor,
        ),
      ),
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
      ],
    );
  }

  Widget _cell(
      String text, {
        bool center = false,
        bool right = false,
      }) {
    final t = Text(
      text,
      style: const TextStyle(
        color: primaryLightColor,
        fontSize: 15,
      ),
    );

    Widget child = t;
    if (center) child = Center(child: t);
    if (right) child = Align(alignment: Alignment.centerRight, child: t);

    return Padding(
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }

  Widget _tapWrap(HistorybayarCariModel d, Widget child) {
    // InkWell butuh Material untuk ripple konsisten
    return InkWell(
      onTap: () => _onTapRow(d),
      child: child,
    );
  }

  TableRow _row(HistorybayarCariModel d, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _tapWrap(d, _cell((index + 1).toString(), center: true)),
        _tapWrap(d, _cell(d.inv1Id)),
        _tapWrap(d, _cell(formatDate(d.invTgl))),
        _tapWrap(d, _cell(d.jmlPolis.toString())),
        _tapWrap(d, _cell(d.status)),
        _tapWrap(d, _cell("${d.curr} ${formatNum(d.totalBayar)}")),
      ],
    );
  }

  Widget _buildTableCompact(List<HistorybayarCariModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(true),
            trackVisibility: WidgetStateProperty.all(false),
            thickness: WidgetStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.1)),
          ),
          child: Scrollbar(
            controller: _hController,
            child: SingleChildScrollView(
              controller: _hController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // sama persis: minWidth layar - padding kiri kanan (hPadding*3)
                  minWidth: MediaQuery.of(context).size.width - (hPadding * 3),
                ),
                child: Material(
                  color: Colors.transparent,
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
                            (e) => _row(e.value, e.key),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableNormal(List<HistorybayarCariModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: Material(
          color: Colors.transparent,
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
                    (e) => _row(e.value, e.key),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width < 900;

    return BlocBuilder<HistorybayarCariBloc, HistorybayarCariState>(
      buildWhen: (p, c) =>
      p.status != c.status ||
          p.items != c.items ||
          p.isLoaded != c.isLoaded ||
          p.isLoading != c.isLoading,
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: LoadingIndicator());
        }

        if (state.items.isEmpty) {
          return const Center(child: Text("No Data Available!!"));
        }

        return SingleChildScrollView(
          controller: _vController,
          // padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
          child: Column(
            children: [
              isNarrow ? _buildTableCompact(state.items) : _buildTableNormal(state.items),

              const SizedBox(height: 16),

              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LoadingIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}