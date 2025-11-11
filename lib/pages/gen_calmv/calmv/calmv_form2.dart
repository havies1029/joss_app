import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';
import '../../../blocs/reusable_connection_flow/reusable_connection_flow_bloc.dart';

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
  State<CalmvForm2Section> createState() => _CalmvForm2SectionState();
}

class _CalmvForm2SectionState extends State<CalmvForm2Section> {
  final _formKey2 = GlobalKey<FormState>();

  // Controllers
  final fieldAwController = TextEditingController();
  final fieldIsEqController = TextEditingController();
  final fieldIsFloodController = TextEditingController();
  final fieldIsSrccController = TextEditingController();
  final fieldIsTbodController = TextEditingController();
  final fieldIsTerrorismController = TextEditingController();
  final fieldPadController = TextEditingController();
  final fieldPapController = TextEditingController();
  final fieldPassangerCountController = TextEditingController();
  final fieldPllController = TextEditingController();
  final fieldTplController = TextEditingController();

  late final Calmv2FormBloc calmv2Bloc;

  @override
  void initState() {
    super.initState();
    calmv2Bloc = context.read<Calmv2FormBloc>();
  }

  @override
  void dispose() {
    fieldAwController.dispose();
    fieldIsEqController.dispose();
    fieldIsFloodController.dispose();
    fieldIsSrccController.dispose();
    fieldIsTbodController.dispose();
    fieldIsTerrorismController.dispose();
    fieldPadController.dispose();
    fieldPapController.dispose();
    fieldPassangerCountController.dispose();
    fieldPllController.dispose();
    fieldTplController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = context.read<ReusableConnectionFlow>();

    return BlocListener<Calmv2FormBloc, Calmv2FormState>(
      listener: (context, state) {
        debugPrint("📡 [Form2] state change → isSaved=${state.isSaved}, isLoaded=${state.isLoaded}");

        if (state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⏳ Menyimpan Perlindungan Tambahan...')),
          );
        }

        if (state.isLoaded && state.record != null) {
          final r = state.record!;
          fieldAwController.text = r.aw.toString();
          fieldIsEqController.text = r.isEq.toString();
          fieldIsFloodController.text = r.isFlood.toString();
          fieldIsSrccController.text = r.isSrcc.toString();
          fieldIsTbodController.text = r.isTbod.toString();
          fieldIsTerrorismController.text = r.isTerrorism.toString();
          fieldPadController.text = NumberFormat("#,###").format(r.pad);
          fieldPapController.text = NumberFormat("#,###").format(r.pap);
          fieldPassangerCountController.text = r.passangerCount.toString();
          fieldPllController.text = NumberFormat("#,###").format(r.pll);
          fieldTplController.text = NumberFormat("#,###").format(r.tpl);
        }

        if (state.isSaved && !state.hasFailure) {
          final rawData = state.returnData?.data ?? "";
          final dataPremi =
          rawData.contains("|") ? rawData.split("|") : rawData.split(";");

          flow.moveTo("form3", data: dataPremi);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Perlindungan berhasil disimpan')),
          );
        }

        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Gagal menyimpan Perlindungan Tambahan')),
          );
        }
      },
      child: Card(
        color: pGrey,
        child: Column(
          children: [
            ListTile(
              title:
              Text('Perlindungan Tambahan', style: bodyTextStyle(context)),
              trailing: AnimatedRotation(
                turns: widget.isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: SvgPicture.asset(
                  'assets/icons/dropdown.svg',
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () => widget.onToggle(!widget.isExpanded),
            ),
            if (widget.isExpanded && widget.calmv1Id != null)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildFieldPLL()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildFieldTPL()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildFieldPAD()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildFieldPAP()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildFieldPassangerCount()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildFieldAW()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildFieldIsEq()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildFieldIsFlood()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildFieldIsSrcc()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildFieldIsTerrorism()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildFieldIsTbod()),
                          const Flexible(flex: 1, child: SizedBox.shrink()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AppButton.primary(
                        text: 'Simpan',
                        onPressed: _save,
                        backgroundColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Field Builders ---
  Widget _buildFieldAW() => appTextField(
    label: "Authorized Workshop (%)",
    controller: fieldAwController,
    keyboardType: TextInputType.number,
    suffix: Text("%", style: bodyTextStyle(context)),
    validator: (v) {
      if (v == null || v.isEmpty) return null;
      final value = double.tryParse(v);
      if (value == null) return "Format AW tidak valid";
      if (value < 0 || value > 100) return "AW harus antara 0–100%";
      return null;
    },
  );

  Widget _buildFieldPAD() => appTextField(
    label: "PA Driver",
    controller: fieldPadController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator("PA Driver"),
  );

  Widget _buildFieldPAP() => appTextField(
    label: "PA Passenger",
    controller: fieldPapController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator("PA Passenger"),
  );

  Widget _buildFieldPassangerCount() => appTextField(
    label: "Passenger Count",
    controller: fieldPassangerCountController,
    keyboardType: TextInputType.number,
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final val = int.tryParse(v.replaceAll(",", ""));
      if (val == null || val <= 0) return "Jumlah penumpang minimal 1";
      return null;
    },
  );

  Widget _buildFieldPLL() => appTextField(
    label: "Passenger Liability",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator("Passenger Liability"),
  );

  Widget _buildFieldTPL() => appTextField(
    label: "TPL",
    controller: fieldTplController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: _moneyValidator("TPL"),
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

  String? Function(String?) _moneyValidator(String label) {
    return (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final val = double.tryParse(clean);
      if (val == null || val < 0) return "$label tidak valid";
      return null;
    };
  }

  // --- SAVE Logic ---
  void _save() {
    final flow = context.read<ReusableConnectionFlow>();

    if (flow.state.isTransitioning || flow.state.isLoading) return;

    if (widget.calmv1Id == null || widget.calmv1Id!.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar("⚠️ Simpan Data Kendaraan terlebih dahulu"));
      return;
    }

    if (!_formKey2.currentState!.validate()) {
      debugPrint("⚠️ [Form2] Validasi gagal — form belum lengkap");
      return;
    }

    final record = Calmv2FormModel(
      calmv2Id: '',
      calmv1Id: widget.calmv1Id!,
      aw: double.tryParse(fieldAwController.text.replaceAll(',', '')) ?? 0,
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      isTbod: toBoolean(fieldIsTbodController.text),
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      pad: double.tryParse(fieldPadController.text.replaceAll(',', '')) ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(',', '')) ?? 0,
      passangerCount:
      int.tryParse(fieldPassangerCountController.text.replaceAll(',', '')) ??
          0,
      pll: double.tryParse(fieldPllController.text.replaceAll(',', '')) ?? 0,
      tpl: double.tryParse(fieldTplController.text.replaceAll(',', '')) ?? 0,
    );

    debugPrint("📦 [Form2] Record dibuat: ${record.toJson()}");

    if (widget.viewMode == "tambah") {
      calmv2Bloc.add(Calmv2FormTambahEvent(record: record));
    } else {
      calmv2Bloc.add(Calmv2FormUbahEvent(record: record));
    }
  }
}
