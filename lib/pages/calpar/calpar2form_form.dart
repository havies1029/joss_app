import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar2form_bloc.dart';
import 'package:joss_app/models/calpar/calpar2form_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/widgets/combobox/combombiindemnityojk_widget.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Calpar2FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Calpar2FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Calpar2FormFormPageFormState createState() => Calpar2FormFormPageFormState();
}

class Calpar2FormFormPageFormState extends State<Calpar2FormFormPage> {
	late Calpar2FormBloc calpar2FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldBiIndexRateController = TextEditingController();
	var fieldBiTotalController = TextEditingController();
	ComboMBiindemnityOjkModel? fieldComboMBiindemnityOjk;
	final comboMBiindemnityOjkKey = GlobalKey<DropdownSearchState<ComboMBiindemnityOjkModel>>();
	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
	var fieldSiBiController = TextEditingController();
	var fieldSiBuildingController = TextEditingController();
	var fieldSiContentController = TextEditingController();
	var fieldSiMachineryController = TextEditingController();
	var fieldSiOtherController = TextEditingController();
	var fieldSiStockController = TextEditingController();
	var fieldStockAdjustableController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		calpar2FormBloc = BlocProvider.of<Calpar2FormBloc>(context);
		return BlocConsumer<Calpar2FormBloc, Calpar2FormState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Info Pertanggungan",
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
										buildFieldBiIndexRate(),
										buildFieldBiTotal(),
										buildFieldCalpar1Id(),
										buildFieldMbiindemnityojkId(),
										buildFieldRmatauangKode(),
										buildFieldSiBi(),
										buildFieldSiBuilding(),
										buildFieldSiContent(),
										buildFieldSiMachinery(),
										buildFieldSiOther(),
										buildFieldSiStock(),
										buildFieldStockAdjustable(),
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
							fieldBiIndexRateController.text = NumberFormat("#,###").format(state.record!.biIndexRate);
							fieldBiTotalController.text = NumberFormat("#,###").format(state.record!.biTotal);
							fieldSiBiController.text = NumberFormat("#,###").format(state.record!.siBi);
							fieldSiBuildingController.text = NumberFormat("#,###").format(state.record!.siBuilding);
							fieldSiContentController.text = NumberFormat("#,###").format(state.record!.siContent);
							fieldSiMachineryController.text = NumberFormat("#,###").format(state.record!.siMachinery);
							fieldSiOtherController.text = NumberFormat("#,###").format(state.record!.siOther);
							fieldSiStockController.text = NumberFormat("#,###").format(state.record!.siStock);
							fieldStockAdjustableController.text = NumberFormat("#,###").format(state.record!.stockAdjustable);
						}
						fieldComboMBiindemnityOjk = state.comboMBiindemnityOjk;
						fieldComboRMatauang = state.comboRMatauang;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		calpar2FormBloc.add(
			Calpar2FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldBiIndexRate(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldBiIndexRateController,
			decoration: const InputDecoration(
				labelText: "biIndexRate",
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

	Widget buildFieldBiTotal(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldBiTotalController,
			decoration: const InputDecoration(
				labelText: "biTotal",
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

	Widget buildFieldCalpar1Id(){
		return TextFormField(
		);
	}

	Widget buildFieldMbiindemnityojkId(){
		return buildFieldComboMBiindemnityOjk(
			comboKey: comboMBiindemnityOjkKey,
			labelText: 'mbiindemnityojkId',
			initItem: fieldComboMBiindemnityOjk,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMBiindemnityOjk tidak boleh kosong.");
					calpar2FormBloc.add(ComboMBiindemnityOjkChangedEvent(comboMBiindemnityOjk: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMBiindemnityOjk = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMBiindemnityOjk tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldRmatauangKode(){
		return buildFieldComboRMatauang(
			comboKey: comboRMatauangKey,
			labelText: 'rmatauangKode',
			initItem: fieldComboRMatauang,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboRMatauang tidak boleh kosong.");
					calpar2FormBloc.add(ComboRMatauangChangedEvent(comboRMatauang: value));
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

	Widget buildFieldSiBi(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldSiBiController,
			decoration: const InputDecoration(
				labelText: "siBi",
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

	Widget buildFieldStockAdjustable(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldStockAdjustableController,
			decoration: const InputDecoration(
				labelText: "stockAdjustable",
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
			Calpar2FormModel record = Calpar2FormModel(
				biIndexRate: double.parse(fieldBiIndexRateController.text.replaceAll(',', '')),
				biTotal: double.parse(fieldBiTotalController.text.replaceAll(',', '')),
				calpar2Id: '',
				mbiindemnityojkId: fieldComboMBiindemnityOjk?.mbiindemnityojkId,
				rmatauangKode: fieldComboRMatauang?.rmatauangKode,
				siBi: double.parse(fieldSiBiController.text.replaceAll(',', '')),
				siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
				siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
				siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
				siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
				siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
				stockAdjustable: double.parse(fieldStockAdjustableController.text.replaceAll(',', '')), calpar1Id: '',
			);
			if (widget.viewMode == "tambah") {
				calpar2FormBloc.add(Calpar2FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.calpar2Id = calpar2FormBloc.state.record!.calpar2Id;
				calpar2FormBloc.add(Calpar2FormUbahEvent(record: record));
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
