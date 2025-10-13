// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
// import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
// import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';
// import 'package:joss_app/widgets/apptheme/build_status_text_box.dart';
// import 'package:joss_app/widgets/apptheme/popup_widget.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/helper/expert_helper.dart';
// import 'package:joss_app/helper/mobile_expert_helper.dart';
// import 'package:joss_app/blocs/share_cubit/share_par_state_cubit.dart';
//
// import '../list_form/aset_list_par.dart';
//
// class TableParWidget extends StatefulWidget {
//   final EdgeInsetsGeometry? padding;
//   final String initialStatusId;
//   final double? listHeight;
//
//   const TableParWidget({
//     super.key,
//     this.padding,
//     this.initialStatusId = '10001',
//     this.listHeight,
//   });
//
//   @override
//   State<TableParWidget> createState() => _TableParWidgetState();
// }
//
// class _TableParWidgetState extends State<TableParWidget> {
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
//     context.read<AsetParCariBloc>().add(
//       RefreshAsetParCariEvent(
//         statusId: widget.initialStatusId,
//         searchText: _searchController.text,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ShareParStateCubit(),
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<ShareParStateCubit, Map<String, AsetParCariModel>>(
//             listener: (context, state) {
//               if (kDebugMode) {
//                 final selected = state.values.toList();
//                 debugPrint("=============================================");
//                 debugPrint("✅ Selected Items: ${selected.length}");
//                 debugPrint("=============================================");
//                 for (var i = 0; i < selected.length; i++) {
//                   final item = selected[i];
//                   debugPrint("[$i]");
//                   debugPrint("  • ID       : ${item.asetParId}");
//                   debugPrint("  • Alamat   : ${item.alamat}");
//                   debugPrint("  • Currency : ${item.curr}");
//                   debugPrint("  • Premi    : ${item.premi}");
//                   debugPrint("  • SumIns   : ${item.sumInsured}");
//                   debugPrint("---------------------------------------------");
//                 }
//               }
//             },
//           ),
//         ],
//         child: BlocBuilder<ShareParStateCubit, Map<String, AsetParCariModel>>(
//           builder: (context, map) {
//             final cubit = context.read<ShareParStateCubit>();
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
//                       hintText: "Cari Properti...",
//                     ),
//                   ),
//
//                   const SizedBox(height: vPadding),
//
//                   /// 🧭 Toolbar global (Tambah, Unduh, Share)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: hPadding),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final bool hideText = constraints.maxWidth < 480;
//                         final bool isCompact = constraints.maxWidth < 700;
//
//                         // Responsive: wrap di layar kecil
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
//                   /// 📋 List data PAR
//                   Expanded(
//                     child: AsetListPar(
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
//   /// 🔄 Tombol search/refresh utama
//   IconButton _buildSearchButton() {
//     return IconButton(
//       icon: const Icon(Icons.autorenew_rounded, size: 28),
//       onPressed: _refreshData,
//       tooltip: 'Refresh data',
//     );
//   }
//
//   /// 🎛️ Toolbar buttons (Tambah, Unduh, Share)
//   List<Widget> _buildToolbarButtons(
//       BuildContext context, ShareParStateCubit cubit, bool hideText) {
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
//   /// 📤 Popup ekspor file
//   Future<void> _showExportDialog(
//       BuildContext context, ShareParStateCubit cubit) async {
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
//                               CategoryType.properti,
//                             );
//                           } else {
//                             await MobileDownloadHelper.download(
//                               context: context,
//                               fileName: "Data_Properti.xlsx",
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
//                               CategoryType.properti,
//                             );
//                           } else {
//                             await MobileDownloadHelper.download(
//                               context: context,
//                               fileName: "Data_Properti.pdf",
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
//
//
//
//


import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_par_state_cubit.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/expert_helper.dart';
import '../../../../../../helper/mobile_expert_helper.dart';

import '../../../../../../models/gen_aset_par/asetparcari_model.dart';
import '../../../../../../widgets/apptheme/build_status_box.dart';
import '../../../../../../widgets/apptheme/build_status_text_box.dart';
import '../../../../../../widgets/apptheme/popup_widget.dart';
import '../list_form/aset_list_par.dart';

class TableParWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight;

  const TableParWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight,
  });

  @override
  State<TableParWidget> createState() => _TableParWidgetState();
}

class _TableParWidgetState extends State<TableParWidget> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatusId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _refreshData() {
    context.read<AsetParCariBloc>().add(
      RefreshAsetParCariEvent(
        statusId: widget.initialStatusId,
        searchText: _searchController.text,
      ),
    );

    context.read<AsetDashboardCariBloc>().add(
      RefreshAsetDashboardCariEvent(cobAppId:  "10002"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShareParStateCubit(),
      child: MultiBlocListener(
        listeners: [
          /// Listener untuk debug ShareRingkasanStateCubit
          BlocListener<ShareParStateCubit, Map<String, AsetParCariModel>>(
            listener: (context, state) {
              final selected = state.values.toList();
              debugPrint("=============================================");
              debugPrint("✅ Selected Items: ${selected.length}");
              debugPrint("=============================================");
              for (var i = 0; i < selected.length; i++) {
                final item = selected[i];
                debugPrint("[$i]");
                debugPrint("  • ID       : ${item.asetParId}");
                debugPrint("  • Alamat   : ${item.alamat}");
                debugPrint("  • Currency : ${item.curr}");
                debugPrint("  • Premi    : ${item.premi}");
                debugPrint("  • SumIns   : ${item.sumInsured}");
                debugPrint("---------------------------------------------");
              }

              if (selected.isEmpty) {
                debugPrint("⚠️ Tidak ada item yang dipilih.");
              }
            },
          ),

        ],
        child: BlocBuilder<ShareParStateCubit, Map<String, AsetParCariModel>>(
          builder: (context, map) {
            final cubit = context.read<ShareParStateCubit>();

            return Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isCompact = constraints.maxWidth < 480;
                        final double iconSize = isCompact ? 16 : 20;
                        final double boxSize = isCompact ? 36 : 42;
                        final textStyle = TextStyle(
                          fontSize: isCompact ? 13 : 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        );

                        // ✅ Reusable card sederhana
                        Widget buildStatusCard({
                          required StatusType type,
                          required String text,
                          required bool isSelected,
                          required VoidCallback onTap,
                        }) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: onTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: pGrey,
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                                border: Border.all(
                                  color: isSelected ? type.color : sGrey.withOpacity(0.5),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 🔥 Gunakan IgnorePointer biar tap di ikon gak “nahan” gesture
                                  IgnorePointer(
                                    child: StatusBox(
                                      assetPath: type.asset,
                                      bgColor: type.color,
                                      iconColor: Colors.white,
                                      size: isSelected ? boxSize + 2 : boxSize,
                                      iconSize: iconSize,
                                      showBorder: false,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    text,
                                    style: textStyle.copyWith(
                                      fontWeight:
                                      isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? Colors.white : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // 🔹 Ambil data dari Dashboard
                        return BlocBuilder<AsetDashboardCariBloc, AsetDashboardCariState>(
                          builder: (context, state) {
                            if (state.status == ListStatus.success && state.items.isNotEmpty) {
                              final summary = state.items.first;

                              final statusData = {
                                StatusType.aktif: summary.aktifQty,
                                StatusType.onProgress: summary.onProgressQty,
                                StatusType.nonAktif: summary.nonAktifQty,
                                StatusType.berakhir: summary.berakhirQty,
                              };

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: StatusType.values.map((type) {
                                  final bool isSelected = _selectedStatusId == type.id;

                                  return buildStatusCard(
                                    type: type,
                                    text: statusData[type].toString(),
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        _selectedStatusId = (isSelected) ? null : type.id;
                                      });

                                      // 🧩 Batasi event agar tidak spam (debounce 350ms)
                                      _debounce?.cancel();
                                      _debounce = Timer(const Duration(milliseconds: 350), () {
                                        context.read<AsetParCariBloc>().add(
                                          RefreshAsetParCariEvent(
                                              statusId: _selectedStatusId ?? widget.initialStatusId,
                                            searchText: _searchController.text,
                                          ),
                                        );
                                      });
                                    },

                                  );
                                }).toList(),
                              );
                            }

                            // Placeholder state
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: StatusType.values.map((type) {
                                return buildStatusCard(
                                  type: type,
                                  text: "-",
                                  isSelected: false,
                                  onTap: () {},
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: vPadding),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding),
                    child: ListPageFilterBarUIWidget(
                      searchController: _searchController,
                      searchButton: _buildSearchButton(),
                      hintText: "Cari Polis.... ",
                    ),
                  ),

                  const SizedBox(height: vPadding),

                  /// Toolbar (global actions)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // threshold bebas lo atur, misalnya < 480 px sembunyikan teks
                        final bool hideText = constraints.maxWidth < 480;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StatusTextBox(
                              assetPath: "assets/icons/tambah_polis_icon_polis.svg",
                              text: "Tambah",   // ⬅️ hilangkan teks
                              bgColor: Colors.orange,
                            ),


                            const SizedBox(
                                width: hPadding
                            ),

                            StatusTextBox(
                              assetPath: "assets/icons/unduh_data_polis.svg",
                              text: "Unduh",
                              bgColor: Colors.grey,
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: "Tutup",
                                  barrierColor: Colors.black.withOpacity(0.6),
                                  transitionDuration: const Duration(milliseconds: 250),
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return BlocProvider.value(
                                      value: cubit, // 🔑 pass cubit yang udah ada
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context).pop(),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: PopupWidget(
                                                title: "Pilih format file untuk diunduh",
                                                subtitle: "Tersedia dalam format Excel dan PDF",
                                                button1Text: "Excel",
                                                button2Text: "PDF",
                                                onExportSelected: (format) async {
                                                  final exportData = cubit.toExportData();

                                                  if (exportData.isEmpty) {
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("⚠️ Tidak ada data yang dipilih"),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  Navigator.of(context).pop();

                                                  switch (format) {
                                                    case ExportFormat.excel:
                                                      if (kIsWeb) {
                                                        await ExportHelper.export("excel", exportData, CategoryType.ringkasan);
                                                      } else {
                                                        await MobileDownloadHelper.download(
                                                          context: context,
                                                          fileName: "Data_Par.xlsx",
                                                          data: exportData,
                                                          format: "excel",
                                                        );
                                                      }
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text("✅ Berhasil ekspor ${exportData.length} data ke Excel"),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                      break;

                                                    case ExportFormat.pdf:
                                                      if (kIsWeb) {
                                                        await ExportHelper.export("pdf", exportData, CategoryType.ringkasan);
                                                      } else {
                                                        await MobileDownloadHelper.download(
                                                          context: context,
                                                          fileName: "Data_Par.pdf",
                                                          data: exportData,
                                                          format: "pdf",
                                                        );
                                                      }
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text("✅ Berhasil ekspor ${exportData.length} data ke PDF"),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                      break;
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutBack,
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(
                                width: hPadding
                            ),

                            StatusTextBox(
                              assetPath: "assets/icons/share_data_polis.svg",
                              text: "Share",
                              bgColor: Colors.blue,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: vPadding),

                  Expanded(
                    child: AsetListPar(
                      searchText: _searchController.text,
                    ),
                  ),
                ],
              ),
            );

          },
        ),
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
