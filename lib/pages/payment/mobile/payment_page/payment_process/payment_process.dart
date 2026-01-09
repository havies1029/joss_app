import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/payment/invbayarvaform_bloc.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_bloc.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_state.dart';
import 'package:intl/intl.dart';


import '../../../../../common/thousand_separator_input_formatter.dart';
import '../../../../../widgets/payment/bank_logo_widget.dart';
import '../../../../base/base_background_sidepage.dart';


class PaymentProcess extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const PaymentProcess({super.key, required this.viewMode, required this.recordId});

  @override
  PaymentProcessFormState createState() => PaymentProcessFormState();
}

class PaymentProcessFormState extends State<PaymentProcess> {
  late InvbayarvaFormBloc invbayarvaFormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final fieldBatasBayarController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldVaNoController = TextEditingController();
  final fieldTotalBayarController = TextEditingController();
  final fieldCurrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    invbayarvaFormBloc = context.read<InvbayarvaFormBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      invbayarvaFormBloc.add(
          InvbayarvaFormLihatEvent(invoiceId: widget.recordId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvbayarvaFormBloc, InvbayarvaFormState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title:  state.record?.bankNama.isNotEmpty == true
              ? state.record!.bankNama
              : "Pembayaran",
          child: Container(
            color: secondaryBlackColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildBankLogo(state.record?.iconId??'', state.record?.iconUrl??'', size: 120),
                      const SizedBox(height: hPadding),
                      buildWaitingStatus(),
                      const SizedBox(height: hPadding),
                      buildFieldTotalBayar(),
                      const SizedBox(height: hPadding),
                      buildFieldVaNo(),
                      const SizedBox(height: hPadding),
                      buildFieldBatasBayar(),
                      const SizedBox(height: hPadding),
                      buildInstruksiPembayaran(state),
                      // const SizedBox(height: hPadding),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   height: 60,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 30.0),
                      //     child: ElevatedButton(
                      //       onPressed: _dismissDialog,
                      //       child: const Text('Close', style: TextStyle(fontSize: 13)),
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   height: 100,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 30.0),
                      //     child: ElevatedButton(
                      //       onPressed: () {
                      //         context.read<DnRekap2invBloc>().add(
                      //           CheckInvoiceStatusEvent(invoiceId: widget.recordId),
                      //         );
                      //       },
                      //       child: const Text('Cek Payment Manual', style: TextStyle(fontSize: 13)),
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   height: 100,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 30.0),
                      //     child: ElevatedButton(
                      //       onPressed: () {
                      //         context.read<DnRekap2invBloc>().add(
                      //           ForcePaymentViaVaEvent(invoiceId: widget.recordId),
                      //         );
                      //       },
                      //       child: const Text('Backend -> Payment Via VA', style: TextStyle(fontSize: 13)),
                      //     ),
                      //   ),
                      // ),
                      FormError(
                        errors: errors,
                        key: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          fieldBatasBayarController.text = state.record!.batasBayar.toIso8601String();
          fieldVaNoController.text = state.record!.vaNo;
        }
      },
    );
  }

  Widget buildFieldBatasBayar() {
    final batasBayar =
    DateTime.tryParse(fieldBatasBayarController.text);

    final batasBayarText = batasBayar == null
        ? "-"
        : DateFormat('dd/MM/yyyy HH:mm:ss').format(batasBayar);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pembayaran Berakhir pada:",
              style: TextStyle(
                fontSize: getResponsiveFont(context, 16),
                fontWeight: FontWeight.w600,
                color: formGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              batasBayarText,
              style: TextStyle(
                fontSize: getResponsiveFont(context, 16),
                fontWeight: FontWeight.w700,
                color: primaryLightColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



  String formatVa4(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }

    return buffer.toString().trim();
  }

  Widget buildFieldVaNo() {
    final rawVa = fieldVaNoController.text.trim();
    final digitsOnly = rawVa.replaceAll(RegExp(r'\D'), '');
    final formattedVa = formatVa4(rawVa);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Nomor Virtual Account:",
            style: TextStyle(
              fontSize: getResponsiveFont(context, 18),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: hPadding),
          Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  digitsOnly.isEmpty ? "-" : formattedVa,
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 18),
                    fontWeight: FontWeight.w700,
                    color: primaryLightColor,
                  ),
                ),
                const SizedBox(width: hPadding),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () async {
                    if (digitsOnly.isEmpty) return;

                    await Clipboard.setData(ClipboardData(text: digitsOnly));
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nomor VA berhasil disalin")),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 22,
                      color: primaryLightColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  Widget buildFieldTotalBayar() {
    final curr = fieldCurrController.text.trim();
    final totalRaw = fieldTotalBayarController.text.trim();

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Total Pembayaran:",
            style: TextStyle(
              fontSize: getResponsiveFont(context, 18),
              fontWeight: FontWeight.w600,
              color: formGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                curr.isEmpty ? "-" : curr,
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 20),
                  fontWeight: FontWeight.w700,
                  color: primaryLightColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                totalRaw.isEmpty ? "-" : totalRaw,
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 20),
                  fontWeight: FontWeight.w700,
                  color: primaryLightColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInstruksiPembayaran(InvbayarvaFormState state) {
    final instruksi = state.record?.instruksi ?? [];

    if (instruksi.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: hPadding * 1.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: hPadding * 1.5,
          vertical: hPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Instruksi Pembayaran:",
              style: TextStyle(
                color: primaryLightColor,
                fontSize: getResponsiveFont(context, 16),
                fontWeight: FontWeight.bold,
              ),
            ),
            ...instruksi.map(
                  (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.urutan}. ",
                      style: TextStyle(
                        color: primaryLightColor,
                        fontSize: getResponsiveFont(context, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.tahapDesc,
                        style: TextStyle(
                          color: primaryLightColor,
                          fontSize: getResponsiveFont(context, 16),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: hPadding),
          ],
        ),
      ),
    );
  }

  Widget buildWaitingStatus() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),

          decoration: BoxDecoration(
            color: formGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: const Border(
              top: BorderSide(color: sGrey, width: 1),
              left: BorderSide(color: sGrey, width: 1),
              right: BorderSide(color: sGrey, width: 1),
              bottom: BorderSide(color: sGrey, width: 0.5),
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_bottom,
                color: primaryColor,
                size: 18,
              ),

              const SizedBox(width: hPadding),

              Text(
                "Menunggu Pembayaran",
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 16),
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
