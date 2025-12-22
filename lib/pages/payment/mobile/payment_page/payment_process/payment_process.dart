import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../blocs/payment/invbayarvaform_bloc.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';

class PaymentPocess extends StatefulWidget {
  final String recordId;

  const PaymentPocess({super.key, required this.recordId});

  @override
  State<PaymentPocess> createState() => _PaymentPocessState();
}

class _PaymentPocessState extends State<PaymentPocess> {
  late InvbayarvaFormBloc invbayarvaFormBloc;
  final List<String> errors = [];

  final fieldBatasBayarController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldVaNoController = TextEditingController();

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // load awal
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });

    // cek tiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      context.read<DnRekap2invBloc>().add(
        CheckInvoiceStatusEvent(invoiceId: widget.recordId),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void loadData() {
      invbayarvaFormBloc.add(
          InvbayarvaFormLihatEvent(invoiceId: widget.recordId));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PaymentMethodCariBloc>().state;
    final catName = state.selectedCategoryName ?? "-";
    return BaseBackgroundSidePage(
      title: "$catName",
      child: Container(
        color: secondaryBlackColor,
        child: buildForm(),
      ),
    );
  }

  Widget buildForm() {
    final displayVa = fieldVaNoController.text.trim().isEmpty
        ? "1234 5678 9012 3456"
        : fieldVaNoController.text;
    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listener: (context, payState) {
        if (payState.paymentStatus != "30" && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: BlocListener<InvbayarvaFormBloc, InvbayarvaFormState>(
        listener: (context, state) {
          if (state.isLoaded && state.record != null) {
            fieldBatasBayarController.text =
                state.record!.batasBayar.toIso8601String();
            fieldVaNoController.text = state.record!.vaNo;
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // BOX STATUS
              buildPaymentStatusBox(),

              const SizedBox(height: hPadding),

              Text(
                "Total Pembayaran",
                style: TextStyle(
                  color: hintGrey,
                  fontSize: getResponsiveFont(context, 16),
                ),
              ),

              const SizedBox(height: hPadding),

              Text(
                "Nomor Virtual Account:",
                style: TextStyle(
                  color: primaryLightColor,
                  fontSize: getResponsiveFont(context, 18),
                ),
              ),

              const SizedBox(height: hPadding),

              AppButton.iconRight(
                text: displayVa,
                icon: const Icon(Icons.copy, color: Colors.white),
                backgroundColor: Colors.orange,
                borderRadius: 20,
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1.8,
                ),
                width: 20 * 3,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: displayVa));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nomor VA disalin!")),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget buildFieldBatasBayar(){
    return DateTimeFormField(
      mode: DateTimeFieldPickerMode.date,
      dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss'),
      initialValue: DateTime.tryParse(fieldBatasBayarController.text),
      decoration: const InputDecoration(
        labelText: "Batas Bayar",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildVaBox() {
    final displayVa = fieldVaNoController.text.trim().isEmpty
        ? "1234 5678 9012 3456"
        : fieldVaNoController.text;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayVa,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: displayVa));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nomor VA disalin!")),
              );
            },
            child: const Icon(Icons.copy, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentStatusBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_bottom, color: primaryColor, size: 16),
          const SizedBox(width: hPadding),
          Text(
            "Menunggu Pembayaran",
            style: TextStyle(
              fontSize: 13,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


}
