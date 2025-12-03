import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regpar/regpar4form_bloc.dart';
import 'package:joss_app/models/regpar/regpar4form_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Regpar4FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regpar4FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regpar4FormFormPageFormState createState() => Regpar4FormFormPageFormState();
}

class Regpar4FormFormPageFormState extends State<Regpar4FormFormPage> {
	late Regpar4FormBloc regpar4FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
	var fieldSiBuildingController = TextEditingController();
	var fieldSiContentController = TextEditingController();
	var fieldSiMachineryController = TextEditingController();
	var fieldSiOtherController = TextEditingController();
	var fieldSiStockController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regpar4FormBloc = BlocProvider.of<Regpar4FormBloc>(context);
		return BlocConsumer<Regpar4FormBloc, Regpar4FormState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Nilai Pertanggungan",
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
										buildFieldCurrId(),
										buildFieldRegpar1Id(),
										buildFieldSiBuilding(),
										buildFieldSiContent(),
										buildFieldSiMachinery(),
										buildFieldSiOther(),
										buildFieldSiStock(),
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
							fieldSiBuildingController.text = NumberFormat("#,###").format(state.record!.siBuilding);
							fieldSiContentController.text = NumberFormat("#,###").format(state.record!.siContent);
							fieldSiMachineryController.text = NumberFormat("#,###").format(state.record!.siMachinery);
							fieldSiOtherController.text = NumberFormat("#,###").format(state.record!.siOther);
							fieldSiStockController.text = NumberFormat("#,###").format(state.record!.siStock);
						}
						fieldComboRMatauang = state.comboRMatauang;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regpar4FormBloc.add(
			Regpar4FormLihatEvent(recordId: widget.recordId));
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
					regpar4FormBloc.add(ComboRMatauangChangedEvent(comboRMatauang: value));
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

	Widget buildFieldRegpar1Id(){
		return TextFormField(
		);
	}

	Widget buildFieldSiBuilding(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSiBuildingController,
			decoration: const InputDecoration(
				labelText: "siBuilding",
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

	Widget buildFieldSiContent(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSiContentController,
			decoration: const InputDecoration(
				labelText: "siContent",
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

	Widget buildFieldSiMachinery(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSiMachineryController,
			decoration: const InputDecoration(
				labelText: "siMachinery",
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

	Widget buildFieldSiOther(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSiOtherController,
			decoration: const InputDecoration(
				labelText: "siOther",
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

	Widget buildFieldSiStock(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSiStockController,
			decoration: const InputDecoration(
				labelText: "siStock",
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
			Regpar4FormModel record = Regpar4FormModel(
				currId: fieldComboRMatauang?.rmatauangKode,
				regpar4Id: '',
				siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
				siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
				siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
				siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
				siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
			);
			if (widget.viewMode == "tambah") {
				regpar4FormBloc.add(Regpar4FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regpar4Id = regpar4FormBloc.state.record!.regpar4Id;
				regpar4FormBloc.add(Regpar4FormUbahEvent(record: record));
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
