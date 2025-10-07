// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
// import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
// import 'package:joss_app/pages/gen_aset_health/asethealthcari_list_widget.dart';
//
// import '../../../../../../blocs/share_cubit/share_health_state_cubit.dart';
// import '../../../../../../common/constants.dart';
// import '../../../../../../helper/expert_helper.dart';
// import '../../../../../../helper/mobile_expert_helper.dart';
// import '../../../../../../models/gen_aset_health/asethealthcari_model.dart';
// import '../../../../../../widgets/apptheme/build_status_text_box.dart';
// import '../../../../../../widgets/apptheme/popup_widget.dart';
// import '../list_form/aset_list_health.dart';
//
// class TableHealthWidget extends StatefulWidget {
//   final EdgeInsetsGeometry? padding;
//   final String initialStatusId;
//   final double? listHeight;
//
//   const TableHealthWidget({
//     super.key,
//     this.padding,
//     this.initialStatusId = '10005',
//     this.listHeight,
//   });
//
//   @override
//   State<TableHealthWidget> createState() => _TableHealthWidgetState();
// }
//
// class _TableHealthWidgetState extends State<TableHealthWidget> {
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
//     context.read<AsetHealthCariBloc>().add(
//       RefreshAsetHealthCariEvent(
//         searchText: _searchController.text,
//         statusId: widget.initialStatusId,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ShareHealthStateCubit(),
//       child: MultiBlocListener(
//         listeners: [
//           /// Debug listener buat pantau data terpilih
//           BlocListener<ShareHealthStateCubit,
//               Map<String, AsetHealthCariModel>>(
//             listener: (context, state) {
//               final selected = state.values.toList();
//               debugPrint("=============================================");
//               debugPrint("✅ Selected Items: ${selected.length}");
//               for (var i = 0; i < selected.length; i++) {
//                 final item = selected[i];
//                 debugPrint(
//                     "[${i + 1}] ${item.asethealthId} - ${item.nama} (${item.jnskel})");
//               }
//               if (selected.isEmpty) {
//                 debugPrint("⚠️ Tidak ada item yang dipilih.");
//               }
//               debugPrint("=============================================");
//             },
//           ),
//         ],
//         child: BlocBuilder<ShareHealthStateCubit,
//             Map<String, AsetHealthCariModel>>(
//           builder: (context, map) {
//             final cubit = context.read<ShareHealthStateCubit>();
//
//             return Padding(
//               padding: widget.padding ?? EdgeInsets.zero,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🔍 Filter Bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: hPadding),
//                     child: ListPageFilterBarUIWidget(
//                       searchController: _searchController,
//                       searchButton: _buildSearchButton(),
//                       hintText: "Cari Polis / Nama Peserta...",
//                     ),
//                   ),
//
//                   const SizedBox(height: vPadding),
//
//                   // 🧰 Toolbar Actions (Tambah / Unduh / Share)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: hPadding),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final bool hideText = constraints.maxWidth < 480;
//
//                         return Wrap(
//                           spacing: 12,
//                           runSpacing: 8,
//                           alignment: WrapAlignment.spaceBetween,
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           children: [
//                             StatusTextBox(
//                               assetPath:
//                               "assets/icons/tambah_polis_icon_polis.svg",
//                               text: hideText ? null : "Tambah",
//                               bgColor: Colors.orange,
//                             ),
//
//                             StatusTextBox(
//                               assetPath: "assets/icons/unduh_data_polis.svg",
//                               text: hideText ? null : "Unduh",
//                               bgColor: Colors.grey,
//                               onTap: () {
//                                 showGeneralDialog(
//                                   context: context,
//                                   barrierDismissible: true,
//                                   barrierLabel: "Tutup",
//                                   barrierColor: Colors.black.withOpacity(0.6),
//                                   transitionDuration:
//                                   const Duration(milliseconds: 250),
//                                   pageBuilder: (context, anim, sec) {
//                                     return BlocProvider.value(
//                                       value: cubit,
//                                       child: GestureDetector(
//                                         onTap: () =>
//                                             Navigator.of(context).pop(),
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: Center(
//                                             child: PopupWidget(
//                                               title:
//                                               "Pilih format file untuk diunduh",
//                                               subtitle:
//                                               "Tersedia dalam format Excel dan PDF",
//                                               button1Text: "Excel",
//                                               button2Text: "PDF",
//                                               onExportSelected: (format) async {
//                                                 final exportData =
//                                                 cubit.toExportData();
//                                                 if (exportData.isEmpty) {
//                                                   Navigator.of(context).pop();
//                                                   ScaffoldMessenger.of(context)
//                                                       .showSnackBar(
//                                                     const SnackBar(
//                                                       content: Text(
//                                                           "⚠️ Tidak ada data yang dipilih"),
//                                                       backgroundColor:
//                                                       Colors.red,
//                                                     ),
//                                                   );
//                                                   return;
//                                                 }
//
//                                                 Navigator.of(context).pop();
//
//                                                 switch (format) {
//                                                   case ExportFormat.excel:
//                                                     if (kIsWeb) {
//                                                       await ExportHelper.export(
//                                                           "excel",
//                                                           exportData,
//                                                           CategoryType.kesehatan);
//                                                     } else {
//                                                       await MobileDownloadHelper
//                                                           .download(
//                                                         context: context,
//                                                         fileName:
//                                                         "Data_Health.xlsx",
//                                                         data: exportData,
//                                                         format: "excel",
//                                                       );
//                                                     }
//                                                     ScaffoldMessenger.of(
//                                                         context)
//                                                         .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           "✅ Berhasil ekspor ${exportData.length} data ke Excel"),
//                                                       backgroundColor:
//                                                       Colors.green,
//                                                     ));
//                                                     break;
//
//                                                   case ExportFormat.pdf:
//                                                     if (kIsWeb) {
//                                                       await ExportHelper.export(
//                                                           "pdf",
//                                                           exportData,
//                                                           CategoryType.kesehatan);
//                                                     } else {
//                                                       await MobileDownloadHelper
//                                                           .download(
//                                                         context: context,
//                                                         fileName:
//                                                         "Data_Health.pdf",
//                                                         data: exportData,
//                                                         format: "pdf",
//                                                       );
//                                                     }
//                                                     ScaffoldMessenger.of(
//                                                         context)
//                                                         .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           "✅ Berhasil ekspor ${exportData.length} data ke PDF"),
//                                                       backgroundColor:
//                                                       Colors.green,
//                                                     ));
//                                                     break;
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   transitionBuilder:
//                                       (context, anim, secAnim, child) {
//                                     return FadeTransition(
//                                       opacity: anim,
//                                       child: ScaleTransition(
//                                         scale: CurvedAnimation(
//                                           parent: anim,
//                                           curve: Curves.easeOutBack,
//                                         ),
//                                         child: child,
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//
//                             StatusTextBox(
//                               assetPath: "assets/icons/share_data_polis.svg",
//                               text: hideText ? null : "Share",
//                               bgColor: Colors.blue,
//                               onTap: () {
//                                 final selected = cubit.selectedItems;
//                                 if (selected.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content:
//                                       Text("⚠️ Tidak ada data yang dipilih"),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                   return;
//                                 }
//
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                         "📤 ${selected.length} data siap di-share."),
//                                     backgroundColor: Colors.blueAccent,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//
//                   const SizedBox(height: vPadding),
//
//                   // 📋 List Data
//                   Expanded(
//                     child: AsetListHealth(
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
//   IconButton _buildSearchButton() {
//     return IconButton(
//       icon: const Icon(Icons.autorenew_rounded, size: 28),
//       tooltip: 'Refresh',
//       onPressed: _refreshData,
//     );
//   }
// }







































import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import '../../../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_health_state_cubit.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/expert_helper.dart';
import '../../../../../../helper/mobile_expert_helper.dart';
import '../../../../../../models/gen_aset_health/asethealthcari_model.dart';
import '../../../../../../widgets/apptheme/build_status_text_box.dart';
import '../../../../../../widgets/apptheme/popup_widget.dart';
import '../list_form/aset_list_health.dart';

class TableHealthWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight;

  const TableHealthWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight,
  });

  @override
  State<TableHealthWidget> createState() => _TableHealthWidgetState();
}

