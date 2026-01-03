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
import 'package:date_field/date_field.dart';

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
  var fieldBatasBayarController = TextEditingController(text: DateTime.now().toIso8601String());
  var fieldVaNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    invbayarvaFormBloc = BlocProvider.of<InvbayarvaFormBloc>(context);
    final state = context.watch<PaymentMethodCariBloc>().state;
    final catName = state.selectedCategoryName ?? "-";

    return BlocConsumer<InvbayarvaFormBloc, InvbayarvaFormState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: "$catName",

          child: Container(
            color: secondaryBlackColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: hPadding),
                      buildWaitingStatus(),
                      const SizedBox(height: hPadding),
                      buildFieldVaNo(),
                      const SizedBox(height: hPadding),
                      buildFieldBatasBayar(),
                      const SizedBox(height: hPadding),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: _dismissDialog,
                            child: const Text('Close', style: TextStyle(fontSize: 13)),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<DnRekap2invBloc>().add(
                                CheckInvoiceStatusEvent(invoiceId: widget.recordId),
                              );
                            },
                            child: const Text('Cek Payment Manual', style: TextStyle(fontSize: 13)),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<DnRekap2invBloc>().add(
                                ForcePaymentViaVaEvent(invoiceId: widget.recordId),
                              );
                            },
                            child: const Text('Backend -> Payment Via VA', style: TextStyle(fontSize: 13)),
                          ),
                        ),
                      ),
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

  void loadData() {
    if (widget.viewMode == "ubah") {
      invbayarvaFormBloc.add(
          InvbayarvaFormLihatEvent(invoiceId: widget.recordId));
    }
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

              const SizedBox(width: 10),

              Text(
                "Menunggu Pembayaran",
                style: TextStyle(
                  fontSize: 16,
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

  Widget buildFieldBatasBayar() {
    final date = DateTime.tryParse(fieldBatasBayarController.text);

    final formatted = date != null
        ? DateFormat('dd MMMM yyyy HH:mm').format(date)
        : "-";

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius), // <— di sini
          border: Border.all(
            color: sGrey,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pembayaran Berakhir pada:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: formGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formatted,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildFieldVaNo() {
    final va = fieldVaNoController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Nomor Virtual Account:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: hPadding),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                va,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 10),

              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: va));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nomor VA disalin"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  void _dismissDialog() {
    Navigator.pop(context);
  }

}
