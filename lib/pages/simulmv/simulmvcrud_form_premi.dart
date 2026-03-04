import 'package:joss_app/widgets/form_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

class SimulmvCrudFormPremiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvCrudFormPremiPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulmvCrudFormPageFormPremiState createState() =>
      SimulmvCrudFormPageFormPremiState();
}

class SimulmvCrudFormPageFormPremiState
    extends State<SimulmvCrudFormPremiPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  var fieldPremiAddController = TextEditingController();
  var fieldPremiCascoController = TextEditingController();
  var fieldPremiTotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  simulmvCrudBloc.add(HitungPremiEvent());
                                },
                                child: Icon(
                                  Icons.calculate,
                                  size: 55,
                                ),
                              )),
                        ),
                        Flexible(
                          flex: 3,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  buildFieldPremiCasco(),
                                  buildFieldPremiAdd(),
                                  buildFieldPremiTotal(),                                  
                                ],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    FormError(
                      errors: state.errors ?? [],
                      key: null,
                    ),
                  ],
                )),
          ),
        );
      },
      listener: (context, state) {
        if ((state.isLoaded) || (state.isCalculated)) {
          if (state.record != null) {
            fieldPremiAddController.text =
                NumberFormat("#,###").format(state.record!.premiAdd);
            fieldPremiCascoController.text =
                NumberFormat("#,###").format(state.record!.premiCasco);
            fieldPremiTotalController.text =
                NumberFormat("#,###").format(state.record!.premiTotal);
          }
        }
      },
      buildWhen: (previous, current) {
        return current.isCalculated;
      },
    );
  }

  Widget buildFieldPremiAdd() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiAddController,
      decoration: const InputDecoration(
        labelText: "Premi Tambahan",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kStringNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          //addError(error: kStringNullError);
          return "";
        }
        return null;
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiCasco() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiCascoController,
      decoration: const InputDecoration(
        labelText: "Premi Casco",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kStringNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          //addError(error: kStringNullError);
          return "";
        }
        return null;
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiTotal() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiTotalController,
      decoration: const InputDecoration(
        labelText: "Premi Total",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kStringNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          //addError(error: kStringNullError);
          return "";
        }
        return null;
      },
      textAlign: TextAlign.right,
    );
  }
}
