import 'package:joss_app/blocs/regklaim/regklaim1crud_bloc.dart';
import 'package:joss_app/models/regklaim/regklaim1crud_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/models/combobox/combominsurance_model.dart';
import 'package:joss_app/widgets/combobox/combominsurance_widget.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Regklaim1CrudFormPage extends StatefulWidget {

	const Regklaim1CrudFormPage({super.key});

	@override
	Regklaim1CrudFormPageState createState() => Regklaim1CrudFormPageState();
}

class Regklaim1CrudFormPageState extends State<Regklaim1CrudFormPage> {
	late Regklaim1CrudBloc regklaim1formBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldInsuredNamaController = TextEditingController();
	ComboMInsuranceModel? fieldComboMInsurance;
	final comboMInsuranceKey = GlobalKey<DropdownSearchState<ComboMInsuranceModel>>();
	var fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPolisNoController = TextEditingController();
  var fieldLokasiObjectController = TextEditingController();

	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		regklaim1formBloc = BlocProvider.of<Regklaim1CrudBloc>(context);
		return BlocConsumer<Regklaim1CrudBloc, Regklaim1CrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Form(
							key: _formKey,
							child: Column(
								children: [
									const SizedBox(height: 10),
									Text(
										"Input Klaim",
										style: const TextStyle(
											fontSize: 20.0,
											color: Color(0xffff6101),
											fontWeight: FontWeight.w600,
											fontFamily: 'Hind',
											fontStyle: FontStyle.normal,
											decoration: TextDecoration.underline,
										),
									),
									const SizedBox(height: 25),
									buildFieldMinsuranceId(),
									buildFieldPolisNo(),
									buildFieldPolisMulai(),
									buildFieldPolisAkhir(),
									buildFieldInsuredNama(),
				                    buildFieldLokasiResiko(),
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
							fieldInsuredNamaController.text = state.record!.insuredNama;
							fieldPolisAkhirController.text = state.record!.polisAkhir.toIso8601String();
							fieldPolisMulaiController.text = state.record!.polisMulai.toIso8601String();
							fieldPolisNoController.text = state.record!.polisNo;
              fieldLokasiObjectController.text = state.record!.lokasiObject;
						}
						fieldComboMInsurance = state.comboMInsurance;
					}
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

	Widget buildFieldMinsuranceId(){
		return buildFieldComboMInsurance(
			comboKey: comboMInsuranceKey,
			labelText: 'minsuranceId',
			initItem: fieldComboMInsurance,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMInsurance tidak boleh kosong.");
					regklaim1formBloc.add(ComboMInsuranceChangedEvent(comboMInsurance: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMInsurance = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMInsurance tidak boleh kosong.");
				}
			},
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

	Widget buildFieldPolisNo(){
		return TextFormField(
			controller: fieldPolisNoController,
			decoration: const InputDecoration(
				labelText: "polisNo",
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

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Regklaim1CrudModel record = Regklaim1CrudModel(
				insuredNama: fieldInsuredNamaController.text,
        lokasiObject: fieldLokasiObjectController.text,
				minsuranceId: fieldComboMInsurance?.minsuranceId,
				polisAkhir: DateTime.parse(fieldPolisAkhirController.text),
				polisMulai: DateTime.parse(fieldPolisMulaiController.text),
				polisNo: fieldPolisNoController.text,
				regklaim1Id: '',
			);
			regklaim1formBloc.add(Regklaim1CrudTambahEvent(record: record));
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

  Widget buildFieldLokasiResiko(){
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 4,
      controller: TextEditingController(),
      decoration: const InputDecoration(
        labelText: "lokasiResiko",
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

}
