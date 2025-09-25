import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';

class TableRingkasanWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight; // <— tambahin

  const TableRingkasanWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight, // <—
  });

  @override
  State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
}

class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // lebih stabil daripada delay
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    context.read<AsetRingkasanCariBloc>().add(
      RefreshAsetRingkasanCariEvent(
        statusId: widget.initialStatusId, // gunakan initialStatusId
        searchText: _searchController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.listHeight ?? 400; // default tinggi list
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListPageFilterBarUIWidget(
            searchController: _searchController,
            searchButton: _buildSearchButton(),
            // opsional: kalau widget ini support trailing, kirim clearButton di sini
          ),
          const SizedBox(height: 8),
          // batasi tinggi agar tidak unbounded
          SizedBox(
            height: h,
            child: Scrollbar(
              thumbVisibility: true,
              child: AsetRingkasanCariListWidget(
                searchText: _searchController.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconButton _buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 28),
      onPressed: _refreshData,
      tooltip: 'Refresh',
    );
  }
}




































































































//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:trina_grid/trina_grid.dart';
// import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
// import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
// import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
// import 'package:joss_app/common/constants.dart';
//
// class TableRingkasanWidget extends StatefulWidget {
//   final EdgeInsetsGeometry? padding;
//   final String initialStatusId;
//   final double? listHeight;
//
//   const TableRingkasanWidget({
//     super.key,
//     this.padding,
//     this.initialStatusId = '10001',
//     this.listHeight,
//   });
//
//   @override
//   State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
// }
//
// class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
//   final TextEditingController _searchController = TextEditingController();
//   TrinaGridStateManager? _stateManager;
//   final _currencyFormat = NumberFormat.currency(
//     locale: 'id_ID',
//     symbol: 'IDR ',
//     decimalDigits: 0,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _refreshData() {
//     context.read<AsetRingkasanCariBloc>().add(
//       RefreshAsetRingkasanCariEvent(
//         statusId: widget.initialStatusId,
//         searchText: _searchController.text,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 768;
//     final height = widget.listHeight ?? (isMobile ? 500 : 600);
//
//     return Padding(
//       padding: widget.padding ?? EdgeInsets.zero,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListPageFilterBarUIWidget(
//             searchController: _searchController,
//             searchButton: _buildSearchButton(),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: height,
//             child: BlocBuilder<AsetRingkasanCariBloc, AsetRingkasanCariState>(
//               builder: (context, state) {
//                 // Handle different ListStatus states
//                 switch (state.status) {
//                   case ListStatus.initial:
//                     return _buildLoadingState();
//
//                   case ListStatus.failure:
//                     return _buildErrorState('Gagal memuat data ringkasan aset');
//
//                   case ListStatus.success:
//                     if (state.items.isEmpty) {
//                       return _buildEmptyState();
//                     }
//                     return _buildTrinaTable(state.items, isMobile);
//
//                   default:
//                     return _buildLoadingState();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Memuat data ringkasan aset...',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String message) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.red.shade200),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 48,
//               color: Colors.red.shade400,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Terjadi kesalahan',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.red.shade700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _refreshData,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Coba Lagi'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF007AFF),
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.inventory_2_outlined,
//               size: 64,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Tidak ada data ringkasan aset',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Silakan refresh atau ubah filter pencarian',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTrinaTable(List<AsetRingkasanCariModel> data, bool isMobile) {
//     final columns = _buildColumns(isMobile);
//     final rows = _buildRows(data);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: TrinaGrid(
//           columns: columns,
//           rows: rows,
//           mode: TrinaGridMode.normal,
//           configuration: _buildGridConfig(isMobile),
//           createFooter: (stateManager) => _buildCustomFooter(stateManager, data.length),
//           onLoaded: (event) {
//             _stateManager = event.stateManager;
//             event.stateManager.setPageSize(isMobile ? 8 : 10, notify: true);
//             event.stateManager.setPage(1);
//           },
//         ),
//
//       ),
//     );
//
//   }
//
//   TrinaGridConfiguration _buildGridConfig(bool isMobile) {
//     return TrinaGridConfiguration(
//       enableMoveHorizontalInEditing: false,
//       columnSize: TrinaGridColumnSizeConfig(
//         autoSizeMode: TrinaAutoSizeMode.scale, // Ubah dari scale ke fit
//         resizeMode: TrinaResizeMode.normal,  // Aktifkan resize
//       ),
//       scrollbar: TrinaGridScrollbarConfig(
//         showHorizontal: true,
//         showVertical: true,
//         isAlwaysShown: true, // Scrollbar selalu terlihat
//       ),
//       style: TrinaGridStyleConfig(
//         rowHeight: isMobile ? 80 : 90,
//         columnHeight: isMobile ? 48 : 56,
//         borderColor: Colors.transparent,
//         enableGridBorderShadow: false,
//         gridBorderColor: Colors.transparent,
//         gridBorderRadius: BorderRadius.circular(16),
//         gridPadding: 0,
//         enableColumnBorderVertical: true,
//         enableCellBorderVertical: true,
//         // Enhanced mobile styling
//         rowColor: Colors.white,
//         activatedColor: const Color(0xFFF0F8FF),
//       ),
//     );
//   }
//
//   List<TrinaColumn> _buildColumns(bool isMobile) {
//     final baseTextStyle = TextStyle(
//       fontFamily: 'Inter',
//       fontSize: isMobile ? 13 : 15,
//       fontWeight: FontWeight.w500,
//     );
//
//     final headerTextStyle = baseTextStyle.copyWith(
//       fontWeight: FontWeight.w600,
//       color: const Color(0xFF1F2937),
//       fontSize: isMobile ? 12 : 14,
//     );
//
//     return [
//       // Index Column
//       TrinaColumn(
//         title: 'NO',
//         field: 'no',
//         width: isMobile ? 50 : 60,
//         minWidth: isMobile ? 50 : 60,
//         frozen: TrinaColumnFrozen.start,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('NO', headerTextStyle),
//         renderer: (context) => _buildIndexCell(context, baseTextStyle),
//       ),
//
//       // Jenis Polis Column
//       TrinaColumn(
//         title: 'JENIS POLIS',
//         field: 'jenis_polis',
//         width: isMobile ? 120 : 140,
//         minWidth: isMobile ? 120 : 140,
//         frozen: isMobile ? TrinaColumnFrozen.start : TrinaColumnFrozen.none,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('JENIS POLIS', headerTextStyle),
//         renderer: (context) => _buildTextCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle.copyWith(
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF374151),
//           ),
//           icon: _getPolisIcon(context.cell.value?.toString() ?? ''),
//         ),
//       ),
//
//       // Jumlah Polis Aktif Column
//       TrinaColumn(
//         title: 'JUMLAH POLIS AKTIF',
//         field: 'jumlah_polis',
//         width: isMobile ? 100 : 120,
//         minWidth: isMobile ? 100 : 120,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('JUMLAH POLIS AKTIF', headerTextStyle),
//         renderer: (context) => _buildNumberCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           showBadge: true,
//         ),
//       ),
//
//       // Total Pertanggungan Column
//       TrinaColumn(
//         title: 'TOTAL PERTANGGUNGAN',
//         field: 'total_pertanggungan',
//         width: isMobile ? 140 : 160,
//         minWidth: isMobile ? 140 : 160,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('TOTAL PERTANGGUNGAN', headerTextStyle),
//         renderer: (context) => _buildCurrencyCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           color: const Color(0xFF059669),
//         ),
//       ),
//
//       // Total Premi Column
//       TrinaColumn(
//         title: 'TOTAL PREMI',
//         field: 'total_premi',
//         width: isMobile ? 120 : 140,
//         minWidth: isMobile ? 120 : 140,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('TOTAL PREMI', headerTextStyle),
//         renderer: (context) => _buildCurrencyCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           color: const Color(0xFF7C3AED),
//         ),
//       ),
//
//       // Jumlah Klaim Berjalan Column
//       TrinaColumn(
//         title: 'JUMLAH KLAIM BERJALAN',
//         field: 'jumlah_klaim',
//         width: isMobile ? 100 : 120,
//         minWidth: isMobile ? 100 : 120,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('JUMLAH KLAIM BERJALAN', headerTextStyle),
//         renderer: (context) => _buildNumberCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           showWarning: int.tryParse(context.cell.value?.toString() ?? '0')! > 0,
//         ),
//       ),
//
//       // Nilai Klaim Dibayar Column
//       TrinaColumn(
//         title: 'NILAI KLAIM DIBAYAR',
//         field: 'nilai_klaim',
//         width: isMobile ? 140 : 160,
//         minWidth: isMobile ? 140 : 160,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('NILAI KLAIM DIBAYAR', headerTextStyle),
//         renderer: (context) => _buildCurrencyCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           color: const Color(0xFFDC2626),
//         ),
//       ),
//     ];
//   }
//
//   IconData _getPolisIcon(String jenisPolis) {
//     switch (jenisPolis.toLowerCase()) {
//       case 'properti':
//         return Icons.home_work_outlined;
//       case 'kendaraan':
//         return Icons.directions_car_outlined;
//       case 'kesehatan':
//         return Icons.health_and_safety_outlined;
//       case 'rangka kapal':
//         return Icons.directions_boat_outlined;
//       case 'sdm':
//         return Icons.people_outline;
//       default:
//         return Icons.description_outlined;
//     }
//   }
//
//   Widget _buildHeaderCell(String title, TextStyle style) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: style,
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   Widget _buildIndexCell(dynamic context, TextStyle style) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       alignment: Alignment.center,
//       child: Container(
//         width: 28,
//         height: 28,
//         decoration: BoxDecoration(
//           color: const Color(0xFF007AFF).withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Text(
//             context.cell.value?.toString() ?? '',
//             style: style.copyWith(
//               color: const Color(0xFF007AFF),
//               fontWeight: FontWeight.w600,
//               fontSize: style.fontSize! - 1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextCell(String value, TextStyle style, {IconData? icon}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Row(
//         children: [
//           if (icon != null) ...[
//             Icon(
//               icon,
//               size: 18,
//               color: style.color?.withOpacity(0.7),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Expanded(
//             child: Text(
//               value,
//               style: style,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNumberCell(String value, TextStyle style, {bool showBadge = false, bool showWarning = false}) {
//     final number = int.tryParse(value) ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       alignment: Alignment.centerLeft,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: showWarning
//               ? const Color(0xFFFEF3C7)
//               : showBadge
//               ? const Color(0xFFECFDF5)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: showWarning
//                 ? const Color(0xFFFBBF24)
//                 : showBadge
//                 ? const Color(0xFF10B981)
//                 : Colors.transparent,
//             width: 1,
//           ),
//         ),
//         child: Text(
//           NumberFormat('#,###', 'id_ID').format(number),
//           style: style.copyWith(
//             color: showWarning
//                 ? const Color(0xFF92400E)
//                 : showBadge
//                 ? const Color(0xFF047857)
//                 : style.color,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCurrencyCell(String value, TextStyle style, {Color? color}) {
//     final amount = double.tryParse(value) ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       alignment: Alignment.centerLeft,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             _currencyFormat.format(amount),
//             style: style.copyWith(
//               color: color ?? const Color(0xFF374151),
//               fontWeight: FontWeight.w600,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<TrinaRow> _buildRows(List<AsetRingkasanCariModel> data) {
//     return data.asMap().entries.map((entry) {
//       final index = entry.key;
//       final item = entry.value;
//
//       return TrinaRow(
//         cells: {
//           'no': TrinaCell(value: (index + 1).toString()),
//           'jenis_polis': TrinaCell(value: item.asetNama ?? ''),
//           'jumlah_polis': TrinaCell(value: '${item.jmlAset ?? 0} ${item.satuan ?? ''}'),
//           'total_pertanggungan': TrinaCell(value: (item.nilaiAset ?? 0).toString()),
//           'total_premi': TrinaCell(value: (item.nilaiPremi ?? 0).toString()),
//           'jumlah_klaim': TrinaCell(value: '0'), // Sesuaikan dengan field yang ada di model
//           'nilai_klaim': TrinaCell(value: '0'), // Sesuaikan dengan field yang ada di model
//         },
//       );
//     }).toList();
//   }
//
//   Widget _buildCustomFooter(TrinaGridStateManager stateManager, int totalRows) {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FA),
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Total: $totalRows item${totalRows != 1 ? 's' : ''}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF6B7280),
//                 ),
//               ),
//             ),
//           ),
//           TrinaPagination(
//             stateManager,
//             pageSizeToMove: 1,
//           ),
//         ],
//       ),
//     );
//   }
//
//   IconButton _buildSearchButton() {
//     return IconButton(
//       icon: const Icon(Icons.search, size: 24),
//       onPressed: () {
//         _refreshData();
//         if (_stateManager != null) {
//           _stateManager!.setPage(1);
//         }
//       },
//       tooltip: 'Cari Data',
//       style: IconButton.styleFrom(
//         backgroundColor: const Color(0xFF007AFF),
//         foregroundColor: Colors.white,
//       ),
//     );
//   }
// }









































































/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../../../../common/constants.dart';
import '../table_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TableRingkasanWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight; // <— tambahin

  const TableRingkasanWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight, // <—
  });

  @override
  State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
}

class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _originalItems = [];
  TrinaGridStateManager? _stateManager;

  @override
  void initState() {
    super.initState();
    // lebih stabil daripada delay
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    context.read<AsetRingkasanCariBloc>().add(
      RefreshAsetRingkasanCariEvent(
        statusId: widget.initialStatusId, // gunakan initialStatusId
        searchText: _searchController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.listHeight ?? 400; // default tinggi list
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListPageFilterBarUIWidget(
            searchController: _searchController,
            searchButton: _buildSearchButton(),
            // opsional: kalau widget ini support trailing, kirim clearButton di sini
          ),
          const SizedBox(height: 8),
          // batasi tinggi agar tidak unbounded
          SizedBox(
            height: h,
            child: Scrollbar(
              thumbVisibility: true,
              child: AsetRingkasanCariListWidget(
                searchText: _searchController.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconButton _buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 28),
      onPressed: _refreshData,
      tooltip: 'Refresh',
    );
  }

}






















// @override
// Widget build(BuildContext context) {
//   return Column(
//       children: [
//         const SizedBox(height: 16),
//         BlocBuilder<AsetRingkasanCariBloc, AsetRingkasanCariState>(
//           builder: (context, state) {
//             if (state.status == ListStatus.success) {
//               _originalItems = state.items.map(TrinaTableMapper.fromRingkasan).toList();
//
//               return GenericTrinaTable(
//                 columns: TrinaColumnBuilder.build(
//                   columns: [
//                     ColumnMeta(title: 'Aset', field: 'aset', widthFactor: 2.0),
//                     ColumnMeta(title: 'Jumlah Aset', field: 'jumlah', widthFactor: 2.0),
//                     ColumnMeta(title: 'Harga Pasar', field: 'hargaPasar', widthFactor: 2.5, isCurrency: true),
//                     ColumnMeta(title: 'Harga Pertanggungan', field: 'hargaPertanggungan', widthFactor: 2.5, isCurrency: true),
//                   ],
//                   showActionColumn: false,
//                 ),
//                 rows: TrinaRowBuilder.build(_originalItems, ['aset', 'jumlah', 'hargaPasar', 'hargaPertanggungan'], showActionColumn: false),
//                 onGridLoaded: (manager) => _stateManager = manager,
//               );
//             } else if (state.status == ListStatus.loading) {
//               return const Center(child: CircularProgressIndicator());
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ]
//   );
// }














































































//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:trina_grid/trina_grid.dart';
// import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
// import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
// import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';
// import 'package:joss_app/common/constants.dart';
//
// class TableRingkasanWidget extends StatefulWidget {
//   final EdgeInsetsGeometry? padding;
//   final String initialStatusId;
//   final double? listHeight;
//
//   const TableRingkasanWidget({
//     super.key,
//     this.padding,
//     this.initialStatusId = '10001',
//     this.listHeight,
//   });
//
//   @override
//   State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
// }
//
// class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
//   final TextEditingController _searchController = TextEditingController();
//   TrinaGridStateManager? _stateManager;
//   final _currencyFormat = NumberFormat.currency(
//     locale: 'id_ID',
//     symbol: 'IDR ',
//     decimalDigits: 0,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _refreshData() {
//     context.read<AsetRingkasanCariBloc>().add(
//       RefreshAsetRingkasanCariEvent(
//         statusId: widget.initialStatusId,
//         searchText: _searchController.text,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 768;
//     final height = widget.listHeight ?? (isMobile ? 500 : 600);
//
//     return Padding(
//       padding: widget.padding ?? EdgeInsets.zero,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListPageFilterBarUIWidget(
//             searchController: _searchController,
//             searchButton: _buildSearchButton(),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: height,
//             child: BlocBuilder<AsetRingkasanCariBloc, AsetRingkasanCariState>(
//               builder: (context, state) {
//                 // Handle different ListStatus states
//                 switch (state.status) {
//                   case ListStatus.initial:
//                     return _buildLoadingState();
//
//                   case ListStatus.failure:
//                     return _buildErrorState('Gagal memuat data ringkasan aset');
//
//                   case ListStatus.success:
//                     if (state.items.isEmpty) {
//                       return _buildEmptyState();
//                     }
//                     return _buildTrinaTable(state.items, isMobile);
//
//                   default:
//                     return _buildLoadingState();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Memuat data ringkasan aset...',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String message) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.red.shade200),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 48,
//               color: Colors.red.shade400,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Terjadi kesalahan',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.red.shade700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _refreshData,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Coba Lagi'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF007AFF),
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.inventory_2_outlined,
//               size: 64,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Tidak ada data ringkasan aset',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Silakan refresh atau ubah filter pencarian',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTrinaTable(List<AsetRingkasanCariModel> data, bool isMobile) {
//     final columns = _buildColumns(isMobile);
//     final rows = _buildRows(data);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: TrinaGrid(
//           columns: columns,
//           rows: rows,
//           mode: TrinaGridMode.normal,
//           configuration: _buildGridConfig(isMobile),
//           createFooter: (stateManager) => _buildCustomFooter(stateManager, data.length),
//           onLoaded: (event) {
//             _stateManager = event.stateManager;
//             event.stateManager.setPageSize(isMobile ? 8 : 10, notify: true);
//             event.stateManager.setPage(1);
//           },
//         ),
//
//       ),
//     );
//
//   }
//
//   TrinaGridConfiguration _buildGridConfig(bool isMobile) {
//     return TrinaGridConfiguration(
//       enableMoveHorizontalInEditing: false,
//       columnSize: TrinaGridColumnSizeConfig(
//         autoSizeMode: TrinaAutoSizeMode.scale, // Ubah dari scale ke fit
//         resizeMode: TrinaResizeMode.normal,  // Aktifkan resize
//       ),
//       scrollbar: TrinaGridScrollbarConfig(
//         showHorizontal: true,
//         showVertical: true,
//         isAlwaysShown: true, // Scrollbar selalu terlihat
//       ),
//       style: TrinaGridStyleConfig(
//         rowHeight: isMobile ? 80 : 90,
//         columnHeight: isMobile ? 48 : 56,
//         borderColor: Colors.transparent,
//         enableGridBorderShadow: false,
//         gridBorderColor: Colors.transparent,
//         gridBorderRadius: BorderRadius.circular(16),
//         gridPadding: 0,
//         enableColumnBorderVertical: true,
//         enableCellBorderVertical: true,
//         // Enhanced mobile styling
//         rowColor: Colors.white,
//         activatedColor: const Color(0xFFF0F8FF),
//       ),
//     );
//   }
//
//   List<TrinaColumn> _buildColumns(bool isMobile) {
//     final baseTextStyle = TextStyle(
//       fontFamily: 'Inter',
//       fontSize: isMobile ? 13 : 15,
//       fontWeight: FontWeight.w500,
//     );
//
//     final headerTextStyle = baseTextStyle.copyWith(
//       fontWeight: FontWeight.w600,
//       color: const Color(0xFF1F2937),
//       fontSize: isMobile ? 12 : 14,
//     );
//
//     return [
//       // Index Column
//       TrinaColumn(
//         title: 'NO',
//         field: 'no',
//         width: isMobile ? 50 : 60,
//         minWidth: isMobile ? 50 : 60,
//         frozen: TrinaColumnFrozen.start,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('NO', headerTextStyle),
//         renderer: (context) => _buildIndexCell(context, baseTextStyle),
//       ),
//
//       // Jenis Polis Column
//       TrinaColumn(
//         title: 'JENIS POLIS',
//         field: 'jenis_polis',
//         width: isMobile ? 120 : 140,
//         minWidth: isMobile ? 120 : 140,
//         frozen: isMobile ? TrinaColumnFrozen.start : TrinaColumnFrozen.none,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('JENIS POLIS', headerTextStyle),
//         renderer: (context) => _buildTextCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle.copyWith(
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF374151),
//           ),
//           icon: _getPolisIcon(context.cell.value?.toString() ?? ''),
//         ),
//       ),
//
//       // Jumlah Polis Aktif Column
//       TrinaColumn(
//         title: 'JUMLAH POLIS AKTIF',
//         field: 'jumlah_polis',
//         width: isMobile ? 100 : 120,
//         minWidth: isMobile ? 100 : 120,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('JUMLAH POLIS AKTIF', headerTextStyle),
//         renderer: (context) => _buildNumberCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           showBadge: true,
//         ),
//       ),
//
//       // Total Pertanggungan Column
//       TrinaColumn(
//         title: 'TOTAL PERTANGGUNGAN',
//         field: 'total_pertanggungan',
//         width: isMobile ? 140 : 160,
//         minWidth: isMobile ? 140 : 160,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('TOTAL PERTANGGUNGAN', headerTextStyle),
//         renderer: (context) => _buildCurrencyCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           color: const Color(0xFF059669),
//         ),
//       ),
//
//       // Total Premi Column
//       TrinaColumn(
//         title: 'TOTAL PREMI',
//         field: 'total_premi',
//         width: isMobile ? 120 : 140,
//         minWidth: isMobile ? 120 : 140,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('TOTAL PREMI', headerTextStyle),
//         renderer: (context) => _buildCurrencyCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           color: const Color(0xFF7C3AED),
//         ),
//       ),
//
//       // Jumlah Klaim Berjalan Column
//       TrinaColumn(
//         title: 'JUMLAH KLAIM BERJALAN',
//         field: 'jumlah_klaim',
//         width: isMobile ? 100 : 120,
//         minWidth: isMobile ? 100 : 120,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('JUMLAH KLAIM BERJALAN', headerTextStyle),
//         renderer: (context) => _buildNumberCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           showWarning: int.tryParse(context.cell.value?.toString() ?? '0')! > 0,
//         ),
//       ),
//
//       // Nilai Klaim Dibayar Column
//       TrinaColumn(
//         title: 'NILAI KLAIM DIBAYAR',
//         field: 'nilai_klaim',
//         width: isMobile ? 140 : 160,
//         minWidth: isMobile ? 140 : 160,
//         type: TrinaColumnType.text(),
//         enableEditingMode: false,
//         enableContextMenu: false,
//         titleRenderer: (context) => _buildHeaderCell('NILAI KLAIM DIBAYAR', headerTextStyle),
//         renderer: (context) => _buildCurrencyCell(
//           context.cell.value?.toString() ?? '',
//           baseTextStyle,
//           color: const Color(0xFFDC2626),
//         ),
//       ),
//     ];
//   }
//
//   IconData _getPolisIcon(String jenisPolis) {
//     switch (jenisPolis.toLowerCase()) {
//       case 'properti':
//         return Icons.home_work_outlined;
//       case 'kendaraan':
//         return Icons.directions_car_outlined;
//       case 'kesehatan':
//         return Icons.health_and_safety_outlined;
//       case 'rangka kapal':
//         return Icons.directions_boat_outlined;
//       case 'sdm':
//         return Icons.people_outline;
//       default:
//         return Icons.description_outlined;
//     }
//   }
//
//   Widget _buildHeaderCell(String title, TextStyle style) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: style,
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   Widget _buildIndexCell(dynamic context, TextStyle style) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       alignment: Alignment.center,
//       child: Container(
//         width: 28,
//         height: 28,
//         decoration: BoxDecoration(
//           color: const Color(0xFF007AFF).withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Text(
//             context.cell.value?.toString() ?? '',
//             style: style.copyWith(
//               color: const Color(0xFF007AFF),
//               fontWeight: FontWeight.w600,
//               fontSize: style.fontSize! - 1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextCell(String value, TextStyle style, {IconData? icon}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Row(
//         children: [
//           if (icon != null) ...[
//             Icon(
//               icon,
//               size: 18,
//               color: style.color?.withOpacity(0.7),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Expanded(
//             child: Text(
//               value,
//               style: style,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNumberCell(String value, TextStyle style, {bool showBadge = false, bool showWarning = false}) {
//     final number = int.tryParse(value) ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       alignment: Alignment.centerLeft,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: showWarning
//               ? const Color(0xFFFEF3C7)
//               : showBadge
//               ? const Color(0xFFECFDF5)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: showWarning
//                 ? const Color(0xFFFBBF24)
//                 : showBadge
//                 ? const Color(0xFF10B981)
//                 : Colors.transparent,
//             width: 1,
//           ),
//         ),
//         child: Text(
//           NumberFormat('#,###', 'id_ID').format(number),
//           style: style.copyWith(
//             color: showWarning
//                 ? const Color(0xFF92400E)
//                 : showBadge
//                 ? const Color(0xFF047857)
//                 : style.color,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCurrencyCell(String value, TextStyle style, {Color? color}) {
//     final amount = double.tryParse(value) ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       alignment: Alignment.centerLeft,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             _currencyFormat.format(amount),
//             style: style.copyWith(
//               color: color ?? const Color(0xFF374151),
//               fontWeight: FontWeight.w600,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<TrinaRow> _buildRows(List<AsetRingkasanCariModel> data) {
//     return data.asMap().entries.map((entry) {
//       final index = entry.key;
//       final item = entry.value;
//
//       return TrinaRow(
//         cells: {
//           'no': TrinaCell(value: (index + 1).toString()),
//           'jenis_polis': TrinaCell(value: item.asetNama ?? ''),
//           'jumlah_polis': TrinaCell(value: '${item.jmlAset ?? 0} ${item.satuan ?? ''}'),
//           'total_pertanggungan': TrinaCell(value: (item.nilaiAset ?? 0).toString()),
//           'total_premi': TrinaCell(value: (item.nilaiPremi ?? 0).toString()),
//           'jumlah_klaim': TrinaCell(value: '0'), // Sesuaikan dengan field yang ada di model
//           'nilai_klaim': TrinaCell(value: '0'), // Sesuaikan dengan field yang ada di model
//         },
//       );
//     }).toList();
//   }
//
//   Widget _buildCustomFooter(TrinaGridStateManager stateManager, int totalRows) {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FA),
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Total: $totalRows item${totalRows != 1 ? 's' : ''}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF6B7280),
//                 ),
//               ),
//             ),
//           ),
//           TrinaPagination(
//             stateManager,
//             pageSizeToMove: 1,
//           ),
//         ],
//       ),
//     );
//   }
//
//   IconButton _buildSearchButton() {
//     return IconButton(
//       icon: const Icon(Icons.search, size: 24),
//       onPressed: () {
//         _refreshData();
//         if (_stateManager != null) {
//           _stateManager!.setPage(1);
//         }
//       },
//       tooltip: 'Cari Data',
//       style: IconButton.styleFrom(
//         backgroundColor: const Color(0xFF007AFF),
//         foregroundColor: Colors.white,
//       ),
//     );
//   }
// }*/