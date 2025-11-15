import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

import '../../../blocs/reusable_connection_flow/flow_parent_cubit.dart';

class CalmvForm2Section extends StatefulWidget {
  final String viewMode;
  final String? calmv1Id;
  final bool isExpanded;
  final Function(bool) onToggle;

  const CalmvForm2Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.calmv1Id,
  });

  @override
  State<CalmvForm2Section> createState() => CalmvForm2SectionState();
}

class CalmvForm2SectionState extends State<CalmvForm2Section> {
  final _formKey2 = GlobalKey<FormState>();

  // Controllers
  final fieldAwController = TextEditingController();
  final fieldPadController = TextEditingController();
  final fieldPapController = TextEditingController();
  final fieldPassangerCountController = TextEditingController();
  final fieldPllController = TextEditingController();
  final fieldTplController = TextEditingController();

  final fieldIsEqController = TextEditingController();
  final fieldIsFloodController = TextEditingController();
  final fieldIsSrccController = TextEditingController();
  final fieldIsTbodController = TextEditingController();
  final fieldIsTerrorismController = TextEditingController();

  late final Calmv2FormBloc calmv2Bloc;
  String? _localCalmv2Id;

  @override
  void initState() {
    super.initState();
    calmv2Bloc = context.read<Calmv2FormBloc>();
  }

  @override
  void dispose() {
    fieldAwController.dispose();
    fieldPadController.dispose();
    fieldPapController.dispose();
    fieldPassangerCountController.dispose();
    fieldPllController.dispose();
    fieldTplController.dispose();

    fieldIsEqController.dispose();
    fieldIsFloodController.dispose();
    fieldIsSrccController.dispose();
    fieldIsTbodController.dispose();
    fieldIsTerrorismController.dispose();
    super.dispose();
  }

  Future<void> validateSelf() async {
    final isValid = _formKey2.currentState?.validate() ?? false;

    context.read<FlowParentCubit>().onValidationResult(
      index: 1,
      isValid: isValid,
    );
  }

  Future<void> saveSelf() async {
    _saveForm();
  }

  void activate() {
    setState(() {});

    // HANYA load ulang data jika form2 baru pertama kali dibuka
    if (_localCalmv2Id != null && widget.isExpanded) {
      calmv2Bloc.add(Calmv2FormLihatEvent(recordId: _localCalmv2Id!));
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<Calmv2FormBloc, Calmv2FormState>(
      listener: (context, state) {
        if (widget.isExpanded && state.isLoaded && state.record != null) {
          final r = state.record!;

          fieldAwController.text = r.aw.toString();
          fieldPadController.text = NumberFormat("#,###").format(r.pad);
          fieldPapController.text = NumberFormat("#,###").format(r.pap);
          fieldPassangerCountController.text = r.passangerCount.toString();
          fieldPllController.text = NumberFormat("#,###").format(r.pll);
          fieldTplController.text = NumberFormat("#,###").format(r.tpl);

          fieldIsEqController.text = r.isEq.toString();
          fieldIsFloodController.text = r.isFlood.toString();
          fieldIsSrccController.text = r.isSrcc.toString();
          fieldIsTbodController.text = r.isTbod.toString();
          fieldIsTerrorismController.text = r.isTerrorism.toString();
        }

        if (state.isSaved && !state.hasFailure) {
          final returnedId = state.returnData?.data ?? "";

          // INSERT → id selalu dari returnData
          if (returnedId.isNotEmpty) {
            _localCalmv2Id = returnedId;
          }

          // UPDATE → server tidak mengirim ID → gunakan ID lama
          else if (_localCalmv2Id == null) {
            _localCalmv2Id = state.record?.calmv2Id; // fallback
          }

          if (_localCalmv2Id != null) {
            context.read<FlowParentCubit>().onSaveResult(
              index: 1,
              id: _localCalmv2Id!,
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Perlindungan tambahan disimpan")),
          );
        }

      },
      child: Card(
        color: pGrey,
        child: Column(
          children: [
            ListTile(
              title: Text('Perlindungan Tambahan', style: bodyTextStyle(context)),
              trailing: AnimatedRotation(
                turns: widget.isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: SvgPicture.asset('assets/icons/dropdown.svg', width: 16),
              ),
              onTap: () => widget.onToggle(!widget.isExpanded),
            ),

            if (widget.isExpanded)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(child: _buildFieldPLL()),
                          const SizedBox(width: 8),
                          Flexible(child: _buildFieldTPL()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Flexible(child: _buildFieldPAD()),
                          const SizedBox(width: 8),
                          Flexible(child: _buildFieldPAP()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Flexible(child: _buildFieldPassangerCount()),
                          const SizedBox(width: 8),
                          Flexible(child: _buildFieldAW()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Flexible(child: _buildFieldIsEq()),
                          const SizedBox(width: 8),
                          Flexible(child: _buildFieldIsFlood()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Flexible(child: _buildFieldIsSrcc()),
                          const SizedBox(width: 8),
                          Flexible(child: _buildFieldIsTerrorism()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Flexible(child: _buildFieldIsTbod()),
                          const Flexible(child: SizedBox.shrink()),
                        ],
                      ),

                      const SizedBox(height: 15),
                      // AppButton.primary(
                      //   text: "Simpan",
                      //   onPressed: _saveForm,
                      // ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ----------------- SAVE -----------------
  void _saveForm() {
    if (!_formKey2.currentState!.validate()) return;

    final id = _localCalmv2Id ?? "";

    final record = Calmv2FormModel(
      calmv2Id: id,
      calmv1Id: widget.calmv1Id ?? "",
      aw: double.tryParse(fieldAwController.text.replaceAll(",", "")) ?? 0,
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      isTbod: toBoolean(fieldIsTbodController.text),
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      pad: double.tryParse(fieldPadController.text.replaceAll(",", "")) ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(",", "")) ?? 0,
      passangerCount: int.tryParse(fieldPassangerCountController.text.replaceAll(",", "")) ?? 0,
      pll: double.tryParse(fieldPllController.text.replaceAll(",", "")) ?? 0,
      tpl: double.tryParse(fieldTplController.text.replaceAll(",", "")) ?? 0,
    );

    final isTambah = id.isEmpty;

    calmv2Bloc.add(
      isTambah
          ? Calmv2FormTambahEvent(record: record)
          : Calmv2FormUbahEvent(record: record),
    );
  }

  // ----------------- FIELDS -----------------

  Widget _buildFieldAW() => appTextField(
    label: "Authorized Workshop (%)",
    controller: fieldAwController,
    keyboardType: TextInputType.number,
    suffix: Text("%", style: bodyTextStyle(context)),
    validator: (v) {
      if (v == null || v.isEmpty) return null;
      final x = double.tryParse(v);
      if (x == null) return "Format tidak valid";
      if (x < 0 || x > 100) return "0–100%";
      return null;
    },
  );

  Widget _buildFieldPAD() => appTextField(
    label: "PA Driver",
    controller: fieldPadController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator(),
  );

  Widget _buildFieldPAP() => appTextField(
    label: "PA Passenger",
    controller: fieldPapController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator(),
  );

  Widget _buildFieldPassangerCount() => appTextField(
    label: "Passenger Count",
    controller: fieldPassangerCountController,
    keyboardType: TextInputType.number,
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final x = int.tryParse(v.replaceAll(",", ""));
      if (x == null || x <= 0) return "Min 1";
      return null;
    },
  );

  Widget _buildFieldPLL() => appTextField(
    label: "Passenger Liability",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator(),
  );

  Widget _buildFieldTPL() => appTextField(
    label: "TPL",
    controller: fieldTplController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator(),
  );

  Widget _buildFieldIsEq() => CheckboxWidget(
    rightLabel: "EQ",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) => fieldIsEqController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsFlood() => CheckboxWidget(
    rightLabel: "Flood",
    initialValue: toBoolean(fieldIsFloodController.text),
    callback: (v) => fieldIsFloodController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsSrcc() => CheckboxWidget(
    rightLabel: "SRCC",
    initialValue: toBoolean(fieldIsSrccController.text),
    callback: (v) => fieldIsSrccController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsTbod() => CheckboxWidget(
    rightLabel: "TBOD",
    initialValue: toBoolean(fieldIsTbodController.text),
    callback: (v) => fieldIsTbodController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsTerrorism() => CheckboxWidget(
    rightLabel: "Terrorism",
    initialValue: toBoolean(fieldIsTerrorismController.text),
    callback: (v) => fieldIsTerrorismController.text = v.toString(),
    leftLabel: "",
  );

  String? Function(String?) _moneyValidator() {
    return (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null || x < 0) return "Tidak valid";
      return null;
    };
  }
}
