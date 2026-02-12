import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_klaim/klaim2crud_bloc.dart';
import 'package:joss_app/models/gen_klaim/klaim2crud_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/widgets/combobox/combomstsclaim_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Klaim2CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Klaim2CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Klaim2CrudFormPageFormState createState() => Klaim2CrudFormPageFormState();
}

class Klaim2CrudFormPageFormState extends State<Klaim2CrudFormPage> {
	late Klaim2CrudBloc klaim2CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldKeteranganController = TextEditingController();
	var fieldKlaimAmountBaruController = TextEditingController();
	var fieldKlaimAmountLamaController = TextEditingController();
	ComboMStsclaimModel? fieldComboMStsclaim;
	final comboMStsclaimKey = GlobalKey<DropdownSearchState<ComboMStsclaimModel>>();
	var fieldPerubahanTglController = TextEditingController(text: DateTime.now().toIso8601String());

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaim2CrudBloc = BlocProvider.of<Klaim2CrudBloc>(context);
		return BlocConsumer<Klaim2CrudBloc, Klaim2CrudState>(
			builder: (context, state) {
				return Dialog(
					shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
					child: SingleChildScrollView(
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Form(
								child: Column(
									children: [
										const SizedBox(height: 10),
										Text(
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Klaim 2",
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
										buildFieldKeterangan(),
										buildFieldKlaimAmountBaru(),
										buildFieldKlaimAmountLama(),
										buildFieldKlaim1Id(),
										buildFieldMstsclaimId(),
										buildFieldPerubahanTgl(),
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
							fieldKeteranganController.text = state.record!.keterangan;
							fieldKlaimAmountBaruController.text = NumberFormat("#,###").format(state.record!.klaimAmountBaru);
							fieldKlaimAmountLamaController.text = NumberFormat("#,###").format(state.record!.klaimAmountLama);
							fieldPerubahanTglController.text = state.record!.perubahanTgl.toIso8601String();
						}
						fieldComboMStsclaim = state.comboMStsclaim;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		klaim2CrudBloc.add(
			Klaim2CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldKeterangan(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldKeteranganController,
			decoration: const InputDecoration(
				labelText: "keterangan",
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

	Widget buildFieldKlaimAmountBaru(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimAmountBaruController,
			decoration: const InputDecoration(
				labelText: "klaimAmountBaru",
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

	Widget buildFieldKlaimAmountLama(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimAmountLamaController,
			decoration: const InputDecoration(
				labelText: "klaimAmountLama",
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

	Widget buildFieldKlaim1Id(){
		return TextFormField(
		);
	}

	Widget buildFieldMstsclaimId(){
		return buildFieldComboMStsclaim(
			comboKey: comboMStsclaimKey,
			labelText: 'mstsclaimId',
			initItem: fieldComboMStsclaim,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMStsclaim tidak boleh kosong.");
					klaim2CrudBloc.add(ComboMStsclaimChangedEvent(comboMStsclaim: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMStsclaim = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMStsclaim tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldPerubahanTgl(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPerubahanTglController.text),
			decoration: const InputDecoration(
				labelText: "perubahanTgl",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldPerubahanTglController.text = value.toIso8601String();
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

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Klaim2CrudModel record = Klaim2CrudModel(
				keterangan: fieldKeteranganController.text,
				klaimAmountBaru: double.parse(fieldKlaimAmountBaruController.text.replaceAll(',', '')),
				klaimAmountLama: double.parse(fieldKlaimAmountLamaController.text.replaceAll(',', '')),
				klaim2Id: '',
				mstsclaimId: fieldComboMStsclaim?.mstsclaimId,
				perubahanTgl: DateTime.parse(fieldPerubahanTglController.text),
			);
			if (widget.viewMode == "tambah") {
				klaim2CrudBloc.add(Klaim2CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.klaim2Id = klaim2CrudBloc.state.record!.klaim2Id;
				klaim2CrudBloc.add(Klaim2CrudUbahEvent(record: record));
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
