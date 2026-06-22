import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
// import 'package:joss_app/pages/payment/mobile/riwayat/riwayat_table_page_remake.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/invbayarvaform_bloc.dart';
import '../../../../blocs/payment/invoicestatuscard_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../common/loading_indicator.dart';
import '../../../../widgets/apptheme/empty_state_page.dart';
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
              ScaffoldMessenger.of(context).showSnackBar(
                successSnackBar('Pembayaran berhasil dibatalkan.'),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccess(
                    display: "Pembayaran Berhasil Dibatalkan",
                    description: "Tagihan pembayaran Anda telah dibatalkan.",
                    displayButton: "Kembali",
                  ),
                ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar('Proses pembayaran kartu gagal. Silakan coba lagi.'),
              );
              return;
            }

            if (!state.isLoaded || state.record == null) return;

            final redirectUrl = state.record!.redirectUrl.trim();

            if (redirectUrl.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar('Redirect URL pembayaran tidak ditemukan.'),
              );
              return;
            }

            await launchUrl(
              Uri.parse(redirectUrl),
              mode: LaunchMode.externalApplication,
            );

            context.read<InvbayarvaFormBloc>().add(
              InvoiceStatusPollingStarted(
                invoiceId: state.record!.invoiceId,
                interval: const Duration(seconds: 4),
              ),
            );
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