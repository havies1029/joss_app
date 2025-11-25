import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv2form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv2form_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:string_validator/string_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../repositories/combobox/combommvjnscover_repository.dart';
import '../../repositories/combobox/combormatauang_repository.dart';

class Regmv2FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final String? parentRegmv1Id;
  final bool initiallyExpanded;

  // 🔥 callback kayak Form 1
  final void Function(String regmv2Id)? onRegmv2Created;
  final VoidCallback? onAccordionClose; // kalau mau, untuk future

  const Regmv2FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.parentRegmv1Id,
    this.initiallyExpanded = false,
    this.onRegmv2Created,
    this.onAccordionClose,
  });

  @override
  State<Regmv2FormFormPage> createState() => Regmv2FormFormPageState();
}

class Regmv2FormFormPageState extends State<Regmv2FormFormPage> {
  late Regmv2FormBloc regmv2FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  // controllers
  final fieldAwController = TextEditingController();
  final fieldCoverLamaController = TextEditingController();
  ComboRMatauangModel? fieldComboRMatauang;
  final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  final fieldIsEqController = TextEditingController();
  final fieldIsFloodController = TextEditingController();
  final fieldIsSrccController = TextEditingController();
  final fieldIsTbodController = TextEditingController();
  final fieldIsTerrorismController = TextEditingController();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  final fieldPadController = TextEditingController();
  final fieldPapController = TextEditingController();
  final fieldPassangerCountController = TextEditingController();
  final fieldPllController = TextEditingController();
  final fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldTplController = TextEditingController();

  String? _currentRegmv2Id;
  late String parentRegmv1Id;

  @override
  void initState() {
    super.initState();
    parentRegmv1Id = widget.parentRegmv1Id ?? "";
    debugPrint("🔥 [FORM2] parentRegmv1Id diterima dari parent = $parentRegmv1Id");

    Future.delayed(const Duration(milliseconds: 500), loadData);
  }

  @override
  void didUpdateWidget(Regmv2FormFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 🔥 Update parentRegmv1Id jika berubah dari parent
    if (widget.parentRegmv1Id != oldWidget.parentRegmv1Id) {
      setState(() {
        parentRegmv1Id = widget.parentRegmv1Id ?? "";
      });
      debugPrint("🔥 [FORM2] parentRegmv1Id updated = $parentRegmv1Id");
    }
  }

  void loadData() {
    if (widget.viewMode == "ubah" && widget.recordId.isNotEmpty) {
      regmv2FormBloc.add(Regmv2FormLihatEvent(recordId: widget.recordId));
    }
  }

