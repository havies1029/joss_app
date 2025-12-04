import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../../common/plat_nomor_formatter.dart';
import '../../../../common/rangka_no_formatter.dart';
import '../../../../models/combobox/combommvmerk_model.dart';
import '../../../../models/combobox/combommvmodel_model.dart';
import '../../../../models/combobox/combommvpakai_model.dart';
import '../../../../models/combobox/combommvtipe_model.dart';
import '../../../../models/combobox/combomwarna_model.dart';
import '../../../../models/combobox/combomwilayah_model.dart';
import '../../../../models/gen_regmv/regmv3form_model.dart';
import '../../../../repositories/combobox/combommvmerk_repository.dart';
import '../../../../repositories/combobox/combommvmodel_repository.dart';
import '../../../../repositories/combobox/combommvpakai_repository.dart';
import '../../../../repositories/combobox/combommvtipe_repository.dart';
import '../../../../repositories/combobox/combomwarna_repository.dart';
import '../../../../repositories/combobox/combomwilayah_repository.dart';



class RegmvForm3Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1Id;

  const RegmvForm3Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1Id,
  });

  @override
  State<RegmvForm3Section> createState() => RegmvForm3SectionState();
}

class RegmvForm3SectionState extends State<RegmvForm3Section> {
  final _regmvform3key = GlobalKey<FormState>();
  final List<String> errors = [];
  // Controllers
  final fieldAksesorisController = TextEditingController();
  final fieldHargaController = TextEditingController();
  final fieldMesinNoController = TextEditingController();

  final fieldPlatNoController = TextEditingController();
  final fieldRangkaNoController = TextEditingController();
  final fieldThnBuatController = TextEditingController();

  ComboMMvmerkModel? fieldComboMMvmerk;
  final comboMMvmerkKey = GlobalKey<DropdownSearchState<ComboMMvmerkModel>>();
  ComboMMvmodelModel? fieldComboMMvmodel;
  final comboMMvmodelKey = GlobalKey<DropdownSearchState<ComboMMvmodelModel>>();
  ComboMMvpakaiModel? fieldComboMMvpakai;
  final comboMMvpakaiKey = GlobalKey<DropdownSearchState<ComboMMvpakaiModel>>();
  ComboMMvtipeModel? fieldComboMMvtipe;
  final comboMMvtipeKey = GlobalKey<DropdownSearchState<ComboMMvtipeModel>>();
  ComboMWarnaModel? fieldComboMWarna;
  final comboMWarnaKey = GlobalKey<DropdownSearchState<ComboMWarnaModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  
  String? gMerkId;
  String? gTipeId;
  String? gModelId;
  String? gPakaiId;
  String? gWarnaId;
  String? gWilayahId;



  String selectedYear = "";
  late final Regmv3FormBloc regmv3Bloc;

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      debugPrint("🔥 Form3 dibuka parent → trigger lihat event");
      regmv3Bloc.add(Regmv3FormLihatEvent(recordId: widget.regmv1Id!));
    }
  }

  @override
  void initState() {
    super.initState();
    regmv3Bloc = context.read<Regmv3FormBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      regmv3Bloc.add(Regmv3FormLihatEvent(recordId: widget.regmv1Id!));
    }
  }

  @override
  void dispose() {
    fieldAksesorisController.dispose();
    fieldHargaController.dispose();
    fieldMesinNoController.dispose();

    fieldPlatNoController.dispose();
    fieldRangkaNoController.dispose();
    fieldThnBuatController.dispose();
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
      title: Text("Data Kendaraan", style: bodyTextStyle(context)),
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
        BlocListener<Regmv3FormBloc, Regmv3FormState>(
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
          key: _regmvform3key,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: _buildFieldComboTahun()),
                  const SizedBox(width: 8),
                  Flexible(child: _buildHargaMobil()),
                ],
              ),
              const SizedBox(height: 12),

              _buildComboMWilayah(),
              const SizedBox(height: 12),

              _buildFieldPlatNo(),
              const SizedBox(height: 12),

              _buildFieldRangkaNo(),
              const SizedBox(height: 12),

              _buildFieldMesinNo(),
              const SizedBox(height: 12),

              _buildFieldMmvmerkId(),
              const SizedBox(height: 12),

              _buildComboTipeId(),
              const SizedBox(height: 12),

              _buildFieldMmvmodelId(),
              const SizedBox(height: 12),

              Row(
                children: [
                  Flexible(child: _buildFieldMmvsubmodelId()),
                  const SizedBox(width: 8),
                  Flexible(child: _buildComboWarnaId()),
                ],
              ),
              const SizedBox(height: 12),

              _buildFieldAksesoris(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void _injectPayload(Regmv3FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldAksesorisController.text = record.aksesoris.toString();
    fieldHargaController.text = record.harga.toString();
    fieldMesinNoController.text = record.mesinNo.toString();

    fieldPlatNoController.text = record.platNo.toString();
    fieldRangkaNoController.text = record.rangkaNo.toString();
    fieldThnBuatController.text = record.thnBuat.toString();

    selectedYear = record.thnBuat.toString();

    // Dropdown Values
    fieldComboMMvmerk = record.comboMMvmerk;
    fieldComboMMvtipe = record.comboMMvtipe;

    fieldComboMMvmodel = record.comboMMvmodel;
    fieldComboMMvpakai = record.comboMMvpakai;

    fieldComboMWarna = record.comboMWarna;
    fieldComboMWilayah = record.comboMWilayah;

    setState(() {});
  }


  Future<bool> validateAndReturn() async {
    return _regmvform3key.currentState?.validate() ?? false;
  }


  Future<void> saveForm3() async {
    final record = Regmv3FormModel(
      regmv1Id: widget.regmv1Id ?? "",
      aksesoris: fieldAksesorisController.text,
      harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
      mesinNo: fieldMesinNoController.text,
      mmvmerkId: gMerkId ?? fieldComboMMvmerk?.mmvmerkId,
      mmvmodelId: gModelId ?? fieldComboMMvmodel?.mmvmodelId,
      mmvpakaiId: gPakaiId ?? fieldComboMMvpakai?.mmvpakaiId,
      mmvtipeId: gTipeId ?? fieldComboMMvtipe?.mmvtipeId,
      mwarnaId: gWarnaId ?? fieldComboMWarna?.mwarnaId,
      mwilayahId: gWilayahId ?? fieldComboMWilayah?.mwilayahId,
      platNo: fieldPlatNoController.text,
      rangkaNo: fieldRangkaNoController.text,
      regmv3Id: widget.recordId ?? "",
      thnBuat: int.parse(fieldThnBuatController.text),
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di form1");
      regmv3Bloc.add(Regmv3FormTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di form1");
      regmv3Bloc.add(Regmv3FormUbahEvent(record: record));
    }

  }

  Widget _buildFieldComboTahun() {
    final yearNow = DateTime.now().year;
    final years = List<String>.generate(
      yearNow - 1980 + 1,
          (i) => (yearNow - i).toString(),
    );

    return ReusableComboBox<String>(
      hintText: "Tahun Pembuatan",
      initItem: selectedYear.isNotEmpty ? selectedYear : null, // kalau mode ubah
      dataLoader: () async => years,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,

      // Validator
      validatorCallback: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },

      onChangedCallback: (value) {
        selectedYear = value ?? "";
      },

      onSaveCallback: (value) {
        selectedYear = value ?? "";
      },
    );
  }

  Widget _buildHargaMobil() => appTextField(
    label: "Harga Mobil",
    controller: fieldHargaController,
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

  Widget _buildComboMWilayah() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      fieldComboMWilayah = v;
      gWilayahId = v?.mwilayahId;
    },
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );

  Widget _buildFieldPlatNo() => appTextField(
    label: "No Polisi",
    controller: fieldPlatNoController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      PlatNomorFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final cleaned = v.replaceAll(' ', '');
      if (cleaned.length < 3 || cleaned.length > 9) {
        return "Format plat nomor tidak valid";
      }
      return null;
    },
  );

  Widget _buildFieldRangkaNo() => appTextField(
    label: "No Rangka",
    controller: fieldRangkaNoController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      RangkaNoFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final cleaned = v;
      if (cleaned.length < 5) {
        return "Nomor rangka terlalu pendek";
      }
      return null;
    },
  );

  Widget _buildFieldMesinNo() => appTextField(
    label: "No Mesin",
    controller: fieldMesinNoController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      RangkaNoFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final cleaned = v;
      if (cleaned.length < 5) {
        return "Nomor Mesin terlalu pendek";
      }
      return null;
    },
  );

  Widget _buildFieldMmvmerkId() {
    debugPrint("🟦 [BUILD] MEREK widget dibangun dengan initItem = ${fieldComboMMvmerk?.mmvmerkId}");

    return ReusableComboBox<ComboMMvmerkModel>(
      hintText: "Merek",
      comboKey: comboMMvmerkKey,
      initItem: fieldComboMMvmerk,

      dataLoader: () {
        debugPrint("🟩 [LOAD] MEREK dataLoader dipanggil (filter=${fieldComboMMvmerk?.mmvmerkId})");
        return ComboMMvmerkRepository()
            .getComboMMvmerk(fieldComboMMvmerk?.mmvmerkId ?? "");
      },

      displayText: (i) => i.nmMerk,
      compareItems: (a, b) => a.mmvmerkId == b.mmvmerkId,

      validatorCallback: (v) => v == null ? kStringNullError : null,

      onChangedCallback: (v) {
        debugPrint("🟨 [MERK] onChanged START (dipilih=${v?.mmvmerkId})");

        if (v != null) {
          debugPrint("🟨 [MERK] kirim event ke bloc");
          removeError(error: kStringNullError);
          regmv3Bloc.add(ComboMMvmerkChangedEvent(comboMMvmerk: v));

          debugPrint("🟨 [MERK] clear tipe & model");
          comboMMvtipeKey.currentState?.clear();
          comboMMvmodelKey.currentState?.clear();
        }
        gMerkId = v?.mmvmerkId;
        fieldComboMMvmerk = v;
        debugPrint("🟨 [MERK] assign fieldComboMMvmerk = ${fieldComboMMvmerk?.mmvmerkId}");

        debugPrint("🟨 [MERK] onChanged END");
      },

      onSaveCallback: (value) {
        debugPrint("🟦 [MERK] onSaveCallback dipanggil: ${value?.mmvmerkId}");
        fieldComboMMvmerk = value;
      },
    );
  }

  Widget _buildComboTipeId() {
    debugPrint("🟫 [BUILD] TIPE widget dibangun. key = tipe-${fieldComboMMvmerk?.mmvmerkId ?? 'none'}");

    return ReusableComboBox<ComboMMvtipeModel>(
      key: ValueKey("tipe-${fieldComboMMvmerk?.mmvmerkId ?? 'none'}"),
      hintText: "Model",
      comboKey: comboMMvtipeKey,
      initItem: fieldComboMMvtipe,

      dataLoader: () {
        debugPrint("🔥 Load TIPE pakai MERK = $gMerkId");
        return ComboMMvtipeRepository()
            .getComboMMvtipe(gMerkId  ?? "", "");
      },

      displayText: (i) => i.nmTipe,
      compareItems: (a, b) => a.mmvtipeId == b.mmvtipeId,

      validatorCallback: (v) => v == null ? kStringNullError : null,

      onChangedCallback: (v) {
        debugPrint("🟥 [TIPE] onChanged START (v=${v?.mmvtipeId})");

        if (v != null){
          debugPrint("🟥 [TIPE] kirim event ke bloc");
          removeError(error: kStringNullError);
          regmv3Bloc.add(ComboMMvtipeChangedEvent(comboMMvtipe: v));

          comboMMvmodelKey.currentState?.clear();
        }
        gTipeId = v?.mmvtipeId;
        fieldComboMMvtipe = v;
        debugPrint("🟥 [TIPE] fieldComboMMvmerk sekarang = ${fieldComboMMvmerk?.mmvmerkId}");
        debugPrint("🟥 [TIPE] onChanged END");
      },

      onSaveCallback: (value) {
        debugPrint("🟥 [TIPE] onSaveCallback = ${value?.mmvtipeId}");
        fieldComboMMvtipe = value;
      },
    );
  }


  Widget _buildFieldMmvmodelId() => ReusableComboBox<ComboMMvmodelModel>(
    hintText: "Sub Model",
    comboKey: comboMMvmodelKey,
    initItem: fieldComboMMvmodel,
    dataLoader: () => ComboMMvmodelRepository().getComboMMvmodel(gTipeId ?? "",""),
    displayText: (i) => i.nmModel,
    compareItems: (a, b) => a.mmvmodelId == b.mmvmodelId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regmv3Bloc.add(
          ComboMMvmodelChangedEvent(comboMMvmodel: v),
        );
      }
      gModelId = v?.mmvmodelId;
      fieldComboMMvmodel = v;
    },
    onSaveCallback: (value) => fieldComboMMvmodel = value,
  );

  Widget _buildFieldMmvsubmodelId() => ReusableComboBox<ComboMMvpakaiModel>(
    hintText: "Penggunaan",
    comboKey: comboMMvpakaiKey,
    initItem: fieldComboMMvpakai,
    dataLoader: () => ComboMMvpakaiRepository().getComboMMvpakai(),
    displayText: (i) => i.pakaiNama,
    compareItems: (a, b) => a.mmvpakaiId == b.mmvpakaiId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regmv3Bloc.add(
          ComboMMvpakaiChangedEvent(comboMMvpakai: v),
        );
      }
      gPakaiId = v?.mmvpakaiId;
      fieldComboMMvpakai = v;
    },
    onSaveCallback: (value) => fieldComboMMvpakai = value,
  );



  Widget _buildComboWarnaId() => ReusableComboBox<ComboMWarnaModel>(
    hintText: "Warna",
    comboKey: comboMWarnaKey,
    initItem: fieldComboMWarna,
    dataLoader: () => ComboMWarnaRepository().getComboMWarna(""),
    displayText: (i) => i.warnaDesc,
    compareItems: (a, b) => a.mwarnaId == b.mwarnaId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) {
      if (v != null){
        removeError(error: kStringNullError);
        regmv3Bloc.add(
          ComboMWarnaChangedEvent(comboMWarna: v),
        );
      }
      gWarnaId = v?.mwarnaId;
      fieldComboMWarna = v;
    },
    onSaveCallback: (value) => fieldComboMWarna = value,
  );

  Widget _buildFieldAksesoris() => appTextField(
    label: "Aksesoris",
    controller: fieldAksesorisController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
      ThousandsSeparatorInputFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      return null;
    },
  );

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}

