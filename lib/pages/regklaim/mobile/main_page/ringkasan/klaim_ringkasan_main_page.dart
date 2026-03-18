import 'package:flutter/foundation.dart';
import 'package:joss_app/blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'package:joss_app/blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/helper/expert_helper.dart';
import 'package:joss_app/helper/mobile_expert_helper.dart';
import 'package:joss_app/widgets/apptheme/polis_button.dart';
import 'package:joss_app/widgets/apptheme/popup_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/apptheme/empty_state_page.dart';
import 'klaim_ringkasan_status_widget.dart';
import 'klaim_ringkasan_table_widget.dart';

class KlaimRingkasanMainPage extends StatefulWidget {
  const KlaimRingkasanMainPage({super.key});

  @override
  State<KlaimRingkasanMainPage> createState() => _KlaimRingkasanMainPageState();
}

  class _KlaimRingkasanMainPageState extends State<KlaimRingkasanMainPage> {
    final TextEditingController _searchController = TextEditingController();

    @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        refreshData();
      });
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody(context)),
        ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            const KlaimRingkasanStatusWidget(),
          ],
        ),
      );
    }

    Widget _buildBody(BuildContext context) {
      final statusId = context.select<MstatusringkasCariBloc, String>(
            (b) => b.state.selectedStatusId,
      );

      return BlocBuilder<KlaimringkasCariBloc, KlaimringkasCariState>(
        buildWhen: (previous, current) =>
        previous.status != current.status ||
            previous.items != current.items,
        builder: (context, s) {
          if (s.status == ListStatus.initial ||
              s.status == ListStatus.loadingMore) {
            return const Center(child: LoadingIndicator());
          }

          if (s.status == ListStatus.failure) {
            return const Center(child: Text('Failed to fetch data'));
          }

          if (s.status == ListStatus.success && s.items.isEmpty) {
            return const Center(
              child: EmptyStatePage(
                iconPath: 'assets/icons/belipolis_no_file.svg',
                title: 'Tidak ada Klaim',
                description: 'Klaim yang Anda ajukan akan muncul di sini ketika tersedia.',
              ),
            );
          }

          return KlaimRingkasanTableWidget();
        },
      );
    }

  void refreshData() {
    final statusId =
        context.read<MstatusringkasCariBloc>().state.selectedStatusId;

    context.read<KlaimringkasCariBloc>().add(
      RefreshKlaimringkasCariEvent(
        selectedStatusId: statusId,
      ),
    );
  }

  List<Map<String, dynamic>> _exportRows() {
    final st = context.read<KlaimringkasCariBloc>().state;
    return st.items
        .map((d) => {
      "No": d.nourut,
      "Kategori": d.cobNama,
      "Total Nilai": d.klaimQty,
      "Jumlah Klaim": d.klaimAmount,
    })
        .toList();
  }

  CategoryType _exportCategory() => CategoryType.klaim;

  void _showExportDialog(BuildContext context) {
    final rows = _exportRows();
    if (rows.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk diekspor"));
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: IntrinsicHeight(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                Navigator.pop(context);
                await _exportData(context, format, rows);
              },
            ),
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

  Future<void> _exportData(
      BuildContext context,
      ExportFormat format,
      List<Map<String, dynamic>> rows,
      ) async {
    final ext = (format == ExportFormat.excel) ? "xlsx" : "pdf";
    final exportFormat = (format == ExportFormat.excel) ? "excel" : "pdf";
    final fileName =
        "Ringkasan Klaim_${DateTime.now().millisecondsSinceEpoch}.$ext";

    try {
      if (kIsWeb) {
        await ExportHelper.export(exportFormat, rows, _exportCategory());
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: fileName,
          data: rows,
          format: exportFormat,
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar("Berhasil ekspor ${rows.length} item"),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar("Gagal ekspor: $e"),
        );
      }
    }
  }

  Future<void> _onShare(BuildContext context) async {
    final rows = _exportRows();

    if (rows.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk dibagikan"));
      return;
    }

    try {
      if (kIsWeb) {
        await ExportHelper.export(
          "pdf",
          rows,
          CategoryType.ringkasan,
        );
        return;
      }

      final fileName =
          "Ringkasan_Klaim_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final file = await MobileDownloadHelper.generatePdfFile(
        fileName: fileName,
        data: rows,
      );

      if (!context.mounted) return;

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: 'Ringkasan Klaim',
        text: 'Berikut terlampir ringkasan klaim.',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar("Gagal membagikan file: $e"));
      }
    }
  }
}