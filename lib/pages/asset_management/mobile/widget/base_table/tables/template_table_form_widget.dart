import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/expert_helper.dart';
import 'package:joss_app/helper/mobile_expert_helper.dart';
import 'package:joss_app/widgets/apptheme/popup_widget.dart';
import 'package:joss_app/widgets/apptheme/polis_button.dart';
import 'package:joss_app/widgets/apptheme/build_status_box.dart';

/// ===========================
/// 🔹 ENUM: COB Context Config
/// ===========================
enum COBType { ringkasan, par, mv, health }

extension COBTypeX on COBType {
  String get cobId {
    switch (this) {
      case COBType.ringkasan:
        return "10001";
      case COBType.par:
        return "10002";
      case COBType.mv:
        return "10003";
      case COBType.health:
        return "10004";
    }
  }

  String get displayName {
    switch (this) {
      case COBType.ringkasan:
        return "Ringkasan";
      case COBType.par:
        return "Property All Risk";
      case COBType.mv:
        return "Motor Vehicle";
      case COBType.health:
        return "Health Insurance";
    }
  }

  CategoryType get categoryType {
    switch (this) {
      case COBType.ringkasan:
        return CategoryType.ringkasan;
      case COBType.par:
        return CategoryType.properti;
      case COBType.mv:
        return CategoryType.kendaraan;
      case COBType.health:
        return CategoryType.kesehatan;
    }
  }
}

/// =====================================================
/// 🔹 UNIVERSAL BASE TABLE WIDGET
/// =====================================================
class BaseAsetTableWidget<
TModel,
TBloc extends Bloc<dynamic, dynamic>,
TDashboardBloc extends Bloc<dynamic, dynamic>,
TShareCubit extends Cubit<Map<String, TModel>>>
    extends StatefulWidget {
  final COBType cobType;
  final EdgeInsetsGeometry? padding;
  final Widget Function(String searchText) listBuilder;
  final String Function(TModel) getId;
  final TBloc Function(BuildContext) blocBuilder;
  final TDashboardBloc Function(BuildContext) dashboardBuilder;
  final TShareCubit Function() shareCubitBuilder;

  const BaseAsetTableWidget({
    super.key,
    required this.cobType,
    required this.listBuilder,
    required this.blocBuilder,
    required this.dashboardBuilder,
    required this.shareCubitBuilder,
    required this.getId,
    this.padding,
  });

  @override
  State<BaseAsetTableWidget> createState() =>
      _BaseAsetTableWidgetState<TModel, TBloc, TDashboardBloc, TShareCubit>();
}

