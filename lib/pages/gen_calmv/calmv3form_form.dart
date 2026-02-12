import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_calmv/calmv3form_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv3form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

class Calmv3FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const Calmv3FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  Calmv3FormFormPageFormState createState() => Calmv3FormFormPageFormState();
}

class Calmv3FormFormPageFormState extends State<Calmv3FormFormPage> {
  late Calmv3FormBloc calmv3FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldDiskonPersenController = TextEditingController();
  var fieldPremiAddController = TextEditingController();
  var fieldPremiCascoController = TextEditingController();
  var fieldPremiDiskonController = TextEditingController();
  var fieldPremiNetController = TextEditingController();
  var fieldPremiSubtotalController = TextEditingController();
  var fieldCalmv1IdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    calmv3FormBloc = BlocProvider.of<Calmv3FormBloc>(context);
    return BlocConsumer<Calmv3FormBloc, Calmv3FormState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: 'Hasil Perhitungan Premi',
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: pGrey,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                child: Column(
                  children: [
                    buildFieldCalmv1Id(),
                    const SizedBox(height: 12),
                    buildFieldDiskonPersen(),
                    const SizedBox(height: 12),
                    buildFieldPremiAdd(),
                    const SizedBox(height: 12),
                    buildFieldPremiCasco(),
                    const SizedBox(height: 12),
                    buildFieldPremiDiskon(),
                    const SizedBox(height: 12),
                    buildFieldPremiNet(),
                    const SizedBox(height: 12),
                    buildFieldPremiSubtotal(),
                    const SizedBox(height: 12),
                    const SizedBox(height: 25),
                    FormError(errors: errors, key: null),
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
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          if (state.record != null) {
            fieldDiskonPersenController.text = NumberFormat(
              "#,###",
            ).format(state.record!.diskonPersen);
            fieldPremiAddController.text = NumberFormat(
              "#,###",
            ).format(state.record!.premiAdd);
            fieldPremiCascoController.text = NumberFormat(
              "#,###",
            ).format(state.record!.premiCasco);
            fieldCalmv1IdController.text = state.record!.calmv3Id;
            fieldPremiDiskonController.text = NumberFormat(
              "#,###",
            ).format(state.record!.premiDiskon);
            fieldPremiNetController.text = NumberFormat(
              "#,###",
            ).format(state.record!.premiNet);
            fieldPremiSubtotalController.text = NumberFormat(
              "#,###",
            ).format(state.record!.premiSubtotal);
          }
        }
      },
    );
  }

  void loadData() {
    // if (widget.viewMode == "ubah") {
    //   calmv3FormBloc.add(Calmv3FormLihatEvent(recordId: widget.recordId));
    // }
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return appTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.number,
      enabled: false,
      hint: "0",
      prefix: Text("IDR | ", style: bodyTextStyle(context)),
      onTap: () {},
    );
  }

  Widget buildFieldCalmv1Id() {
    return appTextField(
      controller: fieldCalmv1IdController,
      label: 'Claimv1id',
    );
  }

  Widget buildFieldDiskonPersen() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldDiskonPersenController,
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
      label: 'Persen Diskon',
    );
  }

  Widget buildFieldPremiAdd() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiAddController,
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
      label: 'Premi Tambahan',
    );
  }

  Widget buildFieldPremiCasco() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiCascoController,
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
      label: 'Premi CASCO',
    );
  }

  Widget buildFieldPremiDiskon() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiDiskonController,
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
      label: 'Premi Diskon',
    );
  }

  Widget buildFieldPremiNet() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiNetController,
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
      label: 'Net Premi',
    );
  }

  Widget buildFieldPremiSubtotal() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiSubtotalController,
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
      label: 'Subtotal Premi',
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Calmv3FormModel record = Calmv3FormModel(
        calmv3Id: '',
        diskonPersen: double.parse(
          fieldDiskonPersenController.text.replaceAll(',', ''),
        ),
        premiAdd: double.parse(
          fieldPremiAddController.text.replaceAll(',', ''),
        ),
        premiCasco: double.parse(
          fieldPremiCascoController.text.replaceAll(',', ''),
        ),
        premiDiskon: double.parse(
          fieldPremiDiskonController.text.replaceAll(',', ''),
        ),
        premiNet: double.parse(
          fieldPremiNetController.text.replaceAll(',', ''),
        ),
        premiSubtotal: double.parse(
          fieldPremiSubtotalController.text.replaceAll(',', ''),
        ),
      );
      if (widget.viewMode == "tambah") {
        calmv3FormBloc.add(Calmv3FormTambahEvent(record: record));
      } else if (widget.viewMode == "ubah") {
        record.calmv3Id = calmv3FormBloc.state.record!.calmv3Id;
        calmv3FormBloc.add(Calmv3FormUbahEvent(record: record));
      }
      _dismissDialog();
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
