import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1crud_bloc.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/widgets/combobox/combomstsclaim_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Klaim1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Klaim1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Klaim1CrudFormPageFormState createState() => Klaim1CrudFormPageFormState();
}

class Klaim1CrudFormPageFormState extends State<Klaim1CrudFormPage> {
	late Klaim1CrudBloc klaim1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldInsuredNameController = TextEditingController();
	var fieldKejadianLokasiController = TextEditingController();
	var fieldKejadianTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldKlaimAmountController = TextEditingController();
	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
	ComboMStsclaimModel? fieldComboMStsclaim;
	final comboMStsclaimKey = GlobalKey<DropdownSearchState<ComboMStsclaimModel>>();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaim1CrudBloc = BlocProvider.of<Klaim1CrudBloc>(context);
		return BlocConsumer<Klaim1CrudBloc, Klaim1CrudState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Klaim 1",
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
										buildFieldInsuredName(),
										buildFieldKejadianLokasi(),
										buildFieldKejadianTgl(),
										buildFieldKlaimAmount(),
										buildFieldKursId(),
										buildFieldLastStsclaimId(),
										buildFieldMinsuranceId(),
										buildFieldMjenisrugiId(),
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
							fieldInsuredNameController.text = state.record!.insuredName;
							fieldKejadianLokasiController.text = state.record!.kejadianLokasi;
							fieldKejadianTglController.text = state.record!.kejadianTgl.toIso8601String();
							fieldKlaimAmountController.text = NumberFormat("#,###").format(state.record!.klaimAmount);
						}
						fieldComboRMatauang = state.comboRMatauang;
						fieldComboMStsclaim = state.comboMStsclaim;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		klaim1CrudBloc.add(
			Klaim1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldInsuredName(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldInsuredNameController,
			decoration: const InputDecoration(
				labelText: "insuredName",
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

	Widget buildFieldKejadianLokasi(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldKejadianLokasiController,
			decoration: const InputDecoration(
				labelText: "kejadianLokasi",
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

	Widget buildFieldKejadianTgl(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldKejadianTglController.text),
			decoration: const InputDecoration(
				labelText: "kejadianTgl",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldKejadianTglController.text = value.toIso8601String();
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

	Widget buildFieldKlaimAmount(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimAmountController,
			decoration: const InputDecoration(
				labelText: "klaimAmount",
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

	Widget buildFieldKursId(){
		return buildFieldComboRMatauang(
			comboKey: comboRMatauangKey,
			labelText: 'kursId',
			initItem: fieldComboRMatauang,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboRMatauang tidak boleh kosong.");
					klaim1CrudBloc.add(ComboRMatauangChangedEvent(comboRMatauang: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRMatauang = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboRMatauang tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldLastStsclaimId(){
		return buildFieldComboMStsclaim(
			comboKey: comboMStsclaimKey,
			labelText: 'lastStsclaimId',
			initItem: fieldComboMStsclaim,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMStsclaim tidak boleh kosong.");
					klaim1CrudBloc.add(ComboMStsclaimChangedEvent(comboMStsclaim: value));
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

	Widget buildFieldMinsuranceId(){
		return TextFormField(
		);
	}

	Widget buildFieldMjenisrugiId(){
		return TextFormField(
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Klaim1CrudModel record = Klaim1CrudModel(
				insuredName: fieldInsuredNameController.text,
				kejadianLokasi: fieldKejadianLokasiController.text,
				kejadianTgl: DateTime.parse(fieldKejadianTglController.text),
				klaimAmount: double.parse(fieldKlaimAmountController.text.replaceAll(',', '')),
				klaim1Id: '',
				kursId: fieldComboRMatauang?.rmatauangKode,
				lastStsclaimId: fieldComboMStsclaim?.mstsclaimId,
			);
			if (widget.viewMode == "tambah") {
				klaim1CrudBloc.add(Klaim1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.klaim1Id = klaim1CrudBloc.state.record!.klaim1Id;
				klaim1CrudBloc.add(Klaim1CrudUbahEvent(record: record));
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
