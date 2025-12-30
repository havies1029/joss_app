import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../../../helper/fab_action_helper.dart';
import '../../../../../../widgets/EmptyStateWidget.dart';

typedef OnRowTapCallback<T> = void Function(T item, int rowIndex);

class ReusablePaymentTable<
TBloc extends StateStreamableSource<TState>,
TState,
TModel,
TCubit extends Cubit<Map<String, TModel>>
>
    extends StatefulWidget {
  final TBloc bloc;
  final TCubit cubit;
  final List<TModel> Function(TState state) getItems;
  final ListStatus Function(TState state) getStatus;
  final bool Function(TState state) hasMore;
  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> headerCells;
  final String Function(TModel model) getItemId;
  final void Function(List<TModel> selectedItems)? onPay;
  final List<Widget> Function(
      BuildContext context,
      TModel item,
      int rowNumber,
      TCubit cubit,
      )
  rowBuilder;

  final VoidCallback? onFetchMore;
  final String? emptyStatusLabel;
  final String? currentStatusFilter;
  final bool showCheckbox;
  final OnRowTapCallback<TModel>? onRowTap;

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
    this.emptyStatusLabel,
    this.currentStatusFilter,
    this.showCheckbox = true,
    this.onRowTap,
    this.onPay,
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
>
    extends State<ReusablePaymentTable<TBloc, TState, TModel, TCubit>> {
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
    final isAtBottom = position.pixels >= position.maxScrollExtent - threshold;

    if (canLoadMore && isAtBottom && !_showBottomLoader) {
      setState(() => _showBottomLoader = true);
      if (widget.onFetchMore != null) widget.onFetchMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TBloc, TState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (widget.getStatus(state) == ListStatus.success) {
          if (_showBottomLoader) setState(() => _showBottomLoader = false);
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
                final totalItems = items.length;
                final isAllSelected =
                    selectedItems.length == totalItems && totalItems > 0;
                final selectedItemsList = selectedItems.values.toList();

                // final availableActions =
                // widget.showCheckbox
                //     ? FabActionHelper.getAvailableActions(
                //   currentStatusFilter: widget.currentStatusFilter,
                //   selectedItems: selectedItemsList,
                // )
                //     : <ActionMenuItem>[];

                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            decoration: BoxDecoration(
                              color: secondaryBlackColor,
                              borderRadius: BorderRadius.circular(
                                cardBorderRadius,
                              ),
                              border: Border.all(color: sGrey, width: 1),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.25),
                                ),
                                trackColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.05),
                                ),
                                radius: const Radius.circular(cardBorderRadius),
                                thickness: MaterialStateProperty.all(6),
                              ),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(
                                  context,
                                ).copyWith(
                                  scrollbars: false,
                                  overscroll: false,
                                ),
                                child: Scrollbar(
                                  controller: _scrollController,
                                  thumbVisibility: true,
                                  trackVisibility: false,
                                  radius: const Radius.circular(10),
                                  thickness: 6,
                                  interactive: true,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                    const AlwaysScrollableScrollPhysics(),
                                    child: Scrollbar(
                                      controller: _horizontalController,
                                      thumbVisibility: true,
                                      trackVisibility: false,
                                      radius: const Radius.circular(10),
                                      thickness: 6,
                                      interactive: true,
                                      notificationPredicate:
                                          (notif) =>
                                      notif.metrics.axis ==
                                          Axis.horizontal,
                                      child: SingleChildScrollView(
                                        controller: _horizontalController,
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            cardBorderRadius,
                                          ),
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.white.withOpacity(
                                                0.08,
                                              ),
                                              width: 0.6,
                                            ),
                                            defaultVerticalAlignment:
                                            TableCellVerticalAlignment
                                                .middle,
                                            columnWidths: widget.columnWidths,
                                            children: [
                                              _buildHeaderRow(isAllSelected),
                                              for (
                                              int i = 0;
                                              i < items.length;
                                              i++
                                              )
                                                _buildDataRow(
                                                  context,
                                                  items[i],
                                                  i + 1,
                                                  i,
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: vPadding * 1.5,
                            horizontal: hPadding,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity:
                              (_showBottomLoader && canLoadMore)
                                  ? 1.0
                                  : 0.0,
                              child: IgnorePointer(
                                ignoring: !(_showBottomLoader && canLoadMore),
                                child: const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.showCheckbox &&
                        selectedItemsList.isNotEmpty &&
                        widget.onPay != null)
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: GestureDetector(
                          onTap: () => widget.onPay!(selectedItemsList),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/bayar.svg", // sesuaikan
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Bayar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // if (widget.showCheckbox && availableActions.isNotEmpty)
                    //   FloatingActionMenuWidget(
                    //     availableActions: availableActions,
                    //     selectedItems: selectedItemsList,
                    //     onActionTap: (actionType, selectedItems) {
                    //       FabActionHelper.handleAction(
                    //         context: context,
                    //         actionType: actionType,
                    //         selectedItems: selectedItems,
                    //         onActionComplete: () {
                    //           widget.cubit.emit(Map<String, TModel>.from({}));
                    //           if (widget.onFetchMore != null) {
                    //             widget.onFetchMore!();
                    //           }
                    //         },
                    //       );
                    //     },
                    //   ),
                  ],
                );
              },
            );
          }

          if (status == ListStatus.success && items.isEmpty) {
            return EmptyStateWidget(
              statusLabel: widget.emptyStatusLabel ?? 'Aktif',
            );
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

  TableRow _buildHeaderRow(bool isAllSelected) {
    final List<Widget> headerChildren = [];

    if (widget.showCheckbox) {
      headerChildren.add(
        Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
            message:
            isAllSelected ? "Batalkan semua pilihan" : "Pilih semua data",
            child: InkWell(
              onTap: () => _handleSelectAll(isAllSelected),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder:
                    (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isAllSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  key: ValueKey(isAllSelected),
                  color: isAllSelected ? primaryLightColor : sGrey,
                  size: 20,
                ),
              ),
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

  void _handleSelectAll(bool isAllSelected) {
    final items = widget.getItems(widget.bloc.state);
    final selectedItems = widget.cubit.state;

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
    widget.cubit.emit(Map<String, TModel>.from(selectedItems));
  }

  TableRow _buildDataRow(
      BuildContext context,
      TModel item,
      int rowNumber,
      int rowIndex,
      Map<String, TModel> selectedItems,
      ) {
    final id = widget.getItemId(item);
    final isActive = selectedItems.containsKey(id);
    final List<Widget> rowChildren = [];

    if (widget.showCheckbox) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => _handleCheckboxTap(id, item, selectedItems),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder:
                  (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive ? Icons.check_box : Icons.check_box_outline_blank,
                key: ValueKey(isActive),
                color: isActive ? primaryLightColor : sGrey,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    final dataCells = widget.rowBuilder(context, item, rowNumber, widget.cubit);

    if (widget.onRowTap != null) {
      // Wrap each cell with tap handler
      for (var cell in dataCells) {
        rowChildren.add(
          GestureDetector(
            onTap: () => widget.onRowTap!(item, rowIndex),
            child: Container(
              color: Colors.transparent, // Ensure full cell is tappable
              child: cell,
            ),
          ),
        );
      }
    } else {
      // No tap handler, add cells directly
      rowChildren.addAll(dataCells);
    }

    return TableRow(
      decoration: BoxDecoration(
        color:
        isActive
            ? primaryColor.withOpacity(0.2)
            : (rowNumber.isEven ? formGrey : pGrey),
      ),
      children: rowChildren,
    );
  }

  void _handleCheckboxTap(
      String id,
      TModel item,
      Map<String, TModel> selectedItems,
      ) {
    setState(() {
      if (selectedItems.containsKey(id)) {
        selectedItems.remove(id);
      } else {
        selectedItems[id] = item;
      }
    });
    widget.cubit.emit(Map<String, TModel>.from(selectedItems));
  }
}

class ActionButtonWidget extends StatelessWidget {
  final String asset;
  final String label;
  final Color bgColor;
  final VoidCallback? onTap;
  final double iconSize;

  const ActionButtonWidget({
    super.key,
    required this.asset,
    required this.label,
    required this.bgColor,
    this.onTap,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
      onTap ??
              () => debugPrint("[ActionButtonWidget] '$label' belum di-handle."),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFont(context, 14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCell extends StatelessWidget {
  final String text;
  final bool center;
  const HeaderCell(this.text, {this.center = false, super.key});

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
  const CellText(this.text, {this.center = false, super.key});

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
