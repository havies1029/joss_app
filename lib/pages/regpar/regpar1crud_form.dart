import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/models/regpar/regpar1crud_model.dart';


class Regpar1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regpar1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regpar1CrudFormPageFormState createState() => Regpar1CrudFormPageFormState();
}

class Regpar1CrudFormPageFormState extends State<Regpar1CrudFormPage> {
	late Regpar1CrudBloc regpar1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldTtgAlamatController = TextEditingController();
	var fieldTtgNamaController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regpar1CrudBloc = BlocProvider.of<Regpar1CrudBloc>(context);
		return BlocConsumer<Regpar1CrudBloc, Regpar1CrudState>(
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
										buildFieldTtgNama(),
										buildFieldTtgAlamat(),
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
							fieldTtgAlamatController.text = state.record!.ttgAlamat;
							fieldTtgNamaController.text = state.record!.ttgNama;
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regpar1CrudBloc.add(
			Regpar1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldTtgAlamat(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldTtgAlamatController,
			decoration: const InputDecoration(
				labelText: "ttgAlamat",
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

	Widget buildFieldTtgNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldTtgNamaController,
			decoration: const InputDecoration(
				labelText: "ttgNama",
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
			Regpar1CrudModel record = Regpar1CrudModel(
				regpar1Id: '',
				ttgAlamat: fieldTtgAlamatController.text,
				ttgNama: fieldTtgNamaController.text,
			);
			if (widget.viewMode == "tambah") {
				regpar1CrudBloc.add(Regpar1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regpar1Id = regpar1CrudBloc.state.record!.regpar1Id;
				regpar1CrudBloc.add(Regpar1CrudUbahEvent(record: record));
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
