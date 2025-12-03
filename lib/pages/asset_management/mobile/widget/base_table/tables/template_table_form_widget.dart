import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../helper/expert_helper.dart';
import '../../../../../../helper/mobile_expert_helper.dart';
import '../../../../../../widgets/apptheme/build_status_box.dart';
import '../../../../../../widgets/apptheme/polis_button.dart';
import '../../../../../../widgets/apptheme/popup_widget.dart';
import '../../../../../../widgets/listpage_filter_bar_ui.dart';

abstract class TemplateAsetModel {
  String get id;
  Map<String, dynamic> toMap();
}

class TemplateTableFormWidget<
T, // ⚙ fleksibel — tidak lagi wajib extend TemplateAsetModel
B extends BlocBase,
D extends BlocBase,
C extends Cubit<Map<String, T>>
> extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight;
  final String cobType;

  final C Function() shareCubitBuilder;
  final Widget Function(String searchText, [String? statusLabel]) listBuilder;
  final void Function(String statusId, String searchText) onRefreshRequested;
  final void Function(String cobAppId) onDashboardRefresh;

  const TemplateTableFormWidget({
    super.key,
    required this.cobType,
    required this.shareCubitBuilder,
    required this.listBuilder,
    required this.onRefreshRequested,
    required this.onDashboardRefresh,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight,
  });

  @override
  State<TemplateTableFormWidget<T, B, D, C>> createState() =>
      _TemplateTableFormWidgetState<T, B, D, C>();
}

class _TemplateTableFormWidgetState<
T,
B extends BlocBase,
D extends BlocBase,
C extends Cubit<Map<String, T>>
> extends State<TemplateTableFormWidget<T, B, D, C>> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatusId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  void _refreshData() {
    widget.onRefreshRequested(widget.initialStatusId, _searchController.text);
    widget.onDashboardRefresh(widget.initialStatusId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  String get _currentStatusLabel {
    if (_selectedStatusId == null) return _getStatusLabel(StatusType.aktif);
    final selectedType = StatusType.values.firstWhere(
          (t) => t.id == _selectedStatusId,
      orElse: () => StatusType.aktif,
    );
    return _getStatusLabel(selectedType);
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
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener untuk memantau data terpilih (selected items)
        BlocListener<C, Map<String, T>>(
          listener: (context, state) {
            debugPrint("🔹 Total item terpilih: ${state.length}");

            if (state.isEmpty) {
              debugPrint("🚫 Tidak ada item yang dipilih");
              return;
            }

            debugPrint("📌 IDs terpilih: ${state.keys.toList()}");

            for (var entry in state.entries) {
              debugPrint("🧩 ID: ${entry.key}");

              try {
                final json = (entry.value as dynamic).toJson();
                debugPrint("   📦 Data: $json");
              } catch (_) {
                debugPrint("   📦 Data (fallback): ${entry.value.toString()}");
              }
            }
          },
        ),
      ],

      child: BlocBuilder<C, Map<String, T>>(
        builder: (context, map) {
          final cubit = context.read<C>();   // 🟢 Cubit global, tidak dibuat ulang

          return Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: hPadding),

                // 🔎 Search bar & action buttons
                Row(
                  children: [
                    Expanded(
                      child: ListPageFilterBarUIWidget(
                        searchController: _searchController,
                        searchButton: _buildSearchButton(),
                        hintText: "Cari Polis...",
                      ),
                    ),
                    const SizedBox(width: 8),
                    PolisButton(
                      assetPath: "assets/icons/unduh.svg",
                      bgColor: const Color(0xFFA1A1AA),
                      borderColor: const Color(0xFFBCBCC7),
                      onTap: () => _showExportDialog(context, cubit),
                      iconSize: 16,
                      height: 36,
                      width: 36,
                    ),
                    const SizedBox(width: 8),
                    PolisButton(
                      assetPath: "assets/icons/bagikan.svg",
                      bgColor: const Color(0xFF295EFF),
                      borderColor: const Color(0xFF5D86FF),
                      onTap: () => debugPrint('📤 Bagikan ditekan'),
                      iconSize: 16,
                      height: 36,
                      width: 36,
                    ),
                  ],
                ),

                const SizedBox(height: hPadding),
                _buildStatusChips(context),   // 🧮 Filter status (Aktif / Diproses / Berakhir)
                const SizedBox(height: hPadding),

                // 📋 Ini tempat tabel/list ditampilkan
                Expanded(
                  child: widget.listBuilder(
                    _searchController.text,
                    _currentStatusLabel,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExportDialog(BuildContext context, C cubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: cubit,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: PopupWidget(
                title: "Pilih format file untuk diunduh",
                subtitle: "Tersedia Excel dan PDF",
                button1Text: "Excel",
                button2Text: "PDF",
                onExportSelected: (format) async {
                  List<Map<String, dynamic>> exportData = [];

                  try {
                    final dynamic dynCubit = cubit;
                    if (dynCubit.getExportData != null) {
                      exportData = dynCubit.getExportData();
                    }
                  } catch (_) {
                    exportData = cubit.state.values.map((e) {
                      if (e is TemplateAsetModel) return e.toMap();
                      if (e is dynamic && e.toJson != null) {
                        return e.toJson() as Map<String, dynamic>;
                      }
                      return {'data': e.toString()};
                    }).toList();
                  }

                  if (exportData.isEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠ Tidak ada data yang dipilih"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  await _exportData(context, format, exportData);
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: child,
            ),
          ),
    );
  }

  Future<void> _exportData(
      BuildContext context,
      ExportFormat format,
      List<Map<String, dynamic>> data,
      ) async {
    final fileName =
        "Data_${widget.cobType}_${DateTime.now().millisecondsSinceEpoch}.${format == ExportFormat.excel ? "xlsx" : "pdf"}";

    if (format == ExportFormat.excel) {
      if (kIsWeb) {
        await ExportHelper.export("excel", data, CategoryType.ringkasan);
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: fileName,
          data: data,
          format: "excel",
        );
      }
    } else {
      if (kIsWeb) {
        await ExportHelper.export("pdf", data, CategoryType.ringkasan);
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: fileName,
          data: data,
          format: "pdf",
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Berhasil ekspor ${data.length} item"),
        backgroundColor: Colors.green,
      ),
    );
  }

  IconButton _buildSearchButton() => IconButton(
    icon: const Icon(Icons.autorenew_rounded, size: 28),
    onPressed: _refreshData,
    tooltip: 'Refresh',
  );

  Widget _buildStatusChips(BuildContext context) {
    return BlocBuilder<D, dynamic>(
      builder: (context, state) {
        if (state.status == ListStatus.success && state.items.isNotEmpty) {
          final summary = state.items.first;
          final statusData = [
            {'type': StatusType.aktif, 'label': 'Aktif', 'count': summary.aktifQty.toString()},
            {'type': StatusType.onProgress, 'label': 'Diproses', 'count': summary.onProgressQty.toString()},
            {'type': StatusType.nonAktif, 'label': 'Non Aktif', 'count': summary.nonAktifQty.toString()},
            {'type': StatusType.berakhir, 'label': 'Jatuh Tempo', 'count': summary.berakhirQty.toString()},
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
                    // count: data['count'] as String,
                    iconColor: type.color,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedStatusId = isSelected ? null : type.id);
                      _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 350), () {
                        widget.onRefreshRequested(
                          _selectedStatusId ?? widget.initialStatusId,
                          _searchController.text,
                        );
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}