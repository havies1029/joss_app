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
import '../../../../models/combobox/combomkecamatan_model.dart';
import '../../../../models/combobox/combomkelurahan_model.dart';
import '../../../../models/combobox/combomkota_model.dart';
import '../../../../models/combobox/combompropinsi_model.dart';
import '../../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../../models/combobox/comborokupasi_model.dart';
import '../../../../models/regpar/regpar2form_model.dart';
import '../../../../repositories/combobox/combomkecamatan_repository.dart';
import '../../../../repositories/combobox/combomkelurahan_repository.dart';
import '../../../../repositories/combobox/combomkota_repository.dart';
import '../../../../repositories/combobox/combompropinsi_repository.dart';
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

  final fieldObjectAlamatController = TextEditingController();
  final fieldCoverLamaController = TextEditingController();
  final fieldPolisAkhirController = TextEditingController();
  final fieldPolisMulaiController = TextEditingController();

  ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
  final comboRKonstruksiojkKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
  ComboROkupasiModel? fieldComboROkupasi;
  final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();
  ComboMKecamatanModel? fieldComboMKecamatan;
  final comboMKecamatanKey = GlobalKey<DropdownSearchState<ComboMKecamatanModel>>();
  ComboMKelurahanModel? fieldComboMKelurahan;
  final comboMKelurahanKey = GlobalKey<DropdownSearchState<ComboMKelurahanModel>>();
  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();


  DateTime? kejadianMulaiTgl;
  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day);

  final DateTime _today = DateTime.now().copyWith(
    hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0,
  );

  String selectedPassengerCount = "";

  @override
  void initState() {
    super.initState();
    regpar2Bloc = context.read<Regpar2FormBloc>();
    kejadianBerakhirTgl = _years;
    debugPrint("kejadianBerakhirTgl : ${kejadianBerakhirTgl.toString()}");
    // Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      regpar2Bloc.add(Regpar2FormLihatEvent(recordId: widget.regpar1Id!));
    }
  }

  DateTime addOneYearSafe(DateTime dt) {
    final nextYear = dt.year + 1;
    final maxDay = DateUtils.getDaysInMonth(nextYear, dt.month);

    return DateTime(nextYear, dt.month, dt.day > maxDay ? maxDay : dt.day);
  }


  @override
  void dispose() {
    fieldCoverLamaController.dispose();
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();
    fieldObjectAlamatController.dispose();
    super.dispose();
  }

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      debugPrint("🔥 Form2 dibuka parent → trigger lihat event");
      regpar2Bloc.add(Regpar2FormLihatEvent(recordId: widget.regpar1Id!));
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
                  const SizedBox(width: hPadding,),
                  Flexible(child: buildFieldPolisBerakhir()),
                ],
              ),
              const SizedBox(height: hPadding,),
              const SizedBox(width: hPadding,),
              buildFieldRkonstruksiojkId(),
              const SizedBox(height: hPadding),
              buildFieldRokupasiId(),
              const SizedBox(height: hPadding),
              buildFieldObjectAlamat(),
              const SizedBox(height: hPadding),
              buildFieldObjectPropinsiId(),
              const SizedBox(height: hPadding),
              buildFieldObjectKotaId(),
              const SizedBox(height: hPadding),
              buildFieldObjectKecamatanId(),
              const SizedBox(height: hPadding),
              buildFieldObjectKelurahanId(),
            ],
          ),
        ),
      ),
    );
  }

  void _injectPayload(Regpar2FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    // fieldCoverLamaController.text = record.coverLama.toString();
    if (_isPayloadInjected){
      kejadianBerakhirTgl  = record.polisAkhir;
      kejadianMulaiTgl = record.polisMulai;
    }
    fieldObjectAlamatController.text = record.objectAlamat.toString();
    // Dropdown Values
    fieldComboRKonstruksiojk = record.comboRKonstruksiojk;
    fieldComboROkupasi = record.comboROkupasi;
    fieldComboMPropinsi = record.comboMPropinsi;
    fieldComboMKota = record.comboMKota;
    fieldComboMKecamatan = record.comboMKecamatan;
    fieldComboMKelurahan = record.comboMKelurahan;

    setState(() {});
  }

  Future<bool> validateAndReturn() async {
    return _regparform2key.currentState?.validate() ?? false;
  }


  Future<void> saveForm2() async {
    final record = Regpar2FormModel(
      // coverLama: int.parse(fieldCoverLamaController.text),
      polisAkhir: kejadianBerakhirTgl ?? _years,
      polisMulai: kejadianMulaiTgl ?? _today,
      regpar2Id: widget.regpar1Id! ?? widget.recordId!,
      rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
      rokupasiId: fieldComboROkupasi?.rokupasiId, regpar1Id: widget.regpar1Id!, objectAlamat: fieldObjectAlamatController.text ?? '',
      objectPropinsiId: fieldComboMPropinsi?.mpropinsiId,
      objectKotaId: fieldComboMKota?.mkotaId,
      objectKecamatanId: fieldComboMKecamatan?.mkecamatanId,
      objectKelurahanId: fieldComboMKelurahan?.mkelurahanId,

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
      firstDate: _today,
      lastDate: DateTime(2100),
      validator: (dt) => dt == null ? kStringNullError : null,
      onChanged: (dt) {
        if (dt == null) return;
        setState(() {
          kejadianMulaiTgl = DateTime(dt.year, dt.month, dt.day);
          kejadianBerakhirTgl = addOneYearSafe(kejadianMulaiTgl!);
        });
      },
    );
  }
  Widget buildFieldPolisBerakhir() {
    return AppDateField(
      label: 'Tanggal Berakhir',
      enabled: false,

      // realtime mengikuti variabel state
      initialValue: kejadianBerakhirTgl
          ?? addOneYearSafe(kejadianMulaiTgl ?? _today),

      firstDate: _today,
      lastDate: DateTime(2100, 1, 1),
      validator: (dt) => dt == null ? kStringNullError : null,
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

  Widget buildFieldObjectAlamat() => appTextField(
    label: "Alamat Rumah",
    controller: fieldObjectAlamatController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kAddressNullError;
      return null;
    },
  );

  Widget buildFieldObjectPropinsiId() => ReusableComboBox<ComboMPropinsiModel>(
    hintText: "Provinsi",
    comboKey: comboMPropinsiKey,
    initItem: fieldComboMPropinsi,
    dataLoader: () => ComboMPropinsiRepository().getComboMPropinsi(""),
    displayText: (item) => item.propinsiNama,
    compareItems: (a, b) => a.mpropinsiId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regpar2Bloc.add(ComboMPropinsiChangedEvent(comboMPropinsi: v)
        );
        comboMKotaKey.currentState?.clear();
        comboMKecamatanKey.currentState?.clear();
        comboMKelurahanKey.currentState?.clear();
      }
      fieldComboMPropinsi = v;
    },
    onSaveCallback: (value) => fieldComboMPropinsi = value,
  );

  Widget buildFieldObjectKotaId() => ReusableComboBox<ComboMKotaModel>(
    hintText: "Kota",
    comboKey: comboMKotaKey,
    initItem: fieldComboMKota,
    dataLoader: () => ComboMKotaRepository().getComboMKota(fieldComboMPropinsi?.mpropinsiId ?? ""),
    displayText: (item) => item.kotaDesc,
    compareItems: (a, b) => a.mkotaId == b.mkotaId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regpar2Bloc.add(ComboMKotaChangedEvent(comboMKota: v)
        );
        comboMKecamatanKey.currentState?.clear();
        comboMKelurahanKey.currentState?.clear();
      }
      fieldComboMKota = v;
    },
    onSaveCallback: (value) => fieldComboMKota = value,
  );

  Widget buildFieldObjectKecamatanId() => ReusableComboBox<ComboMKecamatanModel>(
    hintText: "Kecamatan",
    comboKey: comboMKecamatanKey,
    initItem: fieldComboMKecamatan,
    dataLoader: () => ComboMKecamatanRepository().getComboMKecamatan(fieldComboMKota?.mkotaId ?? ""),
    displayText: (item) => item.kecamatanNama,
    compareItems: (a, b) => a.mkecamatanId == b.mkecamatanId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regpar2Bloc.add(ComboMKecamatanChangedEvent(comboMKecamatan: v)
        );
      }
      comboMKelurahanKey.currentState?.clear();
      fieldComboMKecamatan = v;
    },
    onSaveCallback: (value) => fieldComboMKecamatan = value,
  );

  Widget buildFieldObjectKelurahanId() => ReusableComboBox<ComboMKelurahanModel>(
    hintText: "Kelurahan",
    comboKey: comboMKelurahanKey,
    initItem: fieldComboMKelurahan,
    dataLoader: () => ComboMKelurahanRepository().getComboMKelurahan(fieldComboMKecamatan?.mkecamatanId ?? ""),
    displayText: (item) => item.kelurahanNama,
    compareItems: (a, b) => a.mkelurahanId == b.mkelurahanId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regpar2Bloc.add(ComboMKelurahanChangedEvent(comboMKelurahan: v)
        );
      }
      fieldComboMKelurahan = v;
    },
    onSaveCallback: (value) => fieldComboMKelurahan = value,
  );

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}