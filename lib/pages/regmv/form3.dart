import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_regmv/regmv3form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv3form_model.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvmodel_model.dart';
import 'package:joss_app/models/combobox/combommvpakai_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../repositories/combobox/combommvmerk_repository.dart';
import '../../repositories/combobox/combommvmodel_repository.dart';
import '../../repositories/combobox/combommvpakai_repository.dart';
import '../../repositories/combobox/combommvtipe_repository.dart';
import '../../repositories/combobox/combomwarna_repository.dart';
import '../../repositories/combobox/combomwilayah_repository.dart';

class Regmv3FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final bool initiallyExpanded;
  final String? parentRegmv1Id;

  final void Function(String regmv3Id)? onRegmv3Created;
  final VoidCallback? onAccordionClose;

  const Regmv3FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.initiallyExpanded = false,
    this.parentRegmv1Id,
    this.onRegmv3Created,
    this.onAccordionClose,
  });

  @override
  State<Regmv3FormFormPage> createState() => Regmv3FormFormPageState();
}

class Regmv3FormFormPageState extends State<Regmv3FormFormPage> {
  late Regmv3FormBloc regmv3FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

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

  bool isExpanded = false;
  String? _currentRegmv3Id;
  late String parentRegmv1Id;

  @override
  void initState() {
    super.initState();

    parentRegmv1Id = widget.parentRegmv1Id ?? "";
    debugPrint("🔥 [FORM3] parentRegmv1Id diterima dari parent = $parentRegmv1Id");

    Future.delayed(const Duration(milliseconds: 500), loadData);
  }

  @override
  void didUpdateWidget(Regmv3FormFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parentRegmv1Id != oldWidget.parentRegmv1Id) {
      setState(() {
        parentRegmv1Id = widget.parentRegmv1Id ?? "";
      });
      debugPrint("🔥 [FORM3] parentRegmv1Id updated = $parentRegmv1Id");
    }
  }

  void loadData() {
    if (widget.viewMode == "ubah" && widget.recordId.isNotEmpty) {
      regmv3FormBloc.add(Regmv3FormLihatEvent(recordId: widget.recordId));
    }
  }

  @override
  Widget build(BuildContext context) {
    regmv3FormBloc = BlocProvider.of<Regmv3FormBloc>(context);

    return BlocConsumer<Regmv3FormBloc, Regmv3FormState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          fieldAksesorisController.text = state.record!.aksesoris;
          fieldHargaController.text =
              NumberFormat("#,###").format(state.record!.harga);
          fieldMesinNoController.text = state.record!.mesinNo;
          fieldPlatNoController.text = state.record!.platNo;
          fieldRangkaNoController.text = state.record!.rangkaNo;
          fieldThnBuatController.text = state.record!.thnBuat.toString();

          fieldComboMMvmerk = state.comboMMvmerk;
          fieldComboMMvmodel = state.comboMMvmodel;
          fieldComboMMvpakai = state.comboMMvpakai;
          fieldComboMMvtipe = state.comboMMvtipe;
          fieldComboMWarna = state.comboMWarna;
          fieldComboMWilayah = state.comboMWilayah;

          _currentRegmv3Id = state.record!.regmv3Id;
          debugPrint("🔥 [FORM3] Loaded regmv3Id = $_currentRegmv3Id");
        }

        // 🔥 setelah tambah/update berhasil
        if (state.isSaved && !state.hasFailure) {
          final newId = state.record?.regmv3Id;

          if (newId != null && newId.isNotEmpty) {
            debugPrint("🔥 [FORM3] regmv3Id from state = $newId");
            setState(() => _currentRegmv3Id = newId);

            if (widget.onRegmv3Created != null) {
              widget.onRegmv3Created!(newId);
            }
          } else {
            debugPrint(
                "⚠️ [FORM3] state.record/regmv3Id belum terisi setelah save. Cek mapping BLoC / repository.");
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data kendaraan berhasil disimpan')),
          );
        }

        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan Data Kendaraan'),
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
                  Flexible(child: buildFieldHarga()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldThnBuat()),
                ],
              ),
              const SizedBox(height: 12),
              buildFieldMwilayahId(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldPlatNo()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldMesinNo()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldRangkaNo()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldMmvmerkId()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldMmvtipeId()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldMmvmodelId()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: buildFieldMwarnaId()),
                  const SizedBox(width: 8),
                  Flexible(child: buildFieldMmvpakaiId()),
                ],
              ),
              const SizedBox(height: 12),
              buildFieldAksesoris(),
            ],
          ),
        );
      },
    );
  }

  Widget buildFieldAksesoris() => appTextField(
    label: "Aksesori",
    controller: fieldAksesorisController,
    keyboardType: TextInputType.multiline,
    maxLines: 1,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return ""; // biar trigger FormError
      }
      return null;
    },

  );

  Widget buildFieldHarga() => appTextField(
    label: "Harga",
    controller: fieldHargaController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "";
      }
      return null;
    },
  );

  Widget buildFieldMesinNo() => appTextField(
    label: "No Mesin",
    controller: fieldMesinNoController,
    keyboardType: TextInputType.text,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "";
      }
      return null;
    },
  );

  Widget buildFieldMmvmerkId() => ReusableComboBox<ComboMMvmerkModel>(
    hintText: "Merk",
    comboKey: comboMMvmerkKey,
    initItem: fieldComboMMvmerk,
    dataLoader: () => ComboMMvmerkRepository().getComboMMvmerk(""),
    displayText: (item) => item.nmMerk,
    compareItems: (a, b) => a.mmvmerkId == b.mmvmerkId,
    onChangedCallback: (value) {
      if (value != null) {
        setState(() => fieldComboMMvmerk = value);
        regmv3FormBloc.add(ComboMMvmerkChangedEvent(comboMMvmerk: value));
        comboMMvtipeKey.currentState?.clear();
        comboMMvmodelKey.currentState?.clear();
        setState(() {
          fieldComboMMvtipe = null;
          fieldComboMMvmodel = null;
        });
      }
    },
    onSaveCallback: (value) => fieldComboMMvmerk = value,
    validatorCallback: (value) => value == null ? "" : null,
  );

  Widget buildFieldMmvtipeId() {
    final isEnabled = fieldComboMMvmerk != null &&
        (fieldComboMMvmerk!.mmvmerkId.isNotEmpty);

    return ReusableComboBox<ComboMMvtipeModel>(
      hintText: "Model",
      comboKey: comboMMvtipeKey,
      initItem: fieldComboMMvtipe,
      isEnabled: isEnabled,
      dataLoader: () async {
        if (!isEnabled) {
          return [];
        }
        return ComboMMvtipeRepository()
            .getComboMMvtipe(fieldComboMMvmerk!.mmvmerkId, "");
      },
      displayText: (item) => item.nmTipe,
      compareItems: (a, b) => a.mmvtipeId == b.mmvtipeId,
      onChangedCallback: (value) {
        if (value != null) {
          setState(() => fieldComboMMvtipe = value);
          regmv3FormBloc.add(ComboMMvtipeChangedEvent(comboMMvtipe: value));
          comboMMvmodelKey.currentState?.clear();
          setState(() => fieldComboMMvmodel = null);
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboMMvtipe = value;
      },
      validatorCallback: (value) {
        if (value == null && isEnabled) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldMmvmodelId() {
    final isEnabled = fieldComboMMvtipe != null &&
        (fieldComboMMvtipe!.mmvtipeId.isNotEmpty);

    return ReusableComboBox<ComboMMvmodelModel>(
      hintText: "Tipe",
      comboKey: comboMMvmodelKey,
      initItem: fieldComboMMvmodel,
      isEnabled: isEnabled,
      dataLoader: () async {
        if (!isEnabled) {
          return [];
        }
        final tipeId = fieldComboMMvtipe!.mmvtipeId;
        debugPrint("[Regmv3Form] 🔍 REQUEST mmvmodel untuk mmvtipeId = '$tipeId'");
        final list = await ComboMMvmodelRepository()
            .getComboMMvmodel(tipeId, "");
        debugPrint("[Regmv3Form] 🔍 response length = ${list.length}");
        return list;
      },
      displayText: (item) => item.nmModel.isNotEmpty ? item.nmModel : item.mmvmodelId,
      compareItems: (a, b) => a.mmvmodelId == b.mmvmodelId,
      onChangedCallback: (value) {
        if (value != null) {
          setState(() => fieldComboMMvmodel = value); // FIX 🔥
          debugPrint("[Regmv3Form] selected model = ${value.mmvmodelId} | ${value.nmModel}");
          regmv3FormBloc.add(ComboMMvmodelChangedEvent(comboMMvmodel: value));
        }
      },
      onSaveCallback: (value) => fieldComboMMvmodel = value,
      validatorCallback: (value) {
        if (value == null && isEnabled) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldMmvpakaiId() => ReusableComboBox<ComboMMvpakaiModel>(
    hintText: "Penggunaan",
    comboKey: comboMMvpakaiKey,
    initItem: fieldComboMMvpakai,
    dataLoader: () => ComboMMvpakaiRepository().getComboMMvpakai(""),
    displayText: (item) => item.pakaiNama,
    compareItems: (a, b) => a.mmvpakaiId == b.mmvpakaiId,
    onChangedCallback: (value) {
      if (value != null) {
        setState(() => fieldComboMMvpakai = value); // FIX 🔥
        regmv3FormBloc.add(ComboMMvpakaiChangedEvent(comboMMvpakai: value));
      }
    },
    onSaveCallback: (value) {
      fieldComboMMvpakai = value;
    },
    validatorCallback: (value) {
      if (value == null) return "";
      return null;
    },
  );

  Widget buildFieldMwarnaId() => ReusableComboBox<ComboMWarnaModel>(
    hintText: "Warna",
    comboKey: comboMWarnaKey,
    initItem: fieldComboMWarna,
    dataLoader: () => ComboMWarnaRepository().getComboMWarna(""),
    displayText: (item) => item.warnaDesc,
    compareItems: (a, b) => a.mwarnaId == b.mwarnaId,
    onChangedCallback: (value) {
      if (value != null) {
        setState(() => fieldComboMWarna = value); // FIX 🔥
        regmv3FormBloc.add(ComboMWarnaChangedEvent(comboMWarna: value));
      }
    },
    onSaveCallback: (value) {
      fieldComboMWarna = value;
    },
    validatorCallback: (value) {
      if (value == null) return "";
      return null;
    },
  );

  Widget buildFieldMwilayahId() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    comboKey: comboMWilayahKey,
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (item) => item.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    onChangedCallback: (value) {
      if (value != null) {
        setState(() => fieldComboMWilayah = value); // FIX 🔥
        regmv3FormBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
      }
    },
    onSaveCallback: (value) {
      fieldComboMWilayah = value;
    },
    validatorCallback: (value) {
      if (value == null) return "";
      return null;
    },
  );

  Widget buildFieldPlatNo() => appTextField(
    label: "No Polisi",
    controller: fieldPlatNoController,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    validator: (v) => v == null || v.isEmpty ? "" : null,
  );

  Widget buildFieldRangkaNo() => appTextField(
    label: "No Rangka",
    controller: fieldRangkaNoController,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    validator: (v) => v == null || v.isEmpty ? "" : null,
  );

  Widget buildFieldThnBuat() => appTextField(
    label: "Tahun Pembuatan",
    controller: fieldThnBuatController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    textInputAction: TextInputAction.next,
    validator: (v) => v == null || v.isEmpty ? "" : null,
  );

  void saveForm() {
    debugPrint("=======================================");
    debugPrint("🔥 [FORM3] DEBUG BEFORE SAVE");
    debugPrint("regmv1Id         = $parentRegmv1Id");
    debugPrint("wilayahId        = ${fieldComboMWilayah?.mwilayahId}");
    debugPrint("tipeId           = ${fieldComboMMvtipe?.mmvtipeId}");
    debugPrint("warnaId          = ${fieldComboMWarna?.mwarnaId}");
    debugPrint("penggunaanId     = ${fieldComboMMvpakai?.mmvpakaiId}");
    debugPrint("harga            = ${fieldHargaController.text}");
    debugPrint("thnBuat          = ${fieldThnBuatController.text}");
    debugPrint("platNo           = ${fieldPlatNoController.text}");
    debugPrint("mesinNo          = ${fieldMesinNoController.text}");
    debugPrint("rangkaNo         = ${fieldRangkaNoController.text}");
    debugPrint("merkId           = ${fieldComboMMvmerk?.mmvmerkId}");
    debugPrint("modelId          = ${fieldComboMMvmodel?.mmvmodelId}");
    debugPrint("=======================================");

    // 🔐 safety: pastikan regmv1 sudah ada
    if (parentRegmv1Id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Simpan Data Tertanggung terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      debugPrint("⚠️ [FORM3] VALIDATION FAILED");
      return;
    }

    _formKey.currentState!.save();

    final record = Regmv3FormModel(
      regmv1Id: parentRegmv1Id,
      regmv3Id: _currentRegmv3Id ?? '',     // 🔥 kunci insert vs update
      aksesoris: fieldAksesorisController.text,
      harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
      mesinNo: fieldMesinNoController.text,
      mmvmerkId: fieldComboMMvmerk?.mmvmerkId,
      mmvmodelId: fieldComboMMvmodel?.mmvmodelId,
      mmvpakaiId: fieldComboMMvpakai?.mmvpakaiId,
      mmvtipeId: fieldComboMMvtipe?.mmvtipeId,
      mwarnaId: fieldComboMWarna?.mwarnaId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
      platNo: fieldPlatNoController.text,
      rangkaNo: fieldRangkaNoController.text,
      thnBuat: int.parse(fieldThnBuatController.text),
    );

    debugPrint("🔥 [FORM3] RECORD YANG DIKIRIM KE BLOC");
    debugPrint(record.toJson().toString());

    // 🔥 insert vs update pakai _currentRegmv3Id, bukan viewMode
    if (_currentRegmv3Id != null && _currentRegmv3Id!.isNotEmpty) {
      debugPrint("📡 [FORM3] UPDATE regmv3Id = $_currentRegmv3Id");
      regmv3FormBloc.add(Regmv3FormUbahEvent(record: record));
    } else {
      debugPrint("📡 [FORM3] CREATE baru untuk regmv1Id = $parentRegmv1Id");
      regmv3FormBloc.add(Regmv3FormTambahEvent(record: record));
    }
  }
}
