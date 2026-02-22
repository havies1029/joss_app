import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/klaimringkas/klaimringkascari_model.dart';

class KlaimRingkasanTableWidget extends StatefulWidget {
  const KlaimRingkasanTableWidget({super.key});

  @override
  KlaimRingkasanTableWidgetState createState() =>
      KlaimRingkasanTableWidgetState();
}

class KlaimRingkasanTableWidgetState extends State<KlaimRingkasanTableWidget> {
  late KlaimringkasCariBloc klaimringkasCariBloc;
  final ScrollController hController = ScrollController();

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  void dispose() {
    hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    klaimringkasCariBloc = BlocProvider.of<KlaimringkasCariBloc>(context);
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocConsumer<KlaimringkasCariBloc, KlaimringkasCariState>(
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          return state.items.isNotEmpty
              ? Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
            child: Column(
              children: [
                const SizedBox(height: hPadding),
                isNarrow
                    ? _buildDetailTableCompact(state.items)
                    : _buildDetailTableNormal(state.items),
                const SizedBox(height: hPadding),
              ],
            ),
          )
              : const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Text(
                'No Data Available x!!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Data Available y!!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) {
        return (current.status == ListStatus.success);
      },
      listener: (context, state) {},
    );
  }

  Widget _buildDetailTableCompact(List<KlaimringkasCariModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 0.5),
          ),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey, width: 1),
            verticalInside: BorderSide(color: sGrey, width: 1),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(3),
          },
          children: [
            _tableHeader(
                context, ["NO", "KATEGORI", "JUMLAH\n KLAIM", "TOTAL NILAI"]),
            ...details.asMap().entries.map(
                  (e) => _detailRow(
                e.value,
                e.key,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTableNormal(List<KlaimringkasCariModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 0.5),
          ),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey, width: 1),
            verticalInside: BorderSide(color: sGrey, width: 1),
          ),
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(100),
            2: FixedColumnWidth(80),
            3: FixedColumnWidth(50),
          },
          children: [
            _tableHeader(
                // context, ["NO", "KATEGORI", "JUMLAH\NKLAIM", "TOTAL NILAI"]),
                context, ["NO", "KATEGORI", "JUMLAH KLAIM", "TOTAL NILAI"]),
            ...details.asMap().entries.map(
                  (e) => _detailRow(
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
        final bool isNo = text.trim().toUpperCase() == "NO";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
          child: isNo
              ? Center(
            child: Text(
              text,
              style: bodyTextStyle(context, fontSize: 15),
            ),
          )
              : Text(
            text,
            style: bodyTextStyle(context, fontSize: 15),
          ),
        );
      }).toList(),
    );
  }

  TableRow _detailRow(
      KlaimringkasCariModel d,
      int index, {
        required bool compact,
      }) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              d.nourut.toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            d.cobNama,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            formatNum(d.klaimQty),
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            "${d.currNama} ${formatNum(d.klaimAmount)}",
            style: const TextStyle(
              color: primaryLightColor,
            ),
          ),
        )
      ],
    );
  }
}