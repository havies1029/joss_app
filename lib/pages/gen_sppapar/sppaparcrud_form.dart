import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_sppapar/sppaparcrud_bloc.dart';
import 'package:joss_app/models/gen_sppapar/sppaparcrud_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/widgets/combobox/combomkabzonagempa_widget.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/widgets/combobox/combombiindemnityojk_widget.dart';
import 'package:joss_app/models/combobox/combomtarifojkbanjirpar_model.dart';
import 'package:joss_app/widgets/combobox/combomtarifojkbanjirpar_widget.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/widgets/combobox/comborkodepos_widget.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/widgets/combobox/comborkonstruksiojk_widget.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/widgets/combobox/comborokupasi_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../repositories/combobox/comborkonstruksiojk_repository.dart';
import '../../repositories/combobox/comborokupasi_repository.dart';


class SppaparCrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const SppaparCrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	SppaparCrudFormPageFormState createState() => SppaparCrudFormPageFormState();
}

class SppaparCrudFormPageFormState extends State<SppaparCrudFormPage> {
	late SppaparCrudBloc sppaparCrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldBuildingDescController = TextEditingController();
	var fieldContentDescController = TextEditingController();
	var fieldInsuredAlamat1Controller = TextEditingController();
	var fieldInsuredAlamat2Controller = TextEditingController();
	var fieldInsuredNamaController = TextEditingController();
	ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
	final comboMKabZonaGempaKey = GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();
	var fieldLokasi1Controller = TextEditingController();
	var fieldLokasi2Controller = TextEditingController();
	var fieldMachineryDescController = TextEditingController();
	ComboMWilayahModel? fieldComboMWilayah;
	final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
	var fieldOtherDescController = TextEditingController();
	var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPremiEqvetController = TextEditingController();
	var fieldPremiOtherController = TextEditingController();
	var fieldPremiParController = TextEditingController();
	var fieldPremiRsmdccController = TextEditingController();
	var fieldPremiTotalController = TextEditingController();
	var fieldPremiTsfwdController = TextEditingController();
	var fieldRateEqvetController = TextEditingController();
	var fieldRateOtherController = TextEditingController();
	var fieldRateParController = TextEditingController();
	var fieldRateRsmdccController = TextEditingController();
	var fieldRateTotalController = TextEditingController();
	var fieldRateTsfwdController = TextEditingController();
	ComboRKodeposModel? fieldComboRKodepos;
	final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();
	ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
	final comboRKonstruksiojkKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
	ComboROkupasiModel? fieldComboROkupasi;
	final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();
	var fieldSiBuildingController = TextEditingController();
	var fieldSiContentController = TextEditingController();
	var fieldSiMachineryController = TextEditingController();
	var fieldSiOtherController = TextEditingController();
	var fieldSiStockController = TextEditingController();
	var fieldSppaTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldStockAdjustableController = TextEditingController();
	var fieldStockDescController = TextEditingController();
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
		sppaparCrudBloc = BlocProvider.of<SppaparCrudBloc>(context);
		return BlocConsumer<SppaparCrudBloc, SppaparCrudState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} SPPA PAR",
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
										buildFieldBuildingDesc(),
										buildFieldContentDesc(),
										buildFieldInsuredAlamat1(),
										buildFieldInsuredAlamat2(),
										buildFieldInsuredNama(),
										buildFieldKab2zonagempaId(),
										buildFieldLokasi1(),
										buildFieldLokasi2(),
										buildFieldMachineryDesc(),
										buildFieldMwilayahId(),
										buildFieldOtherDesc(),
										buildFieldPeriodeAkhir(),
										buildFieldPeriodeMulai(),
										buildFieldPremiEqvet(),
										buildFieldPremiOther(),
										buildFieldPremiPar(),
										buildFieldPremiRsmdcc(),
										buildFieldPremiTotal(),
										buildFieldPremiTsfwd(),
										buildFieldRateEqvet(),
										buildFieldRateOther(),
										buildFieldRatePar(),
										buildFieldRateRsmdcc(),
										buildFieldRateTotal(),
										buildFieldRateTsfwd(),
										buildFieldRkodeposId(),
										buildFieldRkonstruksiojkId(),
										buildFieldRokupasiId(),
										buildFieldSiBuilding(),
										buildFieldSiContent(),
										buildFieldSiMachinery(),
										buildFieldSiOther(),
										buildFieldSiStock(),
										buildFieldSppaTgl(),
										buildFieldStockAdjustable(),
										buildFieldStockDesc(),
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
							fieldBuildingDescController.text = state.record!.buildingDesc;
							fieldContentDescController.text = state.record!.contentDesc;
							fieldInsuredAlamat1Controller.text = state.record!.insuredAlamat1;
							fieldInsuredAlamat2Controller.text = state.record!.insuredAlamat2;
							fieldInsuredNamaController.text = state.record!.insuredNama;
							fieldLokasi1Controller.text = state.record!.lokasi1;
							fieldLokasi2Controller.text = state.record!.lokasi2;
							fieldMachineryDescController.text = state.record!.machineryDesc;
							fieldOtherDescController.text = state.record!.otherDesc;
							fieldPeriodeAkhirController.text = state.record!.periodeAkhir.toIso8601String();
							fieldPeriodeMulaiController.text = state.record!.periodeMulai.toIso8601String();
							fieldPremiEqvetController.text = NumberFormat("#,###").format(state.record!.premiEqvet);
							fieldPremiOtherController.text = NumberFormat("#,###").format(state.record!.premiOther);
							fieldPremiParController.text = NumberFormat("#,###").format(state.record!.premiPar);
							fieldPremiRsmdccController.text = NumberFormat("#,###").format(state.record!.premiRsmdcc);
							fieldPremiTotalController.text = NumberFormat("#,###").format(state.record!.premiTotal);
							fieldPremiTsfwdController.text = NumberFormat("#,###").format(state.record!.premiTsfwd);
							fieldRateEqvetController.text = NumberFormat("#,###").format(state.record!.rateEqvet);
							fieldRateOtherController.text = NumberFormat("#,###").format(state.record!.rateOther);
							fieldRateParController.text = NumberFormat("#,###").format(state.record!.ratePar);
							fieldRateRsmdccController.text = NumberFormat("#,###").format(state.record!.rateRsmdcc);
							fieldRateTotalController.text = NumberFormat("#,###").format(state.record!.rateTotal);
							fieldRateTsfwdController.text = NumberFormat("#,###").format(state.record!.rateTsfwd);
							fieldSiBuildingController.text = NumberFormat("#,###").format(state.record!.siBuilding);
							fieldSiContentController.text = NumberFormat("#,###").format(state.record!.siContent);
							fieldSiMachineryController.text = NumberFormat("#,###").format(state.record!.siMachinery);
							fieldSiOtherController.text = NumberFormat("#,###").format(state.record!.siOther);
							fieldSiStockController.text = NumberFormat("#,###").format(state.record!.siStock);
							fieldSppaTglController.text = state.record!.sppaTgl.toIso8601String();
							fieldStockAdjustableController.text = NumberFormat("#,###").format(state.record!.stockAdjustable);
							fieldStockDescController.text = state.record!.stockDesc;
							fieldTsiController.text = NumberFormat("#,###").format(state.record!.tsi);
						}
						fieldComboMKabZonaGempa = state.comboMKabZonaGempa;
						fieldComboMWilayah = state.comboMWilayah;
						fieldComboRKodepos = state.comboRKodepos;
						fieldComboRKonstruksiojk = state.comboRKonstruksiojk;
						fieldComboROkupasi = state.comboROkupasi;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		sppaparCrudBloc.add(
			SppaparCrudLihatEvent(recordId: widget.recordId));
		}
	}


	Widget buildFieldBuildingDesc(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldBuildingDescController,
			decoration: const InputDecoration(
				labelText: "buildingDesc",
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


	Widget buildFieldContentDesc(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldContentDescController,
			decoration: const InputDecoration(
				labelText: "contentDesc",
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


	Widget buildFieldInsuredAlamat1(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldInsuredAlamat1Controller,
			decoration: const InputDecoration(
				labelText: "insuredAlamat1",
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

	Widget buildFieldInsuredAlamat2(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldInsuredAlamat2Controller,
			decoration: const InputDecoration(
				labelText: "insuredAlamat2",
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

	Widget buildFieldKab2zonagempaId(){
		return buildFieldComboMKabZonaGempa(
			comboKey: comboMKabZonaGempaKey,
			labelText: 'kab2zonagempaId',
			initItem: fieldComboMKabZonaGempa,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMKabZonaGempa tidak boleh kosong.");
					sppaparCrudBloc.add(ComboMKabZonaGempaChangedEvent(comboMKabZonaGempa: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMKabZonaGempa = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMKabZonaGempa tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldLokasi1(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldLokasi1Controller,
			decoration: const InputDecoration(
				labelText: "lokasi1",
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

	Widget buildFieldLokasi2(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldLokasi2Controller,
			decoration: const InputDecoration(
				labelText: "lokasi2",
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

	Widget buildFieldMachineryDesc(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldMachineryDescController,
			decoration: const InputDecoration(
				labelText: "machineryDesc",
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

	Widget buildFieldMwilayahId(){
		return buildFieldComboMWilayah(
			comboKey: comboMWilayahKey,
			labelText: 'mwilayahId',
			initItem: fieldComboMWilayah,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMWilayah tidak boleh kosong.");
					sppaparCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMWilayah = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMWilayah tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldOtherDesc(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldOtherDescController,
			decoration: const InputDecoration(
				labelText: "otherDesc",
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


	Widget buildFieldPremiEqvet(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiEqvetController,
			decoration: const InputDecoration(
				labelText: "premiEqvet",
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


	Widget buildFieldPremiOther(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiOtherController,
			decoration: const InputDecoration(
				labelText: "premiOther",
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

	Widget buildFieldPremiPar(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiParController,
			decoration: const InputDecoration(
				labelText: "premiPar",
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

	Widget buildFieldPremiRsmdcc(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiRsmdccController,
			decoration: const InputDecoration(
				labelText: "premiRsmdcc",
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

	Widget buildFieldPremiTotal(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTotalController,
			decoration: const InputDecoration(
				labelText: "premiTotal",
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

	Widget buildFieldPremiTsfwd(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTsfwdController,
			decoration: const InputDecoration(
				labelText: "premiTsfwd",
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

	Widget buildFieldRateEqvet(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldRateEqvetController,
			decoration: const InputDecoration(
				labelText: "rateEqvet",
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

	Widget buildFieldRateOther(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldRateOtherController,
			decoration: const InputDecoration(
				labelText: "rateOther",
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

	Widget buildFieldRatePar(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldRateParController,
			decoration: const InputDecoration(
				labelText: "ratePar",
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

	Widget buildFieldRateRsmdcc(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldRateRsmdccController,
			decoration: const InputDecoration(
				labelText: "rateRsmdcc",
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

	Widget buildFieldRateTotal(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldRateTotalController,
			decoration: const InputDecoration(
				labelText: "rateTotal",
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

	Widget buildFieldRateTsfwd(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldRateTsfwdController,
			decoration: const InputDecoration(
				labelText: "rateTsfwd",
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

	Widget buildFieldRkodeposId(){
		return buildFieldComboRKodepos(
			comboKey: comboRKodeposKey,
			labelText: 'rkodeposId',
      kotaId: "",
			initItem: fieldComboRKodepos,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboRKodepos tidak boleh kosong.");
					sppaparCrudBloc.add(ComboRKodeposChangedEvent(comboRKodepos: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRKodepos = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboRKodepos tidak boleh kosong.");
				}
			},
		);
	}
	Widget buildFieldRkonstruksiojkId() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					'Konstruksi',
					style: TextStyle(
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Colors.black87,
					),
				),
				const SizedBox(height: 8),

				DropdownSearch<ComboRKonstruksiojkModel>(
					key: comboRKonstruksiojkKey,
					selectedItem: fieldComboRKonstruksiojk,

					// BORDER & DECORATION
					decoratorProps: DropDownDecoratorProps(
						decoration: InputDecoration(
							hintText: '-- Pilih Konstruksi --',
							hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
							contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.5),
							),
							enabledBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.5),
							),
							focusedBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Color(0xFF91C050), width: 2.0),
							),
							errorBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Colors.red, width: 1.5),
							),
							focusedErrorBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Colors.red, width: 2.0),
							),
							floatingLabelBehavior: FloatingLabelBehavior.never,
						),
					),

					// ASYNC DROPDOWN ITEMS
					items: (filter, _) async {
						return ComboRKonstruksiojkRepository().getComboRKonstruksiojk();
					},

					compareFn: (item, sItem) => item.rkonstruksiojkId == sItem.rkonstruksiojkId,
					itemAsString: (item) => item.kelasNama,

					onChanged: (value) {
						if (value != null) {
							removeError(error: "Field ComboRKonstruksiojk tidak boleh kosong.");
							sppaparCrudBloc.add(
								ComboRKonstruksiojkChangedEvent(comboRKonstruksiojk: value),
							);
						}
					},

					onSaved: (value) {
						if (value != null) {
							fieldComboRKonstruksiojk = value;
						}
					},

					validator: (value) {
						if (value == null) {
							addError(error: "Field ComboRKonstruksiojk tidak boleh kosong.");
							return "Field ComboRKonstruksiojk tidak boleh kosong.";
						}
						return null;
					},

					suffixProps: const DropdownSuffixProps(
						clearButtonProps: ClearButtonProps(isVisible: false),
						dropdownButtonProps: DropdownButtonProps(
							iconClosed: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
							iconOpened: Icon(Icons.keyboard_arrow_up, color: Color(0xFF91C050)),
						),
					),

					popupProps: PopupPropsMultiSelection.modalBottomSheet(
						disableFilter: false,
						showSelectedItems: true,
						showSearchBox: false,
						itemBuilder: itemBuilderComboRKonstruksiojk,
						modalBottomSheetProps: const ModalBottomSheetProps(
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
							),
						),
					),
				),
			],
		);
	}

	Widget buildFieldRokupasiId() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					'Rokupasi',
					style: TextStyle(
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Colors.black87,
					),
				),
				const SizedBox(height: 8),

				DropdownSearch<ComboROkupasiModel>(
					key: comboROkupasiKey,
					selectedItem: fieldComboROkupasi,

					// DESAIN BORDER KONSISTEN
					decoratorProps: DropDownDecoratorProps(
						decoration: InputDecoration(
							hintText: '-- Pilih Rokupasi --',
							hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
							contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.5),
							),
							enabledBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.5),
							),
							focusedBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Color(0xFF91C050), width: 2.0),
							),
							errorBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Colors.red, width: 1.5),
							),
							focusedErrorBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
								borderSide: const BorderSide(color: Colors.red, width: 2.0),
							),
							floatingLabelBehavior: FloatingLabelBehavior.never,
						),
					),

					// LOAD ASYNC DATA
					items: (filter, _) async {
						return ComboROkupasiRepository().getComboROkupasi(filter);
					},

					compareFn: (item, sItem) => item.rokupasiId == sItem.rokupasiId,
					itemAsString: (item) => '${item.kodeOjk} - ${item.okupasiDesc}',

					onChanged: (value) {
						if (value != null) {
							removeError(error: "Field ComboROkupasi tidak boleh kosong.");
							sppaparCrudBloc.add(ComboROkupasiChangedEvent(comboROkupasi: value));
						}
					},

					onSaved: (value) {
						if (value != null) {
							fieldComboROkupasi = value;
						}
					},

					validator: (value) {
						if (value == null) {
							addError(error: "Field ComboROkupasi tidak boleh kosong.");
							return "Field ComboROkupasi tidak boleh kosong.";
						}
						return null;
					},

					suffixProps: const DropdownSuffixProps(
						clearButtonProps: ClearButtonProps(isVisible: false),
						dropdownButtonProps: DropdownButtonProps(
							iconClosed: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
							iconOpened: Icon(Icons.keyboard_arrow_up, color: Color(0xFF91C050)),
						),
					),

					popupProps: PopupPropsMultiSelection.modalBottomSheet(
						disableFilter: false,
						showSelectedItems: true,
						showSearchBox: true,
						itemBuilder: itemBuilderComboROkupasi,
						modalBottomSheetProps: const ModalBottomSheetProps(
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
							),
						),
					),
				),
			],
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

	Widget buildFieldSppaTgl(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldSppaTglController.text),
			decoration: const InputDecoration(
				labelText: "sppaTgl",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
				removeError(error: kStringNullError);
					fieldSppaTglController.text = value.toIso8601String();
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

	Widget buildFieldStockDesc(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldStockDescController,
			decoration: const InputDecoration(
				labelText: "stockDesc",
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
			SppaparCrudModel record = SppaparCrudModel(
				buildingDesc: fieldBuildingDescController.text,
				contentDesc: fieldContentDescController.text,				
				insuredAlamat1: fieldInsuredAlamat1Controller.text,
				insuredAlamat2: fieldInsuredAlamat2Controller.text,
				insuredNama: fieldInsuredNamaController.text,
				kab2zonagempaId: fieldComboMKabZonaGempa?.mkabzonagempaId,
				lokasi1: fieldLokasi1Controller.text,
				lokasi2: fieldLokasi2Controller.text,
				machineryDesc: fieldMachineryDescController.text,
				mwilayahId: fieldComboMWilayah?.mwilayahId,
				otherDesc: fieldOtherDescController.text,
				periodeAkhir: DateTime.parse(fieldPeriodeAkhirController.text),
				periodeMulai: DateTime.parse(fieldPeriodeMulaiController.text),
				premiEqvet: double.parse(fieldPremiEqvetController.text.replaceAll(',', '')),
				premiOther: double.parse(fieldPremiOtherController.text.replaceAll(',', '')),
				premiPar: double.parse(fieldPremiParController.text.replaceAll(',', '')),
				premiRsmdcc: double.parse(fieldPremiRsmdccController.text.replaceAll(',', '')),
				premiTotal: double.parse(fieldPremiTotalController.text.replaceAll(',', '')),
				premiTsfwd: double.parse(fieldPremiTsfwdController.text.replaceAll(',', '')),
				rateEqvet: double.parse(fieldRateEqvetController.text.replaceAll(',', '')),
				rateOther: double.parse(fieldRateOtherController.text.replaceAll(',', '')),
				ratePar: double.parse(fieldRateParController.text.replaceAll(',', '')),
				rateRsmdcc: double.parse(fieldRateRsmdccController.text.replaceAll(',', '')),
				rateTotal: double.parse(fieldRateTotalController.text.replaceAll(',', '')),
				rateTsfwd: double.parse(fieldRateTsfwdController.text.replaceAll(',', '')),
				rkodeposId: fieldComboRKodepos?.rkodeposId,
				rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
				rokupasiId: fieldComboROkupasi?.rokupasiId,
				siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
				siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
				siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
				siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
				siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
				sppaTgl: DateTime.parse(fieldSppaTglController.text),
				sppa1Id: '',
				stockAdjustable: double.parse(fieldStockAdjustableController.text.replaceAll(',', '')),
				stockDesc: fieldStockDescController.text,
				tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
			);
			if (widget.viewMode == "tambah") {
				sppaparCrudBloc.add(SppaparCrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.sppa1Id = sppaparCrudBloc.state.record!.sppa1Id;
				sppaparCrudBloc.add(SppaparCrudUbahEvent(record: record));
			}
			//_dismissDialog();
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
