import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../blocs/gen_calmv/calmv1crud_bloc.dart';
import '../../../../blocs/gen_calmv/calmv2form_bloc.dart';

class CalmvForm2Section2 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CalmvForm2Section2({
    super.key,
    required this.formKey,
  });

  @override
  State<CalmvForm2Section2> createState() => CalmvForm2Section2State();
}

class CalmvForm2Section2State extends State<CalmvForm2Section2> {
  final _calmvform2key = GlobalKey<FormState>();
  //form2
  final fieldAwController = TextEditingController();
  final fieldPadController = TextEditingController();
  final fieldPapController = TextEditingController();
  final fieldPllController = TextEditingController();
  final fieldTplController = TextEditingController();
  final fieldIsEqController = TextEditingController();
  final fieldIsFloodController = TextEditingController();
  final fieldIsSrccController = TextEditingController();
  final fieldIsTbodController = TextEditingController();
  final fieldIsTerrorismController = TextEditingController();
  String selectedPassengerCount = "";
//form2

  String? calmv2Id;
  String? calmv1Id;
  late final Calmv2FormBloc calmv2Bloc;
  late final Calmv1CrudBloc calmv1Bloc;

  @override
  void initState() {
    super.initState();
    calmv2Bloc = context.read<Calmv2FormBloc>();
    calmv1Bloc = context.read<Calmv1CrudBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    final calmv1State = context.read<Calmv1CrudBloc>().state;
    calmv1Id = calmv1State.record?.calmv1Id;
    if (calmv1Id?.isNotEmpty == true) {
      calmv2Bloc.add(Calmv2FormLihatEvent(recordId: calmv2Id!));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return BlocConsumer<Calmv2FormBloc, Calmv2FormState>(
      listenWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded || prev.record != curr.record,
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          final r = state.record!;
          fieldAwController.text = r.aw.toString();
          fieldAwController.text = r.aw.toString();
          fieldPadController.text = r.pad.toString();
          fieldPapController.text = r.pap.toString();
          fieldPllController.text = r.pll.toString();
          fieldTplController.text = r.tpl.toString();
          fieldIsEqController.text = r.isEq.toString();
          fieldIsFloodController.text = r.isFlood.toString();
          fieldIsSrccController.text = r.isSrcc.toString();
          fieldIsTbodController.text = r.isTbod.toString();
          fieldIsTerrorismController.text = r.isTerrorism.toString();

          selectedPassengerCount = r.passangerCount.toString() ?? "";

          setState(() {});
        }
      },
      buildWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded || prev.record != curr.record,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Form(
            key: _calmvform2key,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(child: _buildFieldPLL()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildFieldTPL()),
                  ],
                ),
                const SizedBox(height: hPadding),

                Row(
                  children: [
                    Flexible(child: _buildFieldPAD()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildFieldPAP()),
                  ],
                ),
                const SizedBox(height: hPadding),

                Row(
                  children: [
                    Flexible(child: _buildFieldPassengerCountCombo()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildFieldAW()),
                  ],
                ),
                const SizedBox(height: hPadding),

                Row(
                  children: [
                    Flexible(child: _buildFieldIsEq()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildFieldIsFlood()),
                  ],
                ),
                const SizedBox(height: hPadding),

                Row(
                  children: [
                    Flexible(child: _buildFieldIsSrcc()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildFieldIsTerrorism()),
                  ],
                ),
                const SizedBox(height: hPadding),

                Row(
                  children: [
                    Flexible(child: _buildFieldIsTbod()),
                    const Flexible(child: SizedBox.shrink()),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }


//form2 field
  Widget _buildFieldAW() => appTextField(
    label: "Bengkel Resmi",
    controller: fieldAwController,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    suffix: Text("%", style: bodyTextStyle(context)),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      TextInputFormatter.withFunction((oldValue, newValue) {
        // Prevent input if value would exceed 100
        if (newValue.text.isEmpty) return newValue;

        final value = double.tryParse(newValue.text);
        if (value == null) return newValue;

        if (value > 100) {
          return oldValue; // Block input if exceeds 100
        }

        return newValue;
      }),
    ],
    errorText: err('form2.aw'),
    validator: (_) => err('form2.aw'),
    onChanged: (v) {
      final x = double.tryParse(v.trim());
      if (x != null && x >= 0 && x <= 100) {
        clearErr('form2.aw');
        calmv2Bloc.add(FieldAwChangedEvent(aw: x));
      }
    },
  );


  Widget _buildFieldPAD() => appTextField(
    label: "Kecelakaan Diri Pengemudi",
    controller: fieldPadController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.pad'),
    validator: (_) => err('form2.pad'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0){
        clearErr('form2.pad');
        calmv2Bloc.add(FieldPadChangedEvent(pad: angka));
      }
    },
  );

  Widget _buildFieldPAP() => appTextField(
    label: "Kecelakaan Diri Penumpang",
    controller: fieldPapController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.pap'),
    validator: (_) => err('form2.pap'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0){
        clearErr('form2.pap');
        calmv2Bloc.add(FieldPapChangedEvent(pap: angka));
      }
    },
  );

  Widget _buildFieldPassengerCountCombo() {
    final counts = List<String>.generate(7, (i) => (i + 1).toString());

    return ReusableComboBox<String>(
      hintText: "Jumlah Penumpang",
      initItem: selectedPassengerCount.isNotEmpty ? selectedPassengerCount : null,
      dataLoader: () async => counts,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,

      errorText: err('form2.passengerCount'),
      validatorCallback: (_) => err('form2.passengerCount'),

      onChangedCallback: (v) {
        final str = (v ?? "").toString();
        final passengerCountInt = int.tryParse(str) ?? 0;

        debugPrint("🔁 onChanged v='$v' parsed=$passengerCountInt");

        if (passengerCountInt > 0) {
          setState(() => selectedPassengerCount = str); // biar initItem sinkron juga
          clearErr('form2.passengerCount');
          calmv2Bloc.add(
            FieldPassengerCountChangedEvent(passangerCount: passengerCountInt),
          );
        } else {
          debugPrint("⚠️ parsing gagal / 0");
        }
      },

      onSaveCallback: (value) {
        selectedPassengerCount = value ?? "";
      },
    );
  }


  Widget _buildFieldPLL() => appTextField(
    label: "Tanggung Jawab Penumpang",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.pll'),
    validator: (_) => err('form2.pll'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form2.pll');
        calmv2Bloc.add(FieldPllChangedEvent(pll: angka));
      }
    },
  );

  Widget _buildFieldTPL() => appTextField(
    label: "Tanggung Jawab Pihak Ketiga",
    controller: fieldTplController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.tpl'),
    validator: (_) => err('form2.tpl'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form2.tpl');
        calmv2Bloc.add(FieldTplChangedEvent(tpl: angka));
      }
    },
  );

  Widget _buildFieldIsEq() => CheckboxWidget(
    rightLabel: "Gempa Bumi",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) {
      fieldIsEqController.text = v.toString();
      calmv2Bloc.add(FieldIsEqChangedEvent(isEq: v));
    },
    leftLabel: "",
  );

  Widget _buildFieldIsFlood() => CheckboxWidget(
    rightLabel: "Banjir",
    initialValue: toBoolean(fieldIsFloodController.text),
    callback: (v) {
      fieldIsFloodController.text = v.toString();
      calmv2Bloc.add(FieldIsFloodChangedEvent(isFlood: v));
    },
    leftLabel: "",
  );

  Widget _buildFieldIsSrcc() => CheckboxWidget(
    rightLabel: "Kerusuhan",
    initialValue: toBoolean(fieldIsSrccController.text),
    callback: (v) {
      fieldIsSrccController.text = v.toString();
      calmv2Bloc.add(FieldIsSrccChangedEvent(isSrcc: v));
    },
    leftLabel: "",
  );

  Widget _buildFieldIsTbod() => CheckboxWidget(
    rightLabel: "Pencurian Barang oleh Supir",
    initialValue: toBoolean(fieldIsTbodController.text),
    callback: (v) {
      fieldIsTbodController.text = v.toString();
      calmv2Bloc.add(FieldIsTbodChangedEvent(isTbod: v));
    },
    leftLabel: "",
  );

  Widget _buildFieldIsTerrorism() => CheckboxWidget(
    rightLabel: "Terorisme",
    initialValue: toBoolean(fieldIsTerrorismController.text),
    callback: (v) {
      fieldIsTerrorismController.text = v.toString();
      calmv2Bloc.add(FieldIsTerrorismChangedEvent(isTerrorism: v));
    },
    leftLabel: "",
  );
//form2 field

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }
  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }
  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

}