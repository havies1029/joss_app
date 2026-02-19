import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/expert_helper.dart';
import 'package:joss_app/helper/mobile_expert_helper.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:joss_app/widgets/apptheme/polis_button.dart';
import 'package:joss_app/widgets/apptheme/popup_widget.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import 'klaim_rincian_status_widget.dart';
import 'klaim_rincian_table_widget.dart';

class KlaimRincianMainPage extends StatefulWidget {
  const KlaimRincianMainPage({super.key});

  @override
  State<KlaimRincianMainPage> createState() => _KlaimRincianMainPageState();
}

class _KlaimRincianMainPageState extends State<KlaimRincianMainPage> {
  late GroupcobCariBloc groupcobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupcobCariBloc = context.read<GroupcobCariBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _refreshData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    final statusId =
        context.read<MstatusrinciCariBloc>().state.selectedStatusId;
    groupcobCariBloc.add(
      RefreshGroupcobCariEvent(
        statusId: statusId,
        searchText: _searchController.text,
      ),
    );
  }

  // ==============================
  // BUILD
  // ==============================
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MstatusrinciCariBloc, MstatusrinciCariState>(
            listener: (context, state) {
              // Ketika selectedStatusId berubah, refresh data KlaimringkasCariBloc
              context.read<GroupcobCariBloc>().add(
                RefreshGroupcobCariEvent(
                  statusId: state.selectedStatusId, searchText: state.searchText,
                ),
              );
            }, listenWhen: (previous, current) {
          return ((previous.selectedStatusId != current.selectedStatusId) ||
              (previous.searchText != current.searchText));
        }),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ListPageFilterBarUIWidget(
                  searchController: _searchController,
                  searchButton: IconButton(
                    icon: const Icon(Icons.autorenew_rounded, size: 35.0),
                    onPressed: _refreshData,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PolisButton(
                assetPath: "assets/icons/unduh.svg",
                bgColor: bGrey,
                borderColor: bdGrey,
                onTap: () => _showExportDialog(context),
                iconSize: 16,
                height: 36,
                width: 36,
              ),
              const SizedBox(width: 8),
              PolisButton(
                assetPath: "assets/icons/bagikan.svg",
                bgColor: bBlue,
                borderColor: bdBlue,
                onTap: () => _onShare(context),
                iconSize: 16,
                height: 36,
                width: 36,
              ),
            ],
          ),
          const SizedBox(height: hPadding),
          // DESIGN: status chip dari kode gagal
          const KlaimRincianStatusWidget(),
        ],
      ),
    );
  }

  // ==============================
  // CONTENT
  // ==============================
  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GroupcobCariBloc, GroupcobCariState>(
        buildWhen: (previous, current) => current.status != previous.status,
        builder: (context, state) {
          if (state.status == ListStatus.initial ||
              state.status == ListStatus.loadingMore) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ListStatus.failure) {
            return const Center(
              child: Text(
                'Gagal memuat data',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return const KlaimRincianTableWidget();
        },
      ),
    );
  }

  // ==============================
  // EXPORT & SHARE (dari kode gagal, fungsi tetap sama)
  // ==============================
  List<KlaimdetailCariModel> _getSelectedDetails() {
    final state = groupcobCariBloc.state;
    if (state.status != ListStatus.success) return [];
    return state.items
        .expand((cob) => cob.details)
        .where((d) => state.selectedIds.contains(d.klaim1Id))
        .toList();
  }

  void _showExportDialog(BuildContext context) {
    final selected = _getSelectedDetails();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Pilih data klaim terlebih dahulu"));
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: PopupWidget(
            title: "Pilih format file untuk diunduh",
            subtitle: "Tersedia Excel dan PDF",
            button1Text: "Excel",
            button2Text: "PDF",
            onExportSelected: (format) async {
              Navigator.pop(context);
              final data = selected.map(_detailToExportMap).toList();
              await _exportData(context, format, data);
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: child,
            ),
          ),
    );
  }

  Map<String, dynamic> _detailToExportMap(KlaimdetailCariModel d) {
    return {
      "No": d.nourut,
      "No Klaim": d.klaim1Id,
      "No Polis": d.noPolis,
      "Tanggal Kejadian": DateFormat('yyyy-MM-dd').format(d.tglKejadian),
      "Curr": d.curr,
      "Nilai Klaim": d.klaimAmount,
      "Status": d.statusDesc,
    };
  }

  Future<void> _exportData(
      BuildContext context,
      ExportFormat format,
      List<Map<String, dynamic>> data,
      ) async {
    final ext = format == ExportFormat.excel ? "xlsx" : "pdf";
    final fileName =
        "KlaimRincian_${DateTime.now().millisecondsSinceEpoch}.$ext";

    try {
      if (kIsWeb) {
        await ExportHelper.export(
          format == ExportFormat.excel ? "excel" : "pdf",
          data,
          CategoryType.klaimrincian,
        );
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: fileName,
          data: data,
          format: format == ExportFormat.excel ? "excel" : "pdf",
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            successSnackBar("Berhasil ekspor ${data.length} data"));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar("Gagal ekspor: $e"));
      }
    }
  }

  void _onShare(BuildContext context) {
    final selected = _getSelectedDetails();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Pilih data klaim terlebih dahulu"));
      return;
    }

    String fmt(num v) => NumberFormat.decimalPattern().format(v);

    final message = selected.take(20).map((d) {
      return '''
• ${d.noPolis}
  Klaim: ${d.klaim1Id}
  Tgl: ${DateFormat('yyyy-MM-dd').format(d.tglKejadian)}
  Nilai: ${d.curr} ${fmt(d.klaimAmount)}
  Status: ${d.statusDesc}
''';
    }).join("\n");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.share, color: primaryColor),
                  const SizedBox(width: 10),
                  Text("Bagikan Klaim Terpilih", style: bodyTextStyle(context)),
                ],
              ),
              const SizedBox(height: 12),
              Text("Total klaim terpilih: ${selected.length}",
                  style: bodyTextStyle(context, fontSize: 14)),
              const SizedBox(height: 20),
              AppButton.iconLeft(
                text: "Salin Rincian",
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      successSnackBar("Rincian berhasil disalin"));
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}