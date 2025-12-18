import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/payment/pay1crud_bloc.dart';
import 'package:joss_app/models/payment/pay1crud_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';


class Pay1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Pay1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Pay1CrudFormPageFormState createState() => Pay1CrudFormPageFormState();
}

class Pay1CrudFormPageFormState extends State<Pay1CrudFormPage> {
	late Pay1CrudBloc pay1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldArTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldSppaCountController = TextEditingController();
	var fieldTotalOsController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		pay1CrudBloc = BlocProvider.of<Pay1CrudBloc>(context);
		return BlocConsumer<Pay1CrudBloc, Pay1CrudState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Payment #1",
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
										buildFieldArTgl(),
										buildFieldSppaCount(),
										buildFieldTotalOs(),
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
							fieldArTglController.text = state.record!.arTgl.toIso8601String();
							fieldSppaCountController.text = state.record!.sppaCount.toString();
							fieldTotalOsController.text = NumberFormat("#,###").format(state.record!.totalOs);
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		pay1CrudBloc.add(
			Pay1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldArTgl(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldArTglController.text),
			decoration: const InputDecoration(
				labelText: "arTgl",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldArTglController.text = value.toIso8601String();
				}
			},
			validator: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldSppaCount(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSppaCountController,
			decoration: const InputDecoration(
				labelText: "sppaCount",
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

	Widget buildFieldTotalOs(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldTotalOsController,
			decoration: const InputDecoration(
				labelText: "totalOs",
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
			Pay1CrudModel record = Pay1CrudModel(
				arTgl: DateTime.parse(fieldArTglController.text),
				ar1Id: '',
				sppaCount: int.parse(fieldSppaCountController.text),
				totalOs: double.parse(fieldTotalOsController.text.replaceAll(',', '')),
			);
			if (widget.viewMode == "tambah") {
				pay1CrudBloc.add(Pay1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.ar1Id = pay1CrudBloc.state.record!.ar1Id;
				pay1CrudBloc.add(Pay1CrudUbahEvent(record: record));
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
