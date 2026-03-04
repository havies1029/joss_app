import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';

class SimulparFormPremiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormPremiPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  SimulparFormPremiPageFormState createState() =>
      SimulparFormPremiPageFormState();
}

class SimulparFormPremiPageFormState extends State<SimulparFormPremiPage> {
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
            fieldPremiTsfwdController.text = f.format(r.premiTsfwd ?? 0);
            fieldPremiEqvetController.text = f.format(r.premiEqvet ?? 0);
            fieldPremiOthersController.text = f.format(r.premiOthers ?? 0);
            fieldPremiBiController.text = f.format(r.premiBi ?? 0);
            fieldPremiTotalController.text = f.format(r.premiTotal ?? 0);
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
      buildWhen:
          (p, c) =>
              p.isLoaded != c.isLoaded ||
              p.isGroupFieldPremiChanged != c.isGroupFieldPremiChanged ||
              p.errors != c.errors,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildFieldPremiFlexas(),
                const SizedBox(height: 12),
                buildFieldPremiRsmdcc(),
                const SizedBox(height: 12),
                buildFieldPremiTsfwd(),
                const SizedBox(height: 12),
                buildFieldPremiEqvet(),
                const SizedBox(height: 12),
                buildFieldPremiOthers(),
                const SizedBox(height: 12),
                buildFieldPremiBI(),
                const SizedBox(height: 12),
                buildFieldPremiTotal(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFieldPremiTotal() {
    return appTextField(
      label: "Total Premi",
      controller: fieldPremiTotalController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }

  Widget buildFieldPremiBI() {
    return appTextField(
      label: "Premi BI",
      controller: fieldPremiBiController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }

  Widget buildFieldPremiFlexas() {
    return appTextField(
      label: "Premi FLEXAS",
      controller: fieldPremiFlexasController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }

  Widget buildFieldPremiRsmdcc() {
    return appTextField(
      label: "Premi RSMDCC",
      controller: fieldPremiRsmdccController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }

  Widget buildFieldPremiTsfwd() {
    return appTextField(
      label: "Premi TSFWD",
      controller: fieldPremiTsfwdController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }

  Widget buildFieldPremiEqvet() {
    return appTextField(
      label: "Premi EQVET",
      controller: fieldPremiEqvetController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }

  Widget buildFieldPremiOthers() {
    return appTextField(
      label: "Premi Lainnya",
      controller: fieldPremiOthersController,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("$currDesc | ", style: bodyTextStyle(context)),
      onChanged: (value) {},
    );
  }
}
