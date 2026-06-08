import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/helper/hscroll_always_thumb_helper.dart';
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
  late final ScrollController vController;

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  void initState() {
    super.initState();
    groupcobCariBloc = context.read<GroupcobCariBloc>();
    hController = ScrollController();
    vController = ScrollController();
  }

  @override
  void dispose() {
    hController.dispose();
    vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocConsumer<GroupcobCariBloc, GroupcobCariState>(
      buildWhen: (previous, current) {
        return current.status == ListStatus.success ||
            previous.selectedId != current.selectedId;
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                      context,
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
          );
        }

        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              'No Data Available!!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderTitle(BuildContext context, GroupcobCariModel header) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: Text(
        'Klaim ${header.cobNama}',
        style: headingStyle(context, fontSize: 14),
      ),
    );
  }

  Widget _buildDetailTable(
      BuildContext context,
      List<KlaimdetailCariModel> details,
      String? selectedId, {
        required bool isLainnya,
        required bool compact,
      }) {
    if (details.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
        child: const Text(
          "Tidak ada detail klaim",
          style: TextStyle(color: primaryLightColor),
        ),
      );
    }

    const rowHeight = 52.0;
    const headerHeight = 54.0;
    const maxVisibleRows = 8;

    final useVerticalScroll = details.length > maxVisibleRows;
    final bodyHeight = maxVisibleRows * rowHeight;
    final tableHeight = headerHeight + bodyHeight;

    final columnWidths = _buildColumnWidths(
      context,
      details,
      isLainnya: isLainnya,
      compact: compact,
    );

    final headerTable = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: _tableBorder,
      columnWidths: columnWidths,
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
      ],
    );

    final bodyTable = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: _tableBorder,
      columnWidths: columnWidths,
      children: details.asMap().entries.map((e) {
        return _detailRow(
          e.value,
          e.key,
          selectedId,
          compact: compact,
          isLainnya: isLainnya,
        );
      }).toList(),
    );

    Widget tableContent;

    if (useVerticalScroll) {
      tableContent = SizedBox(
        height: tableHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: headerHeight,
              child: headerTable,
            ),
            SizedBox(
              height: bodyHeight,
              child: _verticalScrollbar(
                child: SingleChildScrollView(
                  controller: vController,
                  scrollDirection: Axis.vertical,
                  child: bodyTable,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      tableContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          headerTable,
          bodyTable,
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: _tableShell(
        child: compact
            ? LayoutBuilder(
          builder: (context, constraints) {
            return HScrollAlwaysThumb(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: tableContent,
              ),
            );
          },
        )
            : tableContent,
      ),
    );
  }

  Widget _tableShell({
    required Widget child,
  }) {
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
        child: child,
      ),
    );
  }

  Widget _verticalScrollbar({required Widget child}) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(true),
        trackVisibility: WidgetStateProperty.all(false),
        thickness: WidgetStateProperty.all(5),
        radius: const Radius.circular(cardBorderRadius),
        thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.4)),
      ),
      child: Scrollbar(
        controller: vController,
        thumbVisibility: true,
        child: child,
      ),
    );
  }

  TableBorder get _tableBorder => const TableBorder(
    horizontalInside: BorderSide(color: sGrey, width: 1),
    verticalInside: BorderSide(color: sGrey, width: 1),
  );

  Map<int, TableColumnWidth> _buildColumnWidths(
      BuildContext context,
      List<KlaimdetailCariModel> details, {
        required bool isLainnya,
        required bool compact,
      }) {
    if (!compact) {
      return isLainnya
          ? const {
        0: FixedColumnWidth(50),
        1: FixedColumnWidth(50),
        2: FlexColumnWidth(1.4),
        3: FlexColumnWidth(1.6),
        4: FlexColumnWidth(1.4),
        5: FlexColumnWidth(1.3),
        6: FlexColumnWidth(1.4),
      }
          : const {
        0: FixedColumnWidth(50),
        1: FixedColumnWidth(50),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.8),
        4: FlexColumnWidth(1.3),
        5: FlexColumnWidth(1.5),
      };
    }

    final map = <int, TableColumnWidth>{
      0: const FixedColumnWidth(50),
      1: const FixedColumnWidth(50),
      2: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          details.map((e) => e.klaim1Id),
          min: 100,
          max: 180,
        ),
      ),
      3: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          details.map((e) => e.noPolis),
          min: 120,
          max: 220,
        ),
      ),
    };

    var nextIndex = 4;

    if (isLainnya) {
      map[nextIndex] = FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          details.map((e) => e.cobDesc),
          min: 120,
          max: 220,
        ),
      );
      nextIndex++;
    }

    map[nextIndex] = const FixedColumnWidth(120);
    map[nextIndex + 1] = FixedColumnWidth(
      _columnWidthFromLongest(
        context,
        details.map((e) => "${e.curr} ${formatNum(e.klaimAmount)}"),
        min: 120,
        max: 180,
      ),
    );

    return map;
  }

  TableRow _tableHeader(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: cells.map((text) {
        final isNo = text.trim().toUpperCase() == "NO";

        return _cell(
          vertical: 15,
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
      String? selectedId, {
        required bool compact,
        required bool isLainnya,
      }) {
    final isSelected = selectedId == d.klaim1Id;

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
        _textCell(
          (index + 1).toString(),
          center: true,
          softWrap: false,
        ),
        _textCell(
          d.klaim1Id,
          maxLines: compact ? 2 : 1,
          softWrap: compact,
        ),
        _textCell(
          d.noPolis.trim().isEmpty ? "-" : d.noPolis,
          maxLines: compact ? 2 : 1,
          softWrap: compact,
        ),
        if (isLainnya)
          _textCell(
            d.cobDesc,
            maxLines: compact ? 2 : 1,
            softWrap: compact,
          ),
        _textCell(
          DateFormat('yyyy-MM-dd').format(d.tglKejadian),
          maxLines: compact ? 2 : 1,
          softWrap: compact,
        ),
        _textCell(
          "${d.curr} ${formatNum(d.klaimAmount)}",
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }

  Widget _textCell(
      String text, {
        int maxLines = 1,
        bool center = false,
        bool softWrap = true,
      }) {
    final child = Text(
      text,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: primaryLightColor),
    );

    return _cell(
      child: center ? Center(child: child) : child,
    );
  }

  Widget _cell({
    required Widget child,
    double horizontal = 6,
    double vertical = 6,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: child,
    );
  }

  double _measureTextWidth(
      BuildContext context,
      String text, {
        TextStyle? style,
      }) {
    final effectiveStyle = style ??
        bodyTextStyle(context, fontSize: 13).copyWith(
          color: primaryLightColor,
        );

    final tp = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textDirection: Directionality.of(context),
      maxLines: 1,
      ellipsis: '…',
    )..layout();

    return tp.width;
  }

  double _columnWidthFromLongest(
      BuildContext context,
      Iterable<String> values, {
        required double min,
        required double max,
        double padding = 24,
        TextStyle? style,
      }) {
    var longest = 0.0;

    for (final value in values) {
      final width = _measureTextWidth(context, value, style: style);
      if (width > longest) longest = width;
    }

    return (longest + padding).clamp(min, max);
  }
}