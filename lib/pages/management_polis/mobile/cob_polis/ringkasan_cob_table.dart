import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
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
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  late final ScrollController hController;
  late final ScrollController vController;

  @override
  void initState() {
    super.initState();
    hController = ScrollController();
    vController = ScrollController();
    vController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<AsetRingkasanCariBloc>();
    final s = bloc.state;

    if (!vController.hasClients) return;

    final max = vController.position.maxScrollExtent;
    final cur = vController.position.pixels;
    const threshold = 100.0;

    if (max - cur <= threshold) {
      if (!s.hasReachedMax && !s.isFetching) {
        bloc.add(FetchAsetRingkasanCariEvent());
      }
    }
  }

  @override
  void dispose() {
    hController.dispose();
    vController.removeListener(_onScroll);
    vController.dispose();
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
      controller: vController,
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
            thumbVisibility: WidgetStateProperty.all(false),
            trackVisibility: WidgetStateProperty.all(false),
            thickness: WidgetStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: WidgetStateProperty.all(
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
                  0: FixedColumnWidth(60),   // No
                  1: FixedColumnWidth(160),  // Jenis Polis
                  2: FixedColumnWidth(120),  // Jumlah Polis
                  3: FixedColumnWidth(200),  // Nilai Pertanggungan
                  4: FixedColumnWidth(200),  // Total Premi
                },
                children: [
                  _tableHeader(context, const [
                    "No",
                    "Jenis Polis",
                    "Jumlah Polis",
                    "Nilai Pertanggungan",
                    "Total Premi",
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
            0: FlexColumnWidth(0.9),  // No
            1: FlexColumnWidth(2.3),  // Jenis Polis
            2: FlexColumnWidth(1.4),  // Jumlah Polis
            3: FlexColumnWidth(2.5),  // Nilai Pertanggungan
            4: FlexColumnWidth(2.0),  // Total Premi
          },
          children: [
            _tableHeader(context, const [
              "No",
              "Jenis Polis",
              "Jumlah Polis",
              "Nilai Pertanggungan",
              "Total Premi",
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
        final isNo = text.toUpperCase() == "NO";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
          child: isNo
              ? Center(
            child: Text(text, style: bodyTextStyle(context, fontSize: 15)),
          )
              : Text(text, style: bodyTextStyle(context, fontSize: 15)),
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
    final textStyle = TextStyle(color: primaryLightColor);

    // helpers: gabung dengan spasi rapi (kalau kosong, nggak bikin spasi aneh)
    String join2(String a, String b) {
      final aa = a.trim();
      final bb = b.trim();
      if (aa.isEmpty) return bb;
      if (bb.isEmpty) return aa;
      return "$aa $bb";
    }

    final jumlahDenganSatuan = join2(d.jmlAset.toString(), d.satuan);
    final nilaiDenganCurr = join2(d.curr, formatNum(d.nilaiAset));
    final premiDenganCurr = join2(d.curr, formatNum(d.nilaiPremi));

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        // No (CENTER)
        _cell(
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: textStyle,
            ),
          ),
        ),

        // Jenis Polis (LEFT)
        _cell(
          child: Text(
            d.asetNama,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),

        // Jumlah Polis + Satuan (LEFT)
        _cell(
          child: Text(
            // jumlahDenganSatuan,
            d.jmlAset.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),

        // Currency + Nilai Pertanggungan (LEFT)
        _cell(
          child: Text(
            nilaiDenganCurr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),

        // Currency + Total Premi (LEFT)
        _cell(
          child: Text(
            premiDenganCurr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
      ],
    );
  }


  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 32), // ✅ turunin
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}
