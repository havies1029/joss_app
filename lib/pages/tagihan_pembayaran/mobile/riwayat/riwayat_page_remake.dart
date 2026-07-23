import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
// import 'package:joss_app/pages/payment/mobile/riwayat/riwayat_table_page_remake.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/invbayarvaform_bloc.dart';
import '../../../../blocs/payment/invoicestatuscard_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../common/loading_indicator.dart';
import '../../../../widgets/apptheme/empty_state_page.dart';
import '../../../heropage/mobile/widget/transaksi_page.dart';
import '../payment_page/payment_method/payment_method_page.dart';
import '../payment_page/payment_process/payment_process.dart';
import '../payment_page/payment_success/payment_success.dart';
import 'riwayat_table_page_remake.dart';

enum RiwayatFilter { semua, menunggu, selesai }

class RiwayatPageRemake extends StatefulWidget {
  const RiwayatPageRemake({super.key});

  @override
  RiwayatPageRemakeState createState() => RiwayatPageRemakeState();
}

class RiwayatPageRemakeState extends State<RiwayatPageRemake> {
  static const String STATUS_SEMUA = "10001";
  static const String STATUS_MENUNGGU = "10002";
  static const String STATUS_SELESAI = "10003";

  RiwayatFilter _filter = RiwayatFilter.semua;

  late HistorybayarCariBloc historybayarCariBloc;
  final TextEditingController _searchController = TextEditingController();

  bool _isCardWebViewOpen = false;
  bool _hasHandledPaymentCancel = false;

  @override
  void initState() {
    super.initState();

    historybayarCariBloc = context.read<HistorybayarCariBloc>();

    refreshData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
          listenWhen: (previous, current) {
            return previous.isProcessed != current.isProcessed ||
                previous.paymentStatus != current.paymentStatus;
          },
          listener: (context, state) {
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
              if (_isCardWebViewOpen && Navigator.of(context).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context).pop();
              }

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
            } else if (state.paymentStatus == "91" && state.isProcessed) {
              if (state.statusCheckSource ==
                  InvoiceStatusCheckSource.riwayatContinuePayment) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  infoSnackBar(
                    'Tagihan sudah kedaluwarsa atau dibatalkan. Silakan cek riwayat pembayaran.',
                  ),
                );

