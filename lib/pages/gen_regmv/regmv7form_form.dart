import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv7form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv7form_model.dart';


class Regmv7FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regmv7FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regmv7FormFormPageFormState createState() => Regmv7FormFormPageFormState();
}

class Regmv7FormFormPageFormState extends State<Regmv7FormFormPage> {
	late Regmv7FormBloc regmv7FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldAccNamaController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regmv7FormBloc = BlocProvider.of<Regmv7FormBloc>(context);
		return BlocConsumer<Regmv7FormBloc, Regmv7FormState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} RegMV #7",
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
										buildFieldAccNama(),
										buildFieldRegmv1Id(),
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
							fieldAccNamaController.text = state.record!.accNama;
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regmv7FormBloc.add(
			Regmv7FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldAccNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldAccNamaController,
			decoration: const InputDecoration(
				labelText: "accNama",
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


	Widget buildFieldRegmv1Id(){
		return TextFormField(
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Regmv7FormModel record = Regmv7FormModel(
				accNama: fieldAccNamaController.text,
				regmv7Id: '',
			);
			if (widget.viewMode == "tambah") {
				regmv7FormBloc.add(Regmv7FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regmv7Id = regmv7FormBloc.state.record!.regmv7Id;
				regmv7FormBloc.add(Regmv7FormUbahEvent(record: record));
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