class _TableHealthWidgetState extends State<TableHealthWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    context.read<AsetHealthCariBloc>().add(
      RefreshAsetHealthCariEvent(
        searchText: _searchController.text,
        statusId: widget.initialStatusId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShareHealthStateCubit(),
      child: MultiBlocListener(
        listeners: [
          /// Debug listener buat pantau data terpilih
          BlocListener<ShareHealthStateCubit,
              Map<String, AsetHealthCariModel>>(
            listener: (context, state) {
              final selected = state.values.toList();
              debugPrint("=============================================");
              debugPrint("✅ Selected Items: ${selected.length}");
              for (var i = 0; i < selected.length; i++) {
                final item = selected[i];
                debugPrint(
                    "[${i + 1}] ${item.asethealthId} - ${item.nama} (${item.jnskel})");
              }
              if (selected.isEmpty) {
                debugPrint("⚠️ Tidak ada item yang dipilih.");
              }
              debugPrint("=============================================");
            },
          ),
        ],
        child: BlocBuilder<ShareHealthStateCubit, Map<String, AsetHealthCariModel>>(
          builder: (context, map) {
            final cubit = context.read<ShareHealthStateCubit>();

            return Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                                          fileName: "Data_Health.xlsx",
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
                                                          fileName: "Data_Health.pdf",
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
                    child: AsetListHealth(
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
