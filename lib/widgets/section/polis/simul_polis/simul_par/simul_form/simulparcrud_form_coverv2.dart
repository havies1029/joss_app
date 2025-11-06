import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/repositories/combobox/combombiindemnityojk_repository.dart';
import 'package:joss_app/repositories/combobox/combomkabzonagempa_repository.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulparFormCoverV2Page extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormCoverV2Page({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  SimulparFormCoverV2PageFormState createState() =>
      SimulparFormCoverV2PageFormState();
}

class SimulparFormCoverV2PageFormState extends State<SimulparFormCoverV2Page> {
  late SimulparCrudBloc simulparCrudBloc;
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
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Column(
            children: [
              buildFieldRateRSMDCC(),
              // const SizedBox(height: 10),
              // buildFieldRatePAR(),
              const SizedBox(height: 10),
              buildFieldWilayah(),
              // const SizedBox(height: 10),
              // buildFieldRateTSFWD(),
              const SizedBox(height: 10),
              buildFieldKabupaten(),
              // const SizedBox(height: 10),
              // buildFieldRateEQVET(),
              const SizedBox(height: 10),
              buildFieldBiIndemnity(),
              // const SizedBox(height: 10),
              // buildFieldBiIndexRate(),
              const SizedBox(height: 10),
              buildFieldRateOther(),
              // const SizedBox(height: 10),
              // buildFieldRateTotal(),
            ],
          ),
        );
      },
      listener: (context, state) {
        if ((state.isLoaded) || (state.isGroupFieldRateChanged)) {
          if (state.record != null) {
            fieldRateParController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.ratePar);
            fieldRateRsmdccController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.rateRsmdcc);
            fieldRateTsfwdController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.rateTsfwd);
            fieldRateEqvetController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.rateEqvet);
            fieldRateOtherController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.rateOther);
            fieldBiIndexRateController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.biIndexRate);
            fieldRateTotalController.text = NumberFormat(
              "##0.0###",
            ).format(state.record!.rateTotal);
          }
          fieldComboMWilayah = state.comboMWilayah;
          fieldComboMKabZonaGempa = state.comboMKabZonaGempa;
          fieldComboMBiindemnityOjk = state.comboMBiindemnityOjk;
        }
      },
    );
  }

  Widget buildFieldRatePAR() {
    return appTextField(
      label: "Rate PAR",
      controller: fieldRateParController,
      keyboardType: TextInputType.number,
      enabled: false,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      onChanged: (_) {},
      textInputAction: TextInputAction.next,
      hint: null,
      suffix: Text(" %", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldRateRSMDCC() {
    return appTextField(
      label: "Rate RSMDCC",
      controller: fieldRateRsmdccController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      onChanged: (value) {
        simulparCrudBloc.add(
          FieldRateRsmdccChangedEvent(rateRsmdcc: double.tryParse(value) ?? 0),
        );
      },
      textInputAction: TextInputAction.next,
      suffix: Text(" %", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldWilayah() {
    return ReusableComboBox<ComboMWilayahModel>(
      hintText: "Wilayah",
      comboKey: comboMWilayahKey,
      initItem: fieldComboMWilayah,
      dataLoader: () async {
        return ComboMWilayahRepository().getComboMWilayah();
      },
      displayText: (item) => item.wilayahNama,
      compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMWilayah = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldRateTSFWD() {
    return appTextField(
      label: "Rate TSFWD",
      controller: fieldRateTsfwdController,
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      onChanged: (value) {},
      suffix: Text("%", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldKabupaten() {
    return ReusableComboBox<ComboMKabZonaGempaModel>(
      hintText: "Zona Gempa - Kabupaten",
      comboKey: comboMKabZonaGempaKey,
      initItem: fieldComboMKabZonaGempa,
      dataLoader: () async {
        return ComboMKabZonaGempaRepository().getComboMKabZonaGempa("");
      },
      displayText: (item) => "${item.mzonagempaId} - ${item.kabupaten}",
      compareItems: (a, b) => a.mkabzonagempaId == b.mkabzonagempaId,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc.add(
            ComboMKabZonaGempaChangedEvent(comboMKabZonaGempa: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMKabZonaGempa = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldRateEQVET() {
    return appTextField(
      label: "Rate EQVET",
      controller: fieldRateEqvetController,
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      hint: "0.00",
      onChanged: (value) {},
      textInputAction: TextInputAction.done,
      suffix: Text("%", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldRateOther() {
    return appTextField(
      label: "Rate Other",
      controller: fieldRateOtherController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      suffix: Text(" %", style: bodyTextStyle(context)),
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        simulparCrudBloc.add(
          FieldRateOthersChangedEvent(rate: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldRateTotal() {
    return appTextField(
      label: "Rate Total",
      controller: fieldRateTotalController,
      enabled: false,
      keyboardType: TextInputType.number,
      suffix: Text(" %", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldBiIndexRate() {
    return appTextField(
      label: "Index Rate",
      controller: fieldBiIndexRateController,
      enabled: false,
      keyboardType: TextInputType.number,
    );
  }

  Widget buildFieldBiIndemnity() {
    return ReusableComboBox<ComboMBiindemnityOjkModel>(
      hintText: "Periode Indemnity",
      comboKey: comboMBiindemnityOjkKey,
      initItem: fieldComboMBiindemnityOjk,
      dataLoader: () async {
        return ComboMBiindemnityOjkRepository().getComboMBiindemnityOjk();
      },
      displayText: (item) => item.keterangan,
      compareItems: (a, b) => a.mbiindemnityojkId == b.mbiindemnityojkId,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc.add(
            ComboMBiindemnityOjkChangedEvent(comboMBiindemnityOjk: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMBiindemnityOjk = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }
}