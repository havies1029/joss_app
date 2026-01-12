import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_success/payment_success.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_grand_total_widget.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_tabel_page.dart';
import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../helper/expert_helper.dart';
import '../../../../helper/mobile_expert_helper.dart';
import '../../../../widgets/apptheme/polis_button.dart';
import '../../../../widgets/apptheme/popup_widget.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';
import '../bayar_button.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_method/payment_method_page.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_process/payment_process.dart';
import 'konfirmasi_detail_polis.dart';

class RincianPage extends StatefulWidget {
  const RincianPage({super.key});

  @override
  State<RincianPage> createState() => _RincianPageState();
}

class _RincianPageState extends State<RincianPage> {
  late DnRekap2invBloc dn2invBloc;
  late DnrekapcobCariBloc dnrekapcobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dn2invBloc = context.read<DnRekap2invBloc>();
    dnrekapcobCariBloc = context.read<DnrekapcobCariBloc>();

    Future.delayed(const Duration(milliseconds: 500), () {
      dn2invBloc.add(InitializeDnRekap2invEvent());
      refreshData();
    });
  }

  void refreshData() {
    dn2invBloc.add(GetRincianSOACustomerEvent(searchText: _searchController.text));
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          refreshData();
        });
  }

  void onViewPaymentMethods(String curr, double totalBayar) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodPage(curr: curr, totalBayar: totalBayar)),
    ); // Implement your ta
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listener: (BuildContext context, DnRekap2invState state) {
        if (state.isProcessed){
          if (state.paymentStatus == "20"){
            ScaffoldMessenger.of(context).showSnackBar(
              successSnackBar('Silakan lanjutkan ke metode pembayaran.'),
            );
            onViewPaymentMethods(state.curr, state.totalBayar);
          }
          else if (state.paymentStatus == "30"){
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(infoSnackBar('Silakan lakukan pembayaran.'));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentProcess(viewMode: "ubah", recordId: state.invoiceId)),
            );
          }
          else if (state.paymentStatus == "40"){
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(successSnackBar('Proses pembayaran berhasil.'));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentSuccess()),
            );
          }
          else if (state.paymentStatus == "91"){
            refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar('Proses pembayaran gagal. Silakan coba lagi.'),
            );
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
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

                // ===== CONTENT (TANPA PADDING) =====
                Expanded(
                  child: BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
                    builder: (context, state) {
                      if (state.isProcessing) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.rincianSOA.headers.isEmpty) {
                        return const Center(child: Text("Data kosong"));
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: RincianTablePage(
                              headers: state.rincianSOA.headers,
                              selectedIds: state.selectedIds,
                              onSelect: (dn1Id) {
                                dn2invBloc.add(SelectDetailEvent(dn1Id));
                              },
                              onUnselect: (dn1Id) {
                                dn2invBloc.add(UnselectDetailEvent(dn1Id));
                              },
                            ),
                          ),

                          const SizedBox(height: hPadding),

                          RincianGrandTotalTableWidget(
                            grandTotals: state.rincianSOA.grandtotal,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            // ===== FLOATING BAYAR BUTTON =====
            BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
              builder: (context, state) {
                return BayarButton(
                  isEnabled: state.selectedIds.isNotEmpty,
                  onTap: state.selectedIds.isNotEmpty
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RincianKonfirmasiDetailPage(
                          selectedDnIds: List.from(state.selectedIds),
                        ),
                      ),
                    );
                  }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final state = dn2invBloc.state;

    if (state.selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(infoSnackBar("Pilih data terlebih dahulu"));
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                // ambil semua detail dari semua header
                final allDetails = state.rincianSOA.headers.expand((h) => h.details).toList();

                // filter yang dipilih (dn1Id)
                final selectedDetails = allDetails
                    .where((d) => state.selectedIds.contains(d.dn1Id))
                    .toList();

                if (selectedDetails.isEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("Tidak ada data yang dipilih"));
                  return;
                }

                // mapping export (buat map sendiri)
                final data = selectedDetails.map((d) => _detailToExportMap(d)).toList();

                Navigator.pop(context);
                await _exportDataRincian(context, format, data);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  Map<String, dynamic> _detailToExportMap(dynamic d) {
    // ganti dynamic -> DnDetailSppaModel kalau importnya ada di file ini
    return {
      "DN ID": d.dn1Id,
      "No": d.rownumber,
      "No Polis": d.noPolis,
      "Mulai": d.polisMulai.toString().substring(0, 10),
      "Akhir": d.polisAkhir.toString().substring(0, 10),
      "Curr": d.currSimbol,
      "Premi": d.dnOs, // atau field premi detail kamu
    };
  }


  Future<void> _exportDataRincian(
      BuildContext context,
      ExportFormat format,
      List<Map<String, dynamic>> data,
      ) async {
    final fileName =
        "DN_Rincian_${DateTime.now().millisecondsSinceEpoch}.${format == ExportFormat.excel ? "xlsx" : "pdf"}";

    try {
      if (format == ExportFormat.excel) {
        if (kIsWeb) {
          await ExportHelper.export("excel", data, CategoryType.rincian); // bikin enum ini / sesuaikan
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
          await ExportHelper.export("pdf", data, CategoryType.rincian);
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
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar("Berhasil ekspor ${data.length} item"),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("Gagal ekspor: $e"));
      }
    }
  }


  ///Share data
  void _onShare(BuildContext context) {
    final state = dn2invBloc.state;

    if (state.selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(infoSnackBar("Pilih data terlebih dahulu"));
      return;
    }

    final allDetails = state.rincianSOA.headers.expand((h) => h.details).toList();
    final selectedDetails = allDetails.where((d) => state.selectedIds.contains(d.dn1Id)).toList();

    if (selectedDetails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("Tidak ada data yang dipilih"));
      return;
    }

    // total premi per currency (lebih aman kalau multi-currency)
    final Map<String, num> totalByCurr = {};
    for (final d in selectedDetails) {
      totalByCurr[d.currSimbol] = (totalByCurr[d.currSimbol] ?? 0) + (d.dnOs as num);
    }

    final totalPolis = selectedDetails.length;

    final totalsText = totalByCurr.entries
        .map((e) => "• ${e.key} ${NumberFormat.decimalPattern().format(e.value)}")
        .join("\n");

    final detailLines = selectedDetails.take(20).map((d) {
      final periode =
          "${d.polisMulai.toString().substring(0, 10)} → ${d.polisAkhir.toString().substring(0, 10)}";
      final premi = "${d.currSimbol} ${NumberFormat.decimalPattern().format(d.dnOs)}";
      return "• ${d.noPolis} | $periode | $premi";
    }).join("\n");

    final more = selectedDetails.length > 20 ? "\n…dan ${selectedDetails.length - 20} polis lainnya" : "";

    final message = '''
📄 Rincian Polis Terpilih

Jumlah Polis: $totalPolis

Total Premi:
$totalsText

Detail Polis:
$detailLines$more
''';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
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
                  "Bagikan Rincian",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              child: Text(message, style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text("Salin Rincian"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    successSnackBar("Rincian berhasil disalin", icon: Icons.copy),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text("Batal"),
              ),
            ),
          ],
        ),
      ),
    );
  }

}