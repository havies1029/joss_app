import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar4form_bloc.dart';
import 'package:joss_app/models/calpar/calpar4form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Calpar4FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Calpar4FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Calpar4FormFormPageFormState createState() => Calpar4FormFormPageFormState();
}

class Calpar4FormFormPageFormState extends State<Calpar4FormFormPage> {
	late Calpar4FormBloc calpar4FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldDiscNilaiController = TextEditingController();
	var fieldDiscPersenController = TextEditingController();
	var fieldPremiBiController = TextEditingController();
	var fieldPremiEqvetController = TextEditingController();
	var fieldPremiNetController = TextEditingController();
	var fieldPremiOtherController = TextEditingController();
	var fieldPremiParController = TextEditingController();
	var fieldPremiRsmdccController = TextEditingController();
	var fieldPremiTsfwdController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		calpar4FormBloc = BlocProvider.of<Calpar4FormBloc>(context);
		return BlocConsumer<Calpar4FormBloc, Calpar4FormState>(
			builder: (context, state) {
				return Dialog(
					shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
					child: SingleChildScrollView(
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Form(
								key: _formKey,
								child: Column(
									children: [
										const SizedBox(height: 10),
										Text(
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Info Premi",
											style: const TextStyle(
												fontSize: 20.0,
												color: Color(0xffff6101),
												fontWeight: FontWeight.w600,
												fontFamily: 'Hind',
												fontStyle: FontStyle.italic,
												decoration: TextDecoration.underline,
											),
										),
										const SizedBox(height: 25),
										buildFieldCalpar1Id(),
										buildFieldDiscNilai(),
										buildFieldDiscPersen(),
										buildFieldPremiBi(),
										buildFieldPremiEqvet(),
										buildFieldPremiNet(),
										buildFieldPremiOther(),
										buildFieldPremiPar(),
										buildFieldPremiRsmdcc(),
										buildFieldPremiTsfwd(),
										const SizedBox(height: 25),
										FormError(
											errors: errors,
											key: null,
										),
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceAround,
											children: [
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
													height: 60,
													child: Padding(
														padding: const EdgeInsets.only(top: 30.0),
														child: ElevatedButton(
															onPressed: () {
																onSaveForm();
															},
															child: const Text(
																'Save',
																style: TextStyle(fontSize: 13.0),
															),
														),
													),
												),
											],
										),
									],
								)),
						),
					));
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldDiscNilaiController.text = NumberFormat("#,###").format(state.record!.discNilai);
							fieldDiscPersenController.text = NumberFormat("#,###").format(state.record!.discPersen);
							fieldPremiBiController.text = NumberFormat("#,###").format(state.record!.premiBi);
							fieldPremiEqvetController.text = NumberFormat("#,###").format(state.record!.premiEqvet);
							fieldPremiNetController.text = NumberFormat("#,###").format(state.record!.premiNet);
							fieldPremiOtherController.text = NumberFormat("#,###").format(state.record!.premiOther);
							fieldPremiParController.text = NumberFormat("#,###").format(state.record!.premiPar);
							fieldPremiRsmdccController.text = NumberFormat("#,###").format(state.record!.premiRsmdcc);
							fieldPremiTsfwdController.text = NumberFormat("#,###").format(state.record!.premiTsfwd);
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		calpar4FormBloc.add(
			Calpar4FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCalpar1Id(){
		return TextFormField(
		);
	}

	Widget buildFieldDiscNilai(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldDiscNilaiController,
			decoration: const InputDecoration(
				labelText: "discNilai",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldDiscPersen(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldDiscPersenController,
			decoration: const InputDecoration(
				labelText: "discPersen",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiBi(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiBiController,
			decoration: const InputDecoration(
				labelText: "premiBi",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiEqvet(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiEqvetController,
			decoration: const InputDecoration(
				labelText: "premiEqvet",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiNet(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiNetController,
			decoration: const InputDecoration(
				labelText: "premiNet",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiOther(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiOtherController,
			decoration: const InputDecoration(
				labelText: "premiOther",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiPar(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiParController,
			decoration: const InputDecoration(
				labelText: "premiPar",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiRsmdcc(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiRsmdccController,
			decoration: const InputDecoration(
				labelText: "premiRsmdcc",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiTsfwd(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTsfwdController,
			decoration: const InputDecoration(
				labelText: "premiTsfwd",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			textAlign: TextAlign.right,
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Calpar4FormModel record = Calpar4FormModel(
				calpar4Id: '',
				discNilai: double.parse(fieldDiscNilaiController.text.replaceAll(',', '')),
				discPersen: double.parse(fieldDiscPersenController.text.replaceAll(',', '')),
				premiBi: double.parse(fieldPremiBiController.text.replaceAll(',', '')),
				premiEqvet: double.parse(fieldPremiEqvetController.text.replaceAll(',', '')),
				premiNet: double.parse(fieldPremiNetController.text.replaceAll(',', '')),
				premiOther: double.parse(fieldPremiOtherController.text.replaceAll(',', '')),
				premiPar: double.parse(fieldPremiParController.text.replaceAll(',', '')),
				premiRsmdcc: double.parse(fieldPremiRsmdccController.text.replaceAll(',', '')),
				premiTsfwd: double.parse(fieldPremiTsfwdController.text.replaceAll(',', '')),
			);
			if (widget.viewMode == "tambah") {
				calpar4FormBloc.add(Calpar4FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.calpar4Id = calpar4FormBloc.state.record!.calpar4Id;
				calpar4FormBloc.add(Calpar4FormUbahEvent(record: record));
			}
			_dismissDialog();
		}
	}

	void addError({required String error}) {
		if (!errors.contains(error)){
			setState(() {
				errors.add(error);
			});
		}
	}

	void removeError({required String error}) {
		if (errors.contains(error)){
			setState(() {
				errors.remove(error);
			});
		}
	}

}
