import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/payment/invbayarvaform_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../../widgets/payment/bank_logo_widget.dart';
import '../../../../base/base_background_sidepage.dart';

class PaymentProcess extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const PaymentProcess(
      {super.key, required this.viewMode, required this.recordId});

  @override
  PaymentProcessFormState createState() => PaymentProcessFormState();
}

class PaymentProcessFormState extends State<PaymentProcess> {
  late InvbayarvaFormBloc invbayarvaFormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final fieldBatasBayarController =
      TextEditingController(text: DateTime.now().toIso8601String());
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
      invbayarvaFormBloc
          .add(InvbayarvaFormLihatEvent(invoiceId: widget.recordId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvbayarvaFormBloc, InvbayarvaFormState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: state.record?.bankNama.isNotEmpty == true
              ? state.record!.bankNama
              : "Pembayaran",
          child: Container(
            color: secondaryBlackColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: primaryLightColor,
                          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius))
                      ),
                      width: 120,
                      height: 60,
                      alignment: Alignment.center,
                      child: buildBankLogo(
                        state.record?.iconId ?? '',
                        state.record?.iconUrl ?? '',
                        size: 120,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildWaitingStatus(),
                    const SizedBox(height: 6),
                    buildFieldTotalBayar(),
                    const SizedBox(height: 8),
                    buildFieldVaNo(),
                    const SizedBox(height: 18),
                    buildFieldBatasBayar(),
                    const SizedBox(height: 18),
                    buildInstruksiPembayaran(state),
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
        );
      },
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          fieldBatasBayarController.text =
              state.record!.batasBayar.toIso8601String();
          fieldVaNoController.text = state.record!.vaNo;
          fieldCurrController.text = state.record!.curr;
          fieldTotalBayarController.text =
              NumberFormat("#,###").format(state.record!.totalBayar);
        }
      },
    );
  }

  Widget buildFieldBatasBayar() {
    final batasBayar = DateTime.tryParse(fieldBatasBayarController.text);

    final batasBayarText = batasBayar == null
        ? "-"
        : DateFormat('dd/MM/yyyy HH:mm:ss').format(batasBayar);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius), // <— di sini
          border: Border.all(
            color: sGrey,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pembayaran Berakhir pada:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: hintGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              batasBayarText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: primaryLightColor,
              ),
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
            textAlign: TextAlign.center,
            style: bodyTextStyle(context),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  digitsOnly.isEmpty ? "-" : formattedVa,
                  style: bodyTextStyle(context),
                ),
                const SizedBox(width: hPadding),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () async {
                    if (digitsOnly.isEmpty) return;

                    await Clipboard.setData(ClipboardData(text: digitsOnly));
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      successSnackBar(
                          "Nomor Virtual Account Berhasil Disalin!"),
                    );
                  },
                  child: Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 14,
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
              fontSize: 16,
              color: hintGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                curr.isEmpty ? "-" : curr,
                style: headingStyle(context, fontSize: 24),
              ),
              const SizedBox(width: 2),
              Text(
                totalRaw.isEmpty ? "-" : totalRaw,
                style: headingStyle(context),
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

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: pGrey,
          border: Border.all(color: sGrey),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instruksi Pembayaran:",
            style: bodyTextStyle(context),
          ),
          ...instruksi.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.urutan}. ",
                    style: bodyTextStyle(context),
                  ),
                  Expanded(
                    child: Text(
                      item.tahapDesc,
                      style: bodyTextStyle(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  Widget buildWaitingStatus() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(
            color: sGrey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.hourglass_bottom,
              color: primaryColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              "Menunggu Pembayaran",
              style: TextStyle(
                fontSize: 14,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
