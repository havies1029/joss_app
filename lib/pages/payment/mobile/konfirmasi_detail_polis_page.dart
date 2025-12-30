import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/payment/dnsppacari_bloc.dart';
import '../../../models/payment/dnrekapcobcari_model.dart';
import '../paymentmethodcari_list.dart';
import '../ringkasan/detail/dnsppacari_list_widget.dart';


class KonfirmasiDetailPolisPaymentPage extends StatefulWidget {
  final List<DnrekapcobCariModel> selectedCobs;
  final bool showPaymentButton;

  const KonfirmasiDetailPolisPaymentPage({
    super.key,
    required this.selectedCobs,
    this.showPaymentButton = true,
  });

  @override
  State<KonfirmasiDetailPolisPaymentPage> createState() =>
      _KonfirmasiDetailPolisPaymentPageState();
}

class _KonfirmasiDetailPolisPaymentPageState
    extends State<KonfirmasiDetailPolisPaymentPage> {

  @override
  void initState() {
    super.initState();
    _fetchPolisDetails();
  }

  void _fetchPolisDetails() {
    if (widget.selectedCobs.isEmpty) return;

    // Join all selected COB IDs
    final listCobId = widget.selectedCobs.map((e) => e.cobId).join(';');

    // Use first COB's currency (assume same currency)
    final currId = widget.selectedCobs.first.currId;

    // Fetch polis details
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
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
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Summary Card
          _buildSummaryCard(),

          const Divider(height: 1),

          // Polis List (read-only, no checkbox)
          Expanded(
            child: const DnsppaCariListWidget(),
          ),

          // Payment Button
          if (widget.showPaymentButton) _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalCobs = widget.selectedCobs.length;
    final totalPolis = widget.selectedCobs.fold<int>(
      0,
          (sum, cob) => sum + cob.polisCount,
    );
    final totalAmount = widget.selectedCobs.fold<double>(
      0,
          (sum, cob) => sum + cob.polisAmount,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ringkasan Pembayaran",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem("Total COB", "$totalCobs"),
              _buildSummaryItem("Total Polis", "$totalPolis"),
              _buildSummaryItem(
                "Total Tagihan",
                "IDR ${_formatCurrency(totalAmount)}",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return "${(amount / 1000000000).toStringAsFixed(2)}B";
    } else if (amount >= 1000000) {
      return "${(amount / 1000000).toStringAsFixed(2)}M";
    } else if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(2)}K";
    }
    return amount.toStringAsFixed(0);
  }
}