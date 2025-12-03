import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv4form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv4form_model.dart';


class Regmv4FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const Regmv4FormFormPage({super.key, required this.viewMode, required this.recordId});

  @override
  Regmv4FormFormPageFormState createState() => Regmv4FormFormPageFormState();
}

class Regmv4FormFormPageFormState extends State<Regmv4FormFormPage> {
  late Regmv4FormBloc regmv4FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldCaptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    regmv4FormBloc = BlocProvider.of<Regmv4FormBloc>(context);
    return BlocConsumer<Regmv4FormBloc, Regmv4FormState>(
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
                          "${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Foto STNK",
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
                        buildFieldCaption(),
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
            fieldCaptionController.text = state.record!.caption;
          }
        }
      },
    );
  }
  void loadData() {
    if (widget.viewMode == "ubah") {
      regmv4FormBloc.add(
          Regmv4FormLihatEvent(recordId: widget.recordId));
    }
  }

  Widget buildFieldCaption(){
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: fieldCaptionController,
      decoration: const InputDecoration(
        labelText: "caption",
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
      Regmv4FormModel record = Regmv4FormModel(
        caption: fieldCaptionController.text,
        regmv4Id: '',
      );
      if (widget.viewMode == "tambah") {
        regmv4FormBloc.add(Regmv4FormTambahEvent(record: record));
      } else if (widget.viewMode == "ubah") {
        record.regmv4Id = regmv4FormBloc.state.record!.regmv4Id;
        regmv4FormBloc.add(Regmv4FormUbahEvent(record: record));
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
