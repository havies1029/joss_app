import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../blocs/regpar/regpar3form_bloc.dart';
import '../../../../blocs/regpar/regpar4form_bloc.dart';
import '../../../../models/combobox/combomjnscoverpar_model.dart';
import '../../../../models/combobox/combomwilayah_model.dart';
import '../../../../models/combobox/combomzonagempa_model.dart';
import '../../../../models/combobox/combormatauang_model.dart';
import '../../../../models/regpar/regpar3form_model.dart';
import '../../../../models/regpar/regpar4form_model.dart';
import '../../../../repositories/combobox/combomjnscoverpar_repository.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';

class RegparForm4Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regpar1Id;

  const RegparForm4Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regpar1Id,
  });

  @override
  State<RegparForm4Section> createState() => RegparForm4SectionState();
}

class RegparForm4SectionState extends State<RegparForm4Section> {
  final _regparform4key = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldSiBuildingController = TextEditingController();
  final fieldSiContentController = TextEditingController();
  final fieldSiMachineryController = TextEditingController();
  final fieldSiOtherController = TextEditingController();
  final fieldSiStockController = TextEditingController();

  ComboRMatauangModel? fieldComboRMatauang;
  final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();

  late final Regpar4FormBloc regpar4Bloc;


  @override
  void initState() {
    super.initState();
    regpar4Bloc = context.read<Regpar4FormBloc>();
    // Future.microtask(_loadData);
  }

  void _loadData() {
    debugPrint("Regpar4FormLihatEvent trigger");
    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      regpar4Bloc.add(Regpar4FormLihatEvent(recordId: widget.regpar1Id!));
    }
  }

  @override
  void dispose() {
    fieldSiBuildingController.dispose();
    fieldSiContentController.dispose();
    fieldSiMachineryController.dispose();

    fieldSiOtherController.dispose();
    fieldSiStockController.dispose();
    super.dispose();
  }

  void onOpenedByParent() {
    debugPrint("Regpar4FormLihatEvent trigger");
    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      debugPrint("🔥 Form4 dibuka parent → trigger lihat event");
      regpar4Bloc.add(Regpar4FormLihatEvent(recordId: widget.regpar1Id!));
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
      title: Text("Nilai Pertanggungan", style: bodyTextStyle(context)),
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
        BlocListener<Regpar4FormBloc, Regpar4FormState>(
          listenWhen: (prev, curr) =>
          curr.isLoaded == true && curr.record != null,
          listener: (context, state) {
            _injectPayload(state.record!); // inject ke controller & variable
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Form(
          key: _regparform4key,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: _buildComboCurddId()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldSiMachinery()),
                ],
              ),
              const SizedBox(height: hPadding),
              Row(
                children: [
                  Flexible(child: buildFieldSiBuilding()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldSiOther()),
                ],
              ),
              const SizedBox(height: hPadding),
              Row(
                children: [
                  Flexible(child: buildFieldSiStock()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldSiContent()),
                ],
              ),
              // Row(
              //   children: [
              //     Flexible(child: _buildFieldIsSrcc()),
              //     const SizedBox(width: 8),
              //     Flexible(child: _buildFieldIsTerrorism()),
              //   ],
              // ),
              // const SizedBox(height: hPadding),
              //
              // Row(
              //   children: [
              //     Flexible(child: _buildFieldIsTbod()),
              //     const Flexible(child: SizedBox.shrink()),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _injectPayload(Regpar4FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldSiBuildingController.text = record.siBuilding.toString();
    fieldSiContentController.text = record.siContent.toString();
    fieldSiMachineryController.text = record.siMachinery.toString();
    fieldSiOtherController.text = record.siOther.toString();
    fieldSiStockController.text = record.siStock.toString();
    fieldComboRMatauang = record.comboRMatauang;

    setState(() {});
  }


  Future<bool> validateAndReturn() async {
    return _regparform4key.currentState?.validate() ?? false;
  }


  Future<void> saveForm4() async {
    final record = Regpar4FormModel(
      regpar1Id: widget.regpar1Id!,
      currId: fieldComboRMatauang?.rmatauangKode,
      siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
      siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
      siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
      siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
      siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di form1");
      regpar4Bloc.add(Regpar4FormTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di form1");
      regpar4Bloc.add(Regpar4FormUbahEvent(record: record));
    }
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

  Widget buildFieldSiBuilding() => appTextField(
    label: "Bangunan",
    controller: fieldSiBuildingController,
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

  Widget buildFieldSiContent() => appTextField(
    label: "Konten",
    controller: fieldSiContentController,
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

  Widget buildFieldSiMachinery() => appTextField(
    label: "Mesin",
    controller: fieldSiMachineryController,
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

  Widget buildFieldSiOther() => appTextField(
    label: "Lainnya",
    controller: fieldSiOtherController,
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

  Widget buildFieldSiStock() => appTextField(
    label: "Lainnya",
    controller: fieldSiStockController,
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
}