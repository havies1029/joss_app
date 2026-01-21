import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/constants.dart';
import '../../../../models/gen_aset_ringkasan/asetringkasancari_model.dart';


class RingkasanCobTable extends StatefulWidget {
  final List<AsetRingkasanCariModel> items;
  final bool showFooter;
  final String? title;

  const RingkasanCobTable({
    super.key,
    required this.items,
    this.showFooter = true,
    this.title,
  });

  @override
  State<RingkasanCobTable> createState() => _RingkasanCobTableState();
}

class _RingkasanCobTableState extends State<RingkasanCobTable> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);
  late final ScrollController hController;

  @override
  void initState() {
    super.initState();
    hController = ScrollController();
  }

  @override
  void dispose() {
    hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    final items = widget.items;

    if (items.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: Text(
                widget.title!,
                style: headingStyle(context, fontSize: 14),
              ),
            ),
            const SizedBox(height: hPadding),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
            child: isNarrow
                ? _buildDetailTableCompact(context, items)
                : _buildDetailTableNormal(context, items),
          ),
          const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, String cobNama) {
    return Text(
      "Polis $cobNama",
      style: headingStyle(context, fontSize: 14),
    );
  }


  Widget _buildDetailTableCompact(
      BuildContext context,
      List<AsetRingkasanCariModel> details,
      ) {
    if (details.isEmpty) return const Text("Tidak ada ringkasan");

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 1),
          ),
        ),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbVisibility: MaterialStateProperty.all(true),
            trackVisibility: MaterialStateProperty.all(false),
            thickness: MaterialStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: MaterialStateProperty.all(
              scrollBar.withOpacity(0.1), // <-- 30% opacity
            ),
          ),
          child: Scrollbar(
            controller: hController,
            child: SingleChildScrollView(
              controller: hController,
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: sGrey, width: 1),
                  verticalInside: BorderSide(color: sGrey, width: 1),
                ),
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FixedColumnWidth(220),
                  2: FixedColumnWidth(110),
                  3: FixedColumnWidth(110),
                  4: FixedColumnWidth(170),
                  5: FixedColumnWidth(150),
                  6: FixedColumnWidth(130),
                  7: FixedColumnWidth(110),
                },
                children: [
                  _tableHeader(context, const [
                    "No",
                    "Jenis Polis",
                    "Currency",
                    "Jumlah",
                    "Nilai",
                    "Premi",
                    "Nomor Urut",
                    "Satuan",
                  ]),
                  ...details.asMap().entries.map(
                        (e) => _detailRow(
                      context,
                      e.value,
                      e.key,
                      compact: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildDetailTableNormal(
      BuildContext context,
      List<AsetRingkasanCariModel> details,
      ) {
    if (details.isEmpty) return const Text("Tidak ada ringkasan");

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 1),
          ),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey, width: 1),
            verticalInside: BorderSide(color: sGrey, width: 1),
          ),
          columnWidths: const {
            0: FlexColumnWidth(0.9), // No
            1: FlexColumnWidth(2.6), // Jenis Polis
            2: FlexColumnWidth(1.2), // Currency
            3: FlexColumnWidth(1.2), // Jumlah
            4: FlexColumnWidth(1.8), // Nilai
            5: FlexColumnWidth(1.6), // Premi
            6: FlexColumnWidth(1.4), // Nomor Urut
            7: FlexColumnWidth(1.2), // Satuan
          },
          children: [
            _tableHeader(context, const [
              "No",
              "Jenis Polis",
              "Currency",
              "Jumlah",
              "Nilai",
              "Premi",
              "Nomor Urut",
              "Satuan",
            ]),
            ...details.asMap().entries.map(
                  (e) => _detailRow(
                context,
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

  TableRow _tableHeader(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: cells.map((text) {
        final upper = text.trim().toUpperCase();
        final bool center =
        (upper == "NO" ||
            upper == "CURRENCY" ||
            upper == "JUMLAH" ||
            upper == "NOMOR URUT" ||
            upper == "SATUAN");

        final child = Text(text, style: bodyTextStyle(context, fontSize: 15));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
          child: center ? Center(child: child) : child,
        );
      }).toList(),
    );
  }

  TableRow _detailRow(
      BuildContext context,
      AsetRingkasanCariModel d,
      int index, {
        required bool compact,
      }) {
    // ID tersedia kalau nanti kamu butuh (mis. onTap row):
    final String id = d.asetRingkasanId;

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        // No (nomor baris)
        _cell(
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Jenis Polis = asetNama
        _cell(
          child: Text(
            d.asetNama,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Currency
        _cell(
          child: Center(
            child: Text(
              d.curr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Jumlah
        _cell(
          child: Center(
            child: Text(
              d.jmlAset.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Nilai
        _cell(
          child: Text(
            formatNum(d.nilaiAset),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Premi
        _cell(
          child: Text(
            formatNum(d.nilaiPremi),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Nomor Urut (from model)
        _cell(
          child: Center(
            child: Text(
              d.noUrut.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Satuan
        _cell(
          child: Center(
            child: Text(
              d.satuan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}
