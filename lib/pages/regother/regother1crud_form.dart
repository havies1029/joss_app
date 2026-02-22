
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regother/regother1crud_bloc.dart';
import 'package:joss_app/models/regother/regother1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
import 'package:joss_app/widgets/combobox/combomcobapp1_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Regother1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regother1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regother1CrudFormPageFormState createState() => Regother1CrudFormPageFormState();
}

class Regother1CrudFormPageFormState extends State<Regother1CrudFormPage> {
	late Regother1CrudBloc regother1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
	ComboMCobApp1Model? fieldComboMCobApp1;
	final comboMCobApp1Key = GlobalKey<DropdownSearchState<ComboMCobApp1Model>>();
	var fieldRemarkController = TextEditingController();
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
		regother1CrudBloc = BlocProvider.of<Regother1CrudBloc>(context);
		return BlocConsumer<Regother1CrudBloc, Regother1CrudState>(
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
													"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Reg Other",
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
												buildFieldMcobId(),
												buildFieldCurrId(),
												buildFieldRemark(),
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
						fieldRemarkController.text = state.record!.remark;
						fieldTsiController.text = NumberFormat("#,###").format(state.record!.tsi);
					}
					fieldComboRMatauang = state.comboRMatauang;
					fieldComboMCobApp1 = state.comboMCobApp1;
				}
			},
		);
	}
	void loadData() {
		if (widget.viewMode == "ubah") {
			regother1CrudBloc.add(
					Regother1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCurrId(){
		return buildFieldComboRMatauang(
			comboKey: comboRMatauangKey,
			labelText: 'currId',
			initItem: fieldComboRMatauang,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboRMatauang tidak boleh kosong.");
					regother1CrudBloc.add(ComboRMatauangChangedEvent(comboRMatauang: value));
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

	Widget buildFieldMcobId(){
		return buildFieldComboMCobApp1(
			comboKey: comboMCobApp1Key,
			labelText: 'mcobId',
			initItem: fieldComboMCobApp1,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboMCobApp1 tidak boleh kosong.");
					regother1CrudBloc.add(ComboMCobApp1ChangedEvent(comboMCobApp1: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMCobApp1 = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Field ComboMCobApp1 tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldRemark(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldRemarkController,
			decoration: const InputDecoration(
				labelText: "remark",
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
			Regother1CrudModel record = Regother1CrudModel(
				currId: fieldComboRMatauang?.rmatauangKode,
				mcobId: fieldComboMCobApp1?.mCobApp1Id,
				regother1Id: '',
				remark: fieldRemarkController.text,
				tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
			);
			if (widget.viewMode == "tambah") {
				regother1CrudBloc.add(Regother1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regother1Id = regother1CrudBloc.state.record!.regother1Id;
				regother1CrudBloc.add(Regother1CrudUbahEvent(record: record));
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
