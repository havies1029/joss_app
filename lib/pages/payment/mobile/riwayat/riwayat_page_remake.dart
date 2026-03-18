import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_method/payment_method_page.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_process/payment_process.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/riwayat/invoice_preview_page.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/riwayat/riwayat_table_page_remake.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../common/constants.dart';

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

    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData(); // default load sesuai _filter (semua)
    });
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
        BlocListener<HistorybayarCariBloc, HistorybayarCariState>(
          listenWhen: (prev, curr) =>
              prev.downloadPath != curr.downloadPath &&
              curr.downloadPath.isNotEmpty &&
              !curr.isDownloading,
          listener: (context, state) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InvoicePreviewFromBase64Page(
                  base64Pdf: state.downloadPath,
                ),
              ),
            );
          },
        ),
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
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
              refreshData();
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar('Proses pembayaran gagal. Silakan coba lagi.'),
              );
            }
          },
        ),
        BlocListener<HistorybayarCariBloc, HistorybayarCariState>(
          listener: (context, state) {
            debugPrint(
              '[HistorybayarCariBloc Listener AKTIF] '
              'isDownloading=${state.isDownloading} '
              'downloadPath=${state.downloadPath}',
            );
          },
        ),
      ],
      child: Scaffold(
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
                searchButton: buildSearchButton(),
              ),
              const SizedBox(height: 10),

              // ✅ Filter bar di parent
              _buildFilterBarParent(),
              const SizedBox(height: 10),

              // ✅ list/table
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
    return Flexible(
      child: FractionallySizedBox(
        heightFactor: 0.85,
        alignment: Alignment.topCenter,
        child: RiwayatTablePageRemake(
          searchText: _searchController.text,
        ),
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

    Widget chip(String text, bool selected, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF2994A) : const Color(0xFF2B2B2B),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? const Color(0xFFF2994A)
                  : Colors.white.withOpacity(0.10),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.black : primaryLightColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip("Semua", _filter == RiwayatFilter.semua, () => apply(RiwayatFilter.semua)),
        const SizedBox(width: 10),
        chip("Menunggu Pembayaran", _filter == RiwayatFilter.menunggu, () => apply(RiwayatFilter.menunggu)),
        const SizedBox(width: 10),
        chip("Selesai", _filter == RiwayatFilter.selesai, () => apply(RiwayatFilter.selesai)),
      ],
    );
  }
}