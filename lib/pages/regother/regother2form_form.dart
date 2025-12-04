import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regother/regother2form_bloc.dart';
import 'package:joss_app/models/regother/regother2form_model.dart';


class Regother2FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regother2FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regother2FormFormPageFormState createState() => Regother2FormFormPageFormState();
}

class Regother2FormFormPageFormState extends State<Regother2FormFormPage> {
	late Regother2FormBloc regother2FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldFotoCaptionController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regother2FormBloc = BlocProvider.of<Regother2FormBloc>(context);
		return BlocConsumer<Regother2FormBloc, Regother2FormState>(
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
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Reg Other #2",
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
										buildFieldFotoCaption(),
										buildFieldRegother1Id(),
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
							fieldFotoCaptionController.text = state.record!.fotoCaption;
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regother2FormBloc.add(
			Regother2FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldFotoCaption(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldFotoCaptionController,
			decoration: const InputDecoration(
				labelText: "fotoCaption",
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

	Widget buildFieldRegother1Id(){
		return TextFormField(
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Regother2FormModel record = Regother2FormModel(
				fotoCaption: fieldFotoCaptionController.text,
				regother2Id: '',
			);
			if (widget.viewMode == "tambah") {
				regother2FormBloc.add(Regother2FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regother2Id = regother2FormBloc.state.record!.regother2Id;
				regother2FormBloc.add(Regother2FormUbahEvent(record: record));
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
