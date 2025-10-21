import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

/// ✅ Universal reusable table
/// Punya fitur: pagination, select all, item select, dan bisa dipakai di semua modul aset
class ReusableAsetTable<
TBloc extends StateStreamableSource<TState>,
TState,
TModel> extends StatefulWidget {
  final TBloc bloc;
  final Cubit<Map<String, dynamic>> cubit;
  final List<TModel> Function(TState state) getItems;
  final ListStatus Function(TState state) getStatus;
  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> headerCells;
  final String Function(TModel model) getItemId;
  final List<Widget> Function(
      BuildContext context,
      TModel item,
      int rowNumber,
      Cubit<Map<String, dynamic>> cubit,
      ) rowBuilder;

  const ReusableAsetTable({
    super.key,
    required this.bloc,
    required this.cubit,
    required this.getItems,
    required this.getStatus,
    required this.columnWidths,
    required this.headerCells,
    required this.getItemId,
    required this.rowBuilder,
  });

  @override
  State<ReusableAsetTable<TBloc, TState, TModel>> createState() =>
      _ReusableAsetTableState<TBloc, TState, TModel>();
}

class _ReusableAsetTableState<
TBloc extends StateStreamableSource<TState>,
TState,
TModel> extends State<ReusableAsetTable<TBloc, TState, TModel>> {
  int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, TState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final items = widget.getItems(state);
        final status = widget.getStatus(state);

        if (status == ListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (status == ListStatus.success && items.isNotEmpty) {
          final totalItems = items.length;
          final totalPages = (totalItems / _rowsPerPage).ceil();
          final startIndex = (_currentPage - 1) * _rowsPerPage;
          final endIndex = (_currentPage * _rowsPerPage > totalItems)
              ? totalItems
              : _currentPage * _rowsPerPage;
          final paginatedItems = items.sublist(startIndex, endIndex);

          return BlocBuilder<Cubit<Map<String, dynamic>>,
              Map<String, dynamic>>(
            bloc: widget.cubit,
            builder: (context, selectedItems) {
              final isAllSelected =
                  selectedItems.length == totalItems && totalItems > 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryBlackColor,
                        borderRadius:
                        BorderRadius.circular(cardBorderRadius),
                        border: Border.all(
                            color: sGrey.withOpacity(0.5), width: 1),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false, overscroll: false),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(cardBorderRadius),
                              child: Table(
                                border: TableBorder.all(
                                  color: sGrey,
                                  width: 1,
                                ),
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                columnWidths: widget.columnWidths,
                                children: [
                                  // ✅ HEADER DENGAN SELECT ALL
                                  TableRow(
                                    decoration:
                                    BoxDecoration(color: formGrey),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Tooltip(
                                          message: isAllSelected
                                              ? "Batalkan semua pilihan"
                                              : "Pilih semua data",
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (isAllSelected) {
                                                  selectedItems.clear();
                                                } else {
                                                  for (var item in items) {
                                                    final id = widget.getItemId(item);
                                                    selectedItems[id] = item;
                                                  }
                                                }
                                              });

                                              // 🔹 Sinkron ke cubit agar bisa diunduh
                                              widget.cubit.emit(Map<String, dynamic>.from(selectedItems));
                                            },
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 150),
                                              transitionBuilder:
                                                  (child, anim) =>
                                                  ScaleTransition(
                                                    scale: anim,
                                                    child: child,
                                                  ),
                                              child: Icon(
                                                isAllSelected
                                                    ? Icons.check_box
                                                    : Icons
                                                    .check_box_outline_blank,
                                                key: ValueKey(isAllSelected),
                                                color: isAllSelected
                                                    ? primaryLightColor
                                                    : sGrey,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...widget.headerCells,
                                    ],
                                  ),

                                  // ✅ DATA ROWS
                                  for (int i = 0;
                                  i < paginatedItems.length;
                                  i++)
                                    _buildDataRow(
                                      context,
                                      paginatedItems[i],
                                      startIndex + i + 1,
                                      selectedItems,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: hPadding),
                  if (totalItems > _rowsPerPage)
                    _buildPagination(context, totalPages),
                ],
              );
            },
          );
        }

        return Center(
          child: Text(
            "No Data Available!!",
            style: TextStyle(
              color: Colors.red,
              fontSize: getResponsiveFont(context, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  /// ✅ Build setiap baris data dengan checkbox individual
  TableRow _buildDataRow(
      BuildContext context,
      TModel item,
      int rowNumber,
      Map<String, dynamic> selectedItems,
      ) {
    final id = widget.getItemId(item);
    final isActive = selectedItems.containsKey(id);

    return TableRow(
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withOpacity(0.2)
            : (rowNumber.isEven ? formGrey : pGrey),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              setState(() {
                if (isActive) {
                  selectedItems.remove(id);
                } else {
                  selectedItems[id] = item;
                }
              });

              // 🔹 Sinkron ke cubit
              widget.cubit.emit(Map<String, dynamic>.from(selectedItems));
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                key: ValueKey(isActive),
                color: isActive ? primaryLightColor : sGrey,
                size: 20,
              ),
            ),
          ),
        ),
        ...widget.rowBuilder(context, item, rowNumber, widget.cubit),
      ],
    );
  }

  /// ✅ Pagination sederhana
  Widget _buildPagination(BuildContext context, int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pageArrow("<",
            enabled: _currentPage > 1,
            onTap: () => setState(() => _currentPage--)),
        for (int i = 1; i <= totalPages; i++)
          _pageNumber(i,
              isActive: _currentPage == i,
              onTap: () => setState(() => _currentPage = i)),
        _pageArrow(">",
            enabled: _currentPage < totalPages,
            onTap: () => setState(() => _currentPage++)),
      ],
    );
  }

  Widget _pageArrow(String label,
      {required bool enabled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? secondaryBlackColor : sGrey.withOpacity(0.25),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? primaryLightColor : sGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _pageNumber(int page,
      {required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? primaryColor : secondaryBlackColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isActive ? primaryColor : sGrey),
        ),
        child: Text(
          "$page",
          style: TextStyle(
            color: isActive ? secondaryBlackColor : primaryLightColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