class _BaseAsetTableWidgetState<
TModel,
TBloc extends Bloc<dynamic, dynamic>,
TDashboardBloc extends Bloc<dynamic, dynamic>,
TShareCubit extends Cubit<Map<String, TModel>>>
    extends State<BaseAsetTableWidget<TModel, TBloc, TDashboardBloc, TShareCubit>> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatusId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  void _refreshData() {
    try {
      final bloc = context.read<TBloc>();
      final dashboard = context.read<TDashboardBloc>();

      bloc.add({
        'type': 'refresh',
        'statusId': _selectedStatusId ?? widget.cobType.cobId,
        'searchText': _searchController.text,
      });

      dashboard.add({
        'type': 'dashboard_refresh',
        'cobAppId': widget.cobType.cobId,
      });
    } catch (e) {
      debugPrint("⚠️ Base dispatch skipped: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: widget.blocBuilder),
        BlocProvider(create: widget.dashboardBuilder),
        BlocProvider(create: (_) => widget.shareCubitBuilder()),
      ],
      child: BlocBuilder<TShareCubit, Map<String, TModel>>(
        builder: (context, map) {
          final cubit = context.read<TShareCubit>();

          return Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Toolbar
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 600;
                    return Wrap(
                      spacing: hPadding,
                      runSpacing: 8,
                      children: [
                        PolisButton(
                          assetPath: "assets/icons/tambah_polis.svg",
                          text: "Tambah ${widget.cobType.displayName}",
                          bgColor: const Color(0xFFFF9D00),
                          borderColor: const Color(0xFFFFC972),
                        ),
                        PolisButton(
                          assetPath: "assets/icons/endorse.svg",
                          text: "Endorse",
                          bgColor: const Color(0xFF00BBFF),
                          borderColor: const Color(0xFF7ADBFF),
                        ),
                        PolisButton(
                          assetPath: "assets/icons/hapus.svg",
                          text: "Hapus",
                          bgColor: const Color(0xFFF12929),
                          borderColor: const Color(0xFFFE5E5E),
                        ),
                        PolisButton(
                          assetPath: "assets/icons/unduh.svg",
                          text: "Unduh",
                          bgColor: const Color(0xFFA1A1AA),
                          borderColor: const Color(0xFFBCBCC7),
                          onTap: () => _showExportDialog(context, cubit),
                        ),
                        PolisButton(
                          assetPath: "assets/icons/bagikan.svg",
                          text: "Bagikan",
                          bgColor: const Color(0xFF295EFF),
                          borderColor: const Color(0xFF5D86FF),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: vPadding),

                /// 🔍 Search Bar
                ListPageFilterBarUIWidget(
                  searchController: _searchController,
                  searchButton: IconButton(
                    icon: const Icon(Icons.autorenew_rounded, size: 28),
                    onPressed: _refreshData,
                    tooltip: 'Refresh',
                  ),
                  hintText: "Cari ${widget.cobType.displayName}...",
                ),

                const SizedBox(height: hPadding),

                /// 📊 Status Chip
                BlocBuilder<TDashboardBloc, dynamic>(
                  builder: (context, state) {
                    final bool isCompact =
                        MediaQuery.of(context).size.width < 480;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: StatusType.values.asMap().entries.map((entry) {
                          final type = entry.value;
                          return Padding(
                            padding:
                            EdgeInsets.only(right: entry.key < 3 ? 8 : 0),
                            child: StatusChip(
                              assetPath: type.asset,
                              label: _getStatusLabel(type),
                              count: '-',
                              iconColor: type.color,
                              isSelected: _selectedStatusId == type.id,
                              height: isCompact ? 30 : 32,
                              iconSize: isCompact ? 14 : 16,
                              onTap: () {
                                setState(() => _selectedStatusId = type.id);
                                _debounce?.cancel();
                                _debounce = Timer(
                                  const Duration(milliseconds: 350),
                                  _refreshData,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: hPadding),

                /// 📋 List View
                Expanded(child: widget.listBuilder(_searchController.text)),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 📤 Popup Export
  void _showExportDialog(BuildContext context, TShareCubit cubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return BlocProvider.value(
          value: cubit,
          child: Center(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia dalam format Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                // ✅ ambil semua data dari cubit.state.values
                final rawData = cubit.state.values.toList();

                // ✅ pastikan setiap item diubah ke Map<String, dynamic>
                final exportData = rawData.map((item) {
                  if (item is Map<String, dynamic>) return item;
                  if (item is dynamic && item.toJson != null) {
                    return Map<String, dynamic>.from(item.toJson());
                  }
                  return {'id': widget.getId(item).toString()};
                }).toList();

                if (exportData.isEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("⚠️ Tidak ada data yang bisa diekspor"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                await _export(context, exportData,format);
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  /// ✅ ubah signature fungsi ini:
  Future<void> _export(
      BuildContext context,
      List<Map<String, dynamic>> exportData,
      ExportFormat format, // ⬅️ pakai enum langsung
      ) async {
    final name = widget.cobType.displayName.replaceAll(' ', '_');

    try {
      if (kIsWeb) {
        await ExportHelper.export(
          format.name, // ⬅️ ubah ke string di sini (karena helper butuh "excel"/"pdf")
          exportData,
          widget.cobType.categoryType,
        );
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: "Data_$name.${format == ExportFormat.excel ? 'xlsx' : 'pdf'}",
          data: exportData,
          format: format.name, // ✅ cukup kirim format.name
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ Berhasil ekspor ${exportData.length} data ke ${format.name.toUpperCase()}",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Gagal ekspor data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


}
