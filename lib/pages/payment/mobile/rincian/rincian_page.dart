import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_list.dart';

import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../pages/payment/paymentmethodcari_list.dart';
import '../../../../pages/payment/invbayarvaform_form.dart';
import '../../../../pages/payment/paymentsuccess_form.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';

class RincianSoaPage extends StatefulWidget {
  const RincianSoaPage({super.key});

  @override
  State<RincianSoaPage> createState() => _RincianSoaPageState();
}

class _RincianSoaPageState extends State<RincianSoaPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final bloc = context.read<DnRekap2invBloc>();
    bloc.add(InitializeDnRekap2invEvent());
    bloc.add(const GetRincianSOACustomerEvent(searchText: ""));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DnRekap2invBloc>();

    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listener: _handlePaymentState,
      child: Scaffold(
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          backgroundColor: Colors.blue,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.payment),
              label: 'Lanjut Pembayaran',
              onTap: () {
                if (bloc.state.selectedIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih minimal 1 polis'),
                    ),
                  );
                  return;
                }

                bloc.add(
                  DnToInvByListDnProcessEvent(
                    listDn: bloc.state.selectedIds.join(";"),
                  ),
                );
              },
            ),
          ],
        ),

        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              ListPageFilterBarUIWidget(
                searchController: _searchController,
                searchButton: IconButton(
                  icon: const Icon(Icons.autorenew_rounded, size: 30),
                  onPressed: () {
                    bloc.add(
                      GetRincianSOACustomerEvent(
                        searchText: _searchController.text,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10,),
              // ✅ TABLE ENGINE YANG BENAR
              const Expanded(
                child: PaymentRincianList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePaymentState(BuildContext context, DnRekap2invState state) {
    if (!state.isProcessed) return;

    if (state.paymentStatus == "20") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentMethodsCariListPage()),
      );
    } else if (state.paymentStatus == "30") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InvbayarvaFormFormPage(
            viewMode: "ubah",
            recordId: state.invoiceId,
          ),
        ),
      );
    } else if (state.paymentStatus == "40") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentsuccessFormPage()),
      );
    } else if (state.paymentStatus == "91") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proses pembayaran gagal. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
