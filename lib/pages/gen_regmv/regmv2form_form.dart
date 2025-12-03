import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv2form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv2form_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:string_validator/string_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Regmv2FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regmv2FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regmv2FormFormPageFormState createState() => Regmv2FormFormPageFormState();
}

class Regmv2FormFormPageFormState extends State<Regmv2FormFormPage> {
	late Regmv2FormBloc regmv2FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldAwController = TextEditingController();
	var fieldCoverLamaController = TextEditingController();
	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
	var fieldIsEqController = TextEditingController();
	var fieldIsFloodController = TextEditingController();
	var fieldIsSrccController = TextEditingController();
	var fieldIsTbodController = TextEditingController();
	var fieldIsTerrorismController = TextEditingController();
	ComboMMvjnscoverModel? fieldComboMMvjnscover;
	final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
	var fieldPadController = TextEditingController();
	var fieldPapController = TextEditingController();
	var fieldPassangerCountController = TextEditingController();
	var fieldPllController = TextEditingController();
	var fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldTplController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regmv2FormBloc = BlocProvider.of<Regmv2FormBloc>(context);
		return BlocConsumer<Regmv2FormBloc, Regmv2FormState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Form(
								key: _formKey,
								child: Column(
									children: [
										const SizedBox(height: 25),
										buildFieldAw(),
										const SizedBox(height: 12),
										buildFieldCoverLama(),
										const SizedBox(height: 12),
										buildFieldCurrId(),
										const SizedBox(height: 12),
										buildFieldIsEq(),
										const SizedBox(height: 12),
										buildFieldIsFlood(),
										const SizedBox(height: 12),
										buildFieldIsSrcc(),
										const SizedBox(height: 12),
										buildFieldIsTbod(),
										buildFieldIsTerrorism(),
										buildFieldMmvjnscoverId(),
										buildFieldPad(),
										buildFieldPap(),
										buildFieldPassangerCount(),
										buildFieldPll(),
										buildFieldPolisAkhir(),
										buildFieldPolisMulai(),
										buildFieldRegmv1Id(),
										buildFieldTpl(),
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
				);
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldAwController.text = NumberFormat("#,###").format(state.record!.aw);
							// fieldCoverLamaController.text = state.record!.coverLama.toString();
							fieldIsEqController.text = state.record!.isEq.toString();
							fieldIsFloodController.text = state.record!.isFlood.toString();
							fieldIsSrccController.text = state.record!.isSrcc.toString();
							fieldIsTbodController.text = state.record!.isTbod.toString();
							fieldIsTerrorismController.text = state.record!.isTerrorism.toString();
							fieldPadController.text = NumberFormat("#,###").format(state.record!.pad);
							fieldPapController.text = NumberFormat("#,###").format(state.record!.pap);
							fieldPassangerCountController.text = state.record!.passangerCount.toString();
							fieldPllController.text = NumberFormat("#,###").format(state.record!.pll);
							fieldPolisAkhirController.text = state.record!.polisAkhir.toIso8601String();
							fieldPolisMulaiController.text = state.record!.polisMulai.toIso8601String();
							fieldTplController.text = NumberFormat("#,###").format(state.record!.tpl);
						}
						fieldComboRMatauang = state.comboRMatauang;
						fieldComboMMvjnscover = state.comboMMvjnscover;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regmv2FormBloc.add(
			Regmv2FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldAw() {
		return appTextField(
			label: "aw",
			hint: "Masukkan nilai AW...",
			controller: fieldAwController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}


	Widget buildFieldCoverLama() {
		return appTextField(
			label: "coverLama",
			hint: "Masukkan nilai cover lama...",
			controller: fieldCoverLamaController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}


	Widget buildFieldCurrId() {
		return buildFieldComboRMatauang(
			comboKey: comboRMatauangKey,
			labelText: 'currId',
			initItem: fieldComboRMatauang,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field ComboRMatauang tidak boleh kosong.");
					regmv2FormBloc.add(
						ComboRMatauangChangedEvent(comboRMatauang: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRMatauang = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field ComboRMatauang tidak boleh kosong.");
					return ""; // biar konsisten sama validator TextFormField
				}
				return null;
			},
		);
	}

	Widget buildFieldIsEq(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isEq",
			initialValue: toBoolean(fieldIsEqController.text),
			callback: (value) {
				setState(() {
					fieldIsEqController.text = value.toString();
				});
			}
		);
	}

	Widget buildFieldIsFlood(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isFlood",
			initialValue: toBoolean(fieldIsFloodController.text),
			callback: (value) {
				setState(() {
					fieldIsFloodController.text = value.toString();
				});
			}
		);
	}

	Widget buildFieldIsSrcc(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isSrcc",
			initialValue: toBoolean(fieldIsSrccController.text),
			callback: (value) {
				setState(() {
					fieldIsSrccController.text = value.toString();
				});
			}
		);
	}

	Widget buildFieldIsTbod(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isTbod",
			initialValue: toBoolean(fieldIsTbodController.text),
			callback: (value) {
				setState(() {
					fieldIsTbodController.text = value.toString();
				});
			}
		);
	}

	Widget buildFieldIsTerrorism(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isTerrorism",
			initialValue: toBoolean(fieldIsTerrorismController.text),
			callback: (value) {
				setState(() {
					fieldIsTerrorismController.text = value.toString();
				});
			}
		);
	}

	Widget buildFieldMmvjnscoverId() {
		return buildFieldComboMMvjnscover(
			comboKey: comboMMvjnscoverKey,
			labelText: 'mmvjnscoverId',
			initItem: fieldComboMMvjnscover,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field ComboMMvjnscover tidak boleh kosong.");
					regmv2FormBloc.add(
						ComboMMvjnscoverChangedEvent(comboMMvjnscover: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvjnscover = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field ComboMMvjnscover tidak boleh kosong.");
					return "";
				}
				return null;
			},
		);
	}


	Widget buildFieldPad() {
		return appTextField(
			label: "pad",
			hint: "Masukkan nilai PAD...",
			controller: fieldPadController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldPap() {
		return appTextField(
			label: "pap",
			hint: "Masukkan nilai PAP...",
			controller: fieldPapController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}


	Widget buildFieldPassangerCount() {
		return appTextField(
			label: "passangerCount",
			hint: "Masukkan jumlah penumpang...",
			controller: fieldPassangerCountController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldPll() {
		return appTextField(
			label: "pll",
			hint: "Masukkan nilai PLL...",
			controller: fieldPllController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldPolisAkhir() {
		return AppDateField(
			label: "polisAkhir",
			initialValue: DateTime.tryParse(fieldPolisAkhirController.text),
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			validator: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldPolisAkhirController.text = value.toIso8601String();
				}
			},
		);
	}

	Widget buildFieldPolisMulai() {
		return AppDateField(
			label: "polisMulai",
			initialValue: DateTime.tryParse(fieldPolisMulaiController.text),
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			validator: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldPolisMulaiController.text = value.toIso8601String();
				}
			},
		);
	}


	Widget buildFieldRegmv1Id(){
		return TextFormField(
		);
	}

	Widget buildFieldTpl() {
		return appTextField(
			label: "tpl",
			hint: "Masukkan nilai TPL...",
			controller: fieldTplController,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			textInputAction: TextInputAction.done,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
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
			Regmv2FormModel record = Regmv2FormModel(
				aw: double.parse(fieldAwController.text.replaceAll(',', '')),
				currId: fieldComboRMatauang?.rmatauangKode,
				isEq: toBoolean(fieldIsEqController.text),
				isFlood: toBoolean(fieldIsFloodController.text),
				isSrcc: toBoolean(fieldIsSrccController.text),
				isTbod: toBoolean(fieldIsTbodController.text),
				isTerrorism: toBoolean(fieldIsTerrorismController.text),
				mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
				pad: double.parse(fieldPadController.text.replaceAll(',', '')),
				pap: double.parse(fieldPapController.text.replaceAll(',', '')),
				passangerCount: int.parse(fieldPassangerCountController.text),
				pll: double.parse(fieldPllController.text.replaceAll(',', '')),
				polisAkhir: DateTime.parse(fieldPolisAkhirController.text),
				polisMulai: DateTime.parse(fieldPolisMulaiController.text),
				regmv2Id: '',
				tpl: double.parse(fieldTplController.text.replaceAll(',', '')), regmv1Id: '',
			);
			if (widget.viewMode == "tambah") {
				regmv2FormBloc.add(Regmv2FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regmv2Id = regmv2FormBloc.state.record!.regmv2Id;
				regmv2FormBloc.add(Regmv2FormUbahEvent(record: record));
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
