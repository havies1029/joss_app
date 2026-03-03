import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../helper/expert_helper.dart';
import '../../../../helper/mobile_expert_helper.dart';
import '../../../../widgets/apptheme/polis_button.dart';
import '../../../../widgets/apptheme/popup_widget.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';
import '../../../tagihan_pembayaran/tagihan_pembayaran_page.dart';
import '../bayar_button.dart';
import '../payment_page/payment_method/payment_method_page.dart';
import '../payment_page/payment_process/payment_process.dart';
import '../payment_page/payment_success/payment_success.dart';
import 'konfirmasi_detail_polis.dart';
import 'rincian_grand_total_widget.dart';
import 'rincian_tabel_page.dart';

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
      MaterialPageRoute(
        builder: (_) => PaymentMethodPage(
          curr: curr,
          totalBayar: totalBayar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listenWhen: (previous, current) {
        return previous.isProcessed != current.isProcessed ||
            previous.paymentStatus != current.paymentStatus;
      },
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
                  builder: (context) =>PaymentSuccess(display: "Pembayaran Berhasil!",description: "Polis Anda kini aktif.", displayButton: "Kembali",)),
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
        backgroundColor: secondaryBlackColor,
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
                          onSearch: (value) {
                            dn2invBloc.add(
                              GetRincianSOACustomerEvent(searchText: value),
                            );
                          },
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
                final allDetails =
                state.rincianSOA.headers.expand((h) => h.details).toList();

                final selectedDetails = allDetails
                    .where((d) => state.selectedIds.contains(d.dn1Id))
                    .toList();

                if (selectedDetails.isEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(errorSnackBar("Tidak ada data yang dipilih"));
                  return;
                }

                final data =
                selectedDetails.map((d) => _detailToExportMap(d)).toList();

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


  Future<void> _onShare(BuildContext context) async {
    final state = dn2invBloc.state;

    final allDetails =
    state.rincianSOA.headers.expand((h) => h.details).toList();

    if (allDetails.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Tidak ada data untuk dibagikan"));
      return;
    }

    if (state.selectedIds.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(infoSnackBar("Pilih data terlebih dahulu"));
      return;
    }

    // kalau select all → ambil semua
    final bool isSelectAll =
        state.selectedIds.length == allDetails.length;

    final selectedDetails = isSelectAll
        ? allDetails
        : allDetails
        .where((d) => state.selectedIds.contains(d.dn1Id))
        .toList();

    if (selectedDetails.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar("Tidak ada data yang dipilih"));
      return;
    }

    try {
      final exportData =
      selectedDetails.map((e) => e.toExportMap()).toList();

      if (kIsWeb) {
        await ExportHelper.export(
          "pdf",
          exportData,
          CategoryType.ringkasan,
        );
        return;
      }

      final fileName =
          "Rincian_Polis_${DateTime
          .now()
          .millisecondsSinceEpoch}.pdf";

      final file = await MobileDownloadHelper.generatePdfFile(
        fileName: fileName,
        data: exportData,
      );

      if (!context.mounted) return;

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: 'Rincian Polis Terpilih',
        text: isSelectAll
            ? 'Berikut terlampir seluruh rincian polis.'
            : 'Berikut terlampir rincian polis terpilih.',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar("Gagal membagikan file: $e"));
      }
    }
  }
}