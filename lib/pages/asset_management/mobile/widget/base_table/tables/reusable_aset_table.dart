  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:joss_app/common/constants.dart';
  import '../../../../../../widgets/EmptyStateWidget.dart';

  class ReusableAsetTable<
  TBloc extends StateStreamableSource<TState>,
  TState,
  TModel,
  TCubit extends Cubit<Map<String, TModel>>>
      extends StatefulWidget {
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
    final String? emptyStatusLabel;

    const ReusableAsetTable({
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
          // jika data sudah berhasil dimuat, sembunyikan loader
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

            // ⏳ Loading awal
            if (status == ListStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }

            // ✅ Ada data
            if (status == ListStatus.success && items.isNotEmpty) {
              return BlocBuilder<TCubit, Map<String, TModel>>(
                bloc: widget.cubit,
                builder: (context, selectedItems) {
                  final totalItems = items.length;
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
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor: MaterialStateProperty.all(Colors.white.withOpacity(0.25)),
                              trackColor: MaterialStateProperty.all(Colors.white.withOpacity(0.05)),
                              radius: const Radius.circular(cardBorderRadius),
                              thickness: MaterialStateProperty.all(6),
                            ),
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false, overscroll: false),
                              child: Scrollbar(
                                controller: _scrollController, // vertical scrollbar
                                thumbVisibility: true,
                                trackVisibility: false,
                                radius: const Radius.circular(10),
                                thickness: 6,
                                interactive: true,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: Scrollbar(
                                    controller: _horizontalController, // horizontal scrollbar
                                    thumbVisibility: true,
                                    trackVisibility: false,
                                    radius: const Radius.circular(10),
                                    thickness: 6,
                                    interactive: true,
                                    notificationPredicate: (notif) => notif.metrics.axis == Axis.horizontal,
                                    child: SingleChildScrollView(
                                      controller: _horizontalController,
                                      scrollDirection: Axis.horizontal,
                                      physics: const ClampingScrollPhysics(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(cardBorderRadius),
                                        child: Table(
                                          border: TableBorder.all(
                                            color: Colors.white.withOpacity(0.08),
                                            width: 0.6,
                                          ),
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: widget.columnWidths,
                                          children: [
                                            // 🧭 HEADER
                                            TableRow(
                                              decoration: const BoxDecoration(
                                                color: formGrey,
                                              ),
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
                                                        widget.cubit.emit(
                                                          Map<String, TModel>.from(selectedItems),
                                                        );
                                                      },
                                                      child: AnimatedSwitcher(
                                                        duration: const Duration(milliseconds: 150),
                                                        transitionBuilder: (child, anim) =>
                                                            ScaleTransition(scale: anim, child: child),
                                                        child: Icon(
                                                          isAllSelected
                                                              ? Icons.check_box
                                                              : Icons.check_box_outline_blank,
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
                            opacity: (_showBottomLoader && canLoadMore) ? 1.0 : 0.0,
                            child: IgnorePointer(
                              ignoring: !(_showBottomLoader && canLoadMore),
                              child: SizedBox(
                                height: 28,
                                width: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            // ⚠️ Data kosong
            if (status == ListStatus.success && items.isEmpty) {
              return EmptyStateWidget(
                statusLabel: widget.emptyStatusLabel ?? 'Aktif',
              );
            }

            // ❌ Fallback
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
