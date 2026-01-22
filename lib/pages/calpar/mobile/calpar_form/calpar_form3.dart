import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar3form_bloc.dart';
import 'package:joss_app/models/calpar/calpar3form_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../models/combobox/combomjnscoverpar_model.dart';
import '../../../../repositories/combobox/combomjnscoverpar_repository.dart';
import '../../../../repositories/combobox/combomkabzonagempa_repository.dart';
import '../../../../repositories/combobox/combomwilayah_repository.dart';


class Calpar3FormPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final String? calpar1Id;
  final bool isExpanded;
  final Function(bool) onToggle;
  
  const Calpar3FormPage({super.key, required this.viewMode, required this.recordId, this.calpar1Id, required this.isExpanded, required this.onToggle});

  @override
  Calpar3FormPageFormState createState() => Calpar3FormPageFormState();
}

class Calpar3FormPageFormState extends State<Calpar3FormPage> {
  final _calparform3key = GlobalKey<FormState>();

  final List<String> errors = [];

  // Controllers
  final fieldIsEqController = TextEditingController();
  final fieldIsTsfwdController = TextEditingController();
  final fieldIsFlexasController = TextEditingController();
  final fieldIsOtherController = TextEditingController();
  final fieldIsRsmdccController = TextEditingController();

  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  ComboMWilayahModel? fieldComboMWilayah;

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

  late final Calpar3FormBloc calpar3Bloc;

  @override
  void initState() {
    super.initState();
    calpar3Bloc = context.read<Calpar3FormBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.calpar1Id != null) {
      calpar3Bloc.add(Calpar3FormLihatEvent(recordId: widget.calpar1Id!));
    }
  }

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.calpar1Id != null) {
      debugPrint("🔥 Form1 dibuka parent → trigger lihat event");
      calpar3Bloc.add(Calpar3FormLihatEvent(recordId: widget.calpar1Id!));
    }
  }


  @override
  void dispose() {
    fieldIsEqController.dispose();
    fieldIsTsfwdController.dispose();
    fieldIsFlexasController.dispose();
    fieldIsOtherController.dispose();
    fieldIsRsmdccController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Calpar3FormBloc, Calpar3FormState>(
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

  void _injectPayload(Calpar3FormModel record) {
    fieldIsFlexasController.text = record.isFlexas.toString();
    fieldIsOtherController.text = record.isOther.toString();
    fieldIsRsmdccController.text = record.isRsmdcc.toString();
    fieldIsTsfwdController.text = record.isTsfwd.toString();
    fieldIsEqController.text = record.isEq.toString();

    fieldComboMJnscoverPar = record.comboMJnscoverPar;
    fieldComboMKabZonaGempa = record.comboMKabZonaGempa;
    fieldComboMWilayah = record.comboMWilayah;

    setState(() {});
  }

  Widget _buildHeader() {
    return ListTile(
      title: Text('Perhitungan Tarif', style: bodyTextStyle(context)),
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _calparform3key,
        child: Column(
          children: [
            buildFieldMjnscoverparId(),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(child: buildFieldIsEq()),
                const SizedBox(width: 8),
                Flexible(child: buildFieldIsTsfwd()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(child: buildFieldIsFlexas()),
                const SizedBox(width: 8),
                Flexible(child: buildFieldIsRsmdcc()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(child: buildFieldIsOther()),
                const Flexible(child: SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: 12),
            buildFieldMwilayahId(),
            const SizedBox(height: 12),
            buildFieldKab2zonagempaId(),
            const SizedBox(height: 15),

            // buildFieldCalpar1Id(),
            // buildFieldRateEqvet(),
            // buildFieldRateOther(),
            // buildFieldRatePar(),
            // buildFieldRateRsmdcc(),
            // buildFieldRateTotal(),
            // buildFieldRateTsfwd(),
          ],
        ),
      ),
    );
  }

  Future<bool> validateAndReturn() async {
    return _calparform3key.currentState?.validate() ?? false;
  }

  Future<void> saveForm3() async {
    final record = Calpar3FormModel(
      calpar3Id: widget.recordId ?? "",
      calpar1Id: widget.calpar1Id ?? "",
      isEq: toBoolean(fieldIsEqController.text),
      isTsfwd: toBoolean(fieldIsTsfwdController.text),
      isFlexas: toBoolean(fieldIsFlexasController.text),
      isOther: toBoolean(fieldIsOtherController.text),
      isRsmdcc: toBoolean(fieldIsRsmdccController.text),
      kab2zonagempaId: fieldComboMKabZonaGempa?.mkabzonagempaId,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
    );

    debugPrint("saveForm3 → FORCE UB AH event (viewMode diabaikan)");

    calpar3Bloc.add(
      Calpar3FormUbahEvent(record: record),
    );
  }


  Widget buildFieldCalpar1Id(){
    return TextFormField(
    );
  }

  Widget buildFieldIsEq()=> CheckboxWidget(
    rightLabel: "Gempa Bumi",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) => fieldIsEqController.text = v.toString(),
    leftLabel: "",
  );

  Widget buildFieldIsTsfwd()=> CheckboxWidget(
    rightLabel: "Banjir",
    initialValue: toBoolean(fieldIsTsfwdController.text),
    callback: (v) => fieldIsTsfwdController.text = v.toString(),
    leftLabel: "",
  );

  Widget buildFieldIsFlexas()=> CheckboxWidget(
    rightLabel: "Kebakaran/Petir",
    initialValue: toBoolean(fieldIsFlexasController.text),
    callback: (v) => fieldIsFlexasController.text = v.toString(),
    leftLabel: "",
  );

  Widget buildFieldIsOther()=> CheckboxWidget(
    rightLabel: "Lainnya",
    initialValue: toBoolean(fieldIsOtherController.text),
    callback: (v) => fieldIsOtherController.text = v.toString(),
    leftLabel: "",
  );

  Widget buildFieldIsRsmdcc()=> CheckboxWidget(
    rightLabel: "Huru Hara/Kerusuhan",
    initialValue: toBoolean(fieldIsRsmdccController.text),
    callback: (v) => fieldIsRsmdccController.text = v.toString(),
    leftLabel: "",
  );

  Widget buildFieldKab2zonagempaId() => ReusableComboBox<ComboMKabZonaGempaModel>(
    hintText: "Zona Gempa - Kabupaten",
    initItem: fieldComboMKabZonaGempa,
    dataLoader: () => ComboMKabZonaGempaRepository().getComboMKabZonaGempa(""),
    displayText: (i) => "${i.mzonagempaId} - ${i.kabupaten}",
    compareItems: (a, b) => a.mkabzonagempaId == b.mkabzonagempaId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMKabZonaGempa = v,
    onSaveCallback: (value) => fieldComboMKabZonaGempa = value,
  );

  Widget buildFieldMwilayahId() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah Objek",
    initItem: fieldComboMWilayah,
    maxHeight: 150,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMWilayah = v,
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );

  Widget buildFieldMjnscoverparId() => ReusableComboBox<ComboMJnscoverParModel>(
    hintText: "Wilayah Objek",
    maxHeight: 200,
    initItem: fieldComboMJnscoverPar,
    dataLoader: () => ComboMJnscoverParRepository().getComboMJnscoverPar(),
    displayText: (i) => i.jenisNama,
    compareItems: (a, b) => a.mjnscoverparId == b.mjnscoverparId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMJnscoverPar = v,
    onSaveCallback: (value) => fieldComboMJnscoverPar = value,
  );

}
