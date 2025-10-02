import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:string_validator/string_validator.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';

class SimulmvFormOpsiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvFormOpsiPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  SimulmvCrudFormPageFormOpsiState createState() =>
      SimulmvCrudFormPageFormOpsiState();
}

class SimulmvCrudFormPageFormOpsiState extends State<SimulmvFormOpsiPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  final List<String> errors = [];
  var fieldAwController = TextEditingController();
  var fieldIsEqController = TextEditingController();
  var fieldIsFloodController = TextEditingController();
  var fieldIsSrccController = TextEditingController();
  var fieldIsTerrorismController = TextEditingController();
  var fieldPadController = TextEditingController();
  var fieldPapController = TextEditingController();
  var fieldPllController = TextEditingController();
  var fieldTplController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldPLL()),
                    const SizedBox(width: 8),
                    Flexible(flex: 1, child: buildFieldPAD()),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldTPL()),
                    const SizedBox(width: 8),
                    Flexible(flex: 1, child: buildFieldPAP()),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldAW()),
                    const SizedBox(width: 8),
                    const Flexible(flex: 1, child: SizedBox.shrink()),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldIsEQ()),
                    const SizedBox(width: 8),
                    Flexible(flex: 1, child: buildFieldIsFlood()),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldIsSRCC()),
                    const SizedBox(width: 8),
                    Flexible(flex: 1, child: buildFieldIsTerrorism()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if ((state.isLoaded) || (state.isFieldOpsiChanged)) {
          if (state.record != null) {
            fieldAwController.text = NumberFormat.decimalPattern().format(
              state.record!.aw,
            );
            fieldIsEqController.text = state.record!.isEq.toString();
            fieldIsFloodController.text = state.record!.isFlood.toString();
            fieldIsSrccController.text = state.record!.isSrcc.toString();
            fieldIsTerrorismController.text =
                state.record!.isTerrorism.toString();
            fieldPadController.text = NumberFormat(
              "#,###",
            ).format(state.record!.pad);
            fieldPapController.text = NumberFormat(
              "#,###",
            ).format(state.record!.pap);
            fieldPllController.text = NumberFormat(
              "#,###",
            ).format(state.record!.pll);
            fieldTplController.text = NumberFormat(
              "#,###",
            ).format(state.record!.tpl);
          }
        }
      },
    );
  }

  Widget buildFieldAW() {
    return appTextField(
      label: "Authorized Workshop",
      hint: "0.00",
      controller: fieldAwController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      suffix: Text("%", style: bodyTextStyle(context)),
      onChanged: (value) {
        simulmvCrudBloc.add(
          FieldAWChangedEvent(awRate: double.tryParse(value) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final awRate = double.tryParse(value);
        if (awRate == null || awRate < 0) {
          return kString0;
        }
        if (awRate > 100) {
          return "Authorized Workshop tidak boleh lebih dari 100%";
        }
        return null;
      },
    );
  }

  Widget buildFieldIsEQ() {
    return CheckboxWidget(
      leftLabel: "",
      rightLabel: "EQ",
      initialValue: toBoolean(fieldIsEqController.text),
      callback: (value) {
        simulmvCrudBloc.add(CheckboxIsEQChangedEvent(isChecked: value));
      },
    );
  }

  Widget buildFieldIsFlood() {
    return CheckboxWidget(
      leftLabel: "",
      rightLabel: "Flood",
      initialValue: toBoolean(fieldIsFloodController.text),
      callback: (value) {
        simulmvCrudBloc.add(CheckboxIsFloodChangedEvent(isChecked: value));
      },
    );
  }

  Widget buildFieldIsSRCC() {
    return CheckboxWidget(
      leftLabel: "",
      rightLabel: "SRCC",
      initialValue: toBoolean(fieldIsSrccController.text),
      callback: (value) {
        simulmvCrudBloc.add(CheckboxIsRSCCChangedEvent(isChecked: value));
      },
    );
  }

  Widget buildFieldIsTerrorism() {
    return CheckboxWidget(
      leftLabel: "",
      rightLabel: "Terrorism",
      initialValue: toBoolean(fieldIsTerrorismController.text),
      callback: (value) {
        simulmvCrudBloc.add(CheckboxIsTerrorismChangedEvent(isChecked: value));
      },
    );
  }

  Widget buildFieldPAD() {
    return appTextField(
      label: "PA Driver",
      hint: "0",
      controller: fieldPadController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      onChanged: (value) {
        final clean = value.replaceAll(",", "");
        simulmvCrudBloc.add(
          FieldPADChangedEvent(pad: double.tryParse(clean) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pad = double.tryParse(clean);
        if (pad == null || pad <= 0) {
          return kString0;
        }
        return null;
      },
    );
  }

  Widget buildFieldPAP() {
    return appTextField(
      label: "PA Passenger",
      hint: "0",
      controller: fieldPapController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        final clean = value.replaceAll(",", "");
        simulmvCrudBloc.add(
          FieldPAPChangedEvent(pap: double.tryParse(clean) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pap = double.tryParse(clean);
        if (pap == null || pap <= 0) {
          return kString0;
        }
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldPLL() {
    return appTextField(
      label: "Passenger Liability",
      hint: "0",
      controller: fieldPllController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      onChanged: (value) {
        final clean = value.replaceAll(",", "");
        simulmvCrudBloc.add(
          FieldPLLChangedEvent(pll: double.tryParse(clean) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pll = double.tryParse(clean);
        if (pll == null || pll <= 0) {
          return kString0;
        }
        return null;
      },
    );
  }

  Widget buildFieldTPL() {
    return appTextField(
      label: "TPL",
      hint: "0",
      controller: fieldTplController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        final clean = value.replaceAll(",", "");
        simulmvCrudBloc.add(
          FieldTPLChangedEvent(tpl: double.tryParse(clean) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final tpl = double.tryParse(clean);
        if (tpl == null || tpl <= 0) {
          return kString0;
        }
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }
}