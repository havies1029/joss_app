import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

/// ✅ Universal reusable table
/// Punya fitur: pagination, select all, item select, dan bisa dipakai di semua modul aset
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../../../widgets/EmptyStateWidget.dart';

/// ✅ Universal reusable table
/// Sekarang support: pagination + select all + infinite scroll (auto fetch)
class ReusableAsetTable<
TBloc extends StateStreamableSource<TState>,
TState,
TModel,
TCubit extends Cubit<Map<String, TModel>>> extends StatefulWidget {
  final TBloc bloc;
  final TCubit cubit;
  final List<TModel> Function(TState state) getItems;
  final ListStatus Function(TState state) getStatus;
  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> headerCells;
  final String Function(TModel model) getItemId;
  final List<Widget> Function(
      BuildContext context,
      TModel item,
      int rowNumber,
      TCubit cubit,
      ) rowBuilder;

  final VoidCallback? onFetchMore;
  final String? emptyStatusLabel;

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
    this.onFetchMore,
    this.emptyStatusLabel,
  });

  @override
  State<ReusableAsetTable<TBloc, TState, TModel, TCubit>> createState() =>
      _ReusableAsetTableState<TBloc, TState, TModel, TCubit>();
}

class _ReusableAsetTableState<
TBloc extends StateStreamableSource<TState>,
TState,
TModel,
TCubit extends Cubit<Map<String, TModel>>>
    extends State<ReusableAsetTable<TBloc, TState, TModel, TCubit>> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isFetchingMore) return;

    final position = _scrollController.position;
    const threshold = 150.0;

    if (position.pixels >= position.maxScrollExtent - threshold) {
      if (widget.onFetchMore != null) {
        _isFetchingMore = true;
        widget.onFetchMore!();

        Future.delayed(const Duration(seconds: 1), () {
          _isFetchingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, TState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final items = widget.getItems(state);
        final status = widget.getStatus(state);

        // ⏳ Loading state
        if (status == ListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        // ✅ Success state dengan data
        if (status == ListStatus.success && items.isNotEmpty) {
          final totalItems = items.length;
          final totalPages = (totalItems / _rowsPerPage).ceil();
          final startIndex = (_currentPage - 1) * _rowsPerPage;
          final endIndex = (_currentPage * _rowsPerPage > totalItems)
              ? totalItems
              : _currentPage * _rowsPerPage;
          final paginatedItems = items.sublist(startIndex, endIndex);

          return BlocBuilder<TCubit, Map<String, TModel>>(
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
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                        border: Border.all(color: sGrey, width: 1),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false, overscroll: false),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                  // 🧭 HEADER
                                  TableRow(
                                    decoration:
                                    const BoxDecoration(color: formGrey),
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
                                                    final id =
                                                    widget.getItemId(item);
                                                    selectedItems[id] = item;
                                                  }
                                                }
                                              });
                                              widget.cubit.emit(
                                                Map<String, TModel>.from(
                                                    selectedItems),
                                              );
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

                                  // 📊 ROWS
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

        // ⚠️ Success tapi data kosong
        if (status == ListStatus.success && items.isEmpty) {
          return EmptyStateWidget(
            statusLabel: widget.emptyStatusLabel ?? 'Aktif',
          );
        }

        // ❌ Default fallback
        return const Center(
          child: Text(
            "Gagal memuat data.",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  TableRow _buildDataRow(
      BuildContext context,
      TModel item,
      int rowNumber,
      Map<String, TModel> selectedItems,
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

              widget.cubit.emit(Map<String, TModel>.from(selectedItems));
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

class ActionButtonWidget extends StatelessWidget {
  final String asset;
  final String label;
  final Color bgColor;
  final VoidCallback? onTap; // 🔹 ubah dari required ke opsional
  final double iconSize;

  const ActionButtonWidget({
    super.key,
    required this.asset,
    required this.label,
    required this.bgColor,
    this.onTap, // 🔹 karena bisa null, handler default kita bikin di bawah
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
              () => debugPrint("[ActionButtonWidget] '${label}' belum di-handle."),
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              asset,
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 🔹 Tetap bisa pakai komponen text ini buat gaya konsisten
class HeaderCell extends StatelessWidget {
  final String text;
  final bool center;
  const HeaderCell(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: getResponsiveFont(context, 16),
          color: primaryLightColor,
        ),
      ),
    );
  }
}

class CellText extends StatelessWidget {
  final String text;
  final bool center;
  const CellText(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: getResponsiveFont(context, 14),
          color: primaryLightColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
