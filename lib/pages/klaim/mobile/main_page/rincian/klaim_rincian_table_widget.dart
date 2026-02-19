import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/models/klaimrinci/groupcobcari_model.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:intl/intl.dart';

class KlaimRincianTableWidget extends StatefulWidget {
  const KlaimRincianTableWidget({super.key});

  @override
  State<KlaimRincianTableWidget> createState() =>
      _KlaimRincianTableWidgetState();
}

class _KlaimRincianTableWidgetState extends State<KlaimRincianTableWidget> {
  late GroupcobCariBloc groupcobCariBloc;
  late final ScrollController hController;

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  void initState() {
    super.initState();
    groupcobCariBloc = context.read<GroupcobCariBloc>();
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

    return BlocConsumer<GroupcobCariBloc, GroupcobCariState>(
      buildWhen: (previous, current) {
        return (current.status == ListStatus.success) ||
            (previous.selectedId != current.selectedId);
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          return state.items.isNotEmpty
              ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.items.length,
            itemBuilder: (_, index) {
              final header = state.items[index];
              final isLainnya = header.cobNama.toLowerCase() == "lainnya";

              return Container(
                color: secondaryBlackColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTitle(context, header),
                    const SizedBox(height: hPadding),
                    _buildDetailTable(
                      header.details,
                      state.selectedId,
                      isLainnya: isLainnya,
                      compact: isNarrow,
                    ),
                    const SizedBox(height: hPadding),
                  ],
                ),
              );
            },
          )
              : const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Text(
                'No Data Available!!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Data Available!!',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );
  }

  Widget _buildHeaderTitle(BuildContext context, GroupcobCariModel header) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: Text(
        header.cobNama,
        style: headingStyle(context, fontSize: 14),
      ),
    );
  }

  Widget _buildDetailTable(
      List<KlaimdetailCariModel> details,
  final String? selectedId, {
        required bool isLainnya,
        required bool compact,
      }) {
    if (details.isEmpty) return const Text("Tidak ada detail klaim");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: ClipRRect(
        // DESIGN: rounded corner hanya atas, persis dari kode gagal
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
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              trackVisibility: MaterialStateProperty.all(false),
              thickness: MaterialStateProperty.all(5),
              radius: const Radius.circular(cardBorderRadius),
              thumbColor: MaterialStateProperty.all(
                scrollBar.withOpacity(0.1),
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
                    columnWidths: isLainnya
                        ? const {
                      0: FixedColumnWidth(50),
                      1: FixedColumnWidth(50),
                      2: FixedColumnWidth(100),
                      3: FixedColumnWidth(120),
                      4: FixedColumnWidth(120), // COB
                      5: FixedColumnWidth(80), // TANGGAL
                      6: FixedColumnWidth(100), // ESTIMASI
                    }
                        : const {
                      0: FixedColumnWidth(50),
                      1: FixedColumnWidth(50),
                      2: FixedColumnWidth(100),
                      3: FixedColumnWidth(120),
                      4: FixedColumnWidth(80), // TANGGAL
                      5: FixedColumnWidth(100), // ESTIMASI
                    },
                    children: [
                      _tableHeader(context, [
                        "",
                        "NO",
                        "NO KLAIM",
                        "NO POLIS",
                        if (isLainnya) "COB",
                        "TANGGAL\nKEJADIAN",
                        "NILAI",
                      ]),
                      ...details.asMap().entries.map(
                            (e) => _detailRow(
                          e.value,
                          e.key,
                          selectedId,
                          compact: compact,
                          isLainnya: isLainnya,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
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
              style: bodyTextStyle(context, fontSize: 13),
            ),
          )
              : Text(
            text,
            style: bodyTextStyle(context, fontSize: 13),
          ),
        );
      }).toList(),
    );
  }

  TableRow _detailRow(
      KlaimdetailCariModel d,
      int index,
  final String? selectedId
  , {
        required bool compact,
        required bool isLainnya,
      }) {
    final isSelected = selectedId == d.klaim1Id;

    void _logSelectedRow(KlaimdetailCariModel d, int index) {
      debugPrint("=========== ROW SELECTED ===========");
      debugPrint("Index         : $index");
      debugPrint("No Urut       : ${d.nourut}");
      debugPrint("Klaim1Id      : ${d.klaim1Id}");
      debugPrint("COB ID        : ${d.cobId}");
      debugPrint("COB Nama      : ${d.cobNama}");
      debugPrint("No Polis      : ${d.noPolis}");
      debugPrint("Status        : ${d.statusDesc}");
      debugPrint("Tanggal       : ${DateFormat('yyyy-MM-dd').format(d.tglKejadian)}");
      debugPrint("Currency      : ${d.curr}");
      debugPrint("Nilai Klaim   : ${d.curr} ${formatNum(d.klaimAmount)}");
      debugPrint("====================================");
    }

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withOpacity(0.3)
            : (index.isEven ? pGrey : formGrey),
      ),
      children: [
        Center(
          child: CheckboxRadio(
            value: isSelected,
            onChanged: (checked) {
              _logSelectedRow(d, index);
              if (checked == true) {
                groupcobCariBloc.add(SelectItemEvent(d.klaim1Id));
                groupcobCariBloc.add(SelectKlaimRecordEvent(d));
              } else {
                debugPrint("=== ROW UNSELECTED === ${d.klaim1Id}");
                groupcobCariBloc.add(UnselectItemEvent(d.klaim1Id));
              }
            },
          ),
        ),
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
            d.klaim1Id,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            d.noPolis,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        if (isLainnya)
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
            DateFormat('yyyy-MM-dd').format(d.tglKejadian),
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            "${d.curr} ${formatNum(d.klaimAmount)}",
            style: TextStyle(color: primaryLightColor),
          ),
        ),
      ],
    );
  }
}