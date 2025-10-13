import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/tables/table_action_button.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/tables/table_cell.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/tables/table_config.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/tables/table_pagination.dart';


class GenericTableWidget<T> extends StatelessWidget {
  final List<T> items;
  final List<TableHeaderConfig> headers;
  final List<TableColumnBuilder<T>> columns;
  final List<TableActionConfig>? actions;
  final int rowsPerPage;
  final int currentPage;
  final void Function(int newPage) onPageChange;
  final void Function(TableActionType, T)? onActionTap;
  final bool selectable;
  final bool Function(T)? isSelected;
  final VoidCallback? onSelectAll;

  const GenericTableWidget({
    super.key,
    required this.items,
    required this.headers,
    required this.columns,
    this.actions,
    this.rowsPerPage = 10,
    this.currentPage = 1,
    required this.onPageChange,
    this.onActionTap,
    this.selectable = false,
    this.isSelected,
    this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = items.length;
    final totalPages = (totalItems / rowsPerPage).ceil();
    final startIndex = (currentPage - 1) * rowsPerPage;
    final endIndex = (currentPage * rowsPerPage > totalItems)
        ? totalItems
        : currentPage * rowsPerPage;
    final paginated = items.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: BorderRadius.circular(cardBorderRadius),
              border: Border.all(color: sGrey.withOpacity(0.5)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(color: sGrey),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  for (int i = 0; i < headers.length; i++)
                    i: const IntrinsicColumnWidth(),
                },
                children: [
                  // Header
                  TableRow(
                    decoration: const BoxDecoration(color: formGrey),
                    children: [
                      if (selectable)
                        InkWell(
                          onTap: onSelectAll,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.check_box_outline_blank, size: 20),
                          ),
                        ),
                      for (final h in headers)
                        TableHeaderCell(h.title, center: h.center),
                    ],
                  ),
                  // Rows
                  for (int i = 0; i < paginated.length; i++)
                    _buildRow(context, paginated[i], startIndex + i),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: hPadding),
        if (totalPages > 1)
          TablePagination(
            totalPages: totalPages,
            currentPage: currentPage,
            onPageChange: onPageChange,
          ),
      ],
    );
  }

  TableRow _buildRow(BuildContext context, T item, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? formGrey : pGrey,
      ),
      children: [
        if (selectable)
          Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {},
              child: Icon(
                isSelected?.call(item) ?? false
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: primaryLightColor,
                size: 20,
              ),
            ),
          ),
        for (final col in columns)
          col.builder(context, item, index),
        if (actions != null)
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final a in actions!)
                  TableActionButton(
                    asset: a.asset,
                    bgColor: a.color,
                    onTap: () => onActionTap?.call(a.type, item),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
