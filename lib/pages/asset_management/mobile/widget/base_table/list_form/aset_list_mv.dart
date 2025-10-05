import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'package:joss_app/models/gen_aset_mv/asetmvcari_model.dart';
import '../../../../../../blocs/share_cubit/share_mv_state_cubit.dart';

class AsetListMv extends StatefulWidget {
  final String searchText;
  const AsetListMv({super.key, required this.searchText});

  @override
  State<AsetListMv> createState() => _AsetListMvState();
}

class _AsetListMvState extends State<AsetListMv> {
  int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AsetMvCariBloc, AsetMvCariState>(
      listener: (context, state) {},
      buildWhen: (prev, curr) => prev.status != curr.status || prev.items != curr.items,
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          final totalItems = state.items.length;
          final totalPages = (totalItems / _rowsPerPage).ceil();
          final startIndex = (_currentPage - 1) * _rowsPerPage;
          final endIndex = (_currentPage * _rowsPerPage > totalItems)
              ? totalItems
              : _currentPage * _rowsPerPage;
          final paginatedItems = state.items.sublist(startIndex, endIndex);

          final cubit = context.read<ShareMvStateCubit>();
          cubit.updateTotalItems(totalItems);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: hPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryBlackColor,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                      border: Border.all(color: sGrey.withOpacity(0.5), width: 1),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                        overscroll: false,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(cardBorderRadius),
                            child: BlocBuilder<ShareMvStateCubit, Map<String, AsetMvCariModel>>(
                              builder: (context, shareState) {
                                final isAllSelected =
                                    cubit.selectedItems.length == totalItems && totalItems > 0;

                                return Table(
                                  border: TableBorder.all(color: sGrey, width: 1),
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: IntrinsicColumnWidth(),
                                    1: IntrinsicColumnWidth(),
                                    2: IntrinsicColumnWidth(),
                                    3: IntrinsicColumnWidth(),
                                    4: IntrinsicColumnWidth(),
                                    5: IntrinsicColumnWidth(),
                                    6: IntrinsicColumnWidth(),
                                    7: IntrinsicColumnWidth(),
                                    8: IntrinsicColumnWidth(),
                                    9: IntrinsicColumnWidth(),
                                    10: IntrinsicColumnWidth(),
                                    11: IntrinsicColumnWidth(),
                                    12: IntrinsicColumnWidth(),
                                  },
                                  children: [
                                    // 🔹 HEADER
                                    TableRow(
                                      decoration: const BoxDecoration(color: formGrey),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Tooltip(
                                            message: isAllSelected
                                                ? "Batalkan semua pilihan"
                                                : "Pilih semua data",
                                            child: InkWell(
                                              onTap: () {
                                                cubit.toggleGlobal(state.items);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      cubit.globalActive
                                                          ? "✅ Semua data dipilih (${cubit.selectedItems.length})"
                                                          : "❎ Semua pilihan dibatalkan",
                                                    ),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(4),
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
                                        const _HeaderCell("No", center: true),
                                        const _HeaderCell("ID MV"),
                                        const _HeaderCell("Jenis"),
                                        const _HeaderCell("Merk"),
                                        const _HeaderCell("Tipe"),
                                        const _HeaderCell("No Polisi"),
                                        const _HeaderCell("Tahun"),
                                        const _HeaderCell("Polis No"),
                                        const _HeaderCell("Currency"),
                                        const _HeaderCell("Sum Insured"),
                                        const _HeaderCell("Premi"),
                                        const _HeaderCell("Status", center: true),
                                      ],
                                    ),

                                    // 🔹 ROWS
                                    for (int i = 0; i < paginatedItems.length; i++)
                                      _buildDataRow(
                                        context,
                                        paginatedItems[i],
                                        startIndex + i + 1,
                                        cubit,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: hPadding),
              if (totalItems > _rowsPerPage) buildPagination(context, totalPages),
            ],
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

  TableRow _buildDataRow(
      BuildContext context,
      AsetMvCariModel item,
      int rowNumber,
      ShareMvStateCubit cubit,
      ) {
    final isActive = cubit.isItemActive(item.asetMvId);

    return TableRow(
      decoration: BoxDecoration(
        color: isActive
            ? primaryColor.withOpacity(0.08)
            : (rowNumber.isEven ? formGrey : pGrey),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
            message: isActive ? "Batalkan share item ini" : "Pilih untuk di-share",
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => cubit.toggleItem(item),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isActive ? Icons.check_box : Icons.check_box_outline_blank,
                  key: ValueKey(isActive),
                  color: isActive ? primaryLightColor : sGrey,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        _CellText("$rowNumber", center: true),
        _CellText(item.asetMvId),
        _CellText(item.jenisMv),
        _CellText(item.merk),
        _CellText(item.tipe),
        _CellText(item.noPolisi),
        _CellText("${item.tahun}"),
        _CellText(item.polisNo),
        _CellText(item.curr),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.sumInsured)),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.premi)),
        _CellText(item.status, center: true),
      ],
    );
  }

  Widget buildPagination(BuildContext context, int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    int maxVisible;
    if (screenWidth < 400) {
      maxVisible = 5;
    } else if (screenWidth < 700) {
      maxVisible = 7;
    } else if (screenWidth < 1200) {
      maxVisible = 9;
    } else {
      maxVisible = 11;
    }

    List<int> visiblePages = [];

    if (totalPages <= maxVisible) {
      visiblePages = List.generate(totalPages, (i) => i + 1);
    } else {
      int half = (maxVisible / 2).floor();
      int start = _currentPage - half;
      int end = _currentPage + half;

      if (start < 1) {
        end += (1 - start);
        start = 1;
      }
      if (end > totalPages) {
        start -= (end - totalPages);
        end = totalPages;
      }

      visiblePages = List.generate(end - start + 1, (i) => start + i);
      if (!visiblePages.contains(1)) visiblePages[0] = 1;
      if (!visiblePages.contains(totalPages)) {
        visiblePages[visiblePages.length - 1] = totalPages;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildArrowButton("<", _currentPage > 1, () {
          if (_currentPage > 1) setState(() => _currentPage--);
        }),
        for (int i = 0; i < visiblePages.length; i++) ...[
          if (i > 0 && visiblePages[i] != visiblePages[i - 1] + 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text("...", style: TextStyle(color: sGrey, fontSize: 16)),
            ),
          _buildPageButton(
            "${visiblePages[i]}",
            isActive: _currentPage == visiblePages[i],
            onTap: () => setState(() => _currentPage = visiblePages[i]),
          ),
        ],
        _buildArrowButton(">", _currentPage < totalPages, () {
          if (_currentPage < totalPages) setState(() => _currentPage++);
        }),
      ],
    );
  }

  Widget _buildArrowButton(String label, bool enabled, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? secondaryBlackColor : sGrey.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: sGrey.withOpacity(0.5)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: enabled ? primaryLightColor : sGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton(String label, {bool isActive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? primaryColor : secondaryBlackColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: sGrey.withOpacity(0.6)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? secondaryBlackColor : primaryLightColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 Header & Cell reusable
class _HeaderCell extends StatelessWidget {
  final String text;
  final bool center;
  const _HeaderCell(this.text, {this.center = false});

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

class _CellText extends StatelessWidget {
  final String text;
  final bool center;
  const _CellText(this.text, {this.center = false});

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
