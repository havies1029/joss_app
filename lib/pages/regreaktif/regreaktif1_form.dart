import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regreaktif/regreaktif1_bloc.dart';
import 'package:joss_app/models/regreaktif/regreaktif1_model.dart';
import 'package:string_validator/string_validator.dart';


class Regreaktif1FormPage extends StatefulWidget {
	final String sppa1Id;

	const Regreaktif1FormPage({super.key, required this.sppa1Id});

	@override
	Regreaktif1FormPageFormState createState() => Regreaktif1FormPageFormState();
}

class Regreaktif1FormPageFormState extends State<Regreaktif1FormPage> {
	late Regreaktif1Bloc regreaktif1Bloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldIsUbahController = TextEditingController();
	var fieldNotePerubahanController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		regreaktif1Bloc = BlocProvider.of<Regreaktif1Bloc>(context);
		return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Tambah Registrasi Pengaktifan",
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
          buildFieldIsUbah(),
          buildFieldNotePerubahan(),
          buildFieldSppa1Id(),
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

	Widget buildFieldIsUbah(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isUbah",
			initialValue: toBoolean(fieldIsUbahController.text),
			callback: (value) {
				setState(() {
					fieldIsUbahController.text = value.toString();
				});
			}
		);
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
			Regreaktif1Model record = Regreaktif1Model(
				isUbah: toBoolean(fieldIsUbahController.text),
				notePerubahan: fieldNotePerubahanController.text,
				sppa1Id: widget.sppa1Id,
			);
			
			regreaktif1Bloc.add(Regreaktif1TambahEvent(record: record));
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
