import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

class SimulparFormPremiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormPremiPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparFormPremiPageFormState createState() =>
      SimulparFormPremiPageFormState();
}

class SimulparFormPremiPageFormState
    extends State<SimulparFormPremiPage> {
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
  void dispose() {
    fieldPremiTotalController.dispose();
    fieldPremiBiController.dispose();
    fieldPremiFlexasController.dispose();
    fieldPremiRsmdccController.dispose();
    fieldPremiTsfwdController.dispose();
    fieldPremiEqvetController.dispose();
    fieldPremiOthersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    simulparCrudBloc = context.read<SimulparCrudBloc>();

    return BlocConsumer<SimulparCrudBloc, SimulparCrudState>(
      listener: (context, state) {
        if ((state.isLoaded) || (state.isGroupFieldPremiChanged)) {
          final r = state.record;
          if (r != null) {
            final f = NumberFormat.decimalPattern('id');
            fieldPremiFlexasController.text = f.format(r.premiFlexas ?? 0);
            fieldPremiRsmdccController.text = f.format(r.premiRsmdcc ?? 0);
            fieldPremiTsfwdController.text  = f.format(r.premiTsfwd  ?? 0);
            fieldPremiEqvetController.text  = f.format(r.premiEqvet  ?? 0);
            fieldPremiOthersController.text = f.format(r.premiOthers ?? 0);
            fieldPremiBiController.text     = f.format(r.premiBi     ?? 0);
            fieldPremiTotalController.text  = f.format(r.premiTotal  ?? 0);
            currDesc = r.currDesc ?? "IDR";
          } else {
            fieldPremiFlexasController.clear();
            fieldPremiRsmdccController.clear();
            fieldPremiTsfwdController.clear();
            fieldPremiEqvetController.clear();
            fieldPremiOthersController.clear();
            fieldPremiBiController.clear();
            fieldPremiTotalController.clear();
            currDesc = "IDR";
          }
        }
      },
      buildWhen: (p, c) =>
      p.isLoaded != c.isLoaded ||
          p.isGroupFieldPremiChanged != c.isGroupFieldPremiChanged ||
          p.errors != c.errors,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ✅ TANPA tombol, hanya field hasil
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

                  const SizedBox(height: 16),
                  FormError(errors: state.errors ?? [], key: null,),
                ],
              ),
            ),
          ),
        );
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
