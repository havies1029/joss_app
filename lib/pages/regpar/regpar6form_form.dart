import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/regpar/regpar6form_bloc.dart';
import 'package:joss_app/models/regpar/regpar6form_model.dart';


class Regpar6FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const Regpar6FormFormPage({super.key, required this.viewMode, required this.recordId});

  @override
  Regpar6FormFormPageFormState createState() => Regpar6FormFormPageFormState();
}

class Regpar6FormFormPageFormState extends State<Regpar6FormFormPage> {
  late Regpar6FormBloc regpar6FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldFotoCaptionController = TextEditingController();
  var fieldFotoStreamIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    regpar6FormBloc = BlocProvider.of<Regpar6FormBloc>(context);
    return BlocConsumer<Regpar6FormBloc, Regpar6FormState>(
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
                          "${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Reg PAR #6",
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
                        buildFieldFotoStreamId(),
                        buildFieldRegpar1Id(),
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
      regpar6FormBloc.add(
          Regpar6FormLihatEvent(recordId: widget.recordId));
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

  Widget buildFieldFotoStreamId(){
    return TextFormField(
      controller: fieldFotoStreamIdController,
      decoration: const InputDecoration(
        labelText: "fotoStreamId",
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

  Widget buildFieldRegpar1Id(){
    return TextFormField(
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Regpar6FormModel record = Regpar6FormModel(
        fotoCaption: fieldFotoCaptionController.text,
        regpar6Id: '',
      );
      if (widget.viewMode == "tambah") {
        regpar6FormBloc.add(Regpar6FormTambahEvent(record: record));
      } else if (widget.viewMode == "ubah") {
        record.regpar6Id = regpar6FormBloc.state.record!.regpar6Id;
        regpar6FormBloc.add(Regpar6FormUbahEvent(record: record));
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
