import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import '../../../../../../blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import '../../../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../../../blocs/share_cubit/share_health_state_cubit.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/expert_helper.dart';
import '../../../../../../helper/mobile_expert_helper.dart';
import '../../../../../../models/gen_aset_health/asethealthcari_model.dart';
import '../../../../../../widgets/apptheme/build_status_box.dart';
import '../../../../../../widgets/apptheme/polis_button.dart';
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
  void _refreshData() {
    context.read<AsetHealthCariBloc>().add(
      RefreshAsetHealthCariEvent(
        searchText: _searchController.text,
        statusId: widget.initialStatusId,
      ),
    );

    context.read<AsetDashboardCariBloc>().add(
      RefreshAsetDashboardCariEvent(cobAppId:  widget.initialStatusId),
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
                  const SizedBox(height: hPadding),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PolisButton(
                              assetPath: "assets/icons/tambah_polis.svg",
                              text: "Tambah",
                              bgColor: const Color(0xFFFF9D00),
                              borderColor: const Color(0xFFFFC972),
                            ),
                            const SizedBox(width: hPadding),

                            PolisButton(
                              assetPath: "assets/icons/endorse.svg",
                              text: "Endorse",
                              bgColor: const Color(0xFF00BBFF),
                              borderColor: const Color(0xFF7ADBFF),
                            ),
                            const SizedBox(width: hPadding),

                            PolisButton(
                              assetPath: "assets/icons/hapus.svg",
                              text: "Hapus",
                              bgColor: const Color(0xFFF12929),
                              borderColor: const Color(0xFFFE5E5E),
                            ),
                            const SizedBox(width: hPadding),

                            PolisButton(
                              assetPath: "assets/icons/unduh.svg",
                              text: "Unduh",
                              bgColor: const Color(0xFFA1A1AA),
                              borderColor: const Color(0xFFBCBCC7),
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: "Tutup",
                                  barrierColor: Colors.black.withOpacity(0.6),
                                  transitionDuration: const Duration(milliseconds: 250),
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return BlocProvider.value(
                                      value: cubit,
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
                            ),
                            const SizedBox(width: hPadding),

                            PolisButton(
                              assetPath: "assets/icons/bagikan.svg",
                              text: "Bagikan",
                              bgColor: const Color(0xFF295EFF),
                              borderColor: const Color(0xFF5D86FF),
                            ),
                          ],
                        ),
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
                      final bool isCompact = constraints.maxWidth < 480;

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
                                      height: isCompact ? 30 : 32,
                                      iconSize: isCompact ? 14 : 16,
                                      onTap: () {
                                        setState(() {
                                          _selectedStatusId = isSelected ? null : type.id;
                                        });

                                        _debounce?.cancel();
                                        _debounce = Timer(const Duration(milliseconds: 350), () {
                                          context.read<AsetHealthCariBloc>().add(
                                            RefreshAsetHealthCariEvent(
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

                          // Placeholder
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
                                    height: isCompact ? 30 : 32,
                                    iconSize: isCompact ? 14 : 16,
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
