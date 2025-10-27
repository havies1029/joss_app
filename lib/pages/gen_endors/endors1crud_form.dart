import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_endors/endors1crud_bloc.dart';
import 'package:joss_app/models/gen_endors/endors1crud_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';


class Endors1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Endors1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Endors1CrudFormPageFormState createState() => Endors1CrudFormPageFormState();
}

class Endors1CrudFormPageFormState extends State<Endors1CrudFormPage> {
	late Endors1CrudBloc endors1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldEndorsTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldInsuredNamaController = TextEditingController();
	var fieldMstsendorsIdController = TextEditingController();
	var fieldNoteKonfirmasiController = TextEditingController();
	var fieldNotePerubahanController = TextEditingController();
	var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPremiController = TextEditingController();
	var fieldSppa1IdController = TextEditingController();
	var fieldStatusEndorsController = TextEditingController();
	var fieldTsiController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		endors1CrudBloc = BlocProvider.of<Endors1CrudBloc>(context);
		return BlocConsumer<Endors1CrudBloc, Endors1CrudState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Endorsement",
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
										buildFieldEndorsTgl(),
										buildFieldInsuredNama(),
										buildFieldMstsendorsId(),
										buildFieldNoteKonfirmasi(),
										buildFieldNotePerubahan(),
										buildFieldPeriodeAkhir(),
										buildFieldPeriodeMulai(),
										buildFieldPremi(),
										buildFieldSppa1Id(),
										buildFieldStatusEndors(),
										buildFieldTsi(),
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
							fieldEndorsTglController.text = state.record!.endorsTgl.toIso8601String();
							fieldInsuredNamaController.text = state.record!.insuredNama;
							fieldMstsendorsIdController.text = state.record!.mstsendorsId;
							fieldNoteKonfirmasiController.text = state.record!.noteKonfirmasi;
							fieldNotePerubahanController.text = state.record!.notePerubahan;
							fieldPeriodeAkhirController.text = state.record!.periodeAkhir.toIso8601String();
							fieldPeriodeMulaiController.text = state.record!.periodeMulai.toIso8601String();
							fieldPremiController.text = NumberFormat("#,###").format(state.record!.premi);
							fieldSppa1IdController.text = state.record!.sppa1Id;
							fieldStatusEndorsController.text = state.record!.statusEndors;
							fieldTsiController.text = NumberFormat("#,###").format(state.record!.tsi);
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		endors1CrudBloc.add(
			Endors1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldEndorsTgl(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldEndorsTglController.text),
			decoration: const InputDecoration(
				labelText: "endorsTgl",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldEndorsTglController.text = value.toIso8601String();
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

	Widget buildFieldInsuredNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldInsuredNamaController,
			decoration: const InputDecoration(
				labelText: "insuredNama",
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
		);
	}

	Widget buildFieldMstsendorsId(){
		return TextFormField(
			controller: fieldMstsendorsIdController,
			decoration: const InputDecoration(
				labelText: "mstsendorsId",
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
		);
	}

	Widget buildFieldNoteKonfirmasi(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldNoteKonfirmasiController,
			decoration: const InputDecoration(
				labelText: "noteKonfirmasi",
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
		);
	}

	Widget buildFieldNotePerubahan(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldNotePerubahanController,
			decoration: const InputDecoration(
				labelText: "notePerubahan",
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
		);
	}

	Widget buildFieldPeriodeAkhir(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPeriodeAkhirController.text),
			decoration: const InputDecoration(
				labelText: "periodeAkhir",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldPeriodeAkhirController.text = value.toIso8601String();
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

	Widget buildFieldPeriodeMulai(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPeriodeMulaiController.text),
			decoration: const InputDecoration(
				labelText: "periodeMulai",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldPeriodeMulaiController.text = value.toIso8601String();
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

	Widget buildFieldPremi(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiController,
			decoration: const InputDecoration(
				labelText: "premi",
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

	Widget buildFieldSppa1Id(){
		return TextFormField(
			controller: fieldSppa1IdController,
			decoration: const InputDecoration(
				labelText: "sppa1Id",
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
		);
	}

	Widget buildFieldStatusEndors(){
		return TextFormField(
			controller: fieldStatusEndorsController,
			decoration: const InputDecoration(
				labelText: "statusEndors",
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
		);
	}

	Widget buildFieldTsi(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldTsiController,
			decoration: const InputDecoration(
				labelText: "tsi",
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
			Endors1CrudModel record = Endors1CrudModel(
				endorsTgl: DateTime.parse(fieldEndorsTglController.text),
				endors1Id: '',
				insuredNama: fieldInsuredNamaController.text,
				mstsendorsId: fieldMstsendorsIdController.text,
				noteKonfirmasi: fieldNoteKonfirmasiController.text,
				notePerubahan: fieldNotePerubahanController.text,
				periodeAkhir: DateTime.parse(fieldPeriodeAkhirController.text),
				periodeMulai: DateTime.parse(fieldPeriodeMulaiController.text),
				premi: double.parse(fieldPremiController.text.replaceAll(',', '')),
				sppa1Id: fieldSppa1IdController.text,
				statusEndors: fieldStatusEndorsController.text,
				tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
			);
			if (widget.viewMode == "tambah") {
				endors1CrudBloc.add(Endors1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.endors1Id = endors1CrudBloc.state.record!.endors1Id;
				endors1CrudBloc.add(Endors1CrudUbahEvent(record: record));
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
