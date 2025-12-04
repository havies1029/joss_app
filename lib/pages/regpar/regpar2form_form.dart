import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regpar/regpar2form_bloc.dart';
import 'package:joss_app/models/regpar/regpar2form_model.dart';
import 'package:joss_app/models/combobox/combomkecamatan_model.dart';
import 'package:joss_app/widgets/combobox/combomkecamatan_widget.dart';
import 'package:joss_app/models/combobox/combomkelurahan_model.dart';
import 'package:joss_app/widgets/combobox/combomkelurahan_widget.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/widgets/combobox/combomkota_widget.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/widgets/combobox/combompropinsi_widget.dart';
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
	var fieldObjectAlamatController = TextEditingController();
	ComboMKecamatanModel? fieldComboMKecamatan;
	final comboMKecamatanKey = GlobalKey<DropdownSearchState<ComboMKecamatanModel>>();
	ComboMKelurahanModel? fieldComboMKelurahan;
	final comboMKelurahanKey = GlobalKey<DropdownSearchState<ComboMKelurahanModel>>();
	ComboMKotaModel? fieldComboMKota;
	final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
	ComboMPropinsiModel? fieldComboMPropinsi;
	final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
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
													"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Reg PAR #2",
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
												buildFieldPolisMulai(),
												buildFieldPolisAkhir(),
												buildFieldObjectPropinsiId(),
												buildFieldObjectKotaId(),
												buildFieldObjectKecamatanId(),
												buildFieldObjectKelurahanId(),
												buildFieldObjectAlamat(),
												buildFieldRokupasiId(),
												buildFieldRkonstruksiojkId(),
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
					if (state.record != null){fieldObjectAlamatController.text = state.record!.objectAlamat;
					fieldPolisAkhirController.text = state.record!.polisAkhir.toIso8601String();
					fieldPolisMulaiController.text = state.record!.polisMulai.toIso8601String();
					}
					fieldComboMKecamatan = state.comboMKecamatan;
					fieldComboMKelurahan = state.comboMKelurahan;
					fieldComboMKota = state.comboMKota;
					fieldComboMPropinsi = state.comboMPropinsi;
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

	Widget buildFieldObjectAlamat(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldObjectAlamatController,
			decoration: const InputDecoration(
				labelText: "objectAlamat",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
					regpar2FormBloc.add(FieldObjectAlamatChangedEvent(objectAlamat: value));
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

	Widget buildFieldObjectKecamatanId(){
		return buildFieldComboMKecamatan(
			comboKey: comboMKecamatanKey,
			labelText: 'objectKecamatanId',
			initItem: fieldComboMKecamatan,
			kotaId: fieldComboMKota?.mkotaId ?? '',
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboMKecamatan tidak boleh kosong.");
					regpar2FormBloc.add(ComboMKecamatanChangedEvent(comboMKecamatan: value));
					comboMKelurahanKey.currentState?.changeSelectedItem(null);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMKecamatan = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Field ComboMKecamatan tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldObjectKelurahanId(){
		return buildFieldComboMKelurahan(
			comboKey: comboMKelurahanKey,
			labelText: 'objectKelurahanId',
			initItem: fieldComboMKelurahan,
			kecamatanId: fieldComboMKecamatan?.mkecamatanId ?? '',
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboMKelurahan tidak boleh kosong.");
					regpar2FormBloc.add(ComboMKelurahanChangedEvent(comboMKelurahan: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMKelurahan = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Field ComboMKelurahan tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldObjectKotaId(){
		return buildFieldComboMKota(
			comboKey: comboMKotaKey,
			labelText: 'objectKotaId',
			initItem: fieldComboMKota,
			propinsiId: fieldComboMPropinsi?.mpropinsiId ?? '',
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboMKota tidak boleh kosong.");
					regpar2FormBloc.add(ComboMKotaChangedEvent(comboMKota: value));
					comboMKecamatanKey.currentState?.changeSelectedItem(null);
					comboMKelurahanKey.currentState?.changeSelectedItem(null);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMKota = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Field ComboMKota tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldObjectPropinsiId(){
		return buildFieldComboMPropinsi(
			comboKey: comboMPropinsiKey,
			labelText: 'objectPropinsiId',
			initItem: fieldComboMPropinsi,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboMPropinsi tidak boleh kosong.");
					regpar2FormBloc.add(ComboMPropinsiChangedEvent(comboMPropinsi: value));
					comboMKotaKey.currentState?.changeSelectedItem(null);
					comboMKecamatanKey.currentState?.changeSelectedItem(null);
					comboMKelurahanKey.currentState?.changeSelectedItem(null);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMPropinsi = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Field ComboMPropinsi tidak boleh kosong.");
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
					regpar2FormBloc.add(FieldPolisAkhirChangedEvent(polisAkhir: value));
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

					regpar2FormBloc.add(FieldPolisMulaiChangedEvent(polisMulai: value));
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
				regpar1Id: widget.recordId,
				objectAlamat: fieldObjectAlamatController.text,
				objectKecamatanId: fieldComboMKecamatan?.mkecamatanId,
				objectKelurahanId: fieldComboMKelurahan?.mkelurahanId,
				objectKotaId: fieldComboMKota?.mkotaId,
				objectPropinsiId: fieldComboMPropinsi?.mpropinsiId,
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