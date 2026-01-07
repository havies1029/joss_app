import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_success/payment_success.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_grand_total_widget.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_tabel_page.dart';
import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';
import '../../paymentmethodcari_list.dart';
import '../bayar_button.dart';
import '../payment_page/payment_method/payment_method_page.dart';
import '../payment_page/payment_process/payment_process.dart';
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
      MaterialPageRoute(builder: (context) => PaymentMethodsCariListPage(curr: curr, totalBayar: totalBayar)),
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
        child: BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
          builder: (context, state) {
            if (state.isProcessing) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: vPadding,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: hPadding * 1.5,
                      ),
                      child: ListPageFilterBarUIWidget(
                        searchController: _searchController,
                        searchButton: buildSearchButton(),
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: state.rincianSOA.headers.isEmpty
                                ? const Center(child: Text("Data kosong"))
                                : RincianTablePage(
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

                          RincianGrandTotalTableWidget(
                            grandTotals: state.rincianSOA.grandtotal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                BayarButton(
                  isEnabled: state.selectedIds.isNotEmpty,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RincianKonfirmasiDetailPage(
                          selectedDnIds: List.from(state.selectedIds),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
    );
  }
}