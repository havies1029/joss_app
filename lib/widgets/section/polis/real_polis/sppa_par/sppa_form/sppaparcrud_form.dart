import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_sppapar/sppaparcrud_bloc.dart';
import 'package:joss_app/models/gen_sppapar/sppaparcrud_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/widgets/combobox/comborkodepos_widget.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../../blocs/local_prefs/simulasi_par_local_cubit.dart';
import '../../../../../../repositories/combobox/combomkabzonagempa_repository.dart';
import '../../../../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../../../../repositories/combobox/comborkonstruksiojk_repository.dart';
import '../../../../../../repositories/combobox/comborokupasi_repository.dart';

class SppaparFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const SppaparFormPage({
		super.key,
		required this.viewMode,
		required this.recordId
	});

	@override
	SppaparFormPageState createState() => SppaparFormPageState();
}

class SppaparFormPageState extends State<SppaparFormPage> {
	late SppaparCrudBloc sppaparCrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];

	// Text Controllers - Basic Info
	var fieldInsuredNamaController = TextEditingController();
	var fieldInsuredAlamat1Controller = TextEditingController();
	var fieldInsuredAlamat2Controller = TextEditingController();
	var fieldLokasi1Controller = TextEditingController();
	var fieldLokasi2Controller = TextEditingController();

	// Date Controllers
	var fieldSppaTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());

	// Coverage Controllers
	var fieldBuildingDescController = TextEditingController();
	var fieldContentDescController = TextEditingController();
	var fieldMachineryDescController = TextEditingController();
	var fieldStockDescController = TextEditingController();
	var fieldOtherDescController = TextEditingController();

	// Sum Insured Controllers
	var fieldSiBuildingController = TextEditingController();
	var fieldSiContentController = TextEditingController();
	var fieldSiMachineryController = TextEditingController();
	var fieldSiStockController = TextEditingController();
	var fieldSiOtherController = TextEditingController();
	var fieldTsiController = TextEditingController();
	var fieldStockAdjustableController = TextEditingController();

	// Rate Controllers
	var fieldRateParController = TextEditingController();
	var fieldRateEqvetController = TextEditingController();
	var fieldRateRsmdccController = TextEditingController();
	var fieldRateTsfwdController = TextEditingController();
	var fieldRateOtherController = TextEditingController();
	var fieldRateTotalController = TextEditingController();

	// Premium Controllers
	var fieldPremiParController = TextEditingController();
	var fieldPremiEqvetController = TextEditingController();
	var fieldPremiRsmdccController = TextEditingController();
	var fieldPremiTsfwdController = TextEditingController();
	var fieldPremiOtherController = TextEditingController();
	var fieldPremiTotalController = TextEditingController();

	// Combo Fields
	ComboMWilayahModel? fieldComboMWilayah;
	final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

	ComboRKodeposModel? fieldComboRKodepos;
	final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();

	ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
	final comboMKabZonaGempaKey = GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();

	ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
	final comboRKonstruksiojkKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();

	ComboROkupasiModel? fieldComboROkupasi;
	final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();

	@override
	void initState() {
		super.initState();

		// 🔥 Ambil isi dari SimulasiParLocalCubit dan set controller + dropdown
		Future.delayed(Duration.zero, () {
			final simul = context.read<SimulasiParLocalCubit>().state;

			// === Text Field (SI) ===
			fieldSiBuildingController.text = simul.siBuilding?.toString() ?? '';
			fieldSiContentController.text = simul.siContent?.toString() ?? '';
			fieldSiMachineryController.text = simul.siMachinery?.toString() ?? '';
			fieldSiStockController.text = simul.siStock?.toString() ?? '';
			fieldSiOtherController.text = simul.siOther?.toString() ?? '';
			fieldStockAdjustableController.text = simul.stockAdjustable?.toString() ?? '';

			// === Rate Field ===
			fieldRateParController.text = simul.ratePar?.toString() ?? '';
			fieldRateEqvetController.text = simul.rateEqvet?.toString() ?? '';
			fieldRateRsmdccController.text = simul.rateRsmdcc?.toString() ?? '';
			fieldRateTsfwdController.text = simul.rateTsfwd?.toString() ?? '';
			fieldRateOtherController.text = simul.rateOther?.toString() ?? '';
			fieldRateTotalController.text = simul.rateTotal?.toString() ?? '';

			// === Premi Field ===
			fieldPremiEqvetController.text = simul.premiEqvet?.toString() ?? '';
			fieldPremiRsmdccController.text = simul.premiRsmdcc?.toString() ?? '';
			fieldPremiTsfwdController.text = simul.premiTsfwd?.toString() ?? '';
			fieldPremiOtherController.text = simul.premiOther?.toString() ?? '';
			fieldPremiTotalController.text = simul.premiTotal?.toString() ?? '';

			// === Combo Fields ===
			if (simul.wilayah != null) {
				comboMWilayahKey.currentState?.changeSelectedItem(simul.wilayah!);
			}
			if (simul.zonaGempa != null) {
				comboMKabZonaGempaKey.currentState?.changeSelectedItem(simul.zonaGempa!);
			}
			if (simul.konstruksi != null) {
				comboRKonstruksiojkKey.currentState?.changeSelectedItem(simul.konstruksi!);
			}
			if (simul.okupasi != null) {
				comboROkupasiKey.currentState?.changeSelectedItem(simul.okupasi!);
			}
		});

		// 🌀 Load Data SPPA PAR seperti biasa
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}


	@override
	void dispose() {
		// Dispose all text controllers
		fieldInsuredNamaController.dispose();
		fieldInsuredAlamat1Controller.dispose();
		fieldInsuredAlamat2Controller.dispose();
		fieldLokasi1Controller.dispose();
		fieldLokasi2Controller.dispose();
		fieldSppaTglController.dispose();
		fieldPeriodeMulaiController.dispose();
		fieldPeriodeAkhirController.dispose();
		fieldBuildingDescController.dispose();
		fieldContentDescController.dispose();
		fieldMachineryDescController.dispose();
		fieldStockDescController.dispose();
		fieldOtherDescController.dispose();
		fieldSiBuildingController.dispose();
		fieldSiContentController.dispose();
		fieldSiMachineryController.dispose();
		fieldSiStockController.dispose();
		fieldSiOtherController.dispose();
		fieldTsiController.dispose();
		fieldStockAdjustableController.dispose();
		fieldRateParController.dispose();
		fieldRateEqvetController.dispose();
		fieldRateRsmdccController.dispose();
		fieldRateTsfwdController.dispose();
		fieldRateOtherController.dispose();
		fieldRateTotalController.dispose();
		fieldPremiParController.dispose();
		fieldPremiEqvetController.dispose();
		fieldPremiRsmdccController.dispose();
		fieldPremiTsfwdController.dispose();
		fieldPremiOtherController.dispose();
		fieldPremiTotalController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		sppaparCrudBloc = BlocProvider.of<SppaparCrudBloc>(context);
		return BlocConsumer<SppaparCrudBloc, SppaparCrudState>(
			builder: (context, state) {
				return Form(
						key: _formKey,
						child: Column(
							children: [
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

	Widget buildFieldBuildingDesc() {
		return appTextField(
			label: "Building Description",
			hint: "Masukkan deskripsi bangunan...",
			controller: fieldBuildingDescController,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldContentDesc() {
		return appTextField(
			label: "Content Description",
			hint: "Masukkan deskripsi konten...",
			controller: fieldContentDescController,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldInsuredAlamat1() {
		return appTextField(
			label: "Alamat Tertanggung 1",
			hint: "Masukkan alamat pertama tertanggung...",
			controller: fieldInsuredAlamat1Controller,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldInsuredAlamat2() {
		return appTextField(
			label: "Alamat Tertanggung 2",
			hint: "Masukkan alamat kedua tertanggung...",
			controller: fieldInsuredAlamat2Controller,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldInsuredNama() {
		return appTextField(
			label: "Nama Tertanggung",
			hint: "Masukkan nama tertanggung...",
			controller: fieldInsuredNamaController,
			keyboardType: TextInputType.name,
			maxLines: 1,
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

	Widget buildFieldKab2zonagempaId() {
		return ReusableComboBox<ComboMKabZonaGempaModel>(
			hintText: "Kabupaten Zona Gempa",
			comboKey: comboMKabZonaGempaKey,
			initItem: fieldComboMKabZonaGempa,
			dataLoader: () async => ComboMKabZonaGempaRepository().getComboMKabZonaGempa(''),
			displayText: (item) => "${item.mzonagempaId} - ${item.kabupaten}",
			compareItems: (a, b) => a.mkabzonagempaId == b.mkabzonagempaId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field ComboMKabZonaGempa tidak boleh kosong.");
					sppaparCrudBloc.add(
						ComboMKabZonaGempaChangedEvent(comboMKabZonaGempa: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMKabZonaGempa = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field ComboMKabZonaGempa tidak boleh kosong.");
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldLokasi1() {
		return appTextField(
			label: "Lokasi 1",
			hint: "Masukkan lokasi pertama...",
			controller: fieldLokasi1Controller,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldLokasi2() {
		return appTextField(
			label: "Lokasi 2",
			hint: "Masukkan lokasi kedua...",
			controller: fieldLokasi2Controller,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldMachineryDesc() {
		return appTextField(
			label: "Deskripsi Mesin",
			hint: "Masukkan deskripsi mesin...",
			controller: fieldMachineryDescController,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldMwilayahId() {
		return ReusableComboBox<ComboMWilayahModel>(
			hintText: "Wilayah",
			comboKey: comboMWilayahKey,
			initItem: fieldComboMWilayah,
			dataLoader: () async => ComboMWilayahRepository().getComboMWilayah(),
			displayText: (item) => item.wilayahNama,
			compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field ComboMWilayah tidak boleh kosong.");
					sppaparCrudBloc.add(
						ComboMWilayahChangedEvent(comboMWilayah: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMWilayah = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field ComboMWilayah tidak boleh kosong.");
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldOtherDesc() {
		return appTextField(
			label: "Deskripsi Lainnya",
			hint: "Masukkan deskripsi lainnya...",
			controller: fieldOtherDescController,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldPeriodeAkhir() {
		return AppDateField(
			label: "Periode Akhir",
			initialValue: DateTime.tryParse(fieldPeriodeAkhirController.text),
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
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

	Widget buildFieldPeriodeMulai() {
		return AppDateField(
			label: "Periode Mulai",
			initialValue: DateTime.tryParse(fieldPeriodeMulaiController.text),
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
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

	Widget buildFieldPremiEqvet() {
		return appTextField(
			label: "Premi EQVET",
			hint: "Masukkan nilai premi EQVET...",
			controller: fieldPremiEqvetController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldPremiOther() {
		return appTextField(
			label: "Premi Lainnya",
			hint: "Masukkan nilai premi lainnya...",
			controller: fieldPremiOtherController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldPremiPar() {
		return appTextField(
			label: "Premi PAR",
			controller: fieldPremiParController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldPremiRsmdcc() {
		return appTextField(
			label: "Premi RSMDCC",
			controller: fieldPremiRsmdccController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldPremiTotal() {
		return appTextField(
			label: "Premi Total",
			controller: fieldPremiTotalController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldPremiTsfwd() {
		return appTextField(
			label: "Premi T/S/FWD",
			controller: fieldPremiTsfwdController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldRateEqvet() {
		return appTextField(
			label: "Rate EQVET",
			controller: fieldRateEqvetController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldRateOther() {
		return appTextField(
			label: "Rate Other",
			controller: fieldRateOtherController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldRatePar() {
		return appTextField(
			label: "Rate PAR",
			controller: fieldRateParController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldRateRsmdcc() {
		return appTextField(
			label: "Rate RSM/DCC",
			controller: fieldRateRsmdccController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldRateTotal() {
		return appTextField(
			label: "Rate Total",
			controller: fieldRateTotalController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldRateTsfwd() {
		return appTextField(
			label: "Rate T/S/FWD",
			controller: fieldRateTsfwdController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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
		return ReusableComboBox<ComboRKonstruksiojkModel>(
			hintText: 'Konstruksi',
			comboKey: comboRKonstruksiojkKey,
			initItem: fieldComboRKonstruksiojk,
			dataLoader: () async {
				return ComboRKonstruksiojkRepository().getComboRKonstruksiojk(fieldComboROkupasi?.rokupasiId ?? "");
			},
			displayText: (item) => item.kelasNama,
			compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Konstruksi tidak boleh kosong.");
					sppaparCrudBloc.add(
						ComboRKonstruksiojkChangedEvent(comboRKonstruksiojk: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRKonstruksiojk = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Konstruksi tidak boleh kosong.");
					return "Field Konstruksi tidak boleh kosong.";
				}
				return null;
			},
		);
	}

	Widget buildFieldRokupasiId() {
		return ReusableComboBox<ComboROkupasiModel>(
			hintText: 'Rokupasi',
			comboKey: comboROkupasiKey,
			initItem: fieldComboROkupasi,
			dataLoader: () async {
				return ComboROkupasiRepository().getComboROkupasi('');
			},
			displayText: (item) => '${item.kodeOjk} - ${item.okupasiDesc}',
			compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Rokupasi tidak boleh kosong.");
					sppaparCrudBloc.add(
						ComboROkupasiChangedEvent(comboROkupasi: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboROkupasi = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Rokupasi tidak boleh kosong.");
					return "Field Rokupasi tidak boleh kosong.";
				}
				return null;
			},
		);
	}

	Widget buildFieldSiBuilding() {
		return appTextField(
			label: "SI Building",
			controller: fieldSiBuildingController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldSiContent() {
		return appTextField(
			label: "SI Content",
			controller: fieldSiContentController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldSiMachinery() {
		return appTextField(
			label: "SI Machinery",
			controller: fieldSiMachineryController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldSiOther() {
		return appTextField(
			label: "SI Other",
			controller: fieldSiOtherController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldSiStock() {
		return appTextField(
			label: "SI Stock",
			controller: fieldSiStockController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.done,
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

	Widget buildFieldSppaTgl() {
		return AppDateField(
			label: "SPPA Tanggal",
			initialValue: DateTime.tryParse(fieldSppaTglController.text),
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
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

	Widget buildFieldStockAdjustable() {
		return appTextField(
			label: "Stock Adjustable",
			controller: fieldStockAdjustableController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldStockDesc() {
		return appTextField(
			label: "Stock Description",
			controller: fieldStockDescController,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
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

	Widget buildFieldTsi() {
		return appTextField(
			label: "TSI",
			controller: fieldTsiController,
			keyboardType: TextInputType.number,
			textInputAction: TextInputAction.next,
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
