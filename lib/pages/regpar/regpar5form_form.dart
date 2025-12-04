import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regpar/regpar5form_bloc.dart';
import 'package:joss_app/models/regpar/regpar5form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';


class Regpar5FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regpar5FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regpar5FormFormPageFormState createState() => Regpar5FormFormPageFormState();
}

class Regpar5FormFormPageFormState extends State<Regpar5FormFormPage> {
	late Regpar5FormBloc regpar5FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldDiskonNilaiController = TextEditingController();
	var fieldDiskonPersenController = TextEditingController();
	var fieldPremiEqvetController = TextEditingController();
	var fieldPremiNetController = TextEditingController();
	var fieldPremiOtherController = TextEditingController();
	var fieldPremiParController = TextEditingController();
	var fieldPremiRsmdccController = TextEditingController();
	var fieldPremiTotalController = TextEditingController();
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
		regpar5FormBloc = BlocProvider.of<Regpar5FormBloc>(context);
		return BlocConsumer<Regpar5FormBloc, Regpar5FormState>(
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
													"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Perhitungan Premi",
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
												buildFieldDiskonNilai(),
												buildFieldDiskonPersen(),
												buildFieldPremiEqvet(),
												buildFieldPremiNet(),
												buildFieldPremiOther(),
												buildFieldPremiPar(),
												buildFieldPremiRsmdcc(),
												buildFieldPremiTotal(),
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
						fieldDiskonNilaiController.text = NumberFormat("#,###").format(state.record!.diskonNilai);
						fieldDiskonPersenController.text = NumberFormat("#,###").format(state.record!.diskonPersen);
						fieldPremiEqvetController.text = NumberFormat("#,###").format(state.record!.premiEqvet);
						fieldPremiNetController.text = NumberFormat("#,###").format(state.record!.premiNet);
						fieldPremiOtherController.text = NumberFormat("#,###").format(state.record!.premiOther);
						fieldPremiParController.text = NumberFormat("#,###").format(state.record!.premiPar);
						fieldPremiRsmdccController.text = NumberFormat("#,###").format(state.record!.premiRsmdcc);
						fieldPremiTotalController.text = NumberFormat("#,###").format(state.record!.premiTotal);
						fieldPremiTsfwdController.text = NumberFormat("#,###").format(state.record!.premiTsfwd);
					}
				}
			},
		);
	}
	void loadData() {
		if (widget.viewMode == "ubah") {
			regpar5FormBloc.add(
					Regpar5FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldDiskonNilai(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldDiskonNilaiController,
			decoration: const InputDecoration(
				labelText: "diskonNilai",
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

	Widget buildFieldDiskonPersen(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldDiskonPersenController,
			decoration: const InputDecoration(
				labelText: "diskonPersen",
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

	Widget buildFieldPremiTotal(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTotalController,
			decoration: const InputDecoration(
				labelText: "premiTotal",
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
			Regpar5FormModel record = Regpar5FormModel(
				regpar1Id: widget.recordId,
				diskonNilai: double.parse(fieldDiskonNilaiController.text.replaceAll(',', '')),
				diskonPersen: double.parse(fieldDiskonPersenController.text.replaceAll(',', '')),
				premiEqvet: double.parse(fieldPremiEqvetController.text.replaceAll(',', '')),
				premiNet: double.parse(fieldPremiNetController.text.replaceAll(',', '')),
				premiOther: double.parse(fieldPremiOtherController.text.replaceAll(',', '')),
				premiPar: double.parse(fieldPremiParController.text.replaceAll(',', '')),
				premiRsmdcc: double.parse(fieldPremiRsmdccController.text.replaceAll(',', '')),
				premiTotal: double.parse(fieldPremiTotalController.text.replaceAll(',', '')),
				premiTsfwd: double.parse(fieldPremiTsfwdController.text.replaceAll(',', '')),
				regpar5Id: '',
			);
			if (widget.viewMode == "tambah") {
				regpar5FormBloc.add(Regpar5FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regpar5Id = regpar5FormBloc.state.record!.regpar5Id;
				regpar5FormBloc.add(Regpar5FormUbahEvent(record: record));
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