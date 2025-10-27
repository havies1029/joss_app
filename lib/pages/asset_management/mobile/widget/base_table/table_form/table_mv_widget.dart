// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
// import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
// import 'package:joss_app/models/gen_aset_mv/asetmvcari_model.dart';
// import 'package:joss_app/pages/gen_aset_mv/asetmvcari_list_widget.dart';
// import 'package:joss_app/widgets/apptheme/polis_button.dart';
// import 'package:joss_app/widgets/apptheme/popup_widget.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/helper/expert_helper.dart';
// import 'package:joss_app/helper/mobile_expert_helper.dart';
// import 'package:joss_app/blocs/share_cubit/share_mv_state_cubit.dart';
//
// import '../list_form/aset_list_mv.dart';
//
// class TableMvWidget extends StatefulWidget {
//   final EdgeInsetsGeometry? padding;
//   final String initialStatusId;
//   final double? listHeight;
//
//   const TableMvWidget({
//     super.key,
//     this.padding,
//     this.initialStatusId = '10001',
//     this.listHeight,
//   });
//
//   @override
//   State<TableMvWidget> createState() => _TableMvWidgetState();
// }
//
// class _TableMvWidgetState extends State<TableMvWidget> {
//   final TextEditingController _searchController = TextEditingController();
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
//     context.read<AsetMvCariBloc>().add(
//       RefreshAsetMvCariEvent(
//         statusId: widget.initialStatusId,
//         searchText: _searchController.text,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ShareMvStateCubit(),
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<ShareMvStateCubit, Map<String, AsetMvCariModel>>(
//             listener: (context, state) {
//               if (kDebugMode) {
//                 final selected = state.values.toList();
//                 debugPrint("=============================================");
//                 debugPrint("✅ Selected MV Items: ${selected.length}");
//                 debugPrint("=============================================");
//                 for (var i = 0; i < selected.length; i++) {
//                   final item = selected[i];
//                   debugPrint("[$i]");
//                   debugPrint("  • ID        : ${item.asetMvId}");
//                   debugPrint("  • No Polisi : ${item.noPolisi}");
//                   debugPrint("  • Merk      : ${item.merk}");
//                   debugPrint("  • Tipe      : ${item.tipe}");
//                   debugPrint("  • Tahun     : ${item.tahun}");
//                   debugPrint("  • Premi     : ${item.premi}");
//                   debugPrint("  • SumIns    : ${item.sumInsured}");
//                   debugPrint("---------------------------------------------");
//                 }
//               }
//             },
//           ),
//         ],
//         child: BlocBuilder<ShareMvStateCubit, Map<String, AsetMvCariModel>>(
//           builder: (context, map) {
//             final cubit = context.read<ShareMvStateCubit>();
//
//             return Padding(
//               padding: widget.padding ?? EdgeInsets.zero,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// 🔍 Search bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: hPadding),
//                     child: ListPageFilterBarUIWidget(
//                       searchController: _searchController,
//                       searchButton: _buildSearchButton(),
//                       hintText: "Cari Kendaraan...",
//                     ),
//                   ),
//
//                   const SizedBox(height: vPadding),
//
//                   /// 🧭 Toolbar (Tambah, Unduh, Share)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: hPadding),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final bool hideText = constraints.maxWidth < 480;
//                         final bool isCompact = constraints.maxWidth < 700;
//
//                         return isCompact
//                             ? Wrap(
//                           alignment: WrapAlignment.start,
//                           spacing: 12,
//                           runSpacing: 8,
//                           children: _buildToolbarButtons(context, cubit, hideText),
//                         )
//                             : Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: _buildToolbarButtons(context, cubit, hideText)
//                               .map((btn) => Padding(
//                             padding: const EdgeInsets.only(right: 12),
//                             child: btn,
//                           ))
//                               .toList(),
//                         );
//                       },
//                     ),
//                   ),
//
//                   const SizedBox(height: vPadding),
//
//                   /// 📋 Daftar kendaraan (list)
//                   Expanded(
//                     child: AsetListMv(
//                       searchText: _searchController.text,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   /// 🔁 Tombol Refresh
//   IconButton _buildSearchButton() {
//     return IconButton(
//       icon: const Icon(Icons.autorenew_rounded, size: 28),
//       onPressed: _refreshData,
//       tooltip: 'Refresh data',
//     );
//   }
//
//   /// 🎛️ Toolbar Buttons
//   List<Widget> _buildToolbarButtons(
//       BuildContext context, ShareMvStateCubit cubit, bool hideText) {
//     return [
//       StatusTextBox(
//         assetPath: "assets/icons/tambah_polis_icon_polis.svg",
//         text: hideText ? null : "Tambah",
//         bgColor: Colors.orange,
//       ),
//       StatusTextBox(
//         assetPath: "assets/icons/unduh_data_polis.svg",
//         text: hideText ? null : "Unduh",
//         bgColor: Colors.grey,
//         onTap: () => _showExportDialog(context, cubit),
//       ),
//       StatusTextBox(
//         assetPath: "assets/icons/share_data_polis.svg",
//         text: hideText ? null : "Share",
//         bgColor: Colors.blue,
//       ),
//     ];
//   }
//
//   /// 📤 Popup Export
//   Future<void> _showExportDialog(
//       BuildContext context, ShareMvStateCubit cubit) async {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "Tutup",
//       barrierColor: Colors.black.withOpacity(0.6),
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return BlocProvider.value(
//           value: cubit,
//           child: GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Material(
//               color: Colors.transparent,
//               child: Center(
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: PopupWidget(
//                     title: "Pilih format file untuk diunduh",
//                     subtitle: "Tersedia dalam format Excel dan PDF",
//                     button1Text: "Excel",
//                     button2Text: "PDF",
//                     onExportSelected: (format) async {
//                       final exportData = cubit.toExportData();
//
//                       if (exportData.isEmpty) {
//                         Navigator.of(context).pop();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("⚠️ Tidak ada data yang dipilih"),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                         return;
//                       }
//
//                       Navigator.of(context).pop();
//
//                       switch (format) {
//                         case ExportFormat.excel:
//                           if (kIsWeb) {
//                             await ExportHelper.export(
//                               "excel",
//                               exportData,
//                               CategoryType.kendaraan,
//                             );
//                           } else {
//                             await MobileDownloadHelper.download(
//                               context: context,
//                               fileName: "Data_Kendaraan.xlsx",
//                               data: exportData,
//                               format: "excel",
//                             );
//                           }
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                   "✅ Berhasil ekspor ${exportData.length} data ke Excel"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                           break;
//
//                         case ExportFormat.pdf:
//                           if (kIsWeb) {
//                             await ExportHelper.export(
//                               "pdf",
//                               exportData,
//                               CategoryType.kendaraan,
//                             );
//                           } else {
//                             await MobileDownloadHelper.download(
//                               context: context,
//                               fileName: "Data_Kendaraan.pdf",
//                               data: exportData,
//                               format: "pdf",
//                             );
//                           }
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                   "✅ Berhasil ekspor ${exportData.length} data ke PDF"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                           break;
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: ScaleTransition(
//             scale: CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeOutBack,
//             ),
//             child: child,
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_mv_state_cubit.dart';
import '../../../../../../models/gen_aset_mv/asetmvcari_model.dart';
import '../list_form/aset_list_mv.dart';
import '../tables/template_table_form_widget.dart';

class TableMvWidget extends StatelessWidget {
  const TableMvWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateTableFormWidget<
        AsetMvCariModel,
        AsetMvCariBloc,
        AsetDashboardCariBloc,
        ShareMvStateCubit
    >(
      cobType: 'Mv',
      shareCubitBuilder: () => ShareMvStateCubit(),
      listBuilder: (searchText, [statusLabel]) => AsetListMv(
        searchText: searchText,
        statusLabel: statusLabel ?? 'Aktif',),
      onRefreshRequested: (statusId, searchText) {
        context.read<AsetMvCariBloc>().add(
          RefreshAsetMvCariEvent(statusId: statusId, searchText: searchText),
        );
      },
      onDashboardRefresh: (cobAppId) {
        context.read<AsetDashboardCariBloc>().add(
          RefreshAsetDashboardCariEvent(cobAppId: cobAppId),
        );
      },
    );
  }
}