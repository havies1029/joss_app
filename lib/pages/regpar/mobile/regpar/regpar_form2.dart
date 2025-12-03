import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../blocs/regpar/regpar2form_bloc.dart';
import '../../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../../models/combobox/comborokupasi_model.dart';
import '../../../../models/regpar/regpar2form_model.dart';
import '../../../../repositories/combobox/comborkonstruksiojk_repository.dart';
import '../../../../repositories/combobox/comborokupasi_repository.dart';

class RegparForm2Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regpar1Id; // ini didapat dari parents

  const RegparForm2Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regpar1Id,
  });

  @override
  State<RegparForm2Section> createState() => RegparForm2SectionState();
}


class RegparForm2SectionState extends State<RegparForm2Section> {
  final _regparform2key = GlobalKey<FormState>();
  final List<String> errors = [];
  late final Regpar2FormBloc regpar2Bloc;
  bool _isPayloadInjected = false;

  final fieldCoverLamaController = TextEditingController();
  final fieldPolisAkhirController = TextEditingController();
  final fieldPolisMulaiController = TextEditingController();

  ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
  final comboRKonstruksiojkKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
  ComboROkupasiModel? fieldComboROkupasi;
  final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();

  DateTime? kejadianMulaiTgl;
  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String selectedPassengerCount = "";

  @override
  void initState() {
    super.initState();
    regpar2Bloc = context.read<Regpar2FormBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      regpar2Bloc.add(Regpar2FormLihatEvent(recordId: widget.regpar1Id!));
    }
  }

  @override
  void dispose() {
    fieldCoverLamaController.dispose();
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();

    super.dispose();
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
      title: Text("Informasi Polis", style: bodyTextStyle(context)),
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
        BlocListener<Regpar2FormBloc, Regpar2FormState>(
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
          key: _regparform2key,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: buildFieldPolisMulai()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldPolisBerakhir()),
                ],
              ),
              const SizedBox(height: hPadding),
              buildFieldRkonstruksiojkId(),
              const SizedBox(height: hPadding),
              buildFieldRokupasiId(),
            ],
          ),
        ),
      ),
    );
  }

  void _injectPayload(Regpar2FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldCoverLamaController.text = record.coverLama.toString();
    fieldPolisAkhirController.text = record.polisAkhir.toString();
    fieldPolisMulaiController.text = record.polisMulai.toString();

    // Dropdown Values
    fieldComboRKonstruksiojk = record.comboRKonstruksiojk;
    fieldComboROkupasi = record.comboROkupasi;

    setState(() {});
  }

  Future<bool> validateAndReturn() async {
    return _regparform2key.currentState?.validate() ?? false;
  }


  Future<void> saveForm2() async {
    final record = Regpar2FormModel(
      coverLama: int.parse(fieldCoverLamaController.text),
      polisAkhir: DateTime.parse(fieldPolisAkhirController.text),
      polisMulai: DateTime.parse(fieldPolisMulaiController.text),
      regpar2Id: '',
      rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
      rokupasiId: fieldComboROkupasi?.rokupasiId,
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di regmvform2");
      regpar2Bloc.add(Regpar2FormTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di regmvform2");
      regpar2Bloc.add(Regpar2FormUbahEvent(record: record));
    }
  }

  Widget buildFieldPolisMulai() {
    return AppDateField(
      label: 'Tanggal Mulai',
      initialValue: kejadianMulaiTgl ?? _today,
      firstDate: DateTime(2000, 1, 1),
      lastDate: (kejadianMulaiTgl != null && kejadianMulaiTgl!.isAfter(_today))
          ? kejadianMulaiTgl!
          : _today,
      validator: (dt) => (dt == null) ? kStringNullError : null,
      onChanged: (dt) => setState(() {
        kejadianMulaiTgl = dt != null ? DateTime(dt.year, dt.month, dt.day) : null;

        if (kejadianMulaiTgl != null) {
          kejadianBerakhirTgl = DateTime(
            kejadianMulaiTgl!.year + 1,
            kejadianMulaiTgl!.month,
            kejadianMulaiTgl!.day,
          );
        }
      }),

    );
  }

  Widget buildFieldPolisBerakhir() {
    return AppDateField(
      label: 'Tanggal Berakhir',
      enabled: false,
      initialValue: kejadianBerakhirTgl ?? _years,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 1, 1),
      validator: (dt) => (dt == null) ? kStringNullError : null,
      onChanged: (_) {},
    );
  }

  Widget buildFieldRkonstruksiojkId() => ReusableComboBox<ComboRKonstruksiojkModel>(
    hintText: "Kelas Konstruksi",
    initItem: fieldComboRKonstruksiojk,
    dataLoader: () => ComboRKonstruksiojkRepository().getComboRKonstruksiojk(),
    displayText: (item) => item.kelasNama,
    compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboRKonstruksiojk = v,
    onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
  );

  Widget buildFieldRokupasiId() => ReusableComboBox<ComboROkupasiModel>(
    hintText: "Okupasi",
    comboKey: comboROkupasiKey,
    initItem: fieldComboROkupasi,
    dataLoader: () => ComboROkupasiRepository().getComboROkupasi(fieldComboRKonstruksiojk?.rkonstruksiojkId ?? ""),
    displayText: (item) => item.okupasiDesc,
    compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regpar2Bloc.add(ComboROkupasiChangedEvent(comboROkupasi: v)
        );
      }
      fieldComboROkupasi = v;
    },
    onSaveCallback: (value) => fieldComboROkupasi = value,
  );

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}