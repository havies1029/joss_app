import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regendors/regendors1form_bloc.dart';
import 'package:joss_app/models/regendors/regendors1form_model.dart';


class Regendors1FormFormPage extends StatefulWidget {
	final String sppa1Id;

	const Regendors1FormFormPage({super.key, required this.sppa1Id});

	@override
	Regendors1FormFormPageFormState createState() => Regendors1FormFormPageFormState();
}

class Regendors1FormFormPageFormState extends State<Regendors1FormFormPage> {
	late Regendors1FormBloc regendors1FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldNotePerubahanController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		regendors1FormBloc = BlocProvider.of<Regendors1FormBloc>(context);
		return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          buildFieldSppa1Id(),
          buildFieldNotePerubahan(),
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
		}

	Widget buildFieldNotePerubahan(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 5,
			maxLines: 10,
			controller: fieldNotePerubahanController,
			decoration: const InputDecoration(
				labelText: "notePerubahan",
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

	Widget buildFieldSppa1Id(){
		return TextFormField(
      readOnly: true,
			controller: TextEditingController(text: widget.sppa1Id),
			decoration: const InputDecoration(
				labelText: "sppa1Id",
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
			Regendors1FormModel record = Regendors1FormModel(
				notePerubahan: fieldNotePerubahanController.text,
				sppa1Id: widget.sppa1Id,
			);
			regendors1FormBloc.add(Regendors1FormTambahEvent(record: record));
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
