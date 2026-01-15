import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/calpar/calpar2form_bloc.dart';
import 'package:joss_app/models/calpar/calpar2form_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../repositories/combobox/combombiindemnityojk_repository.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';

class Calpar2FormPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final String? calpar1Id;
  final bool isExpanded;
  final Function(bool) onToggle;

  const Calpar2FormPage({super.key, required this.viewMode, required this.recordId, this.calpar1Id, required this.isExpanded, required this.onToggle});

  @override
  Calpar2FormPageFormState createState() => Calpar2FormPageFormState();
}

class Calpar2FormPageFormState extends State<Calpar2FormPage> {
  final _calparform2key = GlobalKey<FormState>();

  // Controllers
  final fieldBiIndexRateController = TextEditingController();
  final fieldBiTotalController = TextEditingController();
  final fieldSiBiController = TextEditingController();
  final fieldSiBuildingController = TextEditingController();
  final fieldSiContentController = TextEditingController();
  final fieldSiMachineryController = TextEditingController();
  final fieldSiOtherController = TextEditingController();
  final fieldSiStockController = TextEditingController();
  final fieldStockAdjustableController = TextEditingController();

  ComboMBiindemnityOjkModel? fieldComboMBiindemnityOjk;
  ComboRMatauangModel? fieldComboRMatauang;

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

  late final Calpar2FormBloc calpar2Bloc;

