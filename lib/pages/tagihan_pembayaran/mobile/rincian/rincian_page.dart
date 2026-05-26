import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../blocs/layanan/mlayanan1cari_bloc.dart';
import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../helper/expert_helper.dart';
import '../../../../helper/mobile_expert_helper.dart';
import '../../../../widgets/apptheme/empty_state_page.dart';
import '../../../../widgets/apptheme/hubungi_cs.dart';
import '../../../../widgets/apptheme/polis_button.dart';
import '../../../../widgets/apptheme/popup_widget.dart';
import '../../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';
import '../../fab_pembayaran.dart';
import '../bayar_button.dart';
import '../payment_page/payment_method/payment_method_page.dart';
import '../payment_page/payment_process/payment_process.dart';
import '../payment_page/payment_success/payment_success.dart';
import 'konfirmasi_detail_polis.dart';
import 'rincian_grand_total_widget.dart';
import 'rincian_tabel_page.dart';
import 'package:url_launcher/url_launcher.dart';

class RincianPage extends StatefulWidget {
  const RincianPage({super.key});

  @override
  State<RincianPage> createState() => _RincianPageState();
}

class _RincianPageState extends State<RincianPage> {
  late DnRekap2invBloc dn2invBloc;
  late DnrekapcobCariBloc dnrekapcobCariBloc;

  final TextEditingController _searchController =
  TextEditingController();

  Mlayanan1CariBloc? mlayanan1cariBloc;

  bool _firstLoading = true;

  Set<String> getSelectedCurrSet(DnRekap2invState state) {
    return state.rincianSOA.headers
        .expand((header) => header.details)
        .where((detail) => state.selectedIds.contains(detail.dn1Id))
        .map((detail) => detail.currSimbol.trim().toUpperCase())
        .where((curr) => curr.isNotEmpty)
        .toSet();
  }

  @override
  void initState() {
    super.initState();

    dn2invBloc = context.read<DnRekap2invBloc>();
    dnrekapcobCariBloc = context.read<DnrekapcobCariBloc>();
    mlayanan1cariBloc = context.read<Mlayanan1CariBloc>();

    dn2invBloc.add(InitializeDnRekap2invEvent());
    refreshData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _firstLoading = false);
    });
  }

  Future<void> openLinkLayanan(String link) async {
    if (link.trim().isEmpty) return;

    final uri = Uri.parse(link.trim());

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint("Tidak bisa membuka link: $link");
    }
  }

  void refreshData() {
    mlayanan1cariBloc?.add(
      FetchMlayanan1CariEvent(
        mlayanan1Id: "03",
      ),
    );
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
        if (!state.isProcessed) return;

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
            MaterialPageRoute(
              builder: (context) => PaymentSuccess(
                display: "Pembayaran Berhasil!",
                description: "Polis Anda kini aktif.",
                displayButton: "Kembali",
              ),
            ),
          );

        } else if (state.paymentStatus == "91") {

          refreshData();

          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar('Proses pembayaran gagal. Silakan coba lagi.'),
          );
        }
      },
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
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
                              GetRincianSOACustomerEvent(
                                searchText: value,
                              ),
                            );
                          },
                          hintText: "No Polis",
                        ),
                      ),

                      const SizedBox(width: 8),

                      BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
                        buildWhen: (previous, current) {
                          return previous.rincianSOA.headers !=
                              current.rincianSOA.headers;
                        },
                        builder: (context, state) {

                          final bool isEmpty =
                              state.rincianSOA.headers.isEmpty;

                          return PolisButton(
                            assetPath: "assets/icons/unduh.svg",
                            bgColor: const Color(0xFFA1A1AA),
                            borderColor: const Color(0xFFBCBCC7),
                            onTap: isEmpty
                                ? null
                                : () => _showExportDialog(context),
                            iconSize: 16,
                            height: 36,
                            width: 36,
                          );
                        },
                      ),

                      const SizedBox(width: 8),

                      BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
                        buildWhen: (previous, current) {
                          return previous.rincianSOA.headers !=
                              current.rincianSOA.headers;
                        },
                        builder: (context, state) {

                          final bool isEmpty =
                              state.rincianSOA.headers.isEmpty;

                          return PolisButton(
                            assetPath: "assets/icons/bagikan.svg",
                            bgColor: const Color(0xFF295EFF),
                            borderColor: const Color(0xFF5D86FF),
                            onTap: isEmpty
                                ? null
                                : () => _onShare(context),
                            iconSize: 16,
                            height: 36,
                            width: 36,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: hPadding),
                Expanded(
                  child: BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
                    builder: (context, state) {
                      if (_firstLoading) {
                        return const Center(
                          child: LoadingIndicator(),
                        );
                      }

                      final bool isEmpty =
                          state.rincianSOA.headers.isEmpty;

                      if (state.isProcessing) {
                        return const Center(
                          child: LoadingIndicator(),
                        );
                      }

                      if (isEmpty) {
                        return const Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: 24),
                            child: EmptyStatePage(
                              iconPath: 'assets/icons/belipolis_no_file.svg',
                              title: 'Tidak ada Rincian Tagihan',
                              description:
                              'Detail tagihan pembayaran akan muncul di sini ketika tersedia.',
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: [
                            RincianTablePage(
                              headers: state.rincianSOA.headers,
                              selectedIds: state.selectedIds,
                              onSelect: (dn1Id) {
                                dn2invBloc.add(SelectDetailEvent(dn1Id));
                              },
                              onUnselect: (dn1Id) {
                                dn2invBloc.add(UnselectDetailEvent(dn1Id));
                              },
                            ),
                            RincianGrandTotalTableWidget(
                              grandTotals: state.rincianSOA.grandtotal,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
              builder: (context, state) {

                final bool isEmpty =
                    state.rincianSOA.headers.isEmpty;

                if (isEmpty) {
                  return const SizedBox.shrink();
                }

                return FabPembayaran(
                  isEnabled: state.selectedIds.isNotEmpty,

                  onBayarTap: () {
                    final selectedCurrSet = getSelectedCurrSet(state);

                    debugPrint("SELECTED CURR SET : $selectedCurrSet");

                    final isAllIdr =
                        selectedCurrSet.length == 1 && selectedCurrSet.contains('IDR');

                    if (!isAllIdr) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.6),
                        builder: (dialogContext) => RegisterClientPopUp(
                          showIcon: false,
                          showHeaderIcon: false,
                          header: 'Pembayaran Mata Uang Asing',
                          description:
                          'Untuk pembayaran selain IDR atau Rupiah belum bisa dilakukan. Segera hubungi bagian keuangan kami.',
                          buttonText: 'Hubungi',
                          onPressed: () async {
                            final layananState = context.read<Mlayanan1CariBloc>().state;

                            if (layananState.items.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Data layanan tidak ditemukan"),
                                ),
                              );
                              return;
                            }

                            final layanan1 = layananState.items.first;

                            if (layanan1.mLayanan2.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Detail layanan kosong"),
                                ),
                              );
                              return;
                            }

                            final layanan = layanan1.mLayanan2.first;
                            final link = layanan.linkLayanan;

                            if (link.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Link layanan tidak tersedia"),
                                ),
                              );
                              return;
                            }

                            await openLinkLayanan(link);
                          },
                        ),
                      );

                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RincianKonfirmasiDetailPage(
                          selectedDnIds: List.from(state.selectedIds),
                        ),
                      ),
                    );
                  },

                  onHubungiKeuTap: () async {

                    final layananState =
                        context.read<Mlayanan1CariBloc>().state;

                    if (layananState.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("Data layanan tidak ditemukan"),
                        ),
                      );
                      return;
                    }

                    final layanan1 =
                        layananState.items.first;

                    if (layanan1.mLayanan2.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("Detail layanan kosong"),
                        ),
                      );
                      return;
                    }

                    final layanan =
                        layanan1.mLayanan2.first;

                    final link =
                        layanan.linkLayanan;

                    if (link.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("Link layanan tidak tersedia"),
                        ),
                      );
                      return;
                    }

                    await openLinkLayanan(link);
                  },
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

  String formatDateNullable(DateTime? value) {
    if (value == null) return '-';
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String formatPeriode(DateTime? mulai, DateTime? akhir) {
    if (mulai == null && akhir == null) return '-';
    return "${formatDateNullable(mulai)} - ${formatDateNullable(akhir)}";
  }

  Map<String, dynamic> _detailToExportMap(dynamic d) {
    // ganti dynamic -> DnDetailSppaModel kalau importnya ada di file ini
    return {
      "No": d.rownumber,
      "No Polis": d.noPolis,
      "Periode": formatPeriode(d.polisMulai, d.polisAkhir),
      "Curr": d.currSimbol,
      "DN OS": d.dnOs,
      "Aging": d.aging,
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
            reportTitle: "Pembayaran",
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
            reportTitle: "Pembayaran",
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
        reportTitle: "Pembayaran",
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