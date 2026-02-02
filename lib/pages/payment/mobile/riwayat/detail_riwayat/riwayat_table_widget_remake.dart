import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/historybayar2cari_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../../models/payment/historybayar2cari_model.dart';

class RiwayatTableWidgetRemake extends StatefulWidget {
  const RiwayatTableWidgetRemake({super.key});

  @override
  State<RiwayatTableWidgetRemake> createState() => _RiwayatTableWidgetRemakeState();
}
class _RiwayatTableWidgetRemakeState extends State<RiwayatTableWidgetRemake> {
  late Historybayar2CariBloc historybayar2cariBloc;

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  @override
  Widget build(BuildContext context) {
    historybayar2cariBloc = context.read<Historybayar2CariBloc>();

    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocBuilder<Historybayar2CariBloc, Historybayar2CariState>(
      buildWhen: (p, c) => p.status != c.status || p.items != c.items,
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = state.items.isNotEmpty ? state.items : _dummyItems();

        return isNarrow ? _buildTableCompact(items) : _buildTableNormal(items);
      },
    );
  }

  // ========= TABLE COMPACT (NARROW) =========
  Widget _buildTableCompact(List<Historybayar2CariModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                // ini kunci: table minimal selebar container
                width: constraints.maxWidth,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: _tableBorder(),
                  columnWidths: const {
                    0: FlexColumnWidth(1), // NO
                    1: FlexColumnWidth(3), // NO POLIS
                    2: FlexColumnWidth(3), // PREMI
                  },
                  children: [
                    _headerRow(),
                    ...items.asMap().entries.map(
                          (e) => _row(e.value, e.key, compact: true),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ========= TABLE NORMAL =========
  Widget _buildTableNormal(List<Historybayar2CariModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: _tableBorder(),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(3),
                },
                children: [
                  _headerRow(),
                  ...items.asMap().entries.map(
                        (e) => _row(e.value, e.key, compact: false),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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

  TableRow _headerRow() {
    return const TableRow(
      decoration: BoxDecoration(color: formGrey),
      children: [
        _headerCell("NO", center: true),
        _headerCell("NO POLIS"),
        _headerCell("PREMI"),
      ],
    );
  }

  TableRow _row(Historybayar2CariModel d, int index, {required bool compact}) {
    final polisNo = d.polisNo.isNotEmpty ? d.polisNo : "-";
    final premi = "${d.curr} ${formatNum(d.nilaiBayar)}";

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        _cellText(polisNo, compact: compact),
        _cellText(premi, compact: compact),
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
class _headerCell extends StatelessWidget {
  final String text;
  final bool center;

  const _headerCell(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
      child: center
          ? Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: primaryLightColor),
        ),
      )
          : Text(
        text,
        style: TextStyle(fontSize: 15, color: primaryLightColor),
      ),
    );
  }
}

List<Historybayar2CariModel> _dummyItems() {
  return List.generate(5, (i) {
    return Historybayar2CariModel(
      curr: "IDR",
      dn1Id: "DN1-DUMMY-$i",
      nilaiBayar: 1250000.0 * (i + 1),
      polisNo: "POLIS-00$i",
      sppa1Id: "SPPA-$i",
    );
  });
}
