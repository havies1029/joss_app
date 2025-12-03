import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regpar/regpar2form_bloc.dart';
import 'package:joss_app/models/regpar/regpar2form_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/widgets/combobox/comborkonstruksiojk_widget.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/widgets/combobox/comborokupasi_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Regpar2FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regpar2FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regpar2FormFormPageFormState createState() => Regpar2FormFormPageFormState();
}

class Regpar2FormFormPageFormState extends State<Regpar2FormFormPage> {
	late Regpar2FormBloc regpar2FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldCoverLamaController = TextEditingController();
	var fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
	final comboRKonstruksiojkKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
	ComboROkupasiModel? fieldComboROkupasi;
	final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regpar2FormBloc = BlocProvider.of<Regpar2FormBloc>(context);
		return BlocConsumer<Regpar2FormBloc, Regpar2FormState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Info Polis",
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
										buildFieldCoverLama(),
										buildFieldPolisAkhir(),
										buildFieldPolisMulai(),
										buildFieldRegpar1Id(),
										buildFieldRkonstruksiojkId(),
										buildFieldRokupasiId(),
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
							fieldCoverLamaController.text = state.record!.coverLama.toString();
							fieldPolisAkhirController.text = state.record!.polisAkhir.toIso8601String();
							fieldPolisMulaiController.text = state.record!.polisMulai.toIso8601String();
						}
						fieldComboRKonstruksiojk = state.comboRKonstruksiojk;
						fieldComboROkupasi = state.comboROkupasi;
					}
				},
			);
		}



	void loadData() {
		if (widget.viewMode == "ubah") {
		regpar2FormBloc.add(
			Regpar2FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCoverLama(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldCoverLamaController,
			decoration: const InputDecoration(
				labelText: "coverLama",
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

	Widget buildFieldPolisAkhir(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPolisAkhirController.text),
			decoration: const InputDecoration(
				labelText: "polisAkhir",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldPolisAkhirController.text = value.toIso8601String();
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

	Widget buildFieldPolisMulai(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPolisMulaiController.text),
			decoration: const InputDecoration(
				labelText: "polisMulai",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldPolisMulaiController.text = value.toIso8601String();
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

	Widget buildFieldRegpar1Id(){
		return TextFormField(
		);
	}

	Widget buildFieldRkonstruksiojkId(){
		return buildFieldComboRKonstruksiojk(
			comboKey: comboRKonstruksiojkKey,
			labelText: 'rkonstruksiojkId',
			initItem: fieldComboRKonstruksiojk,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboRKonstruksiojk tidak boleh kosong.");
					regpar2FormBloc.add(ComboRKonstruksiojkChangedEvent(comboRKonstruksiojk: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRKonstruksiojk = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboRKonstruksiojk tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldRokupasiId(){
		return buildFieldComboROkupasi(
			comboKey: comboROkupasiKey,
			labelText: 'rokupasiId',
			initItem: fieldComboROkupasi,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboROkupasi tidak boleh kosong.");
					regpar2FormBloc.add(ComboROkupasiChangedEvent(comboROkupasi: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboROkupasi = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboROkupasi tidak boleh kosong.");
				}
			},
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Regpar2FormModel record = Regpar2FormModel(
				coverLama: int.parse(fieldCoverLamaController.text),
				polisAkhir: DateTime.parse(fieldPolisAkhirController.text),
				polisMulai: DateTime.parse(fieldPolisMulaiController.text),
				regpar2Id: '',
				rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
				rokupasiId: fieldComboROkupasi?.rokupasiId,
			);
			if (widget.viewMode == "tambah") {
				regpar2FormBloc.add(Regpar2FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regpar2Id = regpar2FormBloc.state.record!.regpar2Id;
				regpar2FormBloc.add(Regpar2FormUbahEvent(record: record));
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
