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
import '../../../../models/combobox/combomjnscoverpar_model.dart';
import '../../../../models/combobox/combomwilayah_model.dart';
import '../../../../models/combobox/combomzonagempa_model.dart';
import '../../../../models/regpar/regpar3form_model.dart';
import '../../../../repositories/combobox/combomjnscoverpar_repository.dart';
import '../../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../../repositories/combobox/combomzonagempa_repository.dart';

class RegparForm3Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regpar1Id;

  const RegparForm3Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regpar1Id,
  });

  @override
  State<RegparForm3Section> createState() => RegparForm3SectionState();
}

class RegparForm3SectionState extends State<RegparForm3Section> {
  final _regparform3key = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldIsEqController = TextEditingController();
  final fieldRateEqvetController = TextEditingController();
  final fieldRateOtherController = TextEditingController();
  final fieldRateParController = TextEditingController();
  final fieldRateRsmdccController = TextEditingController();
  final fieldRateTotalController = TextEditingController();
  final fieldRateTsfwdController = TextEditingController();

  ComboMZonaGempaModel? fieldComboMZonaGempa;
  final comboMZonaGempaKey = GlobalKey<DropdownSearchState<ComboMZonaGempaModel>>();
  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  final comboMJnscoverParKey = GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

  late final Regpar3FormBloc regpar3Bloc;


  @override
  void initState() {
    super.initState();
    regpar3Bloc = context.read<Regpar3FormBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      regpar3Bloc.add(Regpar3FormLihatEvent(recordId: widget.regpar1Id!));
    }
  }

  @override
  void dispose() {
    fieldRateEqvetController.dispose();
    fieldRateOtherController.dispose();
    fieldRateParController.dispose();

    fieldRateRsmdccController.dispose();
    fieldRateTotalController.dispose();
    fieldRateTsfwdController.dispose();
    super.dispose();
  }

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      debugPrint("🔥 Form3 dibuka parent → trigger lihat event");
      regpar3Bloc.add(Regpar3FormLihatEvent(recordId: widget.regpar1Id!));
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
      title: Text("Perhitungan Tarif", style: bodyTextStyle(context)),
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
        BlocListener<Regpar3FormBloc, Regpar3FormState>(
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
          key: _regparform3key,
          child: Column(
            children: [
              buildFieldMjnscoverparId(),
              const SizedBox(height: hPadding),
              Row(
                children: [
                  Flexible(child: buildFieldRateEqvet()),
                  const SizedBox(width: 8),
                  Flexible(child: _buildFieldIsEq()),
                ],
              ),
              const SizedBox(height: hPadding),

              Row(
                children: [
                  Flexible(child: buildFieldRateOther()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldRatePar()),
                ],
              ),
              const SizedBox(height: hPadding),

              // Row(
              //   children: [
              //     Flexible(child: buildFieldRateRsmdcc()),
              //     const SizedBox(width: 8),
              //     Flexible(child: buildFieldRateTotal()),
              //   ],
              // ),
              // const SizedBox(height: hPadding),

              Row(
                children: [
                  Flexible(child: buildFieldRateTsfwd()),
                  const SizedBox(width: 8),
                  const Flexible(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(height: hPadding),
              buildFieldMwilayahId(),
              const SizedBox(height: hPadding),
              buildFieldKab2zonagempaId(),
            ],
          ),
        ),
      ),
    );
  }

  void _injectPayload(Regpar3FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldIsEqController.text = record.isEq.toString();

    fieldComboMJnscoverPar = record.comboMJnscoverPar;
    fieldComboMWilayah = record.comboMWilayah;

    setState(() {});
  }


  Future<bool> validateAndReturn() async {
    return _regparform3key.currentState?.validate() ?? false;
  }


  Future<void> saveForm3() async {
    final record = Regpar3FormModel(
      isEq: toBoolean(fieldIsEqController.text),
      kab2zonagempaId: fieldComboMZonaGempa?.mzonagempaId,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
      regpar3Id: widget.recordId!,regpar1Id: widget.regpar1Id!
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di form1");
      regpar3Bloc.add(Regpar3FormTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di form1");
      regpar3Bloc.add(Regpar3FormUbahEvent(record: record));
    }
  }

  Widget buildFieldMjnscoverparId() => ReusableComboBox<ComboMJnscoverParModel>(
    hintText: "Jenis Jaminan",
    initItem: fieldComboMJnscoverPar,
    dataLoader: () => ComboMJnscoverParRepository().getComboMJnscoverPar(),
    displayText: (i) => i.jenisNama,
    compareItems: (a, b) => a.mjnscoverparId == b.mjnscoverparId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMJnscoverPar = v,
    onSaveCallback: (value) => fieldComboMJnscoverPar = value,
  );

  Widget buildFieldMwilayahId() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMWilayah = v,
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );


  Widget buildFieldKab2zonagempaId() => ReusableComboBox<ComboMZonaGempaModel>(
    hintText: "Zona gempa Bumi",
    initItem: fieldComboMZonaGempa,
    dataLoader: () => ComboMZonaGempaRepository().getComboMZonaGempa(),
    displayText: (i) => i.zonaNama,
    compareItems: (a, b) => a.mzonagempaId == b.mzonagempaId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMZonaGempa = v,
    onSaveCallback: (value) => fieldComboMZonaGempa = value,
  );


  Widget _buildFieldIsEq() => CheckboxWidget(
    rightLabel: "Gempa Bumi",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) => fieldIsEqController.text = v.toString(),
    leftLabel: "",
  );

  Widget buildFieldRateEqvet() => IgnorePointer(
    ignoring: true,
    child: CheckboxWidget(
      rightLabel: "Kebakaran/Petir",
      initialValue: true,
      callback: (_) {},
      leftLabel: "",
    ),
  );

  Widget buildFieldRateOther() => IgnorePointer(
    ignoring: true,
    child: CheckboxWidget(
      rightLabel: "Kerusuhan",
      initialValue: true,
      callback: (_) {},
      leftLabel: "",
    ),
  );

  Widget buildFieldRatePar() => IgnorePointer(
    ignoring: true,
    child: CheckboxWidget(
      rightLabel: "Banjir",
      initialValue: true,
      callback: (_) {},
      leftLabel: "",
    ),
  );

  Widget buildFieldRateRsmdcc() => IgnorePointer(
    ignoring: true,
    child: CheckboxWidget(
      rightLabel: "RSMDCC",
      initialValue: true,
      callback: (_) {},
      leftLabel: "",
    ),
  );

  Widget buildFieldRateTotal() => IgnorePointer(
    ignoring: true,
    child: CheckboxWidget(
      rightLabel: "Total Rate",
      initialValue: true,
      callback: (_) {},
      leftLabel: "",
    ),
  );

  Widget buildFieldRateTsfwd() => IgnorePointer(
    ignoring: true,
    child: CheckboxWidget(
      rightLabel: "Lain-Lain",
      initialValue: true,
      callback: (_) {},
      leftLabel: "",
    ),
  );

  void removeError({required String error}) {
    if (errors.contains(error)){
      setState(() {
        errors.remove(error);
      });
    }
  }


}