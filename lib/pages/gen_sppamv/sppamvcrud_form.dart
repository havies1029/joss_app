import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'package:joss_app/models/gen_sppamv/sppamvcrud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/widgets/combobox/combommvgrupojk_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/widgets/combobox/combommvmerk_widget.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/widgets/combobox/combommvtipe_widget.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/widgets/combobox/combomwarna_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:string_validator/string_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';


class SppamvCrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const SppamvCrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	SppamvCrudFormPageFormState createState() => SppamvCrudFormPageFormState();
}

class SppamvCrudFormPageFormState extends State<SppamvCrudFormPage> {
	late SppamvCrudBloc sppamvCrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldAwController = TextEditingController();
	var fieldBiayaPolisController = TextEditingController();
	var fieldHargaController = TextEditingController();
	var fieldInsuredAlamat1Controller = TextEditingController();
	var fieldInsuredAlamat2Controller = TextEditingController();
	var fieldInsuredNamaController = TextEditingController();
	var fieldIsEqController = TextEditingController();
	var fieldIsFloodController = TextEditingController();
	var fieldIsSrccController = TextEditingController();
	var fieldIsTerrorismController = TextEditingController();
	var fieldMateraiController = TextEditingController();
	var fieldMesinNoController = TextEditingController();
	ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
	final comboMMvgrupOjkKey = GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();
	ComboMMvjnscoverModel? fieldComboMMvjnscover;
	final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
	ComboMMvmerkModel? fieldComboMMvmerk;
	final comboMMvmerkKey = GlobalKey<DropdownSearchState<ComboMMvmerkModel>>();
	ComboMMvtipeModel? fieldComboMMvtipe;
	final comboMMvtipeKey = GlobalKey<DropdownSearchState<ComboMMvtipeModel>>();
	ComboMWilayahModel? fieldComboMWilayah;
	final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
	var fieldPadController = TextEditingController();
	var fieldPapController = TextEditingController();
	var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPllController = TextEditingController();
	var fieldPolisiNoController = TextEditingController();
	var fieldPremiController = TextEditingController();
	var fieldPremiAddController = TextEditingController();
	var fieldPremiCascoController = TextEditingController();
	var fieldPremiTotalController = TextEditingController();
	var fieldRangkaNoController = TextEditingController();
	var fieldSppaTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldThnBuatController = TextEditingController();
	var fieldTplController = TextEditingController();
	var fieldTsiController = TextEditingController();
	ComboMWarnaModel? fieldComboMWarna;
	final comboMWarnaKey = GlobalKey<DropdownSearchState<ComboMWarnaModel>>();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		sppamvCrudBloc = BlocProvider.of<SppamvCrudBloc>(context);
		return BlocConsumer<SppamvCrudBloc, SppamvCrudState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} SPPA MV",
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
										buildFieldAw(),
										buildFieldBiayaPolis(),
										buildFieldHarga(),
										buildFieldInsuredAlamat1(),
										buildFieldInsuredAlamat2(),
										buildFieldInsuredNama(),
										buildFieldIsEq(),
										buildFieldIsFlood(),
										buildFieldIsSrcc(),
										buildFieldIsTerrorism(),
										buildFieldMaterai(),
										buildFieldMesinNo(),
										buildFieldMmvgrupojkId(),
										buildFieldMmvjnscoverId(),
										buildFieldMvmerkId(),
										buildFieldMvtipeId(),
										buildFieldMwilayahId(),
										buildFieldPad(),
										buildFieldPap(),
										buildFieldPeriodeAkhir(),
										buildFieldPeriodeMulai(),
										buildFieldPll(),
										buildFieldPolisiNo(),
										buildFieldPremi(),
										buildFieldPremiAdd(),
										buildFieldPremiCasco(),
										buildFieldPremiTotal(),
										buildFieldRangkaNo(),
										buildFieldSppaTgl(),
										buildFieldThnBuat(),
										buildFieldTpl(),
										buildFieldTsi(),
										buildFieldWarnaId(),
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
							fieldAwController.text = NumberFormat("#,###").format(state.record!.aw);
							fieldBiayaPolisController.text = NumberFormat("#,###").format(state.record!.biayaPolis);
							fieldHargaController.text = NumberFormat("#,###").format(state.record!.harga);
							fieldInsuredAlamat1Controller.text = state.record!.insuredAlamat1;
							fieldInsuredAlamat2Controller.text = state.record!.insuredAlamat2;
							fieldInsuredNamaController.text = state.record!.insuredNama;
							fieldIsEqController.text = state.record!.isEq.toString();
							fieldIsFloodController.text = state.record!.isFlood.toString();
							fieldIsSrccController.text = state.record!.isSrcc.toString();
							fieldIsTerrorismController.text = state.record!.isTerrorism.toString();
							fieldMateraiController.text = NumberFormat("#,###").format(state.record!.materai);
							fieldMesinNoController.text = state.record!.mesinNo;
							fieldPadController.text = NumberFormat("#,###").format(state.record!.pad);
							fieldPapController.text = NumberFormat("#,###").format(state.record!.pap);
							fieldPeriodeAkhirController.text = state.record!.periodeAkhir.toIso8601String();
							fieldPeriodeMulaiController.text = state.record!.periodeMulai.toIso8601String();
							fieldPllController.text = NumberFormat("#,###").format(state.record!.pll);
							fieldPolisiNoController.text = state.record!.polisiNo;
							fieldPremiController.text = NumberFormat("#,###").format(state.record!.premi);
							fieldPremiAddController.text = NumberFormat("#,###").format(state.record!.premiAdd);
							fieldPremiCascoController.text = NumberFormat("#,###").format(state.record!.premiCasco);
							fieldPremiTotalController.text = NumberFormat("#,###").format(state.record!.premiTotal);
							fieldRangkaNoController.text = state.record!.rangkaNo;
							fieldSppaTglController.text = state.record!.sppaTgl.toIso8601String();
							fieldThnBuatController.text = state.record!.thnBuat.toString();
							fieldTplController.text = NumberFormat("#,###").format(state.record!.tpl);
							fieldTsiController.text = NumberFormat("#,###").format(state.record!.tsi);
						}
						fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
						fieldComboMMvjnscover = state.comboMMvjnscover;
						fieldComboMMvmerk = state.comboMMvmerk;
						fieldComboMMvtipe = state.comboMMvtipe;
						fieldComboMWilayah = state.comboMWilayah;
						fieldComboMWarna = state.comboMWarna;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		sppamvCrudBloc.add(
			SppamvCrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldAw(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldAwController,
			decoration: const InputDecoration(
				labelText: "aw",
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

	Widget buildFieldBiayaPolis(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldBiayaPolisController,
			decoration: const InputDecoration(
				labelText: "biayaPolis",
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

	Widget buildFieldCobId(){
		return TextFormField(
		);
	}

	Widget buildFieldHarga(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldHargaController,
			decoration: const InputDecoration(
				labelText: "harga",
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

	Widget buildFieldMaterai(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldMateraiController,
			decoration: const InputDecoration(
				labelText: "materai",
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

	Widget buildFieldMesinNo(){
		return TextFormField(
			controller: fieldMesinNoController,
			decoration: const InputDecoration(
				labelText: "mesinNo",
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

	Widget buildFieldMmvgrupojkId(){
		return buildFieldComboMMvgrupOjk(
			comboKey: comboMMvgrupOjkKey,
			labelText: 'mmvgrupojkId',
			initItem: fieldComboMMvgrupOjk,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMMvgrupOjk tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvgrupOjk = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMMvgrupOjk tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldMmvjnscoverId(){
		return buildFieldComboMMvjnscover(
			enabled: true,
			comboKey: comboMMvjnscoverKey,
			labelText: 'mmvjnscoverId',
			initItem: fieldComboMMvjnscover,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMMvjnscover tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvjnscover = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMMvjnscover tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldMrekanId(){
		return TextFormField(
		);
	}

	Widget buildFieldMvmerkId(){
		return buildFieldComboMMvmerk(
			comboKey: comboMMvmerkKey,
			labelText: 'mvmerkId',
			initItem: fieldComboMMvmerk,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMMvmerk tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMMvmerkChangedEvent(comboMMvmerk: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvmerk = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMMvmerk tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldMvtipeId(){
		return buildFieldComboMMvtipe(
			comboKey: comboMMvtipeKey,
			labelText: 'mvtipeId',
			initItem: fieldComboMMvtipe,
      mvmerkId: fieldComboMMvmerk?.mmvmerkId??'',
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMMvtipe tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMMvtipeChangedEvent(comboMMvtipe: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvtipe = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMMvtipe tidak boleh kosong.");
				}
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
					sppamvCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
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

	Widget buildFieldPad(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPadController,
			decoration: const InputDecoration(
				labelText: "pad",
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

	Widget buildFieldPap(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPapController,
			decoration: const InputDecoration(
				labelText: "pap",
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

	Widget buildFieldPll(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPllController,
			decoration: const InputDecoration(
				labelText: "pll",
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

	Widget buildFieldPolisiNo(){
		return TextFormField(
			controller: fieldPolisiNoController,
			decoration: const InputDecoration(
				labelText: "polisiNo",
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

	Widget buildFieldPremi(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiController,
			decoration: const InputDecoration(
				labelText: "premi",
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

	Widget buildFieldPremiAdd(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiAddController,
			decoration: const InputDecoration(
				labelText: "premiAdd",
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

	Widget buildFieldPremiCasco(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiCascoController,
			decoration: const InputDecoration(
				labelText: "premiCasco",
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

	Widget buildFieldRangkaNo(){
		return TextFormField(
			controller: fieldRangkaNoController,
			decoration: const InputDecoration(
				labelText: "rangkaNo",
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

	Widget buildFieldThnBuat(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldThnBuatController,
			decoration: const InputDecoration(
				labelText: "thnBuat",
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

	Widget buildFieldTpl(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldTplController,
			decoration: const InputDecoration(
				labelText: "tpl",
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

	Widget buildFieldWarnaId(){
		return buildFieldComboMWarna(
			comboKey: comboMWarnaKey,
			labelText: 'warnaId',
			initItem: fieldComboMWarna,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMWarna tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMWarnaChangedEvent(comboMWarna: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMWarna = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMWarna tidak boleh kosong.");
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
			SppamvCrudModel record = SppamvCrudModel(
				aw: double.parse(fieldAwController.text.replaceAll(',', '')),
				biayaPolis: double.parse(fieldBiayaPolisController.text.replaceAll(',', '')),
				harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
				insuredAlamat1: fieldInsuredAlamat1Controller.text,
				insuredAlamat2: fieldInsuredAlamat2Controller.text,
				insuredNama: fieldInsuredNamaController.text,
				isEq: toBoolean(fieldIsEqController.text),
				isFlood: toBoolean(fieldIsFloodController.text),
				isSrcc: toBoolean(fieldIsSrccController.text),
				isTerrorism: toBoolean(fieldIsTerrorismController.text),
				materai: double.parse(fieldMateraiController.text.replaceAll(',', '')),
				mesinNo: fieldMesinNoController.text,
				mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
				mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
				mvmerkId: fieldComboMMvmerk?.mmvmerkId,
				mvtipeId: fieldComboMMvtipe?.mmvtipeId,
				mwilayahId: fieldComboMWilayah?.mwilayahId,
				pad: double.parse(fieldPadController.text.replaceAll(',', '')),
				pap: double.parse(fieldPapController.text.replaceAll(',', '')),
				periodeAkhir: DateTime.parse(fieldPeriodeAkhirController.text),
				periodeMulai: DateTime.parse(fieldPeriodeMulaiController.text),
				pll: double.parse(fieldPllController.text.replaceAll(',', '')),
				polisiNo: fieldPolisiNoController.text,
				premi: double.parse(fieldPremiController.text.replaceAll(',', '')),
				premiAdd: double.parse(fieldPremiAddController.text.replaceAll(',', '')),
				premiCasco: double.parse(fieldPremiCascoController.text.replaceAll(',', '')),
				premiTotal: double.parse(fieldPremiTotalController.text.replaceAll(',', '')),
				rangkaNo: fieldRangkaNoController.text,
				sppaTgl: DateTime.parse(fieldSppaTglController.text),
				sppa1Id: '',
				thnBuat: int.parse(fieldThnBuatController.text),
				tpl: double.parse(fieldTplController.text.replaceAll(',', '')),
				tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
				warnaId: fieldComboMWarna?.mwarnaId,
			);
			if (widget.viewMode == "tambah") {
				sppamvCrudBloc.add(SppamvCrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.sppa1Id = sppamvCrudBloc.state.record!.sppa1Id;
				sppamvCrudBloc.add(SppamvCrudUbahEvent(record: record));
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