                context.read<DnRekap2invBloc>().add(InitializeDnRekap2invEvent());
                refreshData();
                return;
              }

              if (_hasHandledPaymentCancel) return;
              _hasHandledPaymentCancel = true;

              context.read<DnRekap2invBloc>().add(InitializeDnRekap2invEvent());

              ScaffoldMessenger.of(context).showSnackBar(
                successSnackBar('Pembayaran berhasil dibatalkan.'),
              );


              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentSuccess(
                    display: "Pengajuan Tidak Dilanjutkan",
                    description:
                    "Karena proses pembayaran dibatalkan, pengajuan polis Anda juga telah dibatalkan. Untuk membeli polis, silakan lakukan pengajuan kembali.",
                    displayButton: "Kembali",
                    assetPath: "assets/icons/Logo_Gagal1.svg",
                    onButtonPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const TransaksiPage(),
                        ),
                            (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              );
            } else if (state.paymentStatus == "92") {
              if (_isCardWebViewOpen &&
                  Navigator.of(context, rootNavigator: true).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context, rootNavigator: true).pop();
              }

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                    'Nomor kartu kredit salah. Silakan masukkan ulang kartu yang benar.'),
              );
            } else if (state.paymentStatus == "93") {
              if (_isCardWebViewOpen && Navigator.of(context).canPop()) {
                _isCardWebViewOpen = false;
                Navigator.of(context).pop();
              }

              ScaffoldMessenger.of(context).showSnackBar(
                infoSnackBar('Proses pembayaran kartu kredit dibatalkan.'),
              );
            }
          },
        ),
        BlocListener<InvoiceStatusCardBloc, InvoiceStatusCardState>(
          listenWhen: (previous, current) {
            return previous.isLoaded != current.isLoaded ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) async {
            if (state.hasFailure) {
              String message = 'Proses pembayaran kartu gagal. Silakan coba lagi.';

              final errorMessage = state.message.trim();

              if (errorMessage.contains(
                '"card_number" must be a credit card',
              )) {
                message =
                'Maaf, nomor kartu yang dimasukkan tidak dikenali sebagai kartu kredit.';
              } else if (errorMessage.contains(
                'card_details.card_number must match pattern',
              )) {
                message =
                'Maaf, nomor kartu harus terdiri dari 14 sampai 19 digit angka.';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(message),
              );

              return;
            }

            if (!state.isLoaded || state.record == null) return;

            final redirectUrl = state.record!.redirectUrl.trim();

            if (redirectUrl.isEmpty) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     errorSnackBar('Redirect URL pembayaran tidak ditemukan.'),
            //   );
              return;
            }

            context.read<InvbayarvaFormBloc>().add(
              CreditCardPaymentCheckingStarted(
                invoiceId: state.record!.invoiceId,
                interval: const Duration(seconds: 5),
              ),
            );

            _isCardWebViewOpen = true;

            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PaymentCardWebViewDialog(
                  url: redirectUrl,
                  invoiceId: state.record!.invoiceId,
                );
              },
            );

            _isCardWebViewOpen = false;
          },

        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: hPadding * 1.5,
            vertical: 10,
          ),
          color: secondaryBlackColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListPageFilterBarUIWidget(
                searchController: _searchController,
                onSearch: (value) {
                  refreshData();
                },
               hintText: "No Pembayaran",
              ),
              const SizedBox(height: 10),

              _buildFilterBarParent(),
              const SizedBox(height: 10),

              buildList(),
            ],
          ),
        ),
      ),
    );
  }

  void refreshData() {
    historybayarCariBloc.add(
      RefreshHistorybayarCariEvent(
        searchText: _searchController.text,
        statusId: _statusIdFromFilter(_filter),
      ),
    );
  }

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: () {
        // ✅ jangan hardcode 10001 lagi
        refreshData();
      },
    );
  }

  Widget buildList() {
    return Expanded(
      child: BlocBuilder<HistorybayarCariBloc, HistorybayarCariState>(
        builder: (context, state) {
          if (state.status != ListStatus.success) {
            return const Center(child: LoadingIndicator());
          }

          if (state.items.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: const Center(
                      child: EmptyStatePage(
                        iconPath: 'assets/icons/belipolis_no_file.svg',
                        title: 'Tidak ada Riwayat Pembayaran',
                        description:
                        'Riwayat pembayaran yang telah dilakukan akan muncul di sini',
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return FractionallySizedBox(
            heightFactor: 0.95,
            alignment: Alignment.topCenter,
            child: RiwayatTablePageRemake(
              searchText: _searchController.text,
            ),
          );
        },
      ),
    );
  }

  //test1233 30/06/2026
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

  String _statusIdFromFilter(RiwayatFilter f) {
    switch (f) {
      case RiwayatFilter.semua:
        return STATUS_SEMUA;
      case RiwayatFilter.menunggu:
        return STATUS_MENUNGGU;
      case RiwayatFilter.selesai:
        return STATUS_SELESAI;
    }
  }
  Widget _buildFilterBarParent() {
    void apply(RiwayatFilter f) {
      if (_filter == f) return;
      setState(() => _filter = f);
      refreshData();
    }

    final textStyle = headingStyle(context, fontSize: 14);
    final Color chipSelected = primaryColor;
    final double radius = cardBorderRadius;

    Widget chip(String text, RiwayatFilter value) {
      final selected = _filter == value;

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          backgroundColor: pGrey,
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              text,
              style: textStyle.copyWith(
                color: selected ? Colors.white : primaryLightColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          selected: selected,
          selectedColor: chipSelected,
          showCheckmark: false,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          onSelected: (_) => apply(value),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip("Semua", RiwayatFilter.semua),
          chip("Menunggu Pembayaran", RiwayatFilter.menunggu),
          chip("Selesai", RiwayatFilter.selesai),
        ],
      ),
    );
  }
}

class PaymentCardWebViewDialog extends StatefulWidget {
  final String url;
  final String invoiceId;

  const PaymentCardWebViewDialog({
    super.key,
    required this.url,
    required this.invoiceId,
  });

  @override
  State<PaymentCardWebViewDialog> createState() =>
      _PaymentCardWebViewDialogState();
}

class _PaymentCardWebViewDialogState extends State<PaymentCardWebViewDialog> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog.fullscreen(
        backgroundColor: secondaryBlackColor,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: secondaryBlackColor,
                  border: Border(
                    bottom: BorderSide(
                      color: sGrey,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Verifikasi Kartu Kredit",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryLightColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // close button dihapus supaya user tidak bisa tutup manual
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_isLoading)
                      const Center(
                        child: LoadingIndicator(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
