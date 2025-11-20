import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv1crud_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv1crud_model.dart';


class Regmv1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regmv1CrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regmv1CrudFormPageFormState createState() => Regmv1CrudFormPageFormState();
}

class Regmv1CrudFormPageFormState extends State<Regmv1CrudFormPage> {
	late Regmv1CrudBloc regmv1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldCalmv1IdController = TextEditingController();
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
		regmv1CrudBloc = BlocProvider.of<Regmv1CrudBloc>(context);
		return BlocConsumer<Regmv1CrudBloc, Regmv1CrudState>(
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
										buildFieldCalmv1Id(),
										buildFieldTtgAlamat(),
										buildFieldTtgNama(),
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
							fieldCalmv1IdController.text = state.record!.calmv1Id;
							fieldTtgAlamatController.text = state.record!.ttgAlamat;
							fieldTtgNamaController.text = state.record!.ttgNama;
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regmv1CrudBloc.add(
			Regmv1CrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCalmv1Id() {
		return appTextField(
			label: "calmv1Id",
			controller: fieldCalmv1IdController,
			hint: "Masukkan calmv1Id...",
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldTtgAlamat() {
		return appTextField(
			label: "ttgAlamat",
			hint: "Masukkan alamat tertanggung...",
			controller: fieldTtgAlamatController,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldTtgNama() {
		return appTextField(
			label: "ttgNama",
			hint: "Masukkan nama tertanggung...",
			controller: fieldTtgNamaController,
			keyboardType: TextInputType.name,
			maxLines: 1,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
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
			Regmv1CrudModel record = Regmv1CrudModel(
				calmv1Id: fieldCalmv1IdController.text,
				regmv1Id: '',
				ttgAlamat: fieldTtgAlamatController.text,
				ttgNama: fieldTtgNamaController.text,
			);
			if (widget.viewMode == "tambah") {
				regmv1CrudBloc.add(Regmv1CrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regmv1Id = regmv1CrudBloc.state.record!.regmv1Id;
				regmv1CrudBloc.add(Regmv1CrudUbahEvent(record: record));
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
