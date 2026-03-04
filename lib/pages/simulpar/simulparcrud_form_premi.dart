import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

class SimulparCrudFormPremiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparCrudFormPremiPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparCrudFormPremiPageFormState createState() =>
      SimulparCrudFormPremiPageFormState();
}

class SimulparCrudFormPremiPageFormState
    extends State<SimulparCrudFormPremiPage> {
  late SimulparCrudBloc simulparCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldPremiTotalController = TextEditingController();
  var fieldPremiBiController = TextEditingController();
  var fieldPremiFlexasController = TextEditingController();
  var fieldPremiRsmdccController = TextEditingController();
  var fieldPremiTsfwdController = TextEditingController();
  var fieldPremiEqvetController = TextEditingController();
  var fieldPremiOthersController = TextEditingController();
  String currDesc = "IDR";

  @override
  Widget build(BuildContext context) {
    simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);
    return BlocConsumer<SimulparCrudBloc, SimulparCrudState>(
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
                                  simulparCrudBloc.add(HitungPremiPAREvent());
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
                                  buildFieldPremiFlexas(),
                                  const SizedBox(height: 10),
                                  buildFieldPremiRsmdcc(),
                                  const SizedBox(height: 10),
                                  buildFieldPremiTsfwd(),
                                  const SizedBox(height: 10),
                                  buildFieldPremiEqvet(),
                                  const SizedBox(height: 10),
                                  buildFieldPremiOthers(),
                                  const SizedBox(height: 10),
                                  buildFieldPremiBI(),
                                  const SizedBox(height: 10),
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
        if ((state.isLoaded) || (state.isGroupFieldPremiChanged)) {
          if (state.record != null) {
            fieldPremiFlexasController.text =
                NumberFormat("#,###").format(state.record!.premiFlexas);
            fieldPremiRsmdccController.text =
                NumberFormat("#,###").format(state.record!.premiRsmdcc);
            fieldPremiTsfwdController.text =
                NumberFormat("#,###").format(state.record!.premiTsfwd);
            fieldPremiEqvetController.text =
                NumberFormat("#,###").format(state.record!.premiEqvet);
            fieldPremiOthersController.text =
                NumberFormat("#,###").format(state.record!.premiOthers);
            fieldPremiBiController.text =
                NumberFormat("#,###").format(state.record!.premiBi);
            fieldPremiTotalController.text =
                NumberFormat("#,###").format(state.record!.premiTotal);
            currDesc = state.record!.currDesc ?? "IDR";
          }
        }
      },
      buildWhen: (previous, current) {
        return (current.hasFailure || current.isGroupFieldPremiChanged);
      },
    );
  }

  Widget buildFieldPremiTotal() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiTotalController,
      decoration: InputDecoration(
          labelText: "Total Premi",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiBI() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiBiController,
      decoration: InputDecoration(
          labelText: "Premi BI",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiFlexas() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiFlexasController,
      decoration: InputDecoration(
          labelText: "Premi FLEXAS",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiRsmdcc() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiRsmdccController,
      decoration: InputDecoration(
          labelText: "Premi RSMDCC",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiTsfwd() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiTsfwdController,
      decoration: InputDecoration(
          labelText: "Premi TSFWD",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiEqvet() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiEqvetController,
      decoration: InputDecoration(
          labelText: "Premi EQVET",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldPremiOthers() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiOthersController,
      decoration: InputDecoration(
          labelText: "Premi Others",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: currDesc),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }
 
}