  @override
  void initState() {
    super.initState();
    calpar2Bloc = context.read<Calpar2FormBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.calpar1Id != null) {
      calpar2Bloc.add(Calpar2FormLihatEvent(recordId: widget.calpar1Id!));
    }
  }

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.calpar1Id != null) {
      calpar2Bloc.add(Calpar2FormLihatEvent(recordId: widget.calpar1Id!));
    }
  }


  @override
  void dispose() {
    fieldBiIndexRateController.dispose();
    fieldBiTotalController.dispose();
    fieldSiBiController.dispose();
    fieldSiBuildingController.dispose();
    fieldSiContentController.dispose();
    fieldSiMachineryController.dispose();
    fieldSiOtherController.dispose();
    fieldSiStockController.dispose();
    fieldStockAdjustableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Calpar2FormBloc, Calpar2FormState>(
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

  void _injectPayload(Calpar2FormModel record) {
    fieldBiIndexRateController.text       = cleanNum(record.biIndexRate);
    fieldBiTotalController.text      = cleanNum(record.biTotal);
    fieldSiBiController.text      = cleanNum(record.siBi);
    fieldSiBuildingController.text      = cleanNum(record.siBuilding);
    fieldSiContentController.text      = cleanNum(record.siContent);
    fieldSiMachineryController.text      = cleanNum(record.siMachinery);
    fieldSiOtherController.text      = cleanNum(record.siOther);
    fieldSiStockController.text      = cleanNum(record.siStock);
    fieldStockAdjustableController.text      = cleanNum(record.stockAdjustable);

    fieldComboMBiindemnityOjk = record.comboMBiindemnityOjk;
    fieldComboRMatauang = record.comboRMatauang;

    setState(() {});
  }

  Widget _buildHeader() {
    return ListTile(
      title: Text('Nilai Pertanggungan', style: bodyTextStyle(context)),
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
            key: _calparform2key,
            child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: buildFieldRmatauangKode()),
                      const SizedBox(width: 8),
                      Flexible(child: buildFieldSiMachinery()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(child: buildFieldSiBuilding()),
                      const SizedBox(width: 8),
                      Flexible(child: buildFieldSiContent()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(child: buildFieldSiStock()),
                      const SizedBox(width: 8),
                      Flexible(child: buildFieldSiOther()),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // buildFieldBiIndexRate(),
                  // const SizedBox(height: 12),
                  // buildFieldBiTotal(),
                  // const SizedBox(height: 12),
                  // buildFieldCalpar1Id(),
                  // const SizedBox(height: 12),
                  // buildFieldMbiindemnityojkId(),
                  // const SizedBox(height: 12),
                  // buildFieldStockAdjustable(),
                  // const SizedBox(height: 12),
                  // buildFieldSiBi(),
                  // const SizedBox(height: 15),
                ],
            ),
        ),
    );
  }

  Future<bool> validateAndReturn() async {
    return _calparform2key.currentState?.validate() ?? false;
  }

  Future<void> saveForm2() async {
    final record = Calpar2FormModel(
      calpar2Id: widget.recordId ?? "",
      calpar1Id: widget.calpar1Id ?? "",
      biIndexRate: double.tryParse(fieldBiIndexRateController.text.replaceAll(',', '')) ?? 0,
      biTotal: double.tryParse(fieldBiTotalController.text.replaceAll(',', '')) ?? 0,
      siBi: double.tryParse(fieldSiBiController.text.replaceAll(',', '')) ?? 0,
      stockAdjustable: double.tryParse(fieldStockAdjustableController.text.replaceAll(',', '')) ?? 0,
      mbiindemnityojkId: fieldComboMBiindemnityOjk?.mbiindemnityojkId,
      rmatauangKode: fieldComboRMatauang?.rmatauangKode,
      siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
      siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
      siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
      siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
      siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
    );

    calpar2Bloc.add(Calpar2FormUbahEvent(record: record));

  }

  Widget buildFieldBiIndexRate() => appTextField(
    label: "BI Index Rate",
    controller: fieldBiIndexRateController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    // validator: (v) {
    //   if (v == null || v.isEmpty) return kStringNullError;
    //   final clean = v.replaceAll(",", "");
    //   final angka = double.tryParse(clean);
    //   if (angka == null || angka <= 0) return kString0;
    //   return null;
    // },
  );
  
  Widget buildFieldBiTotal() => appTextField(
    label: "BI Total",
    controller: fieldBiTotalController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    // validator: (v) {
    //   if (v == null || v.isEmpty) return kStringNullError;
    //   final clean = v.replaceAll(",", "");
    //   final angka = double.tryParse(clean);
    //   if (angka == null || angka <= 0) return kString0;
    //   return null;
    // },
  );
  
  Widget buildFieldMbiindemnityojkId() => ReusableComboBox<ComboMBiindemnityOjkModel>(
    hintText: "Indemnity",
    initItem: fieldComboMBiindemnityOjk,
    dataLoader: () => ComboMBiindemnityOjkRepository().getComboMBiindemnityOjk(),
    displayText: (i) => i.keterangan,
    compareItems: (a, b) => a.mbiindemnityojkId == b.mbiindemnityojkId,
    // validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMBiindemnityOjk = v,
    onSaveCallback: (value) => fieldComboMBiindemnityOjk = value,
  );
  
  Widget buildFieldRmatauangKode() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboRMatauang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (i) => i.rmatauangSimbol,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboRMatauang = v,
    onSaveCallback: (value) => fieldComboRMatauang = value,
  );

  Widget buildFieldSiBi() => appTextField(
    label: "siBi",
    controller: fieldSiBiController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    // validator: (v) {
    //   if (v == null || v.isEmpty) return kStringNullError;
    //   final clean = v.replaceAll(",", "");
    //   final angka = double.tryParse(clean);
    //   if (angka == null || angka <= 0) return kString0;
    //   return null;
    // },
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
    label: "Stok",
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
  
  Widget buildFieldStockAdjustable() => appTextField(
    label: "stockAdjustable",
    controller: fieldStockAdjustableController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    // validator: (v) {
    //   if (v == null || v.isEmpty) return kStringNullError;
    //   final clean = v.replaceAll(",", "");
    //   final angka = double.tryParse(clean);
    //   if (angka == null || angka <= 0) return kString0;
    //   return null;
    // },
  );
}
