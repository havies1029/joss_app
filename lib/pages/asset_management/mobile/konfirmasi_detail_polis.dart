// File: pages/payment/ringkasan/konfirmasi_detail_polis_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/payment/dnsppacari_bloc.dart';
import '../../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
import '../../../models/payment/dnrekapcobcari_model.dart';
import '../../payment/mobile/payment_page/payment_method/paymentFormPage.dart';
import '../../payment/ringkasan/detail/dnsppacari_list_widget.dart';

class KonfirmasiDetailPolisPage extends StatefulWidget {
  final bool showPaymentButton;

  const KonfirmasiDetailPolisPage({
    super.key,
    this.showPaymentButton = true,
  });

  @override
  State<KonfirmasiDetailPolisPage> createState() =>
      _KonfirmasiDetailPolisPageState();
}

class _KonfirmasiDetailPolisPageState
    extends State<KonfirmasiDetailPolisPage> {

  @override
  void initState() {
    super.initState();
    // Fetch polis based on selected COBs
    Future.delayed(const Duration(milliseconds: 300), () {
      final cubit = context.read<ShareDnrekapcobStateCubit>();
      final selectedCobs = cubit.state.values.toList()
          .cast<DnrekapcobCariModel>();

      if (selectedCobs.isNotEmpty) {
        final listCobId = selectedCobs.map((e) => e.cobId).join(';');
        final currId = selectedCobs.first.currId;

        context.read<DnsppaCariBloc>().add(
          RefreshDnsppaCariEvent(
            listcobId: listCobId,
            currId: currId,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Detail Polis"),
      ),
      body: Column(
        children: [
          Expanded(
            child: DnsppaCariListWidget(), // ← Existing widget, no checkbox
          ),

          if (widget.showPaymentButton) _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentMethodsCariListPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}