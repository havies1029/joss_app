import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_mv_state_cubit.dart';
import '../../../../../../models/gen_aset_mv/asetmvcari_model.dart';

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
      buildWhen: (prev, curr) =>
      prev.status != curr.status || prev.items != curr.items,
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          // 🔹 Pagination logic
          final totalItems = state.items.length;
          final totalPages = (totalItems / _rowsPerPage).ceil();
          final startIndex = (_currentPage - 1) * _rowsPerPage;
          final endIndex = (_currentPage * _rowsPerPage > totalItems)
              ? totalItems
              : _currentPage * _rowsPerPage;
          final paginatedItems = state.items.sublist(startIndex, endIndex);

          final cubit = context.read<ShareMvStateCubit>();
          cubit.updateTotalItems(totalItems); // ✅ Sinkron total count ke cubit

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 Flexible biar tinggi tabel adaptif (ngikut jumlah data)
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
                    clipBehavior: Clip.hardEdge, // ⬅️ pastiin isi scroll ke-clip rapi
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                        overscroll: false, // ⬅️ hilangin efek pantulan/glow Android
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(), // no bounce
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(cardBorderRadius),
                            child: BlocBuilder<ShareMvStateCubit,
                                Map<String, AsetMvCariModel>>(
                              builder: (context, shareState) {
                                final isAllSelected = cubit.selectedItems.length == totalItems && totalItems > 0;

                                return Table(
                                  border: TableBorder.all(
                                    color: sGrey,
                                    width: 1,
                                  ),
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
                                    13: IntrinsicColumnWidth(),
                                  },
                                  children: [
                                    // ✅ Header row dengan Select All
                                    TableRow(
                                      decoration: BoxDecoration(
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
                                                transitionBuilder: (child, anim) => ScaleTransition(
                                                  scale: anim,
                                                  child: child,
                                                ),
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
                                        const _HeaderCell("No", center: true),
                                        const _HeaderCell("ID Asset"),
                                        const _HeaderCell("Currency"),
                                        const _HeaderCell("Jenis MV"),
                                        const _HeaderCell("Merk"),
                                        const _HeaderCell("No Polisi"),
                                        const _HeaderCell("Polis No"),
                                        const _HeaderCell("Premi"),
                                        const _HeaderCell("SumInsured"),
                                        const _HeaderCell("Tahun", center: true),
                                        const _HeaderCell("Tipe", center: true),
                                        const _HeaderCell("Status", center: true),
                                        const _HeaderCell("Aksi"),
                                      ],
                                    ),

                                    // ✅ Rows
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

              // 🔹 Pagination muncul kalau data > 10
              if (totalItems > _rowsPerPage)
                buildPagination(context, totalPages),
            ],
          );
        }

        // 🔹 Kalau kosong
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
        // 🔹 Warna baris berdasarkan nomor urut
        color: isActive
            ? primaryColor.withOpacity(0.20) // tetap ada highlight kalau dipilih
            : (rowNumber.isEven
            ? formGrey     // genap → abu muda (lebih terang)
            : pGrey),    // ganjil → abu gelap (lebih kontras)
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
            message: isActive
                ? "Batalkan share item ini"
                : "Pilih untuk di-share",
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                cubit.toggleItem(item);
              },
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
        _CellText(item.curr),
        _CellText(item.jenisMv),
        _CellText(item.merk),
        _CellText(item.noPolisi),
        _CellText(item.polisNo),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.premi)),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ')
            .format(item.sumInsured)),
        _CellText("${item.tahun}"),
        _CellText(item.tipe),
        _CellText(item.status),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                asset: 'assets/icons/btn_endorse.svg',
                bgColor: const Color(0xFFFDC13C), // kuning
                onTap: () {},
              ),
              _buildActionButton(
                asset: 'assets/icons/btn_delete.svg',
                bgColor: const Color(0xFFF85B5B), // merah
                onTap: () {},
              ),
              _buildActionButton(
                asset: 'assets/icons/btn_lacak.svg',
                bgColor: const Color(0xFFB9B9B9), // abu
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String asset,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, // 🔹 kecilin lagi biar tampil subtle
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 3), // 🔹 gap antar tombol lebih rapat
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12), // 🔹 lembut banget
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(1, 2), // sedikit ke bawah
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 16, // 🔹 proporsional dengan card kecil
            height: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 🧭 Pagination logic tetap sama seperti sebelumnya
  Widget buildPagination(BuildContext context, int totalPages) {
    // kalau cuma 1 halaman, sembunyikan pagination
    if (totalPages <= 1) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    int maxVisible;
    if (screenWidth < 400) {
      maxVisible = 5; // HP kecil
    } else if (screenWidth < 700) {
      maxVisible = 7; // HP besar / tablet kecil
    } else if (screenWidth < 1200) {
      maxVisible = 9; // tablet besar
    } else {
      maxVisible = 11; // desktop lebar
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
      mainAxisAlignment: MainAxisAlignment.center, // biar rapi di tengah
      children: [
        _buildArrowButton(
          context,
          label: "<",
          enabled: _currentPage > 1,
          onTap: () {
            if (_currentPage > 1) setState(() => _currentPage--);
          },
        ),

        // angka halaman
        for (int i = 0; i < visiblePages.length; i++) ...[
          if (i > 0 && visiblePages[i] != visiblePages[i - 1] + 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "...",
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 16),
                  color: Colors.grey,
                ),
              ),
            ),
          _buildPageNumberButton(
            context,
            page: visiblePages[i],
            isActive: _currentPage == visiblePages[i],
            onTap: () => setState(() => _currentPage = visiblePages[i]),
          ),
        ],

        _buildArrowButton(
          context,
          label: ">",
          enabled: _currentPage < totalPages,
          onTap: () {
            if (_currentPage < totalPages) setState(() => _currentPage++);
          },
        ),
      ],
    );
  }
  Widget _buildArrowButton(
      BuildContext context, {
        required String label,
        required bool enabled,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1.0 : 0.5,
          child: GestureDetector(
            onTap: enabled ? onTap : null,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: enabled ? secondaryBlackColor : sGrey.withOpacity(0.25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: enabled ? sGrey.withOpacity(0.5) : sGrey.withOpacity(0.25),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: enabled ? primaryLightColor : sGrey.withOpacity(0.6),
                  fontSize: getResponsiveFont(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageNumberButton(
      BuildContext context, {
        required int page,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? primaryColor : secondaryBlackColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isActive ? primaryColor : sGrey.withOpacity(0.6),
                width: 1,
              ),
            ),
            child: Text(
              "$page",
              style: TextStyle(
                fontSize: getResponsiveFont(context, 16),
                color: isActive ? secondaryBlackColor : primaryLightColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

}

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
