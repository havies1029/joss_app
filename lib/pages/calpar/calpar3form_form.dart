import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar3form_bloc.dart';
import 'package:joss_app/models/calpar/calpar3form_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/widgets/combobox/combomkabzonagempa_widget.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/widgets/combobox/combomjnscoverpar_widget.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:joss_app/widgets/checkbox_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Calpar3FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const Calpar3FormFormPage({super.key, required this.viewMode, required this.recordId});

  @override
  Calpar3FormFormPageFormState createState() => Calpar3FormFormPageFormState();
}

class Calpar3FormFormPageFormState extends State<Calpar3FormFormPage> {
  late Calpar3FormBloc calpar3FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldIsEqController = TextEditingController();
  var fieldIsFlexasController = TextEditingController();
  var fieldIsOtherController = TextEditingController();
  var fieldIsRsmdccController = TextEditingController();
  var fieldIsTsfwdController = TextEditingController();
  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  final comboMKabZonaGempaKey = GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();
  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  final comboMJnscoverParKey = GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    calpar3FormBloc = BlocProvider.of<Calpar3FormBloc>(context);
    return BlocConsumer<Calpar3FormBloc, Calpar3FormState>(
      builder: (context, state) {
        return Dialog(
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} CalPar #3",
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
                        buildFieldMjnscoverparId(),
                        buildFieldIsEq(),
                        buildFieldIsFlexas(),
                        buildFieldIsOther(),
                        buildFieldIsRsmdcc(),
                        buildFieldIsTsfwd(),
                        buildFieldKab2zonagempaId(),
                        buildFieldMwilayahId(),
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
            fieldIsEqController.text = state.record!.isEq.toString();
            fieldIsFlexasController.text = state.record!.isFlexas.toString();
            fieldIsOtherController.text = state.record!.isOther.toString();
            fieldIsRsmdccController.text = state.record!.isRsmdcc.toString();
            fieldIsTsfwdController.text = state.record!.isTsfwd.toString();
          }
          fieldComboMKabZonaGempa = state.comboMKabZonaGempa;
          fieldComboMJnscoverPar = state.comboMJnscoverPar;
          fieldComboMWilayah = state.comboMWilayah;
        }
      },
    );
  }
  void loadData() {
    if (widget.viewMode == "ubah") {
      calpar3FormBloc.add(
          Calpar3FormLihatEvent(recordId: widget.recordId));
    }
  }

  Widget buildFieldIsEq(){
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "isEq",
        initialValue: toBoolean(fieldIsEqController.text),
        callback: (value) {
          setState(() {
            fieldIsEqController.text = value.toString();
          });
        }
    );
  }

  Widget buildFieldIsFlexas(){
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "isFlexas",
        initialValue: toBoolean(fieldIsFlexasController.text),
        callback: (value) {
          setState(() {
            fieldIsFlexasController.text = value.toString();
          });
        }
    );
  }

  Widget buildFieldIsOther(){
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "isOther",
        initialValue: toBoolean(fieldIsOtherController.text),
        callback: (value) {
          setState(() {
            fieldIsOtherController.text = value.toString();
          });
        }
    );
  }

  Widget buildFieldIsRsmdcc(){
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "isRsmdcc",
        initialValue: toBoolean(fieldIsRsmdccController.text),
        callback: (value) {
          setState(() {
            fieldIsRsmdccController.text = value.toString();
          });
        }
    );
  }

  Widget buildFieldIsTsfwd(){
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "isTsfwd",
        initialValue: toBoolean(fieldIsTsfwdController.text),
        callback: (value) {
          setState(() {
            fieldIsTsfwdController.text = value.toString();
          });
        }
    );
  }

  Widget buildFieldKab2zonagempaId(){
    return buildFieldComboMKabZonaGempa(
      comboKey: comboMKabZonaGempaKey,
      labelText: 'kab2zonagempaId',
      initItem: fieldComboMKabZonaGempa,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(
              error: "Field ComboMKabZonaGempa tidak boleh kosong.");
          calpar3FormBloc.add(ComboMKabZonaGempaChangedEvent(comboMKabZonaGempa: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMKabZonaGempa = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(
              error: "Field ComboMKabZonaGempa tidak boleh kosong.");
        }
      },
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
          calpar3FormBloc.add(ComboMJnscoverParChangedEvent(comboMJnscoverPar: value));
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

  Widget buildFieldMwilayahId(){
    return buildFieldComboMWilayah(
      comboKey: comboMWilayahKey,
      labelText: 'mwilayahId',
      initItem: fieldComboMWilayah,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(
              error: "Field ComboMWilayah tidak boleh kosong.");
          calpar3FormBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMWilayah = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(
              error: "Field ComboMWilayah tidak boleh kosong.");
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
      Calpar3FormModel record = Calpar3FormModel(
        calpar1Id: widget.recordId,
        calpar3Id: '',
        kab2zonagempaId: fieldComboMKabZonaGempa?.mkabzonagempaId,
        mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
        mwilayahId: fieldComboMWilayah?.mwilayahId,
      );
      if (widget.viewMode == "tambah") {
        calpar3FormBloc.add(Calpar3FormTambahEvent(record: record));
      } else if (widget.viewMode == "ubah") {
        record.calpar3Id = calpar3FormBloc.state.record!.calpar3Id;
        calpar3FormBloc.add(Calpar3FormUbahEvent(record: record));
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