import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';

import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_ringkasan_state_cubit.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/expert_helper.dart';
import '../../../../../../helper/mobile_expert_helper.dart';
import '../../../../../../models/gen_aset_ringkasan/asetringkasancari_model.dart';
import '../../../../../../widgets/apptheme/build_status_box.dart';
import '../../../../../../widgets/apptheme/polis_button.dart';
import '../../../../../../widgets/apptheme/popup_widget.dart';
import '../list_form/aset_list_ringkasan.dart';

class TableRingkasanWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight;

  const TableRingkasanWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight,
  });

  @override
  State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
}

class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatusId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }
  String _getStatusLabel(StatusType type) {
    switch (type) {
      case StatusType.aktif:
        return 'Aktif';
      case StatusType.onProgress:
        return 'Diproses';
      case StatusType.nonAktif:
        return 'Non Aktif';
      case StatusType.berakhir:
        return 'Jatuh Tempo';
      default:
        return '';
    }
  }
  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 🔹 hanya dipanggil sekali saat init
  void _refreshData() {
    // 🔸 refresh tabel
    context.read<AsetRingkasanCariBloc>().add(
      RefreshAsetRingkasanCariEvent(
        statusId: widget.initialStatusId,
        searchText: _searchController.text,
      ),
    );

    // 🔸 refresh dashboard (summary)
    context.read<AsetDashboardCariBloc>().add(
      RefreshAsetDashboardCariEvent(cobAppId: "10001"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShareRingkasanStateCubit(),
      child: MultiBlocListener(
        listeners: [
          /// Listener untuk debug ShareRingkasanStateCubit
          BlocListener<ShareRingkasanStateCubit, Map<String, AsetRingkasanCariModel>>(
            listener: (context, state) {
              final selected = state.values.toList();

              debugPrint("=============================================");
              debugPrint("✅ Selected Items: ${selected.length}");
              debugPrint("=============================================");

              for (var i = 0; i < selected.length; i++) {
                final item = selected[i];
                debugPrint("[$i]");
                debugPrint("  • ID       : ${item.asetRingkasanId}");
                debugPrint("  • Nama     : ${item.asetNama}");
                debugPrint("  • Currency : ${item.curr}");
                debugPrint("  • Jumlah   : ${item.jmlAset} ${item.satuan}");
                debugPrint("  • Nilai    : ${item.nilaiAset}");
                debugPrint("  • Premi    : ${item.nilaiPremi}");
                debugPrint("  • No Urut  : ${item.noUrut}");
                debugPrint("  • Satuan  : ${item.satuan}");
                debugPrint("---------------------------------------------");
              }

              if (selected.isEmpty) {
                debugPrint("⚠️ Tidak ada item yang dipilih.");
              }
            },
          ),

        ],
        child: BlocBuilder<ShareRingkasanStateCubit, Map<String, AsetRingkasanCariModel>>(
          builder: (context, map) {
            final cubit = context.read<ShareRingkasanStateCubit>();

            return Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: hPadding),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: PolisButton(
                            assetPath: "assets/icons/tambah_polis.svg",
                            text: "Tambah Polis",
                            bgColor: Color(0xFFFF9D00),
                            borderColor: Color(0xFFFFC972),
                          ),),

                          const SizedBox(
                              width: hPadding
                          ),

                          Flexible(child: PolisButton(
                            assetPath: "assets/icons/endorse.svg",
                            text: "Endorse",
                            bgColor: Color(0xFF00BBFF),
                            borderColor: Color(0xFF7ADBFF),
                          ),),

                          const SizedBox(
                              width: hPadding
                          ),

                          Flexible(child: PolisButton(
                            assetPath: "assets/icons/hapus.svg",
                            text: "Hapus",
                            bgColor: Color(0xFFF12929),
                            borderColor: Color(0xFFFE5E5E),
                          ),),

                          const SizedBox(
                              width: hPadding
                          ),

                          Flexible(child: PolisButton(
                            assetPath: "assets/icons/unduh.svg",
                            text: "Unduh",
                            bgColor: Color(0xFFA1A1AA),
                            borderColor: Color(0xFFBCBCC7),
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
                                                        fileName: "Data_Ringkasan.xlsx",
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
                                                        fileName: "Data_Ringkasan.pdf",
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
                          ),),

                          const SizedBox(
                              width: hPadding
                          ),
                          Flexible(child: PolisButton(
                            assetPath: "assets/icons/bagikan.svg",
                            text: "Bagikan",
                            bgColor: Color(0xFF295EFF),
                            borderColor: Color(0xFF5D86FF),
                          ),)
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: vPadding),

                  ListPageFilterBarUIWidget(
                    searchController: _searchController,
                    searchButton: _buildSearchButton(),
                    hintText: "Cari Polis.... ",
                  ),

                  const SizedBox(height: hPadding),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return BlocBuilder<AsetDashboardCariBloc, AsetDashboardCariState>(
                        builder: (context, state) {
                          if (state.status == ListStatus.success && state.items.isNotEmpty) {
                            final summary = state.items.first;

                            final statusData = [
                              {
                                'type': StatusType.aktif,
                                'label': 'Aktif',
                                'count': summary.aktifQty.toString(),
                              },
                              {
                                'type': StatusType.onProgress,
                                'label': 'Diproses',
                                'count': summary.onProgressQty.toString(),
                              },
                              {
                                'type': StatusType.nonAktif,
                                'label': 'Non Aktif',
                                'count': summary.nonAktifQty.toString(),
                              },
                              {
                                'type': StatusType.berakhir,
                                'label': 'Jatuh Tempo',
                                'count': summary.berakhirQty.toString(),
                              },
                            ];

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: statusData.asMap().entries.map((entry) {
                                  final data = entry.value;
                                  final type = data['type'] as StatusType;
                                  final isSelected = _selectedStatusId == type.id;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: entry.key < statusData.length - 1 ? 10 : 0,
                                    ),
                                    child: StatusChip(
                                      assetPath: type.asset,
                                      label: data['label'] as String,
                                      count: data['count'] as String,
                                      iconColor: type.color,
                                      isSelected: isSelected,
                                      onTap: () {
                                        setState(() {
                                          _selectedStatusId = isSelected ? null : type.id;
                                        });

                                        _debounce?.cancel();
                                        _debounce = Timer(const Duration(milliseconds: 350), () {
                                          context.read<AsetRingkasanCariBloc>().add(
                                            RefreshAsetRingkasanCariEvent(
                                              statusId: _selectedStatusId ?? widget.initialStatusId,
                                              searchText: _searchController.text,
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }

                          // Placeholder state
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: StatusType.values.asMap().entries.map((entry) {
                                final type = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: entry.key < StatusType.values.length - 1 ? 10 : 0,
                                  ),
                                  child: StatusChip(
                                    assetPath: type.asset,
                                    label: _getStatusLabel(type),
                                    count: '-',
                                    iconColor: type.color,
                                    isSelected: false,
                                    onTap: () {},
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: hPadding),

                  Expanded(
                    child: AsetListRingkasan(
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
