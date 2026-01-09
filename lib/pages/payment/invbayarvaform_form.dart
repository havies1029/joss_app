import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:joss_app/widgets/payment/bank_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/invbayarvaform_bloc.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';


class InvbayarvaFormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const InvbayarvaFormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	InvbayarvaFormFormPageFormState createState() => InvbayarvaFormFormPageFormState();
}

class InvbayarvaFormFormPageFormState extends State<InvbayarvaFormFormPage> {
	late InvbayarvaFormBloc invbayarvaFormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldBatasBayarController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldVaNoController = TextEditingController();  
	var fieldTotalBayarController = TextEditingController();
  var fieldCurrController = TextEditingController();

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
		return BlocConsumer<InvbayarvaFormBloc, InvbayarvaFormState>(
			builder: (context, state) {
				return Scaffold(
          appBar: AppBar(
            title: Text(
              "Menunggu Bayar VA",
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      buildFieldVaNo(),
                      buildFieldBatasBayar(),
                      buildBankLogo(state.record?.iconId??'', state.record?.iconUrl??'', size: 120),
                      buildFieldCurr(),
                      buildFieldTotalBayar(),
                      buildInstruksiPembayaran(state),                      
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _dismissDialog();
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(fontSize: 13.0),
                            ),
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
                              context.read<DnRekap2invBloc>().add(CheckInvoiceStatusEvent(
                                invoiceId: widget.recordId,
                              ));
                            },
                            child: const Text(
                              'Cek Payment Manual',
                              style: TextStyle(fontSize: 13.0),
                            ),
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
                              context.read<DnRekap2invBloc>().add(ForcePaymentViaVaEvent(
                                invoiceId: widget.recordId,
                              ));
                            },
                            child: const Text(
                              'Backend -> Payment Via VA',
                              style: TextStyle(fontSize: 13.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              ),
            ),
          );
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldBatasBayarController.text = state.record!.batasBayar.toIso8601String();
							fieldVaNoController.text = state.record!.vaNo;              
							fieldTotalBayarController.text = NumberFormat("#,###").format(state.record!.totalBayar);
              fieldCurrController.text = state.record!.curr;
						}
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

	Widget buildFieldBatasBayar(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss'),
			initialValue: DateTime.tryParse(fieldBatasBayarController.text),
      canClear: false,      
      enabled: false,
			decoration: const InputDecoration(
				labelText: "Batas Bayar",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}


	Widget buildFieldVaNo(){
		return TextFormField(
			controller: fieldVaNoController,
			decoration: const InputDecoration(
				labelText: "No. VA",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

  Widget buildFieldTotalBayar(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldTotalBayarController,
			decoration: const InputDecoration(
				labelText: "Total Bayar",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
			textAlign: TextAlign.right,
		);
	}

  Widget buildFieldCurr(){
		return TextFormField(
			controller: fieldCurrController,
			decoration: const InputDecoration(
				labelText: "Curr",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

  Widget buildInstruksiPembayaran(InvbayarvaFormState state) {
    final instruksi = state.record?.instruksi ?? [];

    if (instruksi.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Instruksi Pembayaran",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...instruksi.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.urutan}. ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        item.tahapDesc,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}