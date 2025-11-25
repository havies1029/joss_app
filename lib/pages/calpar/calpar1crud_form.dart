import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar1crud_bloc.dart';
import 'package:joss_app/models/calpar/calpar1crud_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/widgets/combobox/combomjnscoverpar_widget.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/widgets/combobox/comborkonstruksiojk_widget.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/widgets/combobox/comborokupasi_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Calpar1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Calpar1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Calpar1CrudFormPageFormState createState() => Calpar1CrudFormPageFormState();
}

class Calpar1CrudFormPageFormState extends State<Calpar1CrudFormPage> {
	late Calpar1CrudBloc calpar1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldCoverBulanController = TextEditingController();
	ComboMJnscoverParModel? fieldComboMJnscoverPar;
	final comboMJnscoverParKey = GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>();
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
		calpar1CrudBloc = BlocProvider.of<Calpar1CrudBloc>(context);
		return BlocConsumer<Calpar1CrudBloc, Calpar1CrudState>(
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
										buildFieldCoverBulan(),
										buildFieldMjnscoverparId(),
										buildFieldRkonstruksiojkId(),
										buildFieldRokupasiId(),
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
							fieldCoverBulanController.text = state.record!.coverBulan.toString();
						}
						fieldComboMJnscoverPar = state.comboMJnscoverPar;
						fieldComboRKonstruksiojk = state.comboRKonstruksiojk;
						fieldComboROkupasi = state.comboROkupasi;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		calpar1CrudBloc.add(
			Calpar1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCoverBulan(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldCoverBulanController,
			decoration: const InputDecoration(
				labelText: "coverBulan",
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

	Widget buildFieldMjnscoverparId(){
		return buildFieldComboMJnscoverPar(
			comboKey: comboMJnscoverParKey,
			labelText: 'mjnscoverparId',
			initItem: fieldComboMJnscoverPar,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Field ComboMJnscoverPar tidak boleh kosong.");
					calpar1CrudBloc.add(ComboMJnscoverParChangedEvent(comboMJnscoverPar: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMJnscoverPar = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Field ComboMJnscoverPar tidak boleh kosong.");
				}
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
					calpar1CrudBloc.add(ComboRKonstruksiojkChangedEvent(comboRKonstruksiojk: value));
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
					calpar1CrudBloc.add(ComboROkupasiChangedEvent(comboROkupasi: value));
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
			Calpar1CrudModel record = Calpar1CrudModel(
				calpar1Id: '',
				coverBulan: int.parse(fieldCoverBulanController.text),
				mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
				rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
				rokupasiId: fieldComboROkupasi?.rokupasiId,
			);
			if (widget.viewMode == "tambah") {
				calpar1CrudBloc.add(Calpar1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.calpar1Id = calpar1CrudBloc.state.record!.calpar1Id;
				calpar1CrudBloc.add(Calpar1CrudUbahEvent(record: record));
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
