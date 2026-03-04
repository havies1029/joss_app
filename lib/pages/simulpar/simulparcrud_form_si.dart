import 'package:joss_app/models/combobox/combormatauang_model.dart'
    show ComboRMatauangModel;
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';

class SimulparCrudFormSumInsuredPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparCrudFormSumInsuredPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparCrudFormSumInsuredPageState createState() =>
      SimulparCrudFormSumInsuredPageState();
}

class SimulparCrudFormSumInsuredPageState
    extends State<SimulparCrudFormSumInsuredPage> {
  late SimulparCrudBloc simulparCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldSiBuildingController = TextEditingController();
  var fieldSiContentController = TextEditingController();
  var fieldSiMachineryController = TextEditingController();
  var fieldSiOtherController = TextEditingController();
  var fieldSiStockController = TextEditingController();
  var fieldStockAdjustableController = TextEditingController();
  var fieldSiBiController = TextEditingController();
  var fieldSiTotalController = TextEditingController();
  ComboRMatauangModel? fieldComboRMatauang;

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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldCurr()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldSiBuilding()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildFieldSiMachinery(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldSiStock()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: fieldFieldStockAdjustable(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldSiContent()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildFieldSiOthers(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldSiBi()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildFieldSiTotal(),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          if (state.record != null) {
            fieldSiBuildingController.text =
                NumberFormat("#,###").format(state.record!.siBuilding);
            fieldSiContentController.text =
                NumberFormat("#,###").format(state.record!.siContent);
            fieldSiMachineryController.text =
                NumberFormat("#,###").format(state.record!.siMachinery);
            fieldSiOtherController.text =
                NumberFormat("#,###").format(state.record!.siOther);
            fieldSiStockController.text =
                NumberFormat("#,###").format(state.record!.siStock);
            fieldStockAdjustableController.text =
                NumberFormat("###.00").format(state.record!.stockAdjustable);
            fieldSiBiController.text =
                NumberFormat("#,###").format(state.record!.siBi);

            fieldSiTotalController.text =
                NumberFormat("#,###").format(state.record!.siTotal);
          }

          fieldComboRMatauang = state.comboRMatauang;
        }
      },
    );
  }


  Widget buildFieldSiBuilding() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiBuildingController,
      decoration: const InputDecoration(
        labelText: "Building",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
            FieldSiBuildingChangedEvent(si: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldSiContent() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiContentController,
      decoration: const InputDecoration(
        labelText: "Content",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc
            .add(FieldSiContentChangedEvent(si: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldSiMachinery() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiMachineryController,
      decoration: const InputDecoration(
        labelText: "Machinery",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
            FieldSiMachineryChangedEvent(si: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldSiOthers() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiOtherController,
      decoration: const InputDecoration(
        labelText: "Others",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc
            .add(FieldSiOthersChangedEvent(si: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldSiStock() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiStockController,
      decoration: const InputDecoration(
        labelText: "Stock",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc
            .add(FieldSiStockChangedEvent(si: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  fieldFieldStockAdjustable() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldStockAdjustableController,
      decoration: const InputDecoration(
        labelText: "Stock Adjustable",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {
        simulparCrudBloc.add(FieldStockAdjustableChangedEvent(
            adjustable: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldSiBi() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiBiController,
      decoration: const InputDecoration(
        labelText: "BI",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc
            .add(FieldSiBiChangedEvent(si: (double.tryParse(value) ?? 0)));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldCurr() {
    return buildFieldComboRMatauang(
      labelText: 'Currency',
      initItem: fieldComboRMatauang,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc
              .add(ComboRMatauangChangedEvent(comboRMatauang: value));
        }
      },
      onSaveCallback: (value) {},
    );
  }

  Widget buildFieldSiTotal() {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldSiTotalController,
      decoration: const InputDecoration(
          labelText: "Total",
          floatingLabelBehavior: FloatingLabelBehavior.always),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }
}
