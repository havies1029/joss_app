import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/klaimbatal/klaimbatalcrud_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/expert_helper.dart';
import 'package:joss_app/helper/mobile_expert_helper.dart';
import 'package:joss_app/helper/share_position_origin_helper.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:joss_app/widgets/apptheme/polis_button.dart';
import 'package:joss_app/widgets/apptheme/popup_widget.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/apptheme/empty_state_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MstatusrinciCariBloc, MstatusrinciCariState>(
          listener: (context, state) {
            context.read<GroupcobCariBloc>().add(
                  RefreshGroupcobCariEvent(
                    statusId: state.selectedStatusId,
                    searchText: state.searchText,
                  ),
                );
          },
          listenWhen: (previous, current) {
            return ((previous.selectedStatusId != current.selectedStatusId) ||
                (previous.searchText != current.searchText));
          },
        ),
        BlocListener<KlaimbatalcrudBloc, KlaimbatalcrudState>(
          listener: (context, state) {
            if (state.isSaved) {
              _refreshData();
            }
          },
        ),
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
                  hintText: "No Klaim/No Polis",
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

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GroupcobCariBloc, GroupcobCariState>(
        buildWhen: (previous, current) =>
            current.status != previous.status ||
            current.items != previous.items,
        builder: (context, state) {
          if (state.status == ListStatus.initial ||
              state.status == ListStatus.loadingMore) {
            return const Center(child: LoadingIndicator());
          }

          if (state.status == ListStatus.failure) {
            return const Center(
              child: Text(
                'Gagal memuat data',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.status == ListStatus.success && state.items.isEmpty) {
            return const Center(
              child: EmptyStatePage(
                iconPath: 'assets/icons/belipolis_no_file.svg',
                title: 'Tidak ada Rincian Klaim',
                description:
                    'Detail klaim akan muncul di sini ketika tersedia.',
              ),
            );
          }

          return const SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: KlaimRincianTableWidget(),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getExportRows() {
    final state = groupcobCariBloc.state;

    if (state.status != ListStatus.success) return [];

    final selectedId = state.selectedId.trim();
    var rowNo = 0;

    return state.items.expand((cob) {
      final isLainnya = cob.cobNama.toLowerCase() == "lainnya";

      final details = selectedId.isNotEmpty
          ? cob.details.where((d) => d.klaim1Id == selectedId)
          : cob.details;

      return details.map(
        (d) => _detailToExportMap(
          d,
          no: ++rowNo,
          isLainnya: isLainnya,
        ),
      );
    }).toList();
  }

  void _showExportDialog(BuildContext context) {
    final data = _getExportRows();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: IntrinsicHeight(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                Navigator.pop(context);
                await _exportData(context, format, data);
              },
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _detailToExportMap(
    KlaimdetailCariModel d, {
    required int no,
    required bool isLainnya,
  }) {
    return {
      "No": no,
      "No Klaim": d.klaim1Id,
      "No Polis": d.noPolis,
      if (isLainnya) "COB Desc": d.cobDesc,
      "Tanggal Kejadian": _formatTanggalKejadian(d.tglKejadian),
      "Mata Uang": d.curr,
      "Nilai Klaim": _formatCurrencyValue(d.klaimAmount),
    };
  }

  String _formatCurrencyValue(num? value) {
    return NumberFormat("#,##0.00", "id_ID").format(value ?? 0);
  }

  String _formatTanggalKejadian(DateTime? value) {
    if (value == null) return "-";
    return DateFormat('yyyy-MM-dd').format(value);
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
          reportTitle: "Klaim",
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

  Future<void> _onShare(BuildContext context) async {
    final data = _getExportRows();

    if (data.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk dibagikan"));
      return;
    }

    try {
      if (kIsWeb) {
        await ExportHelper.export(
          "pdf",
          data,
          CategoryType.klaimrincian,
        );
        return;
      }

      final fileName =
          "KlaimRincian_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final file = await MobileDownloadHelper.generatePdfFile(
        fileName: fileName,
        data: data,
        reportTitle: "Klaim",
      );

      if (!context.mounted) return;

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: "Rincian Klaim",
        text: data.length == 1
            ? "Berikut terlampir rincian klaim."
            : "Berikut terlampir ${data.length} rincian klaim terpilih.",
        sharePositionOrigin: sharePositionOrigin(context),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar("Gagal membagikan file: $e"));
      }
    }
  }
}
