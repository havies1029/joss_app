import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/EmptyStateWidget.dart';

// Reuse components from asset table
export 'package:joss_app/pages/asset_management/mobile/widget/base_table/tables/reusable_aset_table.dart'
    show HeaderCell, CellText, OnRowTapCallback;

class ReusablePaymentTable<
TBloc extends StateStreamableSource<TState>,
TState,
TModel,
TCubit extends Cubit<Map<String, TModel>>
> extends StatefulWidget {

  final TBloc bloc;
  final TCubit cubit;
  final List<TModel> Function(TState state) getItems;
  final ListStatus Function(TState state) getStatus;
  final bool Function(TState state) hasMore;
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
  final bool showCheckbox;
  final Widget? footerButton;

  const ReusablePaymentTable({
    super.key,
    required this.bloc,
    required this.cubit,
    required this.getItems,
    required this.getStatus,
    required this.hasMore,
    required this.columnWidths,
    required this.headerCells,
    required this.getItemId,
    required this.rowBuilder,
    this.onFetchMore,
    this.showCheckbox = true,
    this.footerButton,
  });

  @override
  State<ReusablePaymentTable<TBloc, TState, TModel, TCubit>> createState() =>
      _ReusablePaymentTableState<TBloc, TState, TModel, TCubit>();
}

class _ReusablePaymentTableState<
TBloc extends StateStreamableSource<TState>,
TState,
TModel,
TCubit extends Cubit<Map<String, TModel>>
> extends State<ReusablePaymentTable<TBloc, TState, TModel, TCubit>> {

  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  bool _showBottomLoader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    const threshold = 150.0;
    final currentState = widget.bloc.state;

    final canLoadMore = widget.hasMore(currentState);
    final isAtBottom =
        position.pixels >= position.maxScrollExtent - threshold;

    if (canLoadMore && isAtBottom && !_showBottomLoader) {
      setState(() => _showBottomLoader = true);
      widget.onFetchMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TBloc, TState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (widget.getStatus(state) == ListStatus.success) {
          if (_showBottomLoader) {
            setState(() => _showBottomLoader = false);
          }
        }
      },
      child: BlocBuilder<TBloc, TState>(
        bloc: widget.bloc,
        builder: (context, state) {
          final items = widget.getItems(state);
          final status = widget.getStatus(state);
          final canLoadMore = widget.hasMore(state);

          if (status == ListStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          }

          if (status == ListStatus.success && items.isNotEmpty) {
            return BlocBuilder<TCubit, Map<String, TModel>>(
              bloc: widget.cubit,
              builder: (context, selectedItems) {
                final isAllSelected =
                    selectedItems.length == items.length && items.isNotEmpty;

                return Column(
                  children: [
                    Expanded(
                      child: _buildTable(context, items, selectedItems, isAllSelected),
                    ),

                    if (_showBottomLoader && canLoadMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                      ),

                    if (widget.footerButton != null) widget.footerButton!,
                  ],
                );
              },
            );
          }

          if (status == ListStatus.success && items.isEmpty) {
            return const EmptyStateWidget(statusLabel: 'payment');
          }

          return const Center(
            child: Text(
              "Gagal memuat data.",
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTable(
      BuildContext context,
      List<TModel> items,
      Map<String, TModel> selectedItems,
      bool isAllSelected,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryBlackColor,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.6,
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: widget.columnWidths,
                children: [
                  _buildHeaderRow(isAllSelected),
                  for (int i = 0; i < items.length; i++)
                    _buildDataRow(
                      context,
                      items[i],
                      i + 1,
                      selectedItems,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow(bool isAllSelected) {
    final headerChildren = <Widget>[];

    if (widget.showCheckbox) {
      headerChildren.add(
        Padding(
          padding: const EdgeInsets.all(0),
          child: InkWell(
            onTap: () => _handleSelectAll(isAllSelected),
            child: Icon(
              isAllSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: isAllSelected ? primaryLightColor : sGrey,
              size: 20,
            ),
          ),
        ),
      );
    }

    headerChildren.addAll(widget.headerCells);
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: headerChildren,
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
    final rowChildren = <Widget>[];

    if (widget.showCheckbox) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => _handleCheckboxTap(id, item, selectedItems),
            child: Icon(
              isActive
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: isActive ? primaryLightColor : sGrey,
              size: 20,
            ),
          ),
        ),
      );
    }

    rowChildren.addAll(
      widget.rowBuilder(context, item, rowNumber, widget.cubit),
    );

    return TableRow(
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withOpacity(0.2)
            : (rowNumber.isEven ? formGrey : pGrey),
      ),
      children: rowChildren,
    );
  }

  void _handleSelectAll(bool isAllSelected) {
    final items = widget.getItems(widget.bloc.state);
    final next = <String, TModel>{};

    if (!isAllSelected) {
      for (final item in items) {
        next[widget.getItemId(item)] = item;
      }
    }

    widget.cubit.emit(next);
  }

  void _handleCheckboxTap(
      String id,
      TModel item,
      Map<String, TModel> selectedItems,
      ) {
    final next = Map<String, TModel>.from(selectedItems);

    if (next.containsKey(id)) {
      next.remove(id);
    } else {
      next[id] = item;
    }

    widget.cubit.emit(next);
  }
}
