import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/pages/payment/mobile/riwayat/riwayat_table_page_remake.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../common/constants.dart';
import '../../../tagihan_pembayaran/tagihan_pembayaran_page.dart';
import '../payment_page/payment_method/payment_method_page.dart';
import '../payment_page/payment_process/payment_process.dart';
import '../payment_page/payment_success/payment_success.dart';

class RiwayatPageRemake extends StatefulWidget {
  const RiwayatPageRemake({super.key});

  @override
  RiwayatPageRemakeState createState() => RiwayatPageRemakeState();
}

class RiwayatPageRemakeState extends State<RiwayatPageRemake> {
  late HistorybayarCariBloc historybayarCariBloc;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    historybayarCariBloc = context.read<HistorybayarCariBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener lama kamu (contoh)
        BlocListener<DnRekap2invBloc, DnRekap2invState>(
          listener: (context, state) {
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
            children: [
              ListPageFilterBarUIWidget(
                searchController: _searchController,
                searchButton: buildSearchButton(),
              ),
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
        RefreshHistorybayarCariEvent(searchText: _searchController.text, statusId: '10001'));
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          historybayarCariBloc.add(RefreshHistorybayarCariEvent(
              searchText: _searchController.text, statusId: '10001'));
        });
  }

  Widget buildList() {
    return Expanded(
      child: SingleChildScrollView(
        child: RiwayatTablePageRemake(searchText: _searchController.text),
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
          onBack: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const TagihanPembayaranPage(initialTab: 2),
              ),
                  (route) => route.isFirst,
            );
          },
        ),
      ),
    );
  }
}
