// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/widgets/form_error.dart';
// import 'package:joss_app/blocs/gen_regmv/regmv3form_bloc.dart';
// import 'package:joss_app/models/gen_regmv/regmv3form_model.dart';
// import 'package:joss_app/models/combobox/combommvmerk_model.dart';
// import 'package:joss_app/widgets/combobox/combommvmerk_widget.dart';
// import 'package:joss_app/models/combobox/combommvmodel_model.dart';
// import 'package:joss_app/widgets/combobox/combommvmodel_widget.dart';
// import 'package:joss_app/models/combobox/combommvpakai_model.dart';
// import 'package:joss_app/widgets/combobox/combommvpakai_widget.dart';
// import 'package:joss_app/models/combobox/combommvtipe_model.dart';
// import 'package:joss_app/widgets/combobox/combommvtipe_widget.dart';
// import 'package:joss_app/models/combobox/combomwarna_model.dart';
// import 'package:joss_app/widgets/combobox/combomwarna_widget.dart';
// import 'package:joss_app/models/combobox/combomwilayah_model.dart';
// import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:joss_app/common/thousand_separator_input_formatter.dart';
// import 'package:dropdown_search/dropdown_search.dart';
//
//
// class Regmv3FormFormPage extends StatefulWidget {
// 	final String viewMode;
// 	final String recordId;
//
// 	const Regmv3FormFormPage({super.key, required this.viewMode, required this.recordId});
//
// 	@override
// 	Regmv3FormFormPageFormState createState() => Regmv3FormFormPageFormState();
// }
//
// class Regmv3FormFormPageFormState extends State<Regmv3FormFormPage> {
// 	late Regmv3FormBloc regmv3FormBloc;
// 	final _formKey = GlobalKey<FormState>();
// 	final List<String> errors = [];
// 	var fieldAksesorisController = TextEditingController();
// 	var fieldHargaController = TextEditingController();
// 	var fieldMesinNoController = TextEditingController();
// 	ComboMMvmerkModel? fieldComboMMvmerk;
// 	final comboMMvmerkKey = GlobalKey<DropdownSearchState<ComboMMvmerkModel>>();
// 	ComboMMvmodelModel? fieldComboMMvmodel;
// 	final comboMMvmodelKey = GlobalKey<DropdownSearchState<ComboMMvmodelModel>>();
// 	ComboMMvpakaiModel? fieldComboMMvpakai;
// 	final comboMMvpakaiKey = GlobalKey<DropdownSearchState<ComboMMvpakaiModel>>();
// 	ComboMMvtipeModel? fieldComboMMvtipe;
// 	final comboMMvtipeKey = GlobalKey<DropdownSearchState<ComboMMvtipeModel>>();
// 	ComboMWarnaModel? fieldComboMWarna;
// 	final comboMWarnaKey = GlobalKey<DropdownSearchState<ComboMWarnaModel>>();
// 	ComboMWilayahModel? fieldComboMWilayah;
// 	final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
// 	var fieldPlatNoController = TextEditingController();
// 	var fieldRangkaNoController = TextEditingController();
// 	var fieldThnBuatController = TextEditingController();
//
// 	@override
// 	void initState() {
// 		super.initState();
// 		Future.delayed(const Duration(milliseconds: 500), () {
// 			loadData();
// 		});
// 	}
//
// 	@override
// 	Widget build(BuildContext context) {
// 		regmv3FormBloc = BlocProvider.of<Regmv3FormBloc>(context);
// 		return BlocConsumer<Regmv3FormBloc, Regmv3FormState>(
// 			builder: (context, state) {
// 				return Dialog(
// 						shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// 						child: SingleChildScrollView(
// 							child: Padding(
// 								padding: const EdgeInsets.all(8.0),
// 								child: Form(
// 										key: _formKey,
// 										child: Column(
// 											children: [
// 												const SizedBox(height: 10),
// 												Text(
// 													"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Data Kendaraan",
// 													style: const TextStyle(
// 														fontSize: 20.0,
// 														color: Color(0xffff6101),
// 														fontWeight: FontWeight.w600,
// 														fontFamily: 'Hind',
// 														fontStyle: FontStyle.italic,
// 														decoration: TextDecoration.underline,
// 													),
// 												),
// 												const SizedBox(height: 25),
// 												buildFieldAksesoris(),
// 												buildFieldHarga(),
// 												buildFieldMesinNo(),
// 												buildFieldMmvmerkId(),
// 												buildFieldMmvmodelId(),
// 												buildFieldMmvpakaiId(),
// 												buildFieldMmvtipeId(),
// 												buildFieldMwarnaId(),
// 												buildFieldMwilayahId(),
// 												buildFieldPlatNo(),
// 												buildFieldRangkaNo(),
// 												buildFieldRegmv1Id(),
// 												buildFieldThnBuat(),
// 												const SizedBox(height: 25),
// 												FormError(
// 													errors: errors,
// 													key: null,
// 												),
// 												Row(
// 													mainAxisAlignment: MainAxisAlignment.spaceAround,
// 													children: [
// 														SizedBox(
// 															width: MediaQuery.of(context).size.width * 0.3,
// 															height: 60,
// 															child: Padding(
// 																padding: const EdgeInsets.only(top: 30.0),
// 																child: ElevatedButton(
// 																	onPressed: () {
// 																		_dismissDialog();
// 																	},
// 																	child: const Text(
// 																		'Close',
// 																		style: TextStyle(fontSize: 13.0),
// 																	),
// 																),
// 															),
// 														),
// 														SizedBox(
// 															width: MediaQuery.of(context).size.width * 0.3,
// 															height: 60,
// 															child: Padding(
// 																padding: const EdgeInsets.only(top: 30.0),
// 																child: ElevatedButton(
// 																	onPressed: () {
// 																		onSaveForm();
// 																	},
// 																	child: const Text(
// 																		'Save',
// 																		style: TextStyle(fontSize: 13.0),
// 																	),
// 																),
// 															),
// 														),
// 													],
// 												),
// 											],
// 										)),
// 							),
// 						));
// 			},
// 			listener: (context, state) {
// 				if (state.isLoaded) {
// 					if (state.record != null){
// 						fieldAksesorisController.text = state.record!.aksesoris;
// 						fieldHargaController.text = NumberFormat("#,###").format(state.record!.harga);
// 						fieldMesinNoController.text = state.record!.mesinNo;
// 						fieldPlatNoController.text = state.record!.platNo;
// 						fieldRangkaNoController.text = state.record!.rangkaNo;
// 						fieldThnBuatController.text = state.record!.thnBuat.toString();
// 					}
// 					fieldComboMMvmerk = state.comboMMvmerk;
// 					fieldComboMMvmodel = state.comboMMvmodel;
// 					fieldComboMMvpakai = state.comboMMvpakai;
// 					fieldComboMMvtipe = state.comboMMvtipe;
// 					fieldComboMWarna = state.comboMWarna;
// 					fieldComboMWilayah = state.comboMWilayah;
// 				}
// 			},
// 		);
// 	}
// 	void loadData() {
// 		if (widget.viewMode == "ubah") {
// 			regmv3FormBloc.add(
// 					Regmv3FormLihatEvent(recordId: widget.recordId));
// 		}
// 	}
//
// 	Widget buildFieldAksesoris(){
// 		return TextFormField(
// 			keyboardType: TextInputType.multiline,
// 			minLines: 1,
// 			maxLines: 3,
// 			controller: fieldAksesorisController,
// 			decoration: const InputDecoration(
// 				labelText: "aksesoris",
// 				floatingLabelBehavior: FloatingLabelBehavior.always,
// 			),
// 			onChanged: (value) {
// 				if (value.isNotEmpty) {
// 					removeError(error: kStringNullError);
// 				}
// 			},
// 			validator: (value) {
// 				if (value == null || value.isEmpty) {
// 					addError(error: kStringNullError);
// 					return "";
// 				}
// 				return null;
// 			},
// 		);
// 	}
//
// 	Widget buildFieldHarga(){
// 		return TextFormField(
// 			keyboardType: TextInputType.number,
// 			inputFormatters: [ThousandsSeparatorInputFormatter()],
// 			controller: fieldHargaController,
// 			decoration: const InputDecoration(
// 				labelText: "harga",
// 				floatingLabelBehavior: FloatingLabelBehavior.always,
// 			),
// 			onChanged: (value) {
// 				if (value.isNotEmpty) {
// 					removeError(error: kStringNullError);
// 				}
// 			},
// 			validator: (value) {
// 				if (value == null || value.isEmpty) {
// 					addError(error: kStringNullError);
// 					return "";
// 				}
// 				return null;
// 			},
// 			textAlign: TextAlign.right,
// 		);
// 	}
//
// 	Widget buildFieldMesinNo(){
// 		return TextFormField(
// 			controller: fieldMesinNoController,
// 			decoration: const InputDecoration(
// 				labelText: "mesinNo",
// 				floatingLabelBehavior: FloatingLabelBehavior.always,
// 			),
// 			onChanged: (value) {
// 				if (value.isNotEmpty) {
// 					removeError(error: kStringNullError);
// 				}
// 			},
// 			validator: (value) {
// 				if (value == null || value.isEmpty) {
// 					addError(error: kStringNullError);
// 					return "";
// 				}
// 				return null;
// 			},
// 		);
// 	}
//
// 	Widget buildFieldMmvmerkId(){
// 		return buildFieldComboMMvmerk(
// 			comboKey: comboMMvmerkKey,
// 			labelText: 'mmvmerkId',
// 			initItem: fieldComboMMvmerk,
// 			onChangedCallback: (value) {
// 				if (value != null) {
// 					removeError(
// 							error: "Field ComboMMvmerk tidak boleh kosong.");
// 					regmv3FormBloc.add(ComboMMvmerkChangedEvent(comboMMvmerk: value));
// 				}
// 			},
// 			onSaveCallback: (value) {
// 				if (value != null) {
// 					fieldComboMMvmerk = value;
// 				}
// 			},
// 			validatorCallback: (value) {
// 				if (value == null) {
// 					addError(
// 							error: "Field ComboMMvmerk tidak boleh kosong.");
// 				}
// 			},
// 		);
// 	}
//
// 	Widget buildFieldMmvmodelId(){
// 		return buildFieldComboMMvmodel(
// 			comboKey: comboMMvmodelKey,
// 			labelText: 'mmvmodelId',
// 			initItem: fieldComboMMvmodel,
// 			mvtipeId: fieldComboMMvtipe?.mmvtipeId??'',
// 			onChangedCallback: (value) {
// 				if (value != null) {
// 					removeError(
// 							error: "Field ComboMMvmodel tidak boleh kosong.");
// 					regmv3FormBloc.add(ComboMMvmodelChangedEvent(comboMMvmodel: value));
// 				}
// 			},
// 			onSaveCallback: (value) {
// 				if (value != null) {
// 					fieldComboMMvmodel = value;
// 				}
// 			},
// 			validatorCallback: (value) {
// 				if (value == null) {
// 					addError(
// 							error: "Field ComboMMvmodel tidak boleh kosong.");
// 				}
// 			},
// 		);
// 	}
//
// 	Widget buildFieldMmvpakaiId(){
// 		return buildFieldComboMMvpakai(
// 			comboKey: comboMMvpakaiKey,
// 			labelText: 'mmvpakaiId',
// 			initItem: fieldComboMMvpakai,
// 			onChangedCallback: (value) {
// 				if (value != null) {
// 					removeError(
// 							error: "Field ComboMMvpakai tidak boleh kosong.");
// 					regmv3FormBloc.add(ComboMMvpakaiChangedEvent(comboMMvpakai: value));
// 				}
// 			},
// 			onSaveCallback: (value) {
// 				if (value != null) {
// 					fieldComboMMvpakai = value;
// 				}
// 			},
// 			validatorCallback: (value) {
// 				if (value == null) {
// 					addError(
// 							error: "Field ComboMMvpakai tidak boleh kosong.");
// 				}
// 			},
// 		);
// 	}
//
// 	Widget buildFieldMmvtipeId(){
// 		return buildFieldComboMMvtipe(
// 			comboKey: comboMMvtipeKey,
// 			labelText: 'mmvtipeId',
// 			initItem: fieldComboMMvtipe,
// 			mvmerkId: fieldComboMMvmerk?.mmvmerkId??'',
// 			onChangedCallback: (value) {
// 				if (value != null) {
// 					removeError(
// 							error: "Field ComboMMvtipe tidak boleh kosong.");
// 					regmv3FormBloc.add(ComboMMvtipeChangedEvent(comboMMvtipe: value));
// 				}
// 			},
// 			onSaveCallback: (value) {
// 				if (value != null) {
// 					fieldComboMMvtipe = value;
// 				}
// 			},
// 			validatorCallback: (value) {
// 				if (value == null) {
// 					addError(
// 							error: "Field ComboMMvtipe tidak boleh kosong.");
// 				}
// 			},
// 		);
// 	}
//
// 	Widget buildFieldMwarnaId(){
// 		return buildFieldComboMWarna(
// 			comboKey: comboMWarnaKey,
// 			labelText: 'mwarnaId',
// 			initItem: fieldComboMWarna,
// 			onChangedCallback: (value) {
// 				if (value != null) {
// 					removeError(
// 							error: "Field ComboMWarna tidak boleh kosong.");
// 					regmv3FormBloc.add(ComboMWarnaChangedEvent(comboMWarna: value));
// 				}
// 			},
// 			onSaveCallback: (value) {
// 				if (value != null) {
// 					fieldComboMWarna = value;
// 				}
// 			},
// 			validatorCallback: (value) {
// 				if (value == null) {
// 					addError(
// 							error: "Field ComboMWarna tidak boleh kosong.");
// 				}
// 			},
// 		);
// 	}
//
// 	Widget buildFieldMwilayahId(){
// 		return buildFieldComboMWilayah(
// 			comboKey: comboMWilayahKey,
// 			labelText: 'mwilayahId',
// 			initItem: fieldComboMWilayah,
// 			onChangedCallback: (value) {
// 				if (value != null) {
// 					removeError(
// 							error: "Field ComboMWilayah tidak boleh kosong.");
// 					regmv3FormBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
// 				}
// 			},
// 			onSaveCallback: (value) {
// 				if (value != null) {
// 					fieldComboMWilayah = value;
// 				}
// 			},
// 			validatorCallback: (value) {
// 				if (value == null) {
// 					addError(
// 							error: "Field ComboMWilayah tidak boleh kosong.");
// 				}
// 			},
// 		);
// 	}
//
// 	Widget buildFieldPlatNo(){
// 		return TextFormField(
// 			controller: fieldPlatNoController,
// 			decoration: const InputDecoration(
// 				labelText: "platNo",
// 				floatingLabelBehavior: FloatingLabelBehavior.always,
// 			),
// 			onChanged: (value) {
// 				if (value.isNotEmpty) {
// 					removeError(error: kStringNullError);
// 				}
// 			},
// 			validator: (value) {
// 				if (value == null || value.isEmpty) {
// 					addError(error: kStringNullError);
// 					return "";
// 				}
// 				return null;
// 			},
// 		);
// 	}
//
// 	Widget buildFieldRangkaNo(){
// 		return TextFormField(
// 			controller: fieldRangkaNoController,
// 			decoration: const InputDecoration(
// 				labelText: "rangkaNo",
// 				floatingLabelBehavior: FloatingLabelBehavior.always,
// 			),
// 			onChanged: (value) {
// 				if (value.isNotEmpty) {
// 					removeError(error: kStringNullError);
// 				}
// 			},
// 			validator: (value) {
// 				if (value == null || value.isEmpty) {
// 					addError(error: kStringNullError);
// 					return "";
// 				}
// 				return null;
// 			},
// 		);
// 	}
//
// 	Widget buildFieldRegmv1Id(){
// 		return TextFormField(
// 		);
// 	}
//
// 	Widget buildFieldThnBuat(){
// 		return TextFormField(
// 			keyboardType: TextInputType.number,
// 			inputFormatters: [ThousandsSeparatorInputFormatter()],
// 			controller: fieldThnBuatController,
// 			decoration: const InputDecoration(
// 				labelText: "thnBuat",
// 				floatingLabelBehavior: FloatingLabelBehavior.always,
// 			),
// 			onChanged: (value) {
// 				if (value.isNotEmpty) {
// 					removeError(error: kStringNullError);
// 				}
// 			},
// 			validator: (value) {
// 				if (value == null || value.isEmpty) {
// 					addError(error: kStringNullError);
// 					return "";
// 				}
// 				return null;
// 			},
// 			textAlign: TextAlign.right,
// 		);
// 	}
//
// 	void _dismissDialog() {
// 		Navigator.pop(context);
// 	}
//
// 	void onSaveForm() {
// 		if (_formKey.currentState!.validate()) {
// 			_formKey.currentState!.save();
// 			Regmv3FormModel record = Regmv3FormModel(
// 				regmv1Id: parentRegmv1Id,
// 				aksesoris: fieldAksesorisController.text,
// 				harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
// 				mesinNo: fieldMesinNoController.text,
// 				mmvmerkId: fieldComboMMvmerk?.mmvmerkId,
// 				mmvmodelId: fieldComboMMvmodel?.mmvmodelId,
// 				mmvpakaiId: fieldComboMMvpakai?.mmvpakaiId,
// 				mmvtipeId: fieldComboMMvtipe?.mmvtipeId,
// 				mwarnaId: fieldComboMWarna?.mwarnaId,
// 				mwilayahId: fieldComboMWilayah?.mwilayahId,
// 				platNo: fieldPlatNoController.text,
// 				rangkaNo: fieldRangkaNoController.text,
// 				regmv3Id: '',
// 				thnBuat: int.parse(fieldThnBuatController.text),
// 			);
// 			if (widget.viewMode == "tambah") {
// 				regmv3FormBloc.add(Regmv3FormTambahEvent(record: record));
// 			} else if (widget.viewMode == "ubah") {
// 				record.regmv3Id = regmv3FormBloc.state.record!.regmv3Id;
// 				regmv3FormBloc.add(Regmv3FormUbahEvent(record: record));
// 			}
// 			_dismissDialog();
// 		}
// 	}
//
// 	void addError({required String error}) {
// 		if (!errors.contains(error)){
// 			setState(() {
// 				errors.add(error);
// 			});
// 		}
// 	}
//
// 	void removeError({required String error}) {
// 		if (errors.contains(error)){
// 			setState(() {
// 				errors.remove(error);
// 			});
// 		}
// 	}
//
// }
