import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../../models/combobox/combommvjnscover_model.dart';
import '../../../../models/combobox/combormatauang_model.dart';
import '../../../../models/gen_regmv/regmv2form_model.dart';
import '../../../../repositories/combobox/combommvjnscover_repository.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';
import '../../../../widgets/apptheme/numeric_to_one_decimal_formatter.dart';

class RegmvForm2Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1Id;

  const RegmvForm2Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1Id,
  });

  @override
  State<RegmvForm2Section> createState() => RegmvForm2SectionState();
}


class RegmvForm2SectionState extends State<RegmvForm2Section> {
  final _regmvform2key = GlobalKey<FormState>();
  final List<String> errors = [];
  late final Regmv2FormBloc regmv2Bloc;
  bool _isPayloadInjected = false;

  final fieldPolisAkhirController = TextEditingController();
  final fieldPolisMulaiController = TextEditingController();
  final fieldAwController = TextEditingController();
  final fieldCoverLamaController = TextEditingController();
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

  ComboRMatauangModel? fieldComboRMatauang;
  final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();

  DateTime? kejadianMulaiTgl;
  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day);

  String selectedPassengerCount = "";

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

  @override
  void initState() {
    super.initState();
    regmv2Bloc = context.read<Regmv2FormBloc>();
    kejadianBerakhirTgl = _years;
    // Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      regmv2Bloc.add(Regmv2FormLihatEvent(recordId: widget.regmv1Id!));
    }
  }

  @override
  void dispose() {
    fieldAwController.dispose();
    fieldCoverLamaController.dispose();

    fieldIsEqController.dispose();
    fieldIsFloodController.dispose();
    fieldIsSrccController.dispose();
    fieldIsTbodController.dispose();
    fieldIsTerrorismController.dispose();

    fieldPadController.dispose();
    fieldPapController.dispose();
    fieldPassangerCountController.dispose();
    fieldPllController.dispose();
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();
    fieldTplController.dispose();

    super.dispose();
  }


  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.regmv1Id != null) {
      debugPrint("🔥 Form2 dibuka parent → trigger lihat event ${widget.regmv1Id}");
      regmv2Bloc.add(Regmv2FormLihatEvent(recordId: widget.regmv1Id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          _buildHeader(),
          if (widget.isExpanded) _buildForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Data Polis", style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
      ),
      onTap: () {
        widget.onToggle(!widget.isExpanded);
      },
    );
  }

  Widget _buildForm() {
    return MultiBlocListener(
      listeners: [
        BlocListener<Regmv2FormBloc, Regmv2FormState>(
          listenWhen: (prev, curr) =>
          curr.isLoaded == true && curr.record != null && !_isPayloadInjected,
          listener: (context, state) {
            _injectPayload(state.record!);
            _isPayloadInjected = true;
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Form(
          key: _regmvform2key,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: buildFieldPolisMulai()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldPolisBerakhir()),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Flexible(child: _buildComboCurddId()),
                  const SizedBox(width: 8),
                  const Flexible(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(height: 12),

              _buildComboMMvjnscover(),
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
              const SizedBox(height: 12),

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
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void _injectPayload(Regmv2FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldAwController.text = record.aw.toString();

    fieldIsEqController.text = record.isEq.toString();
    fieldIsFloodController.text = record.isFlood.toString();
    fieldIsSrccController.text = record.isSrcc.toString();
    fieldIsTbodController.text = record.isTbod.toString();
    fieldIsTerrorismController.text = record.isTerrorism.toString();

    fieldPadController.text = cleanNum(record.pad);
    fieldPapController.text = cleanNum(record.pap);
    fieldPllController.text = cleanNum(record.pll);
    fieldTplController.text = cleanNum(record.tpl);

    fieldPolisMulaiController.text = record.polisMulai.toIso8601String();
    fieldPolisAkhirController.text = record.polisAkhir.toIso8601String();

    kejadianMulaiTgl = record.polisMulai;
    if (_isPayloadInjected) {
      kejadianBerakhirTgl = record.polisAkhir;
    }
    selectedPassengerCount = record.passangerCount.toString();
    fieldPassangerCountController.text = record.passangerCount.toString();

    // Dropdown Values
    fieldComboRMatauang = record.comboRMatauang;
    fieldComboMMvjnscover = record.comboMMvjnscover;

    setState(() {});
  }


  Future<bool> validateAndReturn() async {
    return _regmvform2key.currentState?.validate() ?? false;
  }


  Future<void> saveForm2() async {
    final record = Regmv2FormModel(
      aw: double.tryParse(fieldAwController.text.replaceAll(',', '')) ?? 0,
      currId: fieldComboRMatauang?.rmatauangKode,
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      isTbod: toBoolean(fieldIsTbodController.text),
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      pad: double.tryParse(fieldPadController.text.replaceAll(',', ''))  ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(',', ''))  ?? 0,
      passangerCount: int.tryParse(selectedPassengerCount ?? '') ?? 0,
      pll: double.tryParse(fieldPllController.text.replaceAll(',', ''))  ?? 0,
      polisMulai: kejadianMulaiTgl ?? DateTime.now(),
      polisAkhir: kejadianBerakhirTgl ?? DateTime.now().add(Duration(days: 365)),
      regmv2Id: widget.regmv1Id ?? "",
      tpl: double.tryParse(fieldTplController.text.replaceAll(',', '')) ?? 0,
        regmv1Id: widget.regmv1Id ?? "",
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di regmvform2");
      regmv2Bloc.add(Regmv2FormTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di regmvform2");
      regmv2Bloc.add(Regmv2FormUbahEvent(record: record));
    }

  }


  Widget buildFieldPolisMulai() {
    return AppDateField(
      label: 'Tanggal Mulai',
      initialValue: kejadianMulaiTgl ?? _today,
      firstDate: _today,
      lastDate: DateTime(2100),
      validator: (dt) => (dt == null) ? kStringNullError : null,
      onChanged: (dt) {
        setState(() {
          kejadianMulaiTgl = dt;
          kejadianBerakhirTgl = dt != null
              ? DateTime(dt.year + 1, dt.month, dt.day)
              : null;
        });
      },
    );
  }

  Widget buildFieldPolisBerakhir() {
    return AppDateField(
      label: 'Tanggal Berakhir',
      enabled: false,
      initialValue: kejadianBerakhirTgl ?? (_today.add(const Duration(days: 365))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      validator: (dt) => (dt == null) ? kStringNullError : null,
      onChanged: (_) {},
    );
  }


  Widget _buildComboCurddId() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboRMatauang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (item) => item.rmatauangNama,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboRMatauang = v,
    onSaveCallback: (value) => fieldComboRMatauang = value,
  );

  Widget _buildComboMMvjnscover() => ReusableComboBox<ComboMMvjnscoverModel>(
    hintText: "Jenis Cover",
    initItem: fieldComboMMvjnscover,
    dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
    displayText: (i) => i.coverName,
    compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMMvjnscover = v,
    onSaveCallback: (value) => fieldComboMMvjnscover = value,
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
    rightLabel: "Pencurian Barang oleh Supir",
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


  Widget _buildFieldPLL() => appTextField(
    label: "Tanggung Jawab Penumpang",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return null;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) return "Tidak boleh minus";
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

  Widget _buildFieldPAD() => appTextField(
    label: "Kecelakaan Diri Pengemudi",
    controller: fieldPadController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return null;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) return "Tidak boleh minus";
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
      if (v == null || v.isEmpty) return null;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) return "Tidak boleh minus";
      return null;
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
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;

      final x = double.tryParse(v);
      if (x == null) return "Format tidak valid";
      if (x < 0) return "Tidak boleh minus";
      if (x > 100) return "Max 100%";

      return null;
    },
  );
}