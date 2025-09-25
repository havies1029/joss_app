import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combombiindemnityojk_widget.dart';
import 'package:joss_app/widgets/combobox/combomkabzonagempa_widget.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulparCrudFormCoverV2Page extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparCrudFormCoverV2Page(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparCrudFormCoverV2PageFormState createState() =>
      SimulparCrudFormCoverV2PageFormState();
}

class SimulparCrudFormCoverV2PageFormState
    extends State<SimulparCrudFormCoverV2Page> {
  late SimulparCrudBloc simulparCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  final comboMKabZonaGempaKey =
      GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();

  ComboMBiindemnityOjkModel? fieldComboMBiindemnityOjk;
  final comboMBiindemnityOjkKey =
      GlobalKey<DropdownSearchState<ComboMBiindemnityOjkModel>>();

  var fieldRateTsfwdController = TextEditingController();
  var fieldRateParController = TextEditingController();
  var fieldRateRsmdccController = TextEditingController();
  var fieldRateEqvetController = TextEditingController();
  var fieldRateOtherController = TextEditingController();
  var fieldRateTotalController = TextEditingController();
  var fieldBiIndexRateController = TextEditingController();

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
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: SizedBox(
                                child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'FLEXAS',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: buildFieldRatePAR()),
                              )),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'RSMDCC',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: buildFieldRateRSMDCC()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'TSFWD',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            buildFieldWilayah(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: buildFieldRateTSFWD()),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'EQVET',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            buildFieldKabupaten(),
                            const SizedBox(height: 10),                            
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildFieldRateEQVET(),
                                  ),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'BI',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            buildFieldBiIndemnity(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildFieldBiIndexRate(),
                                  ),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: SizedBox(
                                child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'OTHERS',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: buildFieldRateOther()),
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'TOTAL',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: buildFieldRateTotal()),
                            ),
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
        if ((state.isLoaded) || (state.isGroupFieldRateChanged)) {
          if (state.record != null) {
            fieldRateParController.text =
                NumberFormat("##0.0###").format(state.record!.ratePar);
            fieldRateRsmdccController.text =
                NumberFormat("##0.0###").format(state.record!.rateRsmdcc);
            fieldRateTsfwdController.text =
                NumberFormat("##0.0###").format(state.record!.rateTsfwd);
            fieldRateEqvetController.text =
                NumberFormat("##0.0###").format(state.record!.rateEqvet);
            fieldRateOtherController.text =
                NumberFormat("##0.0###").format(state.record!.rateOther);
            fieldBiIndexRateController.text =
                NumberFormat("##0.0###").format(state.record!.biIndexRate);
            fieldRateTotalController.text =
                NumberFormat("##0.0###").format(state.record!.rateTotal);
          }
          fieldComboMWilayah = state.comboMWilayah;
          fieldComboMKabZonaGempa = state.comboMKabZonaGempa;
          fieldComboMBiindemnityOjk = state.comboMBiindemnityOjk;
        }
      },
    );
  }

  Widget buildFieldRatePAR() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateParController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldRateRSMDCC() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateRsmdccController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {
        simulparCrudBloc.add(FieldRateRsmdccChangedEvent(
            rateRsmdcc: double.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldWilayah() {
    return buildFieldComboMWilayah(
      comboKey: comboMWilayahKey,
      labelText: 'Wilayah',
      initItem: fieldComboMWilayah,
      onChangedCallback: (value) {
        simulparCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMWilayah = value;
        }
      },
    );
  }

  Widget buildFieldRateTSFWD() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateTsfwdController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldKabupaten() {
    return buildFieldComboMKabZonaGempa(
      comboKey: comboMKabZonaGempaKey,
      labelText: 'Zona Gempa - Kabupaten',
      initItem: fieldComboMKabZonaGempa,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc
              .add(ComboMKabZonaGempaChangedEvent(comboMKabZonaGempa: value));
        }
      },
      onSaveCallback: (value) {},
    );
  }

  buildFieldRateEQVET() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateEqvetController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {
        
      },
      textAlign: TextAlign.right,
    );
  }

  buildFieldRateOther() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateOtherController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {
        simulparCrudBloc.add(
            FieldRateOthersChangedEvent(rate: double.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldRateTotal() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldRateTotalController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldBiIndexRate() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldBiIndexRateController,
      decoration: const InputDecoration(
        labelText: "Index Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldBiIndemnity() {
    return buildFieldComboMBiindemnityOjk(
      comboKey: comboMBiindemnityOjkKey,
      labelText: 'Periode Indemnity',
      initItem: fieldComboMBiindemnityOjk,
      onChangedCallback: (value) {
        simulparCrudBloc.add(
            ComboMBiindemnityOjkChangedEvent(comboMBiindemnityOjk: value));
  
      },
      onSaveCallback: (value) {},
    );
  }
}
