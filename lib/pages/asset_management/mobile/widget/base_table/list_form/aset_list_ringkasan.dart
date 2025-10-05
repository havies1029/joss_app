// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
// import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
//
// // ⬅️ pastikan StatusBox udah lo bikin class kayak sebelumnya
// import '../../../../../../blocs/share_cubit/share_cubit_state.dart';
// import '../../../../../../widgets/apptheme/build_status_box.dart';
//
// class AsetListRingkasan extends StatelessWidget {
//   final String searchText;
//   const AsetListRingkasan({super.key, required this.searchText});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AsetRingkasanCariBloc, AsetRingkasanCariState>(
//       listener: (context, state) {},
//       buildWhen: (prev, curr) =>
//       prev.status != curr.status || prev.items != curr.items,
//       builder: (context, state) {
//         if (state.status == ListStatus.initial) {
//           return const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//             ),
//           );
//         }
//
//         if (state.status == ListStatus.success && state.items.isNotEmpty) {
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: hPadding),
//             itemCount: state.items.length,
//             itemBuilder: (context, index) {
//               final item = state.items[index];
//               return _AsetRingkasanCard(item: item);
//             },
//           );
//         }
//
//         return const Center(
//           child: Text(
//             "No Data Available!!",
//             style: TextStyle(
//                 color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _AsetRingkasanCard extends StatelessWidget {
//   final AsetRingkasanCariModel item;
//   const _AsetRingkasanCard({required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: vPadding),
//       decoration: BoxDecoration(
//         color: pGrey,
//         borderRadius: BorderRadius.circular(cardBorderRadius),
//         border: Border.all(color: sGrey, width: 1),
//       ),
//       child: Column(
//         children: [
//           // 🔹 Action bar atas
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: getResponsiveFont(context, 16)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Bagian kiri
//                 Row(
//                   children: const [
//                     StatusBox(
//                       assetPath: "assets/icons/edit_icon_polis.svg",
//                       bgColor: Colors.green,
//                     ),
//                     SizedBox(width: hPadding),
//                     StatusBox(
//                       assetPath: "assets/icons/delete_icon_polis.svg",
//                       bgColor: Colors.orange,
//                     ),
//                     SizedBox(width: hPadding),
//                     StatusBox(
//                       assetPath: "assets/icons/others_icon_polis.svg",
//                       bgColor: Colors.red,
//                     ),
//                   ],
//                 ),
//
//                 // Bagian kanan (Share per card pakai Bloc)
//                 BlocBuilder<ShareStateCubit, Map<String, AsetRingkasanCariModel>>(
//                   builder: (context, state) {
//                     final cubit = context.read<ShareStateCubit>();
//                     final isActive = cubit.isItemActive(item.asetRingkasanId);
//
//                     return StatusBox(
//                       assetPath: "assets/icons/share_data_polis.svg",
//                       bgColor: Colors.transparent,
//                       fullIcon: true,
//                       showBorder: false,
//                       enableBorderClickFill: true,
//                       activeIconColor: secondaryBlackColor,
//                       iconColor: isActive ? secondaryBlackColor : primaryLightColor,
//                       onTap: () => cubit.toggleItem(item), // ⬅️ sekarang passing full object
//                     );
//                   },
//                 ),
//
//               ],
//             ),
//           ),
//
//           _divider(),
//
//           // 🔹 Detail data
//           _buildDetailRow(context, "Nama Aset", item.asetNama),
//           _divider(),
//           _buildDetailRow(context, "ID Ringkasan", item.asetRingkasanId),
//           _divider(),
//           _buildDetailRow(context, "Currency", item.curr),
//           _divider(),
//           _buildDetailRow(context, "Jumlah", "${item.jmlAset} ${item.satuan}"),
//           _divider(),
//           _buildDetailRow(
//             context,
//             "Nilai",
//             NumberFormat.currency(locale: 'id', symbol: 'IDR ')
//                 .format(item.nilaiAset),
//           ),
//           _divider(),
//           _buildDetailRow(
//             context,
//             "Premi",
//             NumberFormat.currency(locale: 'id', symbol: 'IDR ')
//                 .format(item.nilaiPremi),
//           ),
//           _divider(),
//           _buildDetailRow(context, "Nomor Urut", "${item.noUrut}"),
//           _divider(),
//           _buildDetailRow(context, "Satuan", item.satuan),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(BuildContext context, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 110,
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: hintGrey,
//                 fontSize: getResponsiveFont(context, 16),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: getResponsiveFont(context, 16),
//                 color: primaryLightColor,
//                 fontWeight: FontWeight.w500,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _divider() {
//     return Container(height: 1, color: sGrey.withOpacity(0.4));
//   }
// }



































//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
// import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
// import '../../../../../../blocs/share_cubit/share_cubit_state.dart';
//
// class AsetListRingkasan extends StatefulWidget {
//   final String searchText;
//   const AsetListRingkasan({super.key, required this.searchText});
//
//   @override
//   State<AsetListRingkasan> createState() => _AsetListRingkasanState();
// }
//
// class _AsetListRingkasanState extends State<AsetListRingkasan> {
//   int _rowsPerPage = 10;
//   int _currentPage = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AsetRingkasanCariBloc, AsetRingkasanCariState>(
//       listener: (context, state) {},
//       buildWhen: (prev, curr) =>
//       prev.status != curr.status || prev.items != curr.items,
//       builder: (context, state) {
//         if (state.status == ListStatus.initial) {
//           return const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//             ),
//           );
//         }
//
//         if (state.status == ListStatus.success && state.items.isNotEmpty) {
//           // 🔹 Pagination logic
//           final totalItems = state.items.length;
//           final totalPages = (totalItems / _rowsPerPage).ceil();
//           final startIndex = (_currentPage - 1) * _rowsPerPage;
//           final endIndex = (_currentPage * _rowsPerPage > totalItems)
//               ? totalItems
//               : _currentPage * _rowsPerPage;
//           final paginatedItems = state.items.sublist(startIndex, endIndex);
//
//           return Column(
//             children: [
//               // 🔹 Table container
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: secondaryBlackColor,
//                     borderRadius: BorderRadius.circular(cardBorderRadius),
//                     border: Border.all(color: sGrey.withOpacity(0.5), width: 1),
//                   ),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       headingRowColor:
//                       MaterialStateProperty.all(primaryBlackColor),
//                       headingTextStyle: TextStyle(
//                         fontSize: getResponsiveFont(context, 16),
//                         fontWeight: FontWeight.bold,
//                         color: primaryLightColor,
//                       ),
//                       dataTextStyle: TextStyle(
//                         fontSize: getResponsiveFont(context, 16),
//                         color: primaryLightColor,
//                       ),
//                       // 🔹 Highlight row on hover
//                       dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//                             (states) => states.contains(MaterialState.hovered)
//                             ? primaryColor.withOpacity(0.1)
//                             : null,
//                       ),
//                       columns: const [
//                         DataColumn(label: Text("Share")),
//                         DataColumn(label: Text("No")),
//                         DataColumn(label: Text("Nama Aset")),
//                         DataColumn(label: Text("ID Ringkasan")),
//                         DataColumn(label: Text("Currency")),
//                         DataColumn(label: Text("Jumlah")),
//                         DataColumn(label: Text("Nilai")),
//                         DataColumn(label: Text("Premi")),
//                         DataColumn(label: Text("Nomor Urut")),
//                         DataColumn(label: Text("Satuan")),
//                         DataColumn(label: Text("Aksi")),
//                       ],
//                       rows: List.generate(paginatedItems.length, (index) {
//                         final item = paginatedItems[index];
//                         final rowNumber = startIndex + index + 1;
//
//                         return DataRow(
//                           cells: [
//                             // Share column
//                             DataCell(
//                               BlocBuilder<ShareStateCubit,
//                                   Map<String, AsetRingkasanCariModel>>(
//                                 builder: (context, shareState) {
//                                   final cubit =
//                                   context.read<ShareStateCubit>();
//                                   final isActive =
//                                   cubit.isItemActive(item.asetRingkasanId);
//
//                                   return InkWell(
//                                     onTap: () => cubit.toggleItem(item),
//                                     child: Icon(
//                                       isActive
//                                           ? Icons.check_box
//                                           : Icons.check_box_outline_blank,
//                                       color: isActive
//                                           ? primaryLightColor
//                                           : sGrey,
//                                       size: 20,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             DataCell(Text("$rowNumber")),
//                             DataCell(Text(item.asetNama)),
//                             DataCell(Text(item.asetRingkasanId)),
//                             DataCell(Text(item.curr)),
//                             DataCell(Text("${item.jmlAset} ${item.satuan}")),
//                             DataCell(Text(NumberFormat.currency(
//                                 locale: 'id', symbol: 'IDR ')
//                                 .format(item.nilaiAset))),
//                             DataCell(Text(NumberFormat.currency(
//                                 locale: 'id', symbol: 'IDR ')
//                                 .format(item.nilaiPremi))),
//                             DataCell(Text("${item.noUrut}")),
//                             DataCell(Text(item.satuan)),
//                             DataCell(Row(
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.edit,
//                                       size: 18, color: Colors.green),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete,
//                                       size: 18, color: Colors.orange),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.more_horiz,
//                                       size: 18, color: Colors.red),
//                                   onPressed: () {},
//                                 ),
//                               ],
//                             )),
//                           ],
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: hPadding),
//
//               // 🔹 Pagination (muncul kalau data > 10)
//               if (totalItems > _rowsPerPage) buildPagination(context,totalPages),
//             ],
//           );
//         }
//
//         return Center(
//           child: Text(
//             "No Data Available!!",
//             style: TextStyle(
//                 color: Colors.red, fontSize: getResponsiveFont(context, 14), fontWeight: FontWeight.bold),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildPagination(BuildContext context, int totalPages) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     int maxVisible = 3; // default mobile
//
//     if (screenWidth > 600) maxVisible = 5;   // tablet
//     if (screenWidth > 900) maxVisible = 7;   // desktop
//
//     List<int> visiblePages = [];
//
//     if (totalPages <= maxVisible) {
//       // Kalau halaman sedikit, tampil semua
//       visiblePages = List.generate(totalPages, (i) => i + 1);
//     } else {
//       // window di sekitar currentPage
//       int half = (maxVisible / 2).floor();
//       int start = _currentPage - half;
//       int end = _currentPage + half;
//
//       // Pastikan tidak keluar batas
//       if (start < 1) {
//         end += (1 - start);
//         start = 1;
//       }
//       if (end > totalPages) {
//         start -= (end - totalPages);
//         end = totalPages;
//       }
//
//       visiblePages = List.generate(end - start + 1, (i) => start + i);
//
//       // Pastikan first dan last selalu ada
//       if (!visiblePages.contains(1)) {
//         visiblePages[0] = 1;
//       }
//       if (!visiblePages.contains(totalPages)) {
//         visiblePages[visiblePages.length - 1] = totalPages;
//       }
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
//       child: Container(
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildPageButton("<", enabled: _currentPage > 1, onTap: () {
//               if (_currentPage > 1) setState(() => _currentPage--);
//             }),
//
//             // render angka + ellipsis
//             for (int i = 0; i < visiblePages.length; i++) ...[
//               if (i > 0 && visiblePages[i] != visiblePages[i - 1] + 1)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   child: Text("...",
//                       style: TextStyle(
//                           fontSize: getResponsiveFont(context, 16),
//                           color: Colors.grey)),
//                 ),
//               _buildPageButton(
//                 "${visiblePages[i]}",
//                 isActive: _currentPage == visiblePages[i],
//                 onTap: () => setState(() => _currentPage = visiblePages[i]),
//               ),
//             ],
//
//             _buildPageButton(">", enabled: _currentPage < totalPages, onTap: () {
//               if (_currentPage < totalPages) setState(() => _currentPage++);
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPageButton(String label,
//       {bool isActive = false, bool enabled = true, VoidCallback? onTap}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: SizedBox(
//         width: 40,
//         height: 36,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isActive ? primaryColor : secondaryBlackColor,
//             padding: EdgeInsets.zero,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//               side: BorderSide(
//                 color: isActive ? primaryColor : sGrey.withOpacity(0.6),
//               ),
//             ),
//           ),
//           onPressed: enabled ? onTap : null,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: getResponsiveFont(context, 16),
//               color: isActive ? secondaryBlackColor : primaryLightColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
import '../../../../../../blocs/share_cubit/share_cubit_state.dart';

class AsetListRingkasan extends StatefulWidget {
  final String searchText;
  const AsetListRingkasan({super.key, required this.searchText});

  @override
  State<AsetListRingkasan> createState() => _AsetListRingkasanState();
}

class _AsetListRingkasanState extends State<AsetListRingkasan> {
  int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AsetRingkasanCariBloc, AsetRingkasanCariState>(
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
          final endIndex =
          (_currentPage * _rowsPerPage > totalItems) ? totalItems : _currentPage * _rowsPerPage;
          final paginatedItems = state.items.sublist(startIndex, endIndex);

          return Column(
            children: [
              // 🔹 Table container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: hPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryBlackColor,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                      border: Border.all(color: sGrey.withOpacity(0.5), width: 1),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // ⬅️ biar scroll ke bawah
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // ⬅️ biar scroll kanan-kiri
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                          child: Table(
                            border: TableBorder.all(
                              color: sGrey,
                              width: 1,
                            ),
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
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: primaryBlackColor),
                                children: const [
                                  _HeaderCell("Share"),
                                  _HeaderCell("No", center: true),
                                  _HeaderCell("Nama Aset"),
                                  _HeaderCell("ID Ringkasan"),
                                  _HeaderCell("Currency"),
                                  _HeaderCell("Jumlah"),
                                  _HeaderCell("Nilai"),
                                  _HeaderCell("Premi"),
                                  _HeaderCell("Nomor Urut", center: true),
                                  _HeaderCell("Satuan", center: true),
                                  _HeaderCell("Aksi"),
                                ],
                              ),
                              for (int i = 0; i < paginatedItems.length; i++)
                                _buildDataRow(context, paginatedItems[i], startIndex + i + 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: hPadding),

              // 🔹 Pagination (muncul kalau data > 10)
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

  TableRow _buildDataRow(BuildContext context, AsetRingkasanCariModel item, int rowNumber) {
    return TableRow(
      decoration: BoxDecoration(
        color: rowNumber.isEven ? secondaryBlackColor : secondaryBlackColor.withOpacity(0.8),
      ),
      children: [
        BlocBuilder<ShareStateCubit, Map<String, AsetRingkasanCariModel>>(
          builder: (context, shareState) {
            final cubit = context.read<ShareStateCubit>();
            final isActive = cubit.isItemActive(item.asetRingkasanId);

            return Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () => cubit.toggleItem(item),
                child: Icon(
                  isActive ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isActive ? primaryLightColor : sGrey,
                  size: 20,
                ),
              ),
            );
          },
        ),
        _CellText("$rowNumber", center: true),      // ✅ Kolom No center
        _CellText(item.asetNama),
        _CellText(item.asetRingkasanId),
        _CellText(item.curr),
        _CellText("${item.jmlAset} ${item.satuan}"),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ').format(item.nilaiAset)),
        _CellText(NumberFormat.currency(locale: 'id', symbol: 'IDR ').format(item.nilaiPremi)),
        _CellText("${item.noUrut}", center: true),  // ✅ Kolom Nomor Urut center
        _CellText(item.satuan, center: true),       // ✅ Kolom Satuan center
        Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.green),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.orange),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, size: 18, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPagination(BuildContext context, int totalPages) {
    final screenWidth = MediaQuery.of(context).size.width;
    int maxVisible = 3; // default mobile

    if (screenWidth > 600) maxVisible = 5; // tablet
    if (screenWidth > 900) maxVisible = 7; // desktop

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPageButton("<", enabled: _currentPage > 1, onTap: () {
            if (_currentPage > 1) setState(() => _currentPage--);
          }),
          for (int i = 0; i < visiblePages.length; i++) ...[
            if (i > 0 && visiblePages[i] != visiblePages[i - 1] + 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text("...", style: TextStyle(fontSize: getResponsiveFont(context, 16), color: Colors.grey)),
              ),
            _buildPageButton(
              "${visiblePages[i]}",
              isActive: _currentPage == visiblePages[i],
              onTap: () => setState(() => _currentPage = visiblePages[i]),
            ),
          ],
          _buildPageButton(">", enabled: _currentPage < totalPages, onTap: () {
            if (_currentPage < totalPages) setState(() => _currentPage++);
          }),
        ],
      ),
    );
  }

  Widget _buildPageButton(String label,
      {bool isActive = false, bool enabled = true, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 40,
        height: 36,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? primaryColor : secondaryBlackColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: isActive ? primaryColor : sGrey.withOpacity(0.6),
              ),
            ),
          ),
          onPressed: enabled ? onTap : null,
          child: Text(
            label,
            style: TextStyle(
              fontSize: getResponsiveFont(context, 16),
              color: isActive ? secondaryBlackColor : primaryLightColor,
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