  // 🔥 Method untuk save yang bisa dipanggil dari luar
  void saveForm() {
    // 🔥 Validasi parentRegmv1Id dulu
    if (parentRegmv1Id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Simpan Data Tertanggung terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final record = Regmv2FormModel(
        regmv2Id: _currentRegmv2Id ?? '',
        regmv1Id: parentRegmv1Id,
        aw: double.parse(fieldAwController.text.replaceAll(',', '')),
        coverLama: int.parse(fieldCoverLamaController.text),
        currId: fieldComboRMatauang?.rmatauangKode,
        isEq: toBoolean(fieldIsEqController.text),
        isFlood: toBoolean(fieldIsFloodController.text),
        isSrcc: toBoolean(fieldIsSrccController.text),
        isTbod: toBoolean(fieldIsTbodController.text),
        isTerrorism: toBoolean(fieldIsTerrorismController.text),
        mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
        pad: double.parse(fieldPadController.text.replaceAll(',', '')),
        pap: double.parse(fieldPapController.text.replaceAll(',', '')),
        passangerCount: int.parse(fieldPassangerCountController.text),
        pll: double.parse(fieldPllController.text.replaceAll(',', '')),
        polisAkhir: DateTime.parse(fieldPolisAkhirController.text),
        polisMulai: DateTime.parse(fieldPolisMulaiController.text),
        tpl: double.parse(fieldTplController.text.replaceAll(',', '')),
      );

      // 🔥 Jika sudah ada regmv2Id, berarti update. Jika belum, berarti tambah
      if (_currentRegmv2Id != null && _currentRegmv2Id!.isNotEmpty) {
        debugPrint("🔥 [FORM2] Updating existing record: $_currentRegmv2Id");
        regmv2FormBloc.add(Regmv2FormUbahEvent(record: record));
      } else {
        debugPrint("🔥 [FORM2] Creating new record");
        regmv2FormBloc.add(Regmv2FormTambahEvent(record: record));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    regmv2FormBloc = BlocProvider.of<Regmv2FormBloc>(context);

    return BlocConsumer<Regmv2FormBloc, Regmv2FormState>(
      listener: (context, state) {
        // 🔥 load data (viewMode = ubah)
        if (state.isLoaded && state.record != null) {
          fieldAwController.text =
              NumberFormat("#,###").format(state.record!.aw);
          fieldCoverLamaController.text =
              state.record!.coverLama.toString();
          fieldIsEqController.text = state.record!.isEq.toString();
          fieldIsFloodController.text = state.record!.isFlood.toString();
          fieldIsSrccController.text = state.record!.isSrcc.toString();
          fieldIsTbodController.text = state.record!.isTbod.toString();
          fieldIsTerrorismController.text =
              state.record!.isTerrorism.toString();
          fieldPadController.text =
              NumberFormat("#,###").format(state.record!.pad);
          fieldPapController.text =
              NumberFormat("#,###").format(state.record!.pap);
          fieldPassangerCountController.text =
              state.record!.passangerCount.toString();
          fieldPllController.text =
              NumberFormat("#,###").format(state.record!.pll);
          fieldPolisAkhirController.text =
              state.record!.polisAkhir.toIso8601String();
          fieldPolisMulaiController.text =
              state.record!.polisMulai.toIso8601String();
          fieldTplController.text =
              NumberFormat("#,###").format(state.record!.tpl);
          fieldComboRMatauang = state.comboRMatauang;
          fieldComboMMvjnscover = state.comboMMvjnscover;

          _currentRegmv2Id = state.record!.regmv2Id;
          debugPrint("🔥 [FORM2] Loaded regmv2Id = $_currentRegmv2Id");
        }

        // 🔥 setelah tambah/update berhasil
        if (state.isSaved && !state.hasFailure) {
          final newId = state.record?.regmv2Id;

          if (newId != null && newId.isNotEmpty) {
            debugPrint("🔥 [FORM2] regmv2Id from state = $newId");
            setState(() => _currentRegmv2Id = newId);

            if (widget.onRegmv2Created != null) {
              widget.onRegmv2Created!(newId);
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data Polis berhasil disimpan')),
          );
        }

        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan Data Polis'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: buildFieldPolisMulai()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldPolisAkhir()),
                ],
              ),
              const SizedBox(height: 12),
              buildFieldCurrId(),
              const SizedBox(height: 12),
              buildFieldMmvjnscoverId(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldPll()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldTpl()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldPad()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldPap()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldPassangerCount()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldAw()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldIsEq()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldIsFlood()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldIsSrcc()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldIsTerrorism()),
                ],
              ),
              const SizedBox(height: 12),
              buildFieldIsTbod(),
              const SizedBox(height: 12),
              buildFieldCoverLama(),
            ],
          ),
        );
      },
    );
  }

  Widget buildFieldAw() => appTextField(
    label: "Autorized Workshop",
    controller: fieldAwController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget buildFieldCoverLama() => appTextField(
    label: "Lama Cover",
    controller: fieldCoverLamaController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget buildFieldCurrId() {
    return ReusableComboBox<ComboRMatauangModel>(
      hintText: "Mata Uang",
      comboKey: comboRMatauangKey,
      initItem: fieldComboRMatauang,
      dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
      displayText: (item) => item.rmatauangSimbol,
      compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
      onChangedCallback: (value) {
        if (value != null) {
          regmv2FormBloc.add(ComboRMatauangChangedEvent(comboRMatauang: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboRMatauang = value;
      },
      validatorCallback: (value) {
        if (value == null) return "Field mata uang tidak boleh kosong.";
        return null;
      },
      showClearButton: false,
      enableSearch: false,
    );
  }

  Widget buildFieldIsEq() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "EQ",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) => fieldIsEqController.text = v.toString(),
  );

  Widget buildFieldIsFlood() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "Flood",
    initialValue: toBoolean(fieldIsFloodController.text),
    callback: (v) => fieldIsFloodController.text = v.toString(),
  );

  Widget buildFieldIsSrcc() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "SRCC",
    initialValue: toBoolean(fieldIsSrccController.text),
    callback: (v) => fieldIsSrccController.text = v.toString(),
  );

  Widget buildFieldIsTbod() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "TBOD",
    initialValue: toBoolean(fieldIsTbodController.text),
    callback: (v) => fieldIsTbodController.text = v.toString(),
  );

  Widget buildFieldIsTerrorism() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "Terrorism",
    initialValue: toBoolean(fieldIsTerrorismController.text),
    callback: (v) => fieldIsTerrorismController.text = v.toString(),
  );

  Widget buildFieldMmvjnscoverId() {
    return ReusableComboBox<ComboMMvjnscoverModel>(
      hintText: "Jenis Cover",
      comboKey: comboMMvjnscoverKey,
      initItem: fieldComboMMvjnscover,
      dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
      displayText: (item) => item.coverName,
      compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
      onChangedCallback: (value) {
        if (value != null) {
          regmv2FormBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboMMvjnscover = value;
      },
      validatorCallback: (value) {
        if (value == null) return "Field Jenis Cover tidak boleh kosong";
        return null;
      },
      showClearButton: false,
      enableSearch: false,
    );
  }

  Widget buildFieldPad() => appTextField(
    label: "PA Driver",
    controller: fieldPadController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget buildFieldPap() => appTextField(
    label: "PA Pessenger",
    controller: fieldPapController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget buildFieldPassangerCount() => appTextField(
    label: "Passanger Total",
    controller: fieldPassangerCountController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget buildFieldPll() => appTextField(
    label: "Passenger Liability",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget buildFieldPolisAkhir() => AppDateField(
    label: "Tanggal Akhir",
    initialValue: DateTime.tryParse(fieldPolisAkhirController.text),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    validator: (v) => v == null ? "" : null,
    onChanged: (v) {
      if (v != null) fieldPolisAkhirController.text = v.toIso8601String();
    },
  );

  Widget buildFieldPolisMulai() => AppDateField(
    label: "Tanggal Mulai",
    initialValue: DateTime.tryParse(fieldPolisMulaiController.text),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    validator: (v) => v == null ? "" : null,
    onChanged: (v) {
      if (v != null) fieldPolisMulaiController.text = v.toIso8601String();
    },
  );

  Widget buildFieldTpl() => appTextField(
    label: "Third Party Liability",
    controller: fieldTplController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  void addError({required String error}) {
    if (!errors.contains(error)) setState(() => errors.add(error));
  }

  void removeError({required String error}) {
    if (errors.contains(error)) setState(() => errors.remove(error));
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
}