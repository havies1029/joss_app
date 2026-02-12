import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_endors/endors1crud_bloc.dart';
import 'package:joss_app/models/gen_endors/endors1crud_model.dart';

class Endors1CrudFormPage extends StatefulWidget {
	final String sppa1Id;

	const Endors1CrudFormPage({super.key, required this.sppa1Id});

	@override
	Endors1CrudFormPageFormState createState() => Endors1CrudFormPageFormState();
}

class Endors1CrudFormPageFormState extends State<Endors1CrudFormPage> {
	late Endors1CrudBloc endors1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldNotePerubahanController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		endors1CrudBloc = BlocProvider.of<Endors1CrudBloc>(context);
		return Form(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "SPPA : ${widget.sppa1Id}",
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
			minLines: 10,
			maxLines: 25,
			controller: fieldNotePerubahanController,
			decoration: const InputDecoration(
				labelText: "Perubahan",
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
			Endors1CrudModel record = Endors1CrudModel(
				
				notePerubahan: fieldNotePerubahanController.text,
				sppa1Id: widget.sppa1Id,
			);
				endors1CrudBloc.add(Endors1CrudTambahEvent(record: record));
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
