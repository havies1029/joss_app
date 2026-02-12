import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_method/payment_method_page.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_process/payment_process.dart';
import 'package:joss_app/pages/payment/mobile/ringkasan/ringkasan_table_list.dart';
import 'package:joss_app/pages/payment/ringkasan/detail/dnsppacari_list.dart';
import 'package:joss_app/pages/payment/invbayarvaform_form.dart';
import 'package:joss_app/pages/payment/paymentmethodcari_list.dart';
import 'package:joss_app/pages/payment/paymentsuccess_form.dart';

import '../../../../common/constants.dart';
import '../../../../helper/expert_helper.dart';
import '../../../../helper/mobile_expert_helper.dart';
import '../../../../widgets/apptheme/polis_button.dart';
import '../../../../widgets/apptheme/popup_widget.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';
import '../bayar_button.dart';
import '../payment_page/payment_success/payment_success.dart';
import 'detail/ringkasan_detail_page.dart';

class RingkasanPage extends StatefulWidget {
  const RingkasanPage({super.key});

  @override
  RingkasanPageState createState() => RingkasanPageState();
}

class RingkasanPageState extends State<RingkasanPage> {
  late DnrekapcobCariBloc dnrekapcobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    dnrekapcobCariBloc = BlocProvider.of<DnrekapcobCariBloc>(context);

    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listener: (BuildContext context, DnRekap2invState state) {
        if (state.isProcessed) {
          if (state.paymentStatus == "20") {
            ScaffoldMessenger.of(context).showSnackBar(
              successSnackBar('Silakan lanjutkan ke metode pembayaran.'),
            );
            onViewPaymentMethods(state.curr, state.totalBayar);
          } else if (state.paymentStatus == "30") {
            ScaffoldMessenger.of(context).showSnackBar(
              infoSnackBar('Silakan lakukan pembayaran.'),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentProcess(
                  viewMode: "ubah",
                  recordId: state.invoiceId,
                ),
              ),
            );
          } else if (state.paymentStatus == "40") {
            ScaffoldMessenger.of(context).showSnackBar(
              successSnackBar('Proses pembayaran berhasil.'),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentSuccess(display: "Pembayaran Berhasil!",description: "Polis Anda kini aktif.", displayButton: "Kembali",)),
            );
          } else if (state.paymentStatus == "91") {
            refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar('Proses pembayaran gagal. Silakan coba lagi.'),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        body: Stack(
          children: [
            // ===== MAIN CONTENT =====
            Column(
              children: [
                // ===== HEADER (PAKAI PADDING) =====
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPadding * 1.5,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListPageFilterBarUIWidget(
                          searchController: _searchController,
                          searchButton: buildSearchButton(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PolisButton(
                        assetPath: "assets/icons/unduh.svg",
                        bgColor: const Color(0xFFA1A1AA),
                        borderColor: const Color(0xFFBCBCC7),
                        onTap: () => _showExportDialog(context),
                        iconSize: 16,
                        height: 36,
                        width: 36,
                      ),
                      const SizedBox(width: 8),
                      PolisButton(
                        assetPath: "assets/icons/bagikan.svg",
                        bgColor: const Color(0xFF295EFF),
                        borderColor: const Color(0xFF5D86FF),
                        onTap: () => _onShare(context),
                        iconSize: 16,
                        height: 36,
                        width: 36,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: hPadding),

                // ===== TABLE (TANPA PADDING) =====
                Expanded(
                  child: BlocBuilder<DnrekapcobCariBloc, DnrekapcobCariState>(
                    builder: (context, state) {
                      if (state.status != ListStatus.success) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.items.isEmpty) {
                        return const Center(child: Text("Data kosong"));
                      }

                      return RingkasanTablePage(
                        items: state.items,
                        selectedIds: state.selectedIds,
                        onSelect: (id) {
                          context
                              .read<DnrekapcobCariBloc>()
                              .add(ToggleSelectItemEvent(id));
                        },
                        onUnselect: (id) {
                          context
                              .read<DnrekapcobCariBloc>()
                              .add(ToggleSelectItemEvent(id));
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: hPadding),

                // ===== INFO NOTE (PAKAI PADDING) =====
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  child: buildInfoNote(context),
                ),

                const SizedBox(height: 10),
              ],
            ),

            // ===== FLOATING BAYAR BUTTON =====
            BlocBuilder<DnrekapcobCariBloc, DnrekapcobCariState>(
              builder: (context, state) {
                final hasSelection = state.selectedIds.isNotEmpty;

                return BayarButton(
                  isEnabled: hasSelection,
                  onTap: hasSelection ? onViewListOutstandingPolis : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoNote(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 18, color: primaryLightColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "Apabila Anda melakukan pembayaran melalui bagian keuangan internal kami, "
                "dibutuhkan waktu hingga 2 hari agar status tagihan terupdate.",
            style: bodyTextStyle(context, fontSize: 15),
          ),
        ),
      ],
    );
  }

  void onViewListOutstandingPolis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RingkasanDetailPage(
              listcobId: dnrekapcobCariBloc.state.selectedIds.join(";"),
              currId: '001',
            ),
      ),
    );
  }

  ///Export dialog
  void _showExportDialog(BuildContext context) {
    final state = dnrekapcobCariBloc.state;

    if (state.selectedIds.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(infoSnackBar("Pilih data terlebih dahulu"));
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: dnrekapcobCariBloc,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: PopupWidget(
                title: "Pilih format file untuk diunduh",
                subtitle: "Tersedia Excel dan PDF",
                button1Text: "Excel",
                button2Text: "PDF",
                onExportSelected: (format) async {
                  final selectedItems =
                      state.items
                          .where((e) => state.selectedIds.contains(e.cobId))
                          .map((e) => e.toExportMap())
                          .toList();

                  if (selectedItems.isEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar("Tidak ada data yang dipilih"),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  await _exportData(context, format, selectedItems);
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder:
          (context, animation, secondaryAnimation, child) => FadeTransition(
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

  ///Export data
  Future<void> _exportData(
    BuildContext context,
    ExportFormat format,
    List<Map<String, dynamic>> data,
  ) async {
    final fileName =
        "DN_Rekap_COB_${DateTime.now().millisecondsSinceEpoch}.${format == ExportFormat.excel ? "xlsx" : "pdf"}";

    try {
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

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(successSnackBar("Berhasil ekspor ${data.length} item"));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar("Gagal ekspor: $e"));
      }
    }
  }

  ///Share data
  void _onShare(BuildContext context) {
    final state = dnrekapcobCariBloc.state;

    if (state.selectedIds.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(infoSnackBar("Pilih data terlebih dahulu"));
      return;
    }

    final selectedItems =
        state.items.where((e) => state.selectedIds.contains(e.cobId)).toList();

    final totalPolis = selectedItems.fold<int>(
      0,
      (sum, e) => sum + e.polisCount,
    );

    final totalTSI = selectedItems.fold<num>(0, (sum, e) => sum + e.tsi);

    final totalPremi = selectedItems.fold<num>(
      0,
      (sum, e) => sum + e.polisAmount,
    );

    final message = '''
📊 Ringkasan Tagihan & Pembayaran

Jumlah COB: ${selectedItems.length}
Total Polis: ${NumberFormat.decimalPattern().format(totalPolis)}
Total TSI: ${NumberFormat.decimalPattern().format(totalTSI)}
Total Premi: ${NumberFormat.decimalPattern().format(totalPremi)}

Detail COB:
${selectedItems.map((e) => '• ${e.cobNama}: ${e.polisCount} polis').join('\n')}
''';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.share, color: primaryColor, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      "Bagikan Ringkasan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text("Salin Ringkasan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        successSnackBar(
                          "Ringkasan berhasil disalin",
                          icon: Icons.copy,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Batal"),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void onViewPaymentMethods(String curr, double totalBayar) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodPage(curr: curr, totalBayar: totalBayar)),
    );
  }

  void refreshData() {
    dnrekapcobCariBloc.add(RefreshDnrekapcobCariEvent());
  }

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 28),
      onPressed: refreshData,
      tooltip: 'Refresh',
    );
  }
}
