import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/pay2cari_bloc.dart';
import 'package:joss_app/models/payment/pay2cari_model.dart';

class RiwayatTableWidget extends StatefulWidget {
  const RiwayatTableWidget({super.key});

  @override
  State<RiwayatTableWidget> createState() => _RiwayatTableWidgetState();
}

class _RiwayatTableWidgetState extends State<RiwayatTableWidget> {
  late Pay2CariBloc pay2CariBloc;

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  String _fmtDate(dynamic v) {
    if (v == null) return "-";
    // kalau DateTime
    if (v is DateTime) return DateFormat('yyyy-MM-dd').format(v);
    // kalau String "2025-01-01T00:00:00"
    final s = v.toString();
    if (s.length >= 10) return s.substring(0, 10);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    pay2CariBloc = context.read<Pay2CariBloc>();

    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocBuilder<Pay2CariBloc, Pay2CariState>(
      buildWhen: (p, c) => p.status != c.status || p.items != c.items,
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }

        final items =
        state.items.isNotEmpty ? state.items : _dummyItems();

        return isNarrow
            ? _buildTableCompact(items)
            : _buildTableNormal(items);

        /*
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

        return isNarrow
            ? _buildTableCompact(state.items)
            : _buildTableNormal(state.items);
        */
      },
    );
  }

  // ========= TABLE COMPACT (NARROW) =========
  Widget _buildTableCompact(List<Pay2CariModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecorationTopOnly(), // mirip rincian (bagian atas)
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: _tableBorder(),
            columnWidths: const {
              0: FixedColumnWidth(55), // No
              1: IntrinsicColumnWidth(), // No Polis / SPPA
              2: FixedColumnWidth(140), // Periode
              3: FixedColumnWidth(140), // Outstanding
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
    );
  }

  // ========= TABLE NORMAL =========
  Widget _buildTableNormal(List<Pay2CariModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecorationTopOnly(),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder(),
          columnWidths: const {
            0: FlexColumnWidth(1), // No
            1: FlexColumnWidth(3), // No Polis/SPPA
            2: FlexColumnWidth(3), // Periode
            3: FlexColumnWidth(2), // Outstanding
          },
          children: [
            _headerRow(),
            ...items.asMap().entries.map(
                  (e) => _row(e.value, e.key, compact: false),
            ),
          ],
        ),
      ),
    );
  }

  // ========= SHARED PARTS =========
  BoxDecoration _boxDecorationTopOnly() {
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
    return const TableRow(
      decoration: BoxDecoration(color: formGrey),
      children: [
        _HeaderCell("No", center: true),
        _HeaderCell("No Polis/SPPA"),
        _HeaderCell("Periode"),
        _HeaderCell("Outstanding"),
      ],
    );
  }

  TableRow _row(Pay2CariModel d, int index, {required bool compact}) {
    final periode =
        "${_fmtDate(d.periodeMulai)} → ${_fmtDate(d.periodeAkhir)}";

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        _cellText(d.sppaNoref.toString(), compact: compact),
        _cellText(periode, compact: compact),
        _cellText(formatNum(d.dnOs), compact: compact),
      ],
    );
  }

  Widget _cellText(String text, {required bool compact}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        maxLines: compact ? 2 : null,
        overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
        style: TextStyle(color: primaryLightColor),
      ),
    );
  }

  Widget _cellCenter(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Text(text, style: TextStyle(color: primaryLightColor)),
      ),
    );
  }

  Widget _cellRight(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(text, style: TextStyle(color: primaryLightColor)),
      ),
    );
  }
}

// header cell helper biar const TableRow bisa dipakai
class _HeaderCell extends StatelessWidget {
  final String text;
  final bool center;

  const _HeaderCell(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: center
          ? Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
      )
          : Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryLightColor,
        ),
      ),
    );
  }
}

List<Pay2CariModel> _dummyItems() {
  return List.generate(5, (i) {
    return Pay2CariModel(
      ar1Id: "AR1-DUMMY-001",
      ar2Id: "AR2-DUMMY-$i",
      sppa1Id: "SPPA-$i",
      sppaNoref: "POLIS-00$i",
      dnOs: 1250000.0 * (i + 1),
      nourut: i + 1,
      periodeMulai: DateTime(2025, 1, 1),
      periodeAkhir: DateTime(2025, 12, 31),
    );
  });
}
