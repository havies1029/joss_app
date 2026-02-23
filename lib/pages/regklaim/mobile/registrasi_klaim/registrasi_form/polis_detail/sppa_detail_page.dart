import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../../../models/regklaim/sppadetail_model.dart';

class SppaDetailTableWidget extends StatefulWidget {
  final List<SppaDetailModel?> items;

  const SppaDetailTableWidget({
    super.key,
    required this.items,
  });

  @override
  State<SppaDetailTableWidget> createState() => _SppaDetailTableWidgetState();
}

class _SppaDetailTableWidgetState extends State<SppaDetailTableWidget> {
  final ScrollController hController = ScrollController();
  final DateFormat _dateFmt = DateFormat('dd MMM yyyy');

  @override
  void dispose() {
    hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    final items = widget.items.whereType<SppaDetailModel>().toList();

    if (items.isEmpty) {
      return _emptyState();
    }

    return isNarrow ? _buildTableCompact(items) : _buildTableNormal(items);
  }

  Widget _emptyState() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildTableCompact(List<SppaDetailModel> items) {
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
            thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.25)),
          ),
          child: Scrollbar(
            controller: hController,
            child: SingleChildScrollView(
              controller: hController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - (hPadding * 3),
                ),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: _tableBorder(),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(), // SPPA ID
                    1: IntrinsicColumnWidth(), // PERIODE POLIS
                    2: IntrinsicColumnWidth(), // NO POLIS
                    3: IntrinsicColumnWidth(), // STATUS
                  },
                  children: [
                    _headerRow(),
                    ...items.asMap().entries.map((e) => _row(e.value, e.key, compact: true)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========= TABLE NORMAL =========
  Widget _buildTableNormal(List<SppaDetailModel> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder(),
          columnWidths: const {
            0: FlexColumnWidth(2), // SPPA ID
            1: FlexColumnWidth(3), // PERIODE POLIS
            2: FlexColumnWidth(2), // NO POLIS
            3: FlexColumnWidth(2), // STATUS
          },
          children: [
            _headerRow(),
            ...items.asMap().entries.map((e) => _row(e.value, e.key, compact: false)),
          ],
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
        _HeaderCell(text: "SPPA ID", center: false),
        _HeaderCell(text: "PERIODE POLIS", center: false),
        _HeaderCell(text: "NO POLIS", center: false),
        _HeaderCell(text: "STATUS", center: false),
      ],
    );
  }

  TableRow _row(SppaDetailModel d, int index, {required bool compact}) {
    final periode =
        "${_dateFmt.format(d.periodeMulai)} → ${_dateFmt.format(d.periodeAkhir)}";
    final status = d.stsLunas.isNotEmpty ? d.stsLunas : "-";

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cell(d.sppa1Id.isNotEmpty ? d.sppa1Id : "-", compact: compact),
        _cell(periode, compact: compact),
        _cell(d.polisNo.isNotEmpty ? d.polisNo : "-", compact: compact),
        _cell(status, compact: compact),
      ],
    );
  }

  Widget _cell(String text, {bool center = false, bool compact = false}) {
    final style = TextStyle(
      color: primaryLightColor,
      fontSize: 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: center
          ? Center(
        child: Text(text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
      )
          : Text(
        text,
        style: style,
        maxLines: compact ? 2 : null,
        overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
      ),
    );
  }
}

// header cell helper biar const TableRow bisa dipakai
class _HeaderCell extends StatelessWidget {
  final String text;
  final bool center;

  const _HeaderCell({required this.text, required this.center});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryLightColor,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: center
          ? Center(child: Text(text, style: style))
          : Text(text, style: style),
    );
  }
}
