import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../widgets/apptheme/numeric_to_one_decimal_formatter.dart';

class CalmvForm2Section extends StatefulWidget {
  final String viewMode;
  final String? calmv1Id;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;

  const CalmvForm2Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.calmv1Id,
    this.recordId,
  });

  @override
  State<CalmvForm2Section> createState() => CalmvForm2SectionState();
}


class CalmvForm2SectionState extends State<CalmvForm2Section> {
  final _calmvform2key = GlobalKey<FormState>();

  // Controllers
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

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

  late final Calmv2FormBloc calmv2Bloc;

  @override
  void initState() {
    super.initState();
    calmv2Bloc = context.read<Calmv2FormBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      calmv2Bloc.add(Calmv2FormLihatEvent(recordId: widget.recordId!));
    }
  }

  @override
  void dispose() {
    fieldAwController.dispose();
    fieldPadController.dispose();
    fieldPapController.dispose();
    fieldPllController.dispose();
    fieldTplController.dispose();

    fieldIsEqController.dispose();
    fieldIsFloodController.dispose();
    fieldIsSrccController.dispose();
    fieldIsTbodController.dispose();
    fieldIsTerrorismController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Calmv2FormBloc, Calmv2FormState>(
      listenWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded && curr.isLoaded == true,
      listener: (context, state) {
        if (state.record != null) {
          _injectPayload(state.record!);
        }
      },
      child: Card(
        color: pGrey,
        child: Column(
          children: [
            _buildHeader(),
            if (widget.isExpanded) _buildForm(),
          ],
        ),
      ),
    );
  }

  void _injectPayload(Calmv2FormModel record) {
    debugPrint("🔥 [Form2] Injecting payload...");

    // Numeric Controllers
    fieldAwController.text       = cleanNum(record.aw);
    fieldPadController.text      = cleanNum(record.pad);
    fieldPapController.text      = cleanNum(record.pap);
    fieldPllController.text      = cleanNum(record.pll);
    fieldTplController.text      = cleanNum(record.tpl);

    // Boolean -> checkbox controllers
    fieldIsEqController.text         = record.isEq.toString();
    fieldIsFloodController.text      = record.isFlood.toString();
    fieldIsSrccController.text       = record.isSrcc.toString();
    fieldIsTbodController.text       = record.isTbod.toString();
    fieldIsTerrorismController.text  = record.isTerrorism.toString();
    selectedPassengerCount = record.passangerCount.toString();

    setState(() {});
  }

  Widget _buildHeader() {
    return ListTile(
      title: Text('Perlindungan Tambahan', style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset('assets/icons/dropdown.svg', width: 16),
      ),
      onTap: () => widget.onToggle(!widget.isExpanded),
    );
  }

  Widget _buildForm(){
    return Padding(
      padding: const EdgeInsets.all(15),
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
                Flexible(child: _buildFieldPassengerCountCombo()),
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
          ],
        ),
      ),
    );
  }

  Future<bool> validateAndReturn() async {
    return _calmvform2key.currentState?.validate() ?? false;
  }

  Future<void> saveForm2() async {
    final record = Calmv2FormModel(
      calmv2Id: widget.recordId ?? "",
      calmv1Id: widget.calmv1Id ?? "",
      aw: double.tryParse(fieldAwController.text.replaceAll(",", "")) ?? 0,
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      isTbod: toBoolean(fieldIsTbodController.text),
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      pad: double.tryParse(fieldPadController.text.replaceAll(",", "")) ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(",", "")) ?? 0,
      passangerCount: int.tryParse(selectedPassengerCount) ?? 0,
      pll: double.tryParse(fieldPllController.text.replaceAll(",", "")) ?? 0,
      tpl: double.tryParse(fieldTplController.text.replaceAll(",", "")) ?? 0,
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di form2");
      calmv2Bloc.add(Calmv2FormTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di form2");
      calmv2Bloc.add(Calmv2FormUbahEvent(record: record));
    }
  }

  // ----------------- FIELDS -----------------

  Widget _buildFieldAW() => appTextField(
    label: "Bengkel Resmi",
    controller: fieldAwController,
    keyboardType: TextInputType.number,
    suffix: Text("%", style: bodyTextStyle(context)),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      NumericToOneDecimalFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return null;
      final plain = v.replaceAll(".", "");
      if (plain.length > 3) {
        return "Maks 3 digit (100%)";
      }
      
      final x = double.tryParse(v);
      if (x == null) return "Format tidak valid";
      if (x > 100) return "Max 100%";

      return null;
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
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) return kString0;
      return null;
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
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) return kString0;
      return null;
    },
  );

  Widget _buildFieldPassengerCountCombo() {
    // List angka 1 sampai 7
    final counts = List<String>.generate(7, (i) => (i + 1).toString());

    return ReusableComboBox<String>(
      hintText: "Jumlah Penumpang",
      initItem: selectedPassengerCount.isNotEmpty ? selectedPassengerCount : null,
      dataLoader: () async => counts,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,

      validatorCallback: (value) {
        if (value == null || value.isEmpty) return kStringNullError;
        return null;
      },

      onChangedCallback: (value) {
        selectedPassengerCount = value ?? "";
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
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) return kString0;
      return null;
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
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) return kString0;
      return null;
    },
  );

  Widget _buildFieldIsEq() => CheckboxWidget(
    rightLabel: "Gempa Bumi",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) => fieldIsEqController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsFlood() => CheckboxWidget(
    rightLabel: "Banjir",
    initialValue: toBoolean(fieldIsFloodController.text),
    callback: (v) => fieldIsFloodController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsSrcc() => CheckboxWidget(
    rightLabel: "Kerusuhan",
    initialValue: toBoolean(fieldIsSrccController.text),
    callback: (v) => fieldIsSrccController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsTbod() => CheckboxWidget(
    rightLabel: "Kerusakan Barang Pihak ketiga",
    initialValue: toBoolean(fieldIsTbodController.text),
    callback: (v) => fieldIsTbodController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsTerrorism() => CheckboxWidget(
    rightLabel: "Terorisme",
    initialValue: toBoolean(fieldIsTerrorismController.text),
    callback: (v) => fieldIsTerrorismController.text = v.toString(),
    leftLabel: "",
  );
}
