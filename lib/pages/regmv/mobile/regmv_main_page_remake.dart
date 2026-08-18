import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_regmv/regmv1crud_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/pages/regmv/mobile/preview/regmv4_unified_preview_page.dart';
import 'package:joss_app/pages/regmv/mobile/preview/regmv5_unified_preview_page.dart';
import 'package:joss_app/pages/regmv/mobile/preview/regmv7_unified_preview_page.dart';
import 'package:string_validator/string_validator.dart';
import '../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../blocs/gen_regmv/regmv4cari_bloc.dart';
import '../../../blocs/gen_regmv/regmv5cari_bloc.dart';
import '../../../blocs/gen_regmv/regmv6form_bloc.dart';
import '../../../blocs/gen_regmv/regmv7cari_bloc.dart';
import '../../../blocs/gen_regmv/regmv_flow_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/loading_indicator.dart';
import '../../../common/plat_nomor_formatter.dart';
import '../../../common/rangka_no_formatter.dart';
import '../../../common/thousand_separator_input_formatter.dart';
import '../../../helper/navigation_keys.dart';
import '../../../models/combobox/combommvjnscover_model.dart';
import '../../../models/combobox/combommvmerk_model.dart';
import '../../../models/combobox/combommvmodel_model.dart';
import '../../../models/combobox/combommvpakai_model.dart';
import '../../../models/combobox/combommvtipe_model.dart';
import '../../../models/combobox/combomwarna_model.dart';
import '../../../models/combobox/combomwilayah_model.dart';
import '../../../models/combobox/combormatauang_model.dart';
import '../../../models/gen_regmv/regmv1crud_model.dart';
import '../../../models/gen_regmv/regmv2form_model.dart';
import '../../../models/gen_regmv/regmv3form_model.dart';
import '../../../models/gen_regmv/regmv4form_model.dart';
import '../../../models/gen_regmv/regmv5form_model.dart';
import '../../../models/gen_regmv/regmv6form_model.dart';
import '../../../models/gen_regmv/regmv7form_model.dart';
import '../../../models/gen_regmv/regmv_validation_preview_model.dart';
import '../../../repositories/combobox/combommvjnscover_repository.dart';
import '../../../repositories/combobox/combommvmerk_repository.dart';
import '../../../repositories/combobox/combommvmodel_repository.dart';
import '../../../repositories/combobox/combommvpakai_repository.dart';
import '../../../repositories/combobox/combommvtipe_repository.dart';
import '../../../repositories/combobox/combomwarna_repository.dart';
import '../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../repositories/combobox/combormatauang_repository.dart';
import '../../../repositories/gen_regmv/regmv_validation_preview_repository.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/dropdown2.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/apptheme/hitung_premi_empty_view.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import 'konfirmasi_regmv_page.dart';
import '../../../helper/cob_access_guard.dart';

enum RegmvFormSection {
  form1,
  form2,
  form3,
  form4,
  form5,
  form7,
  form6,
}

class _RegmvBackendValidationTarget {
  final RegmvFormSection section;
  final String fieldKey;
  final List<String> affectedFieldKeys;

  const _RegmvBackendValidationTarget({
    required this.section,
    required this.fieldKey,
    required this.affectedFieldKeys,
  });
}

class RegmvFormMainRemake extends StatefulWidget {
  final String? regmv1Id;
  final String? calmv1Id;

  const RegmvFormMainRemake({
    required this.regmv1Id,
    required this.calmv1Id,
    super.key,
  });

  @override
  State<RegmvFormMainRemake> createState() => _RegmvFormMainRemakeState();
}

class _RegmvFormMainRemakeState extends State<RegmvFormMainRemake> {
  bool _accessDeniedDialogShown = false;
  List<bool> expanded = List.filled(RegmvFormSection.values.length, false);
  final Set<RegmvFormSection> _sectionLoadings = <RegmvFormSection>{};

  int getOpenedIndex() => expanded.indexWhere((e) => e);

  String? regmv1Id;
  String? regmv2Id;
  String? regmv3Id;
  String? regmv4Id;
  String? regmv5Id;
  String? regmv7Id;

  Regmv1CrudBloc? regmv1crudbloc;
  Regmv2FormBloc? regmv2formbloc;
  Regmv3FormBloc? regmv3formbloc;

  bool _showVal4 = false;
  bool _showVal5 = false;
  bool _showVal7 = false;

  Regmv1CrudModel? form1Record;
  Regmv2FormModel? form2Record;
  Regmv3FormModel? form3Record;
  Regmv4FormModel? form4Record;
  Regmv5FormModel? form5Record;
  Regmv6FormModel? form6Record;
  Regmv7FormModel? form7Record;
  bool _defaultCurrencyApplied = false;

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

  //form1
  final fieldCalmv1IdController = TextEditingController();
  final fieldTtgAlamatController = TextEditingController();
  final fieldTtgNamaController = TextEditingController();
  //form1

  //form2
  final fieldPolisAkhirController = TextEditingController();
  final fieldPolisMulaiController = TextEditingController();
  final fieldIsAwController = TextEditingController();
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
  final comboRMatauangKey =
      GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey =
      GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  DateTime? kejadianMulaiTgl;
  final _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  String selectedPassengerCount = "";
  //form2

  //form3
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
  String selectedYearform3 = "";
  //form3

  //form6
  final fieldDiskonPersenController = TextEditingController();
  final fieldPremiAddController = TextEditingController();
  final fieldPremiCascoController = TextEditingController();
  final fieldPremiDiskonController = TextEditingController();
  final fieldPremiNetController = TextEditingController();
  final fieldPremiSubtotalController = TextEditingController();
  final fieldRateDasarController = TextEditingController();
  final fieldRateLoadingController = TextEditingController();
  final fieldRateSrccController = TextEditingController();
  final fieldRateFloodController = TextEditingController();
  final fieldRateEqController = TextEditingController();
  final fieldRateTerrorismController = TextEditingController();
  final fieldRatePadController = TextEditingController();
  final fieldRatePapController = TextEditingController();
  final fieldRateAwController = TextEditingController();
  final fieldBiayaPolisController = TextEditingController();
  final fieldBiayaMateraiController = TextEditingController();
  final fieldSumInsuredController = TextEditingController();
  final fieldRateTotalController = TextEditingController();
  final fieldTotalTagihanController = TextEditingController();

  Iterable<TextEditingController> get _premiInputControllers =>
      <TextEditingController>[
        fieldCalmv1IdController,
        fieldTtgAlamatController,
        fieldTtgNamaController,
        fieldIsAwController,
        fieldIsEqController,
        fieldIsFloodController,
        fieldIsSrccController,
        fieldIsTerrorismController,
        fieldPadController,
        fieldPapController,
        fieldPllController,
        fieldTplController,
        fieldAksesorisController,
        fieldHargaController,
        fieldMesinNoController,
        fieldPlatNoController,
        fieldRangkaNoController,
      ];
  //form6

  @override
  void initState() {
    super.initState();

    for (final controller in _premiInputControllers) {
      controller.addListener(_refreshPremiSnapshotVisibility);
    }

    final regmv1 = context.read<Regmv1CrudBloc>().state.record?.regmv1Id ?? "";
    regmv1Id = widget.regmv1Id ?? regmv1;
    _loadDefaultCurrency();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      resetUploadStates(); // ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦ ini yang bikin foto lama hilang

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    });
  }

  Future<void> _loadDefaultCurrency() async {
    final currencies = await ComboRMatauangRepository().getComboRMatauang();

    if (!mounted || fieldComboRMatauang != null) return;

    ComboRMatauangModel? defaultCurrency;
    for (final currency in currencies) {
      if (currency.rmatauangKode == '001') {
        defaultCurrency = currency;
        break;
      }
    }

    if (defaultCurrency == null) return;

    setState(() {
      fieldComboRMatauang = defaultCurrency;
      _defaultCurrencyApplied = true;
      fieldErrors.remove('form2.mataUang');
    });
  }

  @override
  void dispose() {
    for (final controller in _premiInputControllers) {
      controller.removeListener(_refreshPremiSnapshotVisibility);
    }

    //form1
    fieldCalmv1IdController.dispose();
    fieldTtgAlamatController.dispose();
    fieldTtgNamaController.dispose();
    //form1

    //form2
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();
    fieldIsAwController.dispose();
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
    fieldTplController.dispose();
    //form2

    //form3
    fieldAksesorisController.dispose();
    fieldHargaController.dispose();
    fieldMesinNoController.dispose();
    fieldPlatNoController.dispose();
    fieldRangkaNoController.dispose();
    fieldThnBuatController.dispose();
    //form3

    //form6
    fieldDiskonPersenController.dispose();
    fieldPremiAddController.dispose();
    fieldPremiCascoController.dispose();
    fieldPremiDiskonController.dispose();
    fieldPremiNetController.dispose();
    fieldPremiSubtotalController.dispose();
    fieldRateDasarController.dispose();
    fieldRateLoadingController.dispose();
    fieldRateSrccController.dispose();
    fieldRateFloodController.dispose();
    fieldRateEqController.dispose();
    fieldRateTerrorismController.dispose();
    fieldRatePadController.dispose();
    fieldRatePapController.dispose();
    fieldBiayaPolisController.dispose();
    fieldBiayaMateraiController.dispose();
    fieldSumInsuredController.dispose();
    fieldRateTotalController.dispose();
    fieldRateAwController.dispose();
    fieldTotalTagihanController.dispose();
    //form6

    super.dispose();
  }

  void refreshForm1({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regmv1CrudBloc>().add(
          Regmv1CrudLihatEvent(recordId: recordId),
        );
  }

  void refreshForm2({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regmv2FormBloc>().add(
          Regmv2FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm3({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regmv3FormBloc>().add(
          Regmv3FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm4({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) {
      debugPrint("ÃƒÂ¢Ã‚ÂÃ…â€™ recordId null atau empty, RETURN");
      return;
    }

    context.read<Regmv4CariBloc>().add(
          RefreshRegmv4CariEvent(regmv1Id: recordId),
        );
  }

  void refreshForm5({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regmv5CariBloc>().add(
          RefreshRegmv5CariEvent(regmv1Id: recordId),
        );
  }

  void refreshForm6({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regmv6FormBloc>().add(
          Regmv6FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm7({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regmv7CariBloc>().add(
          RefreshRegmv7CariEvent(regmv1Id: recordId),
        );
  }

  bool _isSectionLoading(RegmvFormSection section) =>
      _sectionLoadings.contains(section);

  void _stopSectionLoading(RegmvFormSection section) {
    if (!_sectionLoadings.contains(section) || !mounted) return;
    setState(() {
      _sectionLoadings.remove(section);
    });
  }

  void _clearLoadedErrors(RegmvFormSection section) {
    bool hasText(TextEditingController controller) =>
        controller.text.trim().isNotEmpty;

    bool hasValidOptionalNumber(TextEditingController controller) {
      final raw = controller.text.trim();
      if (raw.isEmpty) return false;
      final clean = raw.replaceAll(',', '');
      final value = double.tryParse(clean);
      return value != null && value >= 0 && !hasLeadingZero(clean);
    }

    bool hasPositiveNumber(TextEditingController controller) {
      final raw = controller.text.trim();
      if (raw.isEmpty) return false;
      final value = double.tryParse(raw.replaceAll(',', ''));
      return value != null && value > 0;
    }

    final keys = <String>[];

    switch (section) {
      case RegmvFormSection.form1:
        if (hasText(fieldTtgNamaController)) keys.add('form1.namaTertanggung');
        if (hasText(fieldTtgAlamatController)) {
          keys.add('form1.alamatTertanggung');
        }
        break;
      case RegmvFormSection.form2:
        keys.add('form2.general');
        if (fieldComboRMatauang != null) keys.add('form2.mataUang');
        if (fieldComboMMvjnscover != null) keys.add('form2.jenisCover');
        if (selectedPassengerCount.trim().isNotEmpty) {
          keys.add('form2.passengerCount');
        }
        if (hasValidOptionalNumber(fieldTplController)) keys.add('form2.tpl');
        if (hasValidOptionalNumber(fieldPadController)) keys.add('form2.pad');
        if (hasValidOptionalNumber(fieldPapController)) keys.add('form2.pap');
        if (hasValidOptionalNumber(fieldPllController)) keys.add('form2.pll');
        break;
      case RegmvFormSection.form3:
        keys.add('form3.general');
        if (selectedYearform3.trim().isNotEmpty) keys.add('form3.tahun');
        if (hasPositiveNumber(fieldHargaController)) {
          keys.add('form3.hargaMobil');
        }
        if (fieldComboMWilayah != null) keys.add('form3.wilayah');
        if (_isValidPlatNomor(fieldPlatNoController.text)) {
          keys.add('form3.platNo');
        }
        if (fieldRangkaNoController.text.trim().length >= 5) {
          keys.add('form3.rangkaNo');
        }
        if (fieldMesinNoController.text.trim().length >= 5) {
          keys.add('form3.mesinNo');
        }
        if (fieldComboMMvmerk != null) keys.add('form3.merek');
        if (fieldComboMMvtipe != null) keys.add('form3.model');
        if (fieldComboMMvmodel != null) keys.add('form3.subModel');
        if (fieldComboMMvpakai != null) keys.add('form3.penggunaan');
        if (fieldComboMWarna != null) keys.add('form3.warna');
        break;
      case RegmvFormSection.form4:
      case RegmvFormSection.form5:
      case RegmvFormSection.form7:
      case RegmvFormSection.form6:
        break;
    }

    if (keys.isEmpty || !mounted) return;
    setState(() {
      for (final key in keys) {
        fieldErrors.remove(key);
      }
    });
  }

  void _payloadform1(Regmv1CrudModel record) {
    if (fieldCalmv1IdController.text.trim().isEmpty) {
      fieldCalmv1IdController.text = record.regmv1Id.toString();
    }

    if (fieldTtgNamaController.text.trim().isEmpty) {
      fieldTtgNamaController.text = record.ttgNama.toString();
    }

    if (fieldTtgAlamatController.text.trim().isEmpty) {
      fieldTtgAlamatController.text = record.ttgAlamat.toString();
    }
  }

  void _payloadform2(Regmv2FormModel record) {
    if (fieldIsAwController.text.trim().isEmpty) {
      fieldIsAwController.text = record.isAw.toString();
    }

    if (fieldIsEqController.text.trim().isEmpty) {
      fieldIsEqController.text = record.isEq.toString();
    }
    if (fieldIsFloodController.text.trim().isEmpty) {
      fieldIsFloodController.text = record.isFlood.toString();
    }
    if (fieldIsSrccController.text.trim().isEmpty) {
      fieldIsSrccController.text = record.isSrcc.toString();
    }
    if (fieldIsTbodController.text.trim().isEmpty) {
      fieldIsTbodController.text = record.isTbod.toString();
    }
    if (fieldIsTerrorismController.text.trim().isEmpty) {
      fieldIsTerrorismController.text = record.isTerrorism.toString();
    }

    if (fieldPadController.text.trim().isEmpty) {
      fieldPadController.text = cleanNum(record.pad);
    }
    if (fieldPapController.text.trim().isEmpty) {
      fieldPapController.text = cleanNum(record.pap);
    }
    if (fieldPllController.text.trim().isEmpty) {
      fieldPllController.text = cleanNum(record.pll);
    }
    if (fieldTplController.text.trim().isEmpty) {
      fieldTplController.text = cleanNum(record.tpl);
    }

    if (fieldPolisMulaiController.text.trim().isEmpty) {
      fieldPolisMulaiController.text = record.polisMulai.toIso8601String();
    }
    if (fieldPolisAkhirController.text.trim().isEmpty) {
      fieldPolisAkhirController.text = record.polisAkhir.toIso8601String();
    }

    if (fieldPassangerCountController.text.trim().isEmpty) {
      fieldPassangerCountController.text = record.passangerCount.toString();
    }

    setState(() {
      final mulai = record.polisMulai;
      final akhir = record.polisAkhir;

      bool sameDay(DateTime a, DateTime b) =>
          a.year == b.year && a.month == b.month && a.day == b.day;

      if (sameDay(mulai, akhir)) {
        debugPrint(
            'ÃƒÂ¢Ã…Â¡Ã‚Â ÃƒÂ¯Ã‚Â¸Ã‚Â Polis invalid dari backend (mulai==akhir). Abaikan polisAkhir backend.');
      }

      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(
            DateTime(mulai.year, mulai.month, mulai.day), // normalize
          ));
      if (selectedPassengerCount.trim().isEmpty) {
        final v = record.passangerCount.toString();
        if (v.isNotEmpty) selectedPassengerCount = v;
      }

      if ((fieldComboRMatauang == null || _defaultCurrencyApplied) &&
          record.comboRMatauang != null) {
        fieldComboRMatauang = record.comboRMatauang;
        _defaultCurrencyApplied = false;
      }

      if (fieldComboMMvjnscover == null && record.comboMMvjnscover != null) {
        fieldComboMMvjnscover = record.comboMMvjnscover;
      }
    });
  }

  void _payloadform3(Regmv3FormModel record) {
    if (fieldAksesorisController.text.trim().isEmpty) {
      fieldAksesorisController.text = record.aksesoris.toString();
    }

    if (fieldHargaController.text.trim().isEmpty) {
      fieldHargaController.text = cleanNum(record.harga);
    }

    if (fieldMesinNoController.text.trim().isEmpty) {
      fieldMesinNoController.text = record.mesinNo.toString();
    }

    if (fieldPlatNoController.text.trim().isEmpty) {
      fieldPlatNoController.text = record.platNo.toString();
    }

    if (fieldRangkaNoController.text.trim().isEmpty) {
      fieldRangkaNoController.text = record.rangkaNo.toString();
    }

    if (fieldThnBuatController.text.trim().isEmpty) {
      fieldThnBuatController.text = record.thnBuat.toString();
    }

    setState(() {
      final thn = record.thnBuat;
      if (selectedYearform3.trim().isEmpty && thn != 0) {
        selectedYearform3 = thn.toString();
      }

      if (fieldComboMMvmerk == null && record.comboMMvmerk != null) {
        fieldComboMMvmerk = record.comboMMvmerk;
      }

      if (fieldComboMMvtipe == null && record.comboMMvtipe != null) {
        fieldComboMMvtipe = record.comboMMvtipe;
      }

      if (fieldComboMMvmodel == null && record.comboMMvmodel != null) {
        fieldComboMMvmodel = record.comboMMvmodel;
      }

      if (fieldComboMMvpakai == null && record.comboMMvpakai != null) {
        fieldComboMMvpakai = record.comboMMvpakai;
      }

      if (fieldComboMWarna == null && record.comboMWarna != null) {
        fieldComboMWarna = record.comboMWarna;
      }

      if (fieldComboMWilayah == null && record.comboMWilayah != null) {
        fieldComboMWilayah = record.comboMWilayah;
      }
    });
  }

  void _payloadform6(Regmv6FormModel record) {
    fieldDiskonPersenController.text = cleanNum(record.diskonPersen);
    fieldPremiAddController.text = cleanNum(record.premiAdd);
    fieldPremiCascoController.text = cleanNum(record.premiCasco);
    fieldPremiDiskonController.text = cleanNum(record.premiDiskon);
    fieldPremiNetController.text = cleanNum(record.premiNet);
    fieldPremiSubtotalController.text = cleanNum(record.premiSubtotal);
    fieldBiayaPolisController.text = cleanNum(record.biayaPolis);
    fieldBiayaMateraiController.text = cleanNum(record.biayaMaterai);
    fieldSumInsuredController.text = cleanNum(record.tsi);
    fieldRateDasarController.text = record.rateDasar.toString();
    fieldRateLoadingController.text = record.rateLoading.toString();
    fieldRateSrccController.text = record.rateSrcc.toString();
    fieldRateFloodController.text = record.rateFlood.toString();
    fieldRateEqController.text = record.rateEq.toString();
    fieldRateTerrorismController.text = record.rateTerrorism.toString();
    fieldRatePadController.text = record.ratePad.toString();
    fieldRatePapController.text = record.ratePap.toString();
    fieldRateAwController.text = record.rateAw.toString();
    fieldRateTotalController.text = record.rateTotal.toString();
    fieldTotalTagihanController.text = record.totalTagihan.toString();
  }

  bool _hasValidRegmv6Premium(Regmv6FormModel? record) {
    if (record == null) return false;

    return record.totalTagihan > 0 ||
        record.premiNet > 0 ||
        record.premiSubtotal > 0 ||
        record.premiCasco > 0 ||
        record.premiAdd > 0;
  }

  Future<bool?> showExitConfirmDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SVG Warning Icon
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: SvgPicture.asset(
                      "assets/icons/bi_exclamation-circle.svg",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Keluar halaman ini?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Anda memiliki data yang belum disimpan. Jika keluar dari halaman ini, seluruh data akan hilang.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sGrey,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "Tidak",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pSlowRed,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              "Iya, Keluar",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _handleExit(BuildContext context) async {
    final shouldLeave = await showExitConfirmDialog(context);

    if (shouldLeave == true) {
      context.read<Regmv1CrudBloc>().add(
            Regmv1CrudHapusEvent(recordId: regmv1Id ?? ""),
          );
      Navigator.pop(context);
    }
  }

  Future<void> _handleExit2(BuildContext context) async {
    final shouldLeave = await showExitConfirmDialog(context);

    if (shouldLeave == true) {
      context.read<Regmv1CrudBloc>().add(
            Regmv1CrudHapusEvent(recordId: regmv1Id ?? ""),
          );
      final homeState = homeTabKey.currentState;

      if (homeState != null) {
        homeState.goToHeroPage();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _handleAccessDeniedExit(BuildContext context) {
    context.read<Regmv1CrudBloc>().add(
          Regmv1CrudHapusEvent(recordId: regmv1Id ?? ""),
        );

    final homeState = homeTabKey.currentState;

    if (homeState != null) {
      homeState.goToHeroPage();
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  bool _isLanjutkanLoading = false;

  bool _isDialogLoadingShown = false;

  void _showGlobalLoading() {
    if (!mounted || _isDialogLoadingShown) return;

    _isDialogLoadingShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }

  void _hideGlobalLoading() {
    if (!mounted || !_isDialogLoadingShown) return;

    _isDialogLoadingShown = false;

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return IosLeftEdgeSwipe(
      onSwipeBack: () async {
        await _handleExit(context);
      },
      child: PopScope(
        canPop: Platform.isAndroid ? false : true,
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS) return;
          if (didPop) return;

          await _handleExit(context);
        },
        child: BaseBackgroundSidePage(
          onBack: () async {
            await _handleExit(context);
          },
          onHome: () async {
            await _handleExit2(context);
          },
          title: "Polis Kendaraan",
          blocListeners: [
            CobAccessGuard.buildHakaksesListener(
              cobId: CobAccessGuard.cobKendaraan,
              isDialogShown: () => _accessDeniedDialogShown,
              markDialogShown: () {
                _accessDeniedDialogShown = true;
              },
              onAccessDeniedReturn: () => _handleAccessDeniedExit(context),
            ),
            BlocListener<Regmv1CrudBloc, Regmv1CrudState>(
              listener: (context, state) {
                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regmv1Id = state.record!.regmv1Id;
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform1(state.record!);
                  _clearLoadedErrors(RegmvFormSection.form1);
                }
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegmvFormSection.form1);
                }
              },
            ),
            BlocListener<Regmv2FormBloc, Regmv2FormState>(
              listener: (context, state) {
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegmvFormSection.form2);
                }

                if (state.hasFailure) {
                  _handleBackendSaveFailure(
                    source: 'regmv2',
                    message: state.failureMessage,
                    kind: state.failureKind,
                  );
                  return;
                }

                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regmv2Id = state.record!.regmv2Id;
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform2(state.record!);
                  _clearLoadedErrors(RegmvFormSection.form2);
                }
              },
            ),
            BlocListener<Regmv3FormBloc, Regmv3FormState>(
              listener: (context, state) {
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegmvFormSection.form3);
                }

                if (state.hasFailure) {
                  _handleBackendSaveFailure(
                    source: 'regmv3',
                    message: state.failureMessage,
                    kind: state.failureKind,
                  );
                  return;
                }

                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regmv3Id = state.record!.regmv3Id;
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform3(state.record!);
                  _clearLoadedErrors(RegmvFormSection.form3);
                }
              },
            ),
            BlocListener<PolisTanggalBloc, PolisTanggalState>(
              listenWhen: (prev, curr) =>
                  prev.mulai != curr.mulai || prev.berakhir != curr.berakhir,
              listener: (_, __) => _refreshPremiSnapshotVisibility(),
            ),
            BlocListener<RegmvUploadStnkBloc, Regmv4UploadFotoObjectState>(
              listenWhen: (prev, curr) => prev.items != curr.items,
              listener: (_, __) => _refreshPremiSnapshotVisibility(),
            ),
            BlocListener<RegmvUploadFotoMobilBloc, Regmv5UploadFotoObjectState>(
              listenWhen: (prev, curr) => prev.items != curr.items,
              listener: (_, __) => _refreshPremiSnapshotVisibility(),
            ),
            BlocListener<RegmvUploadFotoAccBloc, Regmv7UploadFotoObjectState>(
              listenWhen: (prev, curr) => prev.items != curr.items,
              listener: (_, __) => _refreshPremiSnapshotVisibility(),
            ),
            BlocListener<Regmv4CariBloc, Regmv4CariState>(
              listenWhen: (prev, curr) => prev.status != curr.status,
              listener: (context, state) {
                if (state.status == ListStatus.success ||
                    state.status == ListStatus.failure) {
                  _stopSectionLoading(RegmvFormSection.form4);
                }
              },
            ),
            BlocListener<Regmv5CariBloc, Regmv5CariState>(
              listenWhen: (prev, curr) => prev.status != curr.status,
              listener: (context, state) {
                if (state.status == ListStatus.success ||
                    state.status == ListStatus.failure) {
                  _stopSectionLoading(RegmvFormSection.form5);
                }
              },
            ),
            BlocListener<Regmv7CariBloc, Regmv7CariState>(
              listenWhen: (prev, curr) => prev.status != curr.status,
              listener: (context, state) {
                if (state.status == ListStatus.success ||
                    state.status == ListStatus.failure) {
                  _stopSectionLoading(RegmvFormSection.form7);
                }
              },
            ),
            BlocListener<Regmv6FormBloc, Regmv6FormState>(
              listener: (context, state) {
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegmvFormSection.form6);
                }

                if (state.hasFailure) {
                  if (mounted) {
                    setState(() {
                      _isHitungPremiLoading = false;
                    });
                  }
                  return;
                }

                final record = state.record;
                if (record == null) return;

                if (state.isLoaded) {
                  _payloadform6(record);
                }

                if (state.isCalculated) {
                  if (mounted) {
                    setState(() {
                      _isHitungPremiLoading = false;
                      _lastCalculatedPremiKey = _currentPremiInputKey();
                    });
                  }

                  _payloadform6(record);
                  openPremiSection(recordId: regmv1Id);
                }
              },
            ),
          ],
          child: _buildForm(),
        ),
      ),
    );
  }

  bool isAllFormComplete() {
    return isForm1Complete() &&
        isForm2Complete() &&
        isForm3Complete() &&
        isForm4Complete() &&
        isForm5Complete() &&
        isForm6Complete();
    // &&
    // isForm7Complete();
  }

  Widget _buildForm() {
    final bool hasForm6Record = _hasValidRegmv6Premium(
      context.read<Regmv6FormBloc>().state.record,
    );
    final bool canShowLanjutkan =
        isAllFormComplete() && _isCalculatedPremiCurrent();
    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: hPadding * 1.5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                  child: const FormSectionHeader(
                    iconPath: "assets/icons/kendaraan.svg",
                    title: "Polis Kendaraan",
                    subtitle:
                        "Isi detail kendaraan, pilih pertanggungan, dan hitung premi secara otomatis.",
                  ),
                ),
                const SizedBox(height: hPadding * 1.5),
                CustomProgressBar(
                  progress: getProgressValue(),
                  horizontalPadding: hPadding * 1.5,
                  barColor: primaryColor,
                  borderRadius: cardBorderRadius,
                ),
                const SizedBox(height: hPadding * 1.5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form1Page(
                        context: context,
                        title: "Data Tertanggung",
                        isExpanded: expanded[0],
                        isLoading: _isSectionLoading(RegmvFormSection.form1),
                        showLoadingOnRefresh: _canRefreshRecord(regmv1Id),
                        onToggle: (v) => setState(() => expanded[0] = v),
                        onRefresh: () {
                          debugPrint(
                              "regmv1Id : $regmv1Id + widget.regmv1Id : ${widget.regmv1Id}");
                          if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                            refreshForm1(recordId: regmv1Id);
                          }
                        },
                        child: Column(
                          children: [
                            buildFieldCalmv1Id(),
                            const SizedBox(height: hPadding),
                            buildFieldTtgNama(),
                            const SizedBox(height: hPadding),
                            buildFieldTtgAlamat(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form2Page(
                        context: context,
                        title: "Data Polis",
                        isExpanded: expanded[1],
                        isLoading: _isSectionLoading(RegmvFormSection.form2),
                        showLoadingOnRefresh: _canRefreshRecord(regmv1Id),
                        onToggle: (v) => setState(() => expanded[1] = v),
                        onRefresh: () {
                          if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                            refreshForm2(recordId: regmv1Id);
                          }
                        },
                        child: Column(
                          children: [
                            _buildFormError('form2.general'),
                            Row(
                              children: [
                                Flexible(child: buildFieldPolisMulai()),
                                const SizedBox(width: 8),
                                Flexible(child: buildFieldPolisBerakhir()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildComboCurddId()),
                                const SizedBox(width: 8),
                                const Flexible(child: SizedBox.shrink()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            _buildComboMMvjnscover(),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildFieldIsEq()),
                                const SizedBox(width: 8),
                                Flexible(child: _buildFieldIsFlood()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildFieldIsSrcc()),
                                const SizedBox(width: 8),
                                Flexible(child: _buildFieldIsTerrorism()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildFieldIsAw()),
                                const SizedBox(width: 8),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildFieldPLL()),
                                const SizedBox(width: 8),
                                Flexible(child: _buildFieldTPL()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildFieldPAD()),
                                const SizedBox(width: 8),
                                Flexible(child: _buildFieldPAP()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(
                                    child: _buildFieldPassengerCountCombo()),
                                const SizedBox(width: 8),
                                const Flexible(child: SizedBox.shrink()),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form3Page(
                        context: context,
                        title: "Data Kendaraan",
                        isExpanded: expanded[2],
                        isLoading: _isSectionLoading(RegmvFormSection.form3),
                        showLoadingOnRefresh: _canRefreshRecord(regmv1Id),
                        onToggle: (v) => setState(() => expanded[2] = v),
                        onRefresh: () {
                          if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                            refreshForm3(recordId: regmv1Id);
                          }
                        },
                        child: Column(
                          children: [
                            _buildFormError('form3.general'),
                            Row(
                              children: [
                                Flexible(child: _buildFieldComboTahun()),
                                const SizedBox(width: 8),
                                Flexible(child: _buildHargaMobil()),
                              ],

                            ),
                            const SizedBox(height: hPadding),
                            _buildComboMWilayah(),
                            const SizedBox(height: hPadding),
                            _buildFieldPlatNo(),
                            const SizedBox(height: hPadding),
                            _buildFieldRangkaNo(),
                            const SizedBox(height: hPadding),
                            _buildFieldMesinNo(),
                            const SizedBox(height: hPadding),
                            _buildFieldMmvmerkId(),
                            const SizedBox(height: hPadding),
                            _buildComboTipeId(),
                            const SizedBox(height: hPadding),
                            _buildFieldMmvmodelId(),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: _buildFieldMmvsubmodelId()),
                                const SizedBox(width: 8),
                                Flexible(child: _buildComboWarnaId()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            _buildFieldAksesoris(),
                            const SizedBox(height: hPadding),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: hPadding,
                      ),
                      Form4Page(
                        context: context,
                        title: "Foto STNK",
                        isExpanded: expanded[3],
                        isLoading: _isSectionLoading(RegmvFormSection.form4),
                        showLoadingOnRefresh: _canRefreshRecord(regmv1Id),
                        onToggle: (v) => setState(() => expanded[3] = v),
                        onRefresh: () {
                          if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                            refreshForm4(recordId: regmv1Id);
                          }
                        },
                        child: Column(
                          children: [
                            BlocBuilder<RegmvUploadStnkBloc,
                                Regmv4UploadFotoObjectState>(
                              buildWhen: (p, c) =>
                                  p.items.length != c.items.length,
                              builder: (context, state) {
                                if (_showVal4 && state.items.isNotEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted)
                                      setState(() => _showVal4 = false);
                                  });
                                }

                                return Regmv4StoragePickerSectionWidget(
                                  showRequiredError:
                                      _showVal4 && state.items.isEmpty,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form5Page(
                        context: context,
                        title: "Foto Kendaraan",
                        isExpanded: expanded[4],
                        isLoading: _isSectionLoading(RegmvFormSection.form5),
                        showLoadingOnRefresh: _canRefreshRecord(regmv1Id),
                        onToggle: (v) => setState(() => expanded[4] = v),
                        onRefresh: () {
                          if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                            refreshForm5(recordId: regmv1Id);
                          }
                        },
                        child: Column(
                          children: [
                            BlocBuilder<RegmvUploadFotoMobilBloc,
                                Regmv5UploadFotoObjectState>(
                              buildWhen: (p, c) =>
                                  p.items.length != c.items.length,
                              builder: (context, state) {
                                if (_showVal5 && state.items.isNotEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted)
                                      setState(() => _showVal5 = false);
                                  });
                                }

                                return Regmv5StoragePickerSectionWidget(
                                  showRequiredError:
                                      _showVal5 && state.items.isEmpty,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form7Page(
                        context: context,
                        title: "Foto Aksesoris",
                        isExpanded: expanded[5],
                        isLoading: _isSectionLoading(RegmvFormSection.form7),
                        showLoadingOnRefresh: _canRefreshRecord(regmv1Id),
                        onToggle: (v) => setState(() => expanded[5] = v),
                        onRefresh: () {
                          if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                            refreshForm7(recordId: regmv1Id);
                          }
                        },
                        child: Column(
                          children: [
                            BlocBuilder<RegmvUploadFotoAccBloc,
                                Regmv7UploadFotoObjectState>(
                              buildWhen: (p, c) =>
                                  p.items.length != c.items.length,
                              builder: (context, state) {
                                if (_showVal7 && state.items.isNotEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted)
                                      setState(() => _showVal7 = false);
                                  });
                                }

                                return Regmv7StoragePickerSectionWidget(
                                  showRequiredError:
                                      _showVal7 && state.items.isEmpty,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      buildButtonHitungPremi(),
                      const SizedBox(height: hPadding),
                      Form6Page(
                        context: context,
                        title: "Premi",
                        isExpanded: expanded[6],
                        isLoading: _isSectionLoading(RegmvFormSection.form6),
                        onToggle: (v) => setState(() => expanded[6] = v),
                        child: (hasForm6Record)
                            ? Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "RATE",
                                      style: bodyTextStyle(context).copyWith(
                                        color: primaryLightColor,
                                        fontSize:
                                            getResponsiveFont(context, 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  HitungPremiWidget(
                                    rows: [
                                      HitungPremiRow(
                                        label:
                                            "${fieldComboMMvjnscover?.coverName ?? '-'}:",
                                        controller: fieldRateDasarController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Loading:",
                                        controller: fieldRateLoadingController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Kerusuhan:",
                                        controller: fieldRateSrccController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Terorisme & Sabotase:",
                                        controller:
                                            fieldRateTerrorismController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Banjir:",
                                        controller: fieldRateFloodController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Gempa Bumi:",
                                        controller: fieldRateEqController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Bengkel Resmi:",
                                        controller: fieldRateAwController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Total Rate:",
                                        controller: fieldRateTotalController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  const Divider(
                                    thickness: 1,
                                    color: sGrey,
                                  ),
                                  const SizedBox(height: 2),
                                  HitungPremiWidget(
                                    rows: [
                                      HitungPremiRow(
                                        label: "PREMI TAHUNAN",
                                        description:
                                            "${fieldComboRMatauang?.rmatauangSimbol} ${fieldSumInsuredController.text} x ${fieldRateTotalController.text}% =",
                                        controller: fieldPremiCascoController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                      HitungPremiRow(
                                        label: "PREMI TAMBAHAN",
                                        description: "(For TPL & PAD & PAP)",
                                        controller: fieldPremiAddController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                      HitungPremiRow(
                                        label: "DISKON",
                                        controller: fieldPremiDiskonController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                      HitungPremiRow(
                                        label: "BIAYA POLIS",
                                        controller: fieldBiayaPolisController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                      HitungPremiRow(
                                        label: "BIAYA MATERAI",
                                        controller: fieldBiayaMateraiController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                      // HitungPremiRow(
                                      //   // label: "TOTAL PREMI",
                                      //   label: "TOTAL TAGIHAN",
                                      //   controller: fieldPremiNetController,
                                      //   layoutType: HitungPremiLayoutType.vertical,
                                      //   valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
                                      //   showValueBorder: true,
                                      //   formatNumber: true,
                                      // ),
                                      HitungPremiRow(
                                        // label: "TOTAL PREMI",
                                        label: "TOTAL TAGIHAN",
                                        controller: fieldTotalTagihanController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                    ],
                                  ),
                                  // buildFieldPremiNet(),
                                  // const SizedBox(height: hPadding),
                                  // buildFieldPremiDiskon(),
                                  // const SizedBox(height: hPadding),
                                  // buildFieldPremiSubtotal(),
                                ],
                              )
                            : const HitungPremiEmptyView(),
                      ),
                      const SizedBox(height: hPadding),
                      if (canShowLanjutkan) ...[
                        AppButton.primary(
                          text: _isLanjutkanLoading
                              ? "Memproses..."
                              : "Lanjutkan",
                          isLoading: _isLanjutkanLoading,
                          backgroundColor: pBlue,
                          onPressed: _isLanjutkanLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLanjutkanLoading = true;
                                  });

                                  _showGlobalLoading();

                                  try {
                                    draftForm1ToBloc(context);
                                    draftForm2ToBloc(context);
                                    draftForm3ToBloc(context);

                                    context
                                        .read<RegmvFlowBloc>()
                                        .add(RegmvFlowStartEvent());

                                    final saveReady =
                                        await _waitUntilRegmvFormsSaved();
                                    if (!mounted) return;

                                    if (!saveReady) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        errorSnackBar(
                                          "Data belum selesai disimpan, silahkan klik kembali.",
                                        ),
                                      );
                                      return;
                                    }

                                    _hideGlobalLoading();

                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KonfirmasiRegMvPage(
                                          recordId: regmv1Id ?? '',
                                          viewMode: 'ubah',
                                        ),
                                      ),
                                    );
                                  } finally {
                                    _hideGlobalLoading();

                                    if (mounted) {
                                      setState(() {
                                        _isLanjutkanLoading = false;
                                      });
                                    }
                                  }
                                },
                        ),
                      ],
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showValidationPreviewFloatingIcon)
            _buildValidationPreviewFloatingButton(),
        ],
      ),
    );
  }

  Future<bool> _waitUntilRegmvFormsSaved({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      if (_areRegmvFormsSaved()) return true;
      await Future.delayed(const Duration(milliseconds: 150));
    }

    return _areRegmvFormsSaved();
  }

  bool _areRegmvFormsSaved() {
    final s1 = context.read<Regmv1CrudBloc>().state;
    final s2 = context.read<Regmv2FormBloc>().state;
    final s3 = context.read<Regmv3FormBloc>().state;

    final f1 = s1.record;
    final f2 = s2.record;
    final f3 = s3.record;

    return f1 != null &&
        f2 != null &&
        f3 != null &&
        s1.isSaved &&
        s2.isSaved &&
        s3.isSaved &&
        !s1.hasFailure &&
        !s2.hasFailure &&
        !s3.hasFailure &&
        !s1.isSaving &&
        !s2.isSaving &&
        !s3.isSaving &&
        f1.regmv1Id.trim().isNotEmpty &&
        f2.regmv2Id.trim().isNotEmpty &&
        f3.regmv3Id.trim().isNotEmpty;
  }

  Widget _buildSectionContent({
    required Widget child,
    required bool isLoading,
    EdgeInsetsGeometry padding =
        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
  }) {
    return Padding(
      padding: padding,
      child: Stack(
        children: [
          child,
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: pGrey,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: LoadingIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget Form1Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 1",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form1,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              );
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form2Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 2",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form2,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              ); // untuk Form2
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form3Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 3",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form3,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              ); // untuk Form3
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form4Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 4",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form4,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              ); // untuk Form4
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              padding: const EdgeInsets.only(bottom: 15),
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form5Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 5",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form5,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              ); // untuk Form5
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              padding: const EdgeInsets.only(bottom: 15),
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form6Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 6",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form6,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              ); // untuk Form6
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form7Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
    bool showLoadingOnRefresh = false,
    String title = "Form 7",
  }) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(title, style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
            ),
            onTap: () {
              tryOpenSection(
                RegmvFormSection.form7,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              ); // untuk Form7
            },
          ),
          if (isExpanded)
            _buildSectionContent(
              padding: const EdgeInsets.only(bottom: 15),
              isLoading: isLoading,
              child: child,
            ),
        ],
      ),
    );
  }

  void draftForm1ToBloc(BuildContext context) {
    final record = Regmv1CrudModel(
      calmv1Id: widget.calmv1Id ?? "",
      regmv1Id: regmv1Id ?? "",
      ttgNama: fieldTtgNamaController.text,
      ttgAlamat: fieldTtgAlamatController.text,
    );

    context.read<Regmv1CrudBloc>().add(
          Regmv1DraftEvent(record: record),
        );
  }

  void draftForm2ToBloc(BuildContext context) {
    final polis = context.read<PolisTanggalBloc>().state;

    final record = Regmv2FormModel(
      isAw: toBoolean(fieldIsAwController.text),
      currId: fieldComboRMatauang?.rmatauangKode,
      comboRMatauang: fieldComboRMatauang,
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      // isTbod: toBoolean(fieldIsTbodController.text),
      isTbod: false,
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      comboMMvjnscover: fieldComboMMvjnscover,
      pad: double.tryParse(fieldPadController.text.replaceAll(',', '')) ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(',', '')) ?? 0,
      passangerCount: int.tryParse(selectedPassengerCount) ?? 0,
      pll: double.tryParse(fieldPllController.text.replaceAll(',', '')) ?? 0,
      polisMulai: polis.mulai,
      polisAkhir: polis.berakhir,
      regmv2Id: regmv1Id ?? "",
      tpl: double.tryParse(fieldTplController.text.replaceAll(',', '')) ?? 0,
      regmv1Id: regmv1Id ?? "",
    );

    context.read<Regmv2FormBloc>().add(Regmv2DraftEvent(record: record));
  }

  void draftForm3ToBloc(BuildContext context) {
    final record = Regmv3FormModel(
      regmv1Id: regmv1Id ?? "",
      aksesoris: fieldAksesorisController.text.trim(),
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
      regmv3Id: regmv1Id ?? "",
      thnBuat: int.parse(selectedYearform3),
    );
    context.read<Regmv3FormBloc>().add(Regmv3DraftEvent(record: record));
  }

  bool _isHitungPremiLoading = false;
  int _hitungPremiAttempt = 0;
  final RegmvValidationPreviewRepository _validationPreviewRepository =
      RegmvValidationPreviewRepository();
  RegmvValidationPreviewResponseModel? _lastValidationPreviewResponse;
  String? _lastValidationPreviewKey;
  bool _showValidationPreviewFloatingIcon = false;
  bool _isValidationPreviewDialogOpen = false;
  final Set<String> _validationPreviewFieldErrorKeys = <String>{};
  String? _lastCalculatedPremiKey;
  String? _lastBackendValidationKey;
  String? _lastBackendValidationError;
  RegmvFormSection? _lastBackendValidationSection;
  String? _lastBackendValidationFieldKey;
  List<String> _lastBackendValidationAffectedFieldKeys = const [];

  Widget buildButtonHitungPremi() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppButton.primary(
          text: _isHitungPremiLoading ? "Memproses..." : "Hitung Premi",
          isLoading: _isHitungPremiLoading,
          backgroundColor: _isHitungPremiLoading ? secondaryBlackColor : pBlue,
          onPressed: _isHitungPremiLoading
              ? null
              : () async {
                  await onHitungPremi();
                },
        ),
      );

  Future<void> onHitungPremi() async {
    final okForm1 = validateForm1();
    if (!okForm1) {
      openForm1(recordId: regmv1Id);
      return;
    }

    final okForm2 = validateForm2();
    if (!okForm2) {
      openForm2(recordId: regmv1Id);
      return;
    }

    final okForm3 = validateForm3();
    if (!okForm3) {
      openForm3(recordId: regmv1Id);
      return;
    }

    final stnkState = context.read<RegmvUploadStnkBloc>().state;
    final mobilState = context.read<RegmvUploadFotoMobilBloc>().state;
    final accState = context.read<RegmvUploadFotoAccBloc>().state;

    final okForm4 = stnkState.items.isNotEmpty;
    final okForm5 = mobilState.items.isNotEmpty;
    // final okForm7 = accState.items.isNotEmpty; //optional

    // if (!okForm4 || !okForm5 || !okForm7) {
    if (!okForm4 || !okForm5) {
      //opsional
      if (mounted) {
        setState(() {
          _isHitungPremiLoading = false;
          _showVal4 = !okForm4;
          _showVal5 = !okForm5;
          // _showVal7 = !okForm7;
          _showVal7 = false; //opsional
        });
      }

      if (!okForm4) {
        openForm4(recordId: regmv1Id);
      } else if (!okForm5) {
        openForm5(recordId: regmv1Id);
      }
      // else if (!okForm7) {
      //   openForm7(recordId: regmv1Id);
      // } //opsional

      return;
    }

    if (mounted) {
      setState(() {
        _isHitungPremiLoading = true;
      });
    }

    final canContinueByPreview = await _runValidationPreviewBeforeFlow();
    if (!mounted || !canContinueByPreview) return;

    if (_shouldReplayBackendValidation()) {
      _replayBackendValidation();
      return;
    }

    if (mounted) {
      setState(() {
        _isHitungPremiLoading = true;
      });
    }
    _startHitungPremiTimeout();

    final localIds4 = stnkState.items.map((e) => e.localId).toList();
    final localIds5 = mobilState.items.map((e) => e.localId).toList();
    final localIds7 = accState.items.map((e) => e.localId).toList();

    context.read<RegmvUploadStnkBloc>().add(
          Regmv4StorageUploadMany(
            regmv1Id: regmv1Id!,
            localIds: localIds4,
          ),
        );

    context.read<RegmvUploadFotoMobilBloc>().add(
          Regmv5StorageUploadMany(
            regmv1Id: regmv1Id!,
            localIds: localIds5,
          ),
        );

    if (localIds7.isNotEmpty) {
      context.read<RegmvUploadFotoAccBloc>().add(
            Regmv7StorageUploadMany(
              regmv1Id: regmv1Id!,
              localIds: localIds7,
            ),
          );
    }

    draftForm1ToBloc(context);
    draftForm2ToBloc(context);
    draftForm3ToBloc(context);

    context.read<RegmvFlowBloc>().add(RegmvFlowStartEvent());
  }

  Future<bool> _runValidationPreviewBeforeFlow() async {
    final previewKey = _currentBackendValidationKey();
    final cachedPreview = _lastValidationPreviewResponse;

    if (_lastValidationPreviewKey == previewKey &&
        cachedPreview != null &&
        cachedPreview.success &&
        cachedPreview.hasIssue &&
        cachedPreview.issues.any((issue) => issue.hasError)) {
      _applyValidationPreviewIssue(cachedPreview, previewKey);
      return false;
    }

    try {
      final response = await _validationPreviewRepository
          .check(
            _buildValidationPreviewRequest(),
          )
          .timeout(
            const Duration(seconds: 8),
            onTimeout: RegmvValidationPreviewResponseModel.failure,
          );

      if (!mounted) return false;

      if (!response.success) {
        debugPrint(
          '[REGMV VALIDATION PREVIEW] Technical failure, continue main flow.',
        );
        return true;
      }

      if (!response.hasIssue ||
          !response.issues.any((issue) => issue.hasError)) {
        _clearValidationPreviewState();
        return true;
      }

      _applyValidationPreviewIssue(response, previewKey);
      return false;
    } catch (e) {
      debugPrint(
        '[REGMV VALIDATION PREVIEW] Exception, continue main flow: $e',
      );
      return true;
    }
  }

  RegmvValidationPreviewRequestModel _buildValidationPreviewRequest() {
    final polis = context.read<PolisTanggalBloc>().state;

    return RegmvValidationPreviewRequestModel(
      regmv1Id: regmv1Id ?? '',
      polisMulai: polis.mulai,
      polisAkhir: polis.berakhir,
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      currId: fieldComboRMatauang?.rmatauangKode,
      isSrcc: toBoolean(fieldIsSrccController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isEq: toBoolean(fieldIsEqController.text),
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      isTbod: false,
      isAw: toBoolean(fieldIsAwController.text),
      tpl: _parseMoney(fieldTplController.text),
      pad: _parseMoney(fieldPadController.text),
      pap: _parseMoney(fieldPapController.text),
      pll: _parseMoney(fieldPllController.text),
      passangerCount: int.tryParse(selectedPassengerCount.trim()) ?? 0,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
      platNo: fieldPlatNoController.text.trim(),
      mmvmerkId: fieldComboMMvmerk?.mmvmerkId,
      mmvtipeId: fieldComboMMvtipe?.mmvtipeId,
      mmvmodelId: fieldComboMMvmodel?.mmvmodelId,
      mwarnaId: fieldComboMWarna?.mwarnaId,
      thnBuat: int.tryParse(selectedYearform3.trim()) ?? 0,
      mmvpakaiId: fieldComboMMvpakai?.mmvpakaiId,
      harga: _parseMoney(fieldHargaController.text),
    );
  }

  double _parseMoney(String value) {
    return double.tryParse(_cleanNumberText(value)) ?? 0;
  }

  void _applyValidationPreviewIssue(
    RegmvValidationPreviewResponseModel response,
    String previewKey,
  ) {
    final issues = response.issues
        .where((issue) => issue.hasError && issue.message.trim().isNotEmpty)
        .toList();

    if (issues.isEmpty) return;

    final section = _sectionFromValidationPreviewIssues(issues);
    final idx = sectionIndex(section);

    setState(() {
      _hitungPremiAttempt++;
      _isHitungPremiLoading = false;
      _clearValidationPreviewData();

      _lastValidationPreviewResponse = response;
      _lastValidationPreviewKey = previewKey;
      _showValidationPreviewFloatingIcon = false;

      for (final issue in issues) {
        final fieldKey = _fieldKeyFromPreviewIssue(issue);
        _appendValidationPreviewFieldError(fieldKey, issue.message);
        _validationPreviewFieldErrorKeys.add(fieldKey);
      }

      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showValidationPreviewDialog(response);
    });
  }

  RegmvFormSection _sectionFromPreviewIssue(
    RegmvValidationPreviewIssueModel issue,
  ) {
    final section = issue.section.trim().toLowerCase();
    if (section == 'form2') return RegmvFormSection.form2;
    if (section == 'form3') return RegmvFormSection.form3;

    final fieldKey = issue.fieldKey.trim().toLowerCase();
    if (fieldKey.startsWith('form2.')) return RegmvFormSection.form2;
    if (fieldKey.startsWith('form3.')) return RegmvFormSection.form3;

    return RegmvFormSection.form3;
  }

  RegmvFormSection _sectionFromValidationPreviewIssues(
    List<RegmvValidationPreviewIssueModel> issues,
  ) {
    final hasForm2Issue = issues.any(
      (issue) => _sectionFromPreviewIssue(issue) == RegmvFormSection.form2,
    );

    if (hasForm2Issue) return RegmvFormSection.form2;

    return _sectionFromPreviewIssue(issues.first);
  }

  void _appendValidationPreviewFieldError(String fieldKey, String message) {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    final existing = fieldErrors[fieldKey]?.trim();
    if (existing == null || existing.isEmpty) {
      fieldErrors[fieldKey] = trimmedMessage;
      return;
    }

    if (existing.contains(trimmedMessage)) return;

    fieldErrors[fieldKey] = '$existing\n$trimmedMessage';
  }

  String _fieldKeyFromPreviewIssue(RegmvValidationPreviewIssueModel issue) {
    final code = issue.code.trim().toUpperCase();
    if (code == 'PRICE_LIST_NOT_FOUND' ||
        code == 'VEHICLE_YEAR_INVALID' ||
        code == 'EV_MAX_AGE_3') {
      return 'form3.tahun';
    }

    final fieldKey = issue.fieldKey.trim();
    if (fieldKey.isNotEmpty) return fieldKey;

    final section = _sectionFromPreviewIssue(issue);
    return section == RegmvFormSection.form2
        ? 'form2.general'
        : 'form3.general';
  }

  void _clearValidationPreviewForChangedField(String fieldKey) {
    if (_lastValidationPreviewResponse == null) return;
    if (!_isValidationPreviewFieldKey(fieldKey)) return;

    setState(() {
      _clearValidationPreviewChangedFields([fieldKey]);
    });
  }

  bool _isValidationPreviewFieldKey(String fieldKey) {
    return fieldKey.startsWith('form2.') || fieldKey.startsWith('form3.');
  }

  void _clearValidationPreviewChangedFields(Iterable<String> fieldKeys) {
    final keys = fieldKeys.where(_isValidationPreviewFieldKey).toSet();
    if (keys.isEmpty) return;

    for (final fieldKey in keys) {
      if (_validationPreviewFieldErrorKeys.remove(fieldKey)) {
        fieldErrors.remove(fieldKey);
      }
    }

    _lastValidationPreviewResponse = null;
    _lastValidationPreviewKey = null;
    _showValidationPreviewFloatingIcon = false;
  }

  void _clearValidationPreviewState() {
    if (!mounted) return;
    setState(() {
      _clearValidationPreviewData();
    });
  }

  void _clearValidationPreviewData() {
    for (final fieldKey in _validationPreviewFieldErrorKeys) {
      fieldErrors.remove(fieldKey);
    }
    _validationPreviewFieldErrorKeys.clear();
    _lastValidationPreviewResponse = null;
    _lastValidationPreviewKey = null;
    _showValidationPreviewFloatingIcon = false;
  }

  Future<void> _showValidationPreviewDialog(
    RegmvValidationPreviewResponseModel response,
  ) async {
    if (!mounted || _isValidationPreviewDialogOpen) return;

    setState(() {
      _showValidationPreviewFloatingIcon = false;
    });
    _isValidationPreviewDialogOpen = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) => _buildValidationPreviewDialog(response),
    );

    _isValidationPreviewDialogOpen = false;
    if (!mounted) return;

    final stillCurrentIssue = _lastValidationPreviewResponse != null &&
        _lastValidationPreviewKey == _currentBackendValidationKey();
    if (stillCurrentIssue) {
      setState(() {
        _showValidationPreviewFloatingIcon = true;
      });
    }
  }

  Widget _buildValidationPreviewFloatingButton() {
    final issueCount = _lastValidationPreviewResponse?.issues
            .where((issue) => issue.hasError)
            .length ??
        0;

    return Positioned(
      top: 12,
      left: 12,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              final response = _lastValidationPreviewResponse;
              if (response != null) {
                _showValidationPreviewDialog(response);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: pGrey,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: pRed),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: pRed, size: 20),
                  if (issueCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      issueCount.toString(),
                      style: bodyTextStyle(context, fontSize: 12).copyWith(
                        color: primaryLightColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationPreviewDialog(
    RegmvValidationPreviewResponseModel response,
  ) {
    final issues = response.issues.where((issue) => issue.hasError).toList();
    final vehicleLabel = response.vehicleLabel.trim();
    final maxDialogHeight = MediaQuery.of(context).size.height * 0.82;

    return Dialog(
      backgroundColor: pGrey,
      insetPadding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: sGrey),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxDialogHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Validasi Kendaraan',
                      style: bodyTextStyle(
                        context,
                        fontSize: getResponsiveFont(context, 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: primaryLightColor,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: hPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (vehicleLabel.isNotEmpty) ...[
                      Text(
                        vehicleLabel,
                        style: bodyTextStyle(context, fontSize: 16).copyWith(
                          color: primaryLightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'Data belum sesuai ketentuan asuransi. Sesuaikan field berikut sebelum hitung premi.',
                      style: bodyTextStyle(context, fontSize: 14).copyWith(
                        color: primaryLightColor.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: hPadding),
                    const Divider(height: 1),
                    const SizedBox(height: hPadding),
                    ..._buildValidationPreviewIssueCards(issues),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(hPadding),
              child: AppButton.primary(
                text: 'Mengerti',
                backgroundColor: pBlue,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildValidationPreviewIssueCards(
    List<RegmvValidationPreviewIssueModel> issues,
  ) {
    final widgets = <Widget>[];

    for (var i = 0; i < issues.length; i++) {
      widgets.add(_buildValidationPreviewIssueCard(issues[i]));

      if (i < issues.length - 1) {
        widgets.add(
          const SizedBox(height: 12),
        );
      }
    }

    return widgets;
  }

  Widget _buildValidationPreviewIssueCard(
    RegmvValidationPreviewIssueModel issue,
  ) {
    final details = _validationPreviewIssueDetails(issue);
    final suggestion = _validationPreviewSuggestion(issue);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: zRed.withOpacity(0.20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: SvgPicture.asset(
                  'assets/icons/bi_exclamation-circle.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(zRed, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  issue.message,
                  style: bodyTextStyle(context, fontSize: 15).copyWith(
                    color: primaryLightColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (suggestion.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              suggestion,
              style: bodyTextStyle(context, fontSize: 14).copyWith(
                color: primaryLightColor.withOpacity(0.92),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (details.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...details,
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _validationPreviewIssueDetails(
    RegmvValidationPreviewIssueModel issue,
  ) {
    final rows = <Widget>[];
    final code = issue.code.trim().toUpperCase();
    final isPriceRange = code == 'PRICE_OUT_OF_RANGE';
    final isYearIssue = code == 'PRICE_LIST_NOT_FOUND' ||
        code == 'VEHICLE_YEAR_INVALID' ||
        code == 'EV_MAX_AGE_3';

    if (issue.expectedText.trim().isNotEmpty) {
      rows.add(_buildValidationPreviewDetailRow(
        isYearIssue
            ? 'Tahun tersedia'
            : isPriceRange
                ? 'Referensi harga'
                : 'Nilai disarankan',
        issue.expectedText.trim(),
      ));
    }

    if (issue.minValue.trim().isNotEmpty || issue.maxValue.trim().isNotEmpty) {
      rows.add(_buildValidationPreviewDetailRow(
        isPriceRange ? 'Batas Harga' : 'Tahun Berlaku',
        isPriceRange
            ? '${_formatValidationIdr(issue.minValue)} - ${_formatValidationIdr(issue.maxValue)}'
            : '${issue.minValue.trim()} - ${issue.maxValue.trim()}',
      ));
    }

    return rows;
  }

  String _validationPreviewSuggestion(RegmvValidationPreviewIssueModel issue) {
    final code = issue.code.trim().toUpperCase();
    if (code == 'PRICE_OUT_OF_RANGE' &&
        issue.minValue.trim().isNotEmpty &&
        issue.maxValue.trim().isNotEmpty) {
      final reference = issue.expectedText.trim();
      final prefix = reference.isNotEmpty ? '$reference. ' : '';
      return '${prefix}Gunakan harga antara ${_formatValidationIdr(issue.minValue)} sampai ${_formatValidationIdr(issue.maxValue)}.';
    }

    return issue.suggestion.trim();
  }

  Widget _buildValidationPreviewDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: bodyTextStyle(context, fontSize: 13).copyWith(
                color: primaryLightColor.withOpacity(0.7),
              ),
            ),
            TextSpan(
              text: value,
              style: bodyTextStyle(context, fontSize: 13).copyWith(
                color: primaryLightColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValidationIdr(String value) {
    final clean = _cleanNumberText(value);
    final number = double.tryParse(clean);
    if (number == null) return value.trim();
    return 'IDR ${NumberFormat.decimalPattern('id_ID').format(number)}';
  }

  void _startHitungPremiTimeout() {
    final attempt = ++_hitungPremiAttempt;
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted ||
          attempt != _hitungPremiAttempt ||
          !_isHitungPremiLoading) {
        return;
      }

      setState(() {
        _isHitungPremiLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          "Terjadi kesalahan dalam pengiriman data, silahkan klik kembali.",
        ),
      );
    });
  }

  bool _shouldReplayBackendValidation() {
    final key = _lastBackendValidationKey;
    if (key == null || _lastBackendValidationError == null) return false;
    return key == _currentBackendValidationKey();
  }

  void _replayBackendValidation() {
    final section = _lastBackendValidationSection;
    final fieldKey = _lastBackendValidationFieldKey;
    final message = _lastBackendValidationError;
    if (section == null || fieldKey == null || message == null) return;

    final idx = sectionIndex(section);
    setState(() {
      _isHitungPremiLoading = false;
      fieldErrors[fieldKey] = message;
      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;
    });
  }

  void _handleBackendSaveFailure({
    required String source,
    required String message,
    required String kind,
  }) {
    if (!mounted) return;

    _hitungPremiAttempt++;
    final trimmedMessage = message.trim();

    if (kind == 'validation' && trimmedMessage.isNotEmpty) {
      _applyBackendValidation(source: source, message: trimmedMessage);
      return;
    }

    setState(() {
      _isHitungPremiLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      errorSnackBar(
        trimmedMessage.isNotEmpty
            ? trimmedMessage
            : "Terjadi kesalahan dalam pengiriman data, silahkan klik kembali.",
      ),
    );
  }

  void _applyBackendValidation({
    required String source,
    required String message,
  }) {
    final target = _mapBackendValidationTarget(source, message);
    final idx = sectionIndex(target.section);

    setState(() {
      _isHitungPremiLoading = false;
      fieldErrors[target.fieldKey] = message;
      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;

      _lastBackendValidationKey = _currentBackendValidationKey();
      _lastBackendValidationError = message;
      _lastBackendValidationSection = target.section;
      _lastBackendValidationFieldKey = target.fieldKey;
      _lastBackendValidationAffectedFieldKeys = target.affectedFieldKeys;
    });
  }

  _RegmvBackendValidationTarget _mapBackendValidationTarget(
    String source,
    String message,
  ) {
    if (source == 'regmv2') {
      if (message.contains('Jenis Coverage')) {
        return const _RegmvBackendValidationTarget(
          section: RegmvFormSection.form2,
          fieldKey: 'form2.jenisCover',
          affectedFieldKeys: ['form2.jenisCover'],
        );
      }
      if (message.contains('Mata Uang')) {
        return const _RegmvBackendValidationTarget(
          section: RegmvFormSection.form2,
          fieldKey: 'form2.mataUang',
          affectedFieldKeys: ['form2.mataUang'],
        );
      }
      if (message.contains('Jumlah Penumpang')) {
        return const _RegmvBackendValidationTarget(
          section: RegmvFormSection.form2,
          fieldKey: 'form2.passengerCount',
          affectedFieldKeys: ['form2.passengerCount'],
        );
      }
      if (message.contains('Pilihan perluasan jaminan')) {
        return const _RegmvBackendValidationTarget(
          section: RegmvFormSection.form2,
          fieldKey: 'form2.general',
          affectedFieldKeys: [
            'form2.isSrcc',
            'form2.isFlood',
            'form2.isEq',
            'form2.isTerrorism',
          ],
        );
      }
      if (message.contains('TPL/PAD/PAP/PLL')) {
        return const _RegmvBackendValidationTarget(
          section: RegmvFormSection.form2,
          fieldKey: 'form2.tpl',
          affectedFieldKeys: [
            'form2.tpl',
            'form2.pad',
            'form2.pap',
            'form2.pll',
          ],
        );
      }
      if (message.contains('Tanggal') ||
          message.contains('Periode Polis') ||
          message.contains('Backdate')) {
        return const _RegmvBackendValidationTarget(
          section: RegmvFormSection.form2,
          fieldKey: 'form2.general',
          affectedFieldKeys: ['form2.polisMulai', 'form2.polisAkhir'],
        );
      }

      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form2,
        fieldKey: 'form2.general',
        affectedFieldKeys: [
          'form2.mataUang',
          'form2.jenisCover',
          'form2.passengerCount',
          'form2.tpl',
          'form2.pad',
          'form2.pap',
          'form2.pll',
          'form2.isSrcc',
          'form2.isFlood',
          'form2.isEq',
          'form2.isTerrorism',
          'form2.isAw',
        ],
      );
    }

    if (message ==
        'Kendaraan Motor hanya dapat menggunakan jaminan Total Loss Only!') {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form2,
        fieldKey: 'form2.jenisCover',
        affectedFieldKeys: [
          'form2.jenisCover',
          'form3.merek',
          'form3.model',
          'form3.subModel',
        ],
      );
    }
    if (message ==
        'Jaminan Authorized Workshop hanya berlaku untuk usia kendaraan maksimal 15 tahun!') {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form2,
        fieldKey: 'form2.isAw',
        affectedFieldKeys: [
          'form2.isAw',
          'form3.tahun',
          'form3.merek',
          'form3.model',
          'form3.subModel',
        ],
      );
    }
    if (message ==
        'Maksimal usia Kendaraan Listrik (Mobil/Motor) adalah 3 tahun!') {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.tahun',
        affectedFieldKeys: [
          'form3.tahun',
          'form3.merek',
          'form3.model',
          'form3.subModel',
        ],
      );
    }
    if (message.contains('Harga Kendaraan')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.hargaMobil',
        affectedFieldKeys: [
          'form3.hargaMobil',
          'form3.tahun',
          'form3.merek',
          'form3.model',
          'form3.subModel',
        ],
      );
    }
    if (message.contains('Wilayah')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.wilayah',
        affectedFieldKeys: ['form3.wilayah'],
      );
    }
    if (message.contains('Plat')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.platNo',
        affectedFieldKeys: ['form3.platNo'],
      );
    }
    if (message.contains('Mesin')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.mesinNo',
        affectedFieldKeys: ['form3.mesinNo'],
      );
    }
    if (message.contains('Rangka')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.rangkaNo',
        affectedFieldKeys: ['form3.rangkaNo'],
      );
    }
    if (message.contains('Merk')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.merek',
        affectedFieldKeys: ['form3.merek', 'form3.model', 'form3.subModel'],
      );
    }
    if (message.contains('Tipe')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.model',
        affectedFieldKeys: ['form3.merek', 'form3.model', 'form3.subModel'],
      );
    }
    if (message.contains('Model')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.subModel',
        affectedFieldKeys: ['form3.merek', 'form3.model', 'form3.subModel'],
      );
    }
    if (message.contains('Warna')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.warna',
        affectedFieldKeys: ['form3.warna'],
      );
    }
    if (message.contains('Penggunaan')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.penggunaan',
        affectedFieldKeys: ['form3.penggunaan'],
      );
    }
    if (message.contains('Tahun')) {
      return const _RegmvBackendValidationTarget(
        section: RegmvFormSection.form3,
        fieldKey: 'form3.tahun',
        affectedFieldKeys: ['form3.tahun'],
      );
    }

    return const _RegmvBackendValidationTarget(
      section: RegmvFormSection.form3,
      fieldKey: 'form3.general',
      affectedFieldKeys: [
        'form3.tahun',
        'form3.hargaMobil',
        'form3.wilayah',
        'form3.platNo',
        'form3.rangkaNo',
        'form3.mesinNo',
        'form3.merek',
        'form3.model',
        'form3.subModel',
        'form3.penggunaan',
        'form3.warna',
      ],
    );
  }

  String _currentBackendValidationKey() {
    final polis = context.read<PolisTanggalBloc>().state;
    final values = <String>[
      regmv1Id ?? '',
      polis.mulai.toIso8601String(),
      polis.berakhir.toIso8601String(),
      fieldComboRMatauang?.rmatauangKode ?? '',
      fieldComboMMvjnscover?.mmvjnscoverId ?? '',
      toBoolean(fieldIsSrccController.text).toString(),
      toBoolean(fieldIsFloodController.text).toString(),
      toBoolean(fieldIsEqController.text).toString(),
      toBoolean(fieldIsTerrorismController.text).toString(),
      false.toString(),
      toBoolean(fieldIsAwController.text).toString(),
      _cleanNumberText(fieldTplController.text),
      _cleanNumberText(fieldPadController.text),
      _cleanNumberText(fieldPapController.text),
      _cleanNumberText(fieldPllController.text),
      selectedPassengerCount.trim(),
      fieldComboMWilayah?.mwilayahId ?? '',
      fieldPlatNoController.text.trim().toUpperCase(),
      fieldMesinNoController.text.trim().toUpperCase(),
      fieldRangkaNoController.text.trim().toUpperCase(),
      fieldComboMMvmerk?.mmvmerkId ?? '',
      fieldComboMMvtipe?.mmvtipeId ?? '',
      fieldComboMMvmodel?.mmvmodelId ?? '',
      fieldComboMWarna?.mwarnaId ?? '',
      selectedYearform3.trim(),
      fieldComboMMvpakai?.mmvpakaiId ?? '',
      _cleanNumberText(fieldHargaController.text),
    ];

    return values.map(_keyPart).join('|');
  }

  bool _isCalculatedPremiCurrent() {
    final calculatedKey = _lastCalculatedPremiKey;
    return calculatedKey != null && calculatedKey == _currentPremiInputKey();
  }

  void _refreshPremiSnapshotVisibility() {
    if (!mounted || _lastCalculatedPremiKey == null) return;
    setState(() {});
  }

  String _currentPremiInputKey() {
    final values = <String>[
      _currentBackendValidationKey(),
      fieldCalmv1IdController.text.trim(),
      fieldTtgNamaController.text.trim(),
      fieldTtgAlamatController.text.trim(),
      fieldAksesorisController.text.trim(),
      _uploadItemsKey(context.read<RegmvUploadStnkBloc>().state.items),
      _uploadItemsKey(context.read<RegmvUploadFotoMobilBloc>().state.items),
      _uploadItemsKey(context.read<RegmvUploadFotoAccBloc>().state.items),
    ];

    return values.map(_keyPart).join('|');
  }

  String _uploadItemsKey(Iterable<dynamic> items) {
    final values = items.map((dynamic item) {
      final size = item.size;
      return <String>[
        item.localId?.toString() ?? '',
        item.name?.toString() ?? '',
        item.path?.toString() ?? '',
        size == null ? '' : size.toString(),
        item.mime?.toString() ?? '',
      ].map(_keyPart).join('~');
    }).toList()
      ..sort();

    return values.join(',');
  }

  String _keyPart(String value) =>
      value.replaceAll('|', '/').replaceAll('\n', ' ').trim();

  String _cleanNumberText(String value) => value.replaceAll(',', '').trim();

  void _clearBackendValidationForChangedField(String fieldKey) {
    if (!_lastBackendValidationAffectedFieldKeys.contains(fieldKey)) return;
    setState(() {
      _clearBackendValidationCacheIfAffected(fieldKey);
    });
  }

  void _clearBackendValidationCacheIfAffected(String fieldKey) {
    if (!_lastBackendValidationAffectedFieldKeys.contains(fieldKey)) return;

    final lastFieldKey = _lastBackendValidationFieldKey;
    if (lastFieldKey != null) {
      fieldErrors.remove(lastFieldKey);
    }

    _lastBackendValidationKey = null;
    _lastBackendValidationError = null;
    _lastBackendValidationSection = null;
    _lastBackendValidationFieldKey = null;
    _lastBackendValidationAffectedFieldKeys = const [];
  }

  bool _canRefreshRecord(String? recordId) =>
      recordId != null && recordId.isNotEmpty;

  void openForm1({required String? recordId}) => openSection(
        RegmvFormSection.form1,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm1(recordId: recordId),
      );

  void openForm2({required String? recordId}) => openSection(
        RegmvFormSection.form2,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm2(recordId: recordId),
      );

  void openForm3({required String? recordId}) => openSection(
        RegmvFormSection.form3,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm3(recordId: recordId),
      );

  void openForm4({required String? recordId}) => openSection(
        RegmvFormSection.form4,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm4(recordId: recordId),
      );

  void openForm5({required String? recordId}) => openSection(
        RegmvFormSection.form5,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm5(recordId: recordId),
      );

  void openForm6({required String? recordId}) => openSection(
        RegmvFormSection.form6,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm6(recordId: recordId),
      );

  void openPremiSection({required String? recordId}) => openSection(
        RegmvFormSection.form6,
        showLoading: _canRefreshRecord(recordId) &&
            context.read<Regmv6FormBloc>().state.record == null,
        onRefresh: () {
          final st = context.read<Regmv6FormBloc>().state;
          if (st.record == null) {
            refreshForm6(recordId: recordId);
          }
        },
      );

  void openForm7({required String? recordId}) => openSection(
        RegmvFormSection.form7,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm7(recordId: recordId),
      );

  bool validateForm1() {
    clearErrsByPrefix('form1.');

    bool ok = true;

    // No Registrasi (meskipun disabled, tetap wajib ada value)
    // final sppa = fieldCalmv1IdController.text.trim();
    // if (sppa.isEmpty) {
    //   setErr('form1.noRegistrasi', kStringNullError);
    //   ok = false;
    // }

    // Nama Tertanggung
    final nama = fieldTtgNamaController.text.trim();
    if (nama.isEmpty) {
      setErr('form1.namaTertanggung', kStringNullError);
      ok = false;
    }

    // Alamat Tertanggung
    final alamat = fieldTtgAlamatController.text.trim();
    if (alamat.isEmpty) {
      setErr('form1.alamatTertanggung', kStringNullError);
      ok = false;
    }

    if (!ok) {
      setState(() => expanded[0] = true);
    }

    return ok;
  }

  bool hasLeadingZero(String raw) {
    return raw.length > 1 && raw.startsWith('0');
  }

  bool validateForm2() {
    clearErrsByPrefix('form2.');
    bool ok = true;

    if (fieldComboRMatauang == null) {
      setErr('form2.mataUang', kStringNullError);
      ok = false;
    }

    if (fieldComboMMvjnscover == null) {
      setErr('form2.jenisCover', kStringNullError);
      ok = false;
    }

    if (selectedPassengerCount.trim().isEmpty) {
      setErr('form2.passengerCount', kStringNullError);
      ok = false;
    }

    final tplRaw = fieldTplController.text.trim();
    if (tplRaw.isNotEmpty) {
      final clean = tplRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null) {
        setErr('form2.tpl', "Format tidak valid");
        ok = false;
      } else if (angka < 0) {
        setErr('form2.tpl', "Tidak boleh minus");
        ok = false;
      }
      if (hasLeadingZero(clean)) {
        setErr('form2.tpl', "Format tidak disarankan (diawali 0)");
      }
    }

    final padRaw = fieldPadController.text.trim();
    if (padRaw.isNotEmpty) {
      final clean = padRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null) {
        setErr('form2.pad', "Format tidak valid");
        ok = false;
      } else if (angka < 0) {
        setErr('form2.pad', "Tidak boleh minus");
        ok = false;
      }
      if (hasLeadingZero(clean)) {
        setErr('form2.pad', "Format tidak disarankan (diawali 0)");
      }
    }

    final papRaw = fieldPapController.text.trim();
    if (papRaw.isNotEmpty) {
      final clean = papRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null) {
        setErr('form2.pap', "Format tidak valid");
        ok = false;
      } else if (angka < 0) {
        setErr('form2.pap', "Tidak boleh minus");
        ok = false;
      }
      if (hasLeadingZero(clean)) {
        setErr('form2.pap', "Format tidak disarankan (diawali 0)");
      }
    }

    // PLL (optional, >= 0)
    final pllRaw = fieldPllController.text.trim();
    if (pllRaw.isNotEmpty) {
      final clean = pllRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null) {
        setErr('form2.pll', "Format tidak valid");
        ok = false;
      } else if (angka < 0) {
        setErr('form2.pll', "Tidak boleh minus");
        ok = false;
      }
      if (hasLeadingZero(clean)) {
        setErr('form2.pll', "Format tidak disarankan (diawali 0)");
      }
    }

    if (!ok) {
      setState(() => expanded[1] = true);
    }

    return ok;
  }

  bool validateForm3() {
    clearErrsByPrefix('form3.');
    bool ok = true;

    // Tahun Pembuatan (required)
    if (selectedYearform3.trim().isEmpty) {
      setErr('form3.tahun', kStringNullError);
      ok = false;
    }

    // Harga Mobil (required, > 0)
    final hargaRaw = fieldHargaController.text.trim();
    if (hargaRaw.isEmpty) {
      setErr('form3.hargaMobil', kStringNullError);
      ok = false;
    } else {
      final clean = hargaRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) {
        setErr('form3.hargaMobil', kString0);
        ok = false;
      }
    }

    // Wilayah (required)
    if (fieldComboMWilayah == null) {
      setErr('form3.wilayah', kStringNullError);
      ok = false;
    }

    // No Polisi (required, format: B 1234 CD)
    final platRaw = fieldPlatNoController.text.trim();
    if (platRaw.isEmpty) {
      setErr('form3.platNo', kStringNullError);
      ok = false;
    } else if (!_isValidPlatNomor(platRaw)) {
      setErr('form3.platNo', "Format No Plat tidak valid");
      ok = false;
    }

    // No Rangka (required, min 5)
    final rangkaRaw = fieldRangkaNoController.text.trim();
    if (rangkaRaw.isEmpty) {
      setErr('form3.rangkaNo', kStringNullError);
      ok = false;
    } else {
      if (rangkaRaw.length < 5) {
        setErr('form3.rangkaNo', "Nomor rangka terlalu pendek");
        ok = false;
      }
    }

    // No Mesin (required, min 5)
    final mesinRaw = fieldMesinNoController.text.trim();
    if (mesinRaw.isEmpty) {
      setErr('form3.mesinNo', kStringNullError);
      ok = false;
    } else {
      if (mesinRaw.length < 5) {
        setErr('form3.mesinNo', "Nomor Mesin terlalu pendek");
        ok = false;
      }
    }

    // Merek (required)
    if (fieldComboMMvmerk == null) {
      setErr('form3.merek', kStringNullError);
      ok = false;
    }

    // Model / Tipe (required)
    if (fieldComboMMvtipe == null) {
      setErr('form3.model', kStringNullError);
      ok = false;
    }

    // Sub Model (required)
    if (fieldComboMMvmodel == null) {
      setErr('form3.subModel', kStringNullError);
      ok = false;
    }

    // Penggunaan (required)
    if (fieldComboMMvpakai == null) {
      setErr('form3.penggunaan', kStringNullError);
      ok = false;
    }

    // Warna (required)
    if (fieldComboMWarna == null) {
      setErr('form3.warna', kStringNullError);
      ok = false;
    }

    String aksesorisRaw = fieldAksesorisController.text.trim();
    if (aksesorisRaw.isEmpty) {
      aksesorisRaw = '';
      fieldAksesorisController.text = aksesorisRaw;
    }

    if (!ok) {
      setState(() => expanded[2] = true);
    }

    return ok;
  }

  bool _isValidPlatNomor(String value) {
    return RegExp(r'^[A-Z]{1,2} [0-9]{1,4} [A-Z]{1,3}$')
        .hasMatch(value.trim().toUpperCase());
  }

  bool validateForm7() {
    clearErrsByPrefix('form7.');
    bool ok = true;

    // Diskon Persen (required, angka valid)
    final diskonRaw = fieldDiskonPersenController.text.trim();
    if (diskonRaw.isEmpty) {
      setErr('form7.diskonPersen', kStringNullError);
      ok = false;
    } else {
      final clean = diskonRaw.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null) {
        setErr('form7.diskonPersen', "Format tidak valid");
        ok = false;
      }
    }

    // Premi Add
    final addRaw = fieldPremiAddController.text.trim();
    if (addRaw.isEmpty) {
      setErr('form7.premiAdd', kStringNullError);
      ok = false;
    } else {
      final clean = addRaw.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null) {
        setErr('form7.premiAdd', "Format tidak valid");
        ok = false;
      }
    }

    // Premi Casco
    final cascoRaw = fieldPremiCascoController.text.trim();
    if (cascoRaw.isEmpty) {
      setErr('form7.premiCasco', kStringNullError);
      ok = false;
    } else {
      final clean = cascoRaw.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null) {
        setErr('form7.premiCasco', "Format tidak valid");
        ok = false;
      }
    }

    // Premi Diskon
    final diskonPremiRaw = fieldPremiDiskonController.text.trim();
    if (diskonPremiRaw.isEmpty) {
      setErr('form7.premiDiskon', kStringNullError);
      ok = false;
    } else {
      final clean = diskonPremiRaw.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null) {
        setErr('form7.premiDiskon', "Format tidak valid");
        ok = false;
      }
    }

    // Premi Net
    final netRaw = fieldPremiNetController.text.trim();
    if (netRaw.isEmpty) {
      setErr('form7.premiNet', kStringNullError);
      ok = false;
    } else {
      final clean = netRaw.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null) {
        setErr('form7.premiNet', "Format tidak valid");
        ok = false;
      }
    }

    // Premi Subtotal
    final subRaw = fieldPremiSubtotalController.text.trim();
    if (subRaw.isEmpty) {
      setErr('form7.premiSubtotal', kStringNullError);
      ok = false;
    } else {
      final clean = subRaw.replaceAll(",", "");
      final x = double.tryParse(clean);
      if (x == null) {
        setErr('form7.premiSubtotal', "Format tidak valid");
        ok = false;
      }
    }

    // kalau gagal buka panel form7 (index 6, karena 0..6)
    if (!ok) {
      setState(() => expanded[6] = true);
    }

    return ok;
  }

  //form1
  Widget buildFieldCalmv1Id() => appTextField(
        label: "No Registrasi",
        controller: fieldCalmv1IdController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
        ],
        enabled: false,
        errorText: err('form1.noRegistrasi'),
        validator: (_) => err('form1.noRegistrasi'),
      );

  Widget buildFieldTtgAlamat() => appTextField(
        label: "Alamat Tertanggung",
        controller: fieldTtgAlamatController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z ,./\-#()]")),
        ],
        errorText: err('form1.alamatTertanggung'),
        validator: (_) => err('form1.alamatTertanggung'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('form1.alamatTertanggung');
        },
      );

  Widget buildFieldTtgNama() => appTextField(
        label: "Nama Tertanggung",
        controller: fieldTtgNamaController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z ,.]")),
        ],
        errorText: err('form1.namaTertanggung'),
        validator: (_) => err('form1.namaTertanggung'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('form1.namaTertanggung');
        },
      );
  //form1

  //form2
  Widget buildFieldPolisMulai() {
    return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
      buildWhen: (prev, curr) => prev.mulai != curr.mulai,
      builder: (context, state) {
        final today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        return AppDateField(
          label: 'Tanggal Mulai',
          initialValue: state.mulai,
          firstDate: today,
          lastDate: DateTime(2100),
          validator: (_) => null,
          onChanged: (dt) {
            if (dt == null) return;
            _clearBackendValidationForChangedField('form2.polisMulai');
            _clearValidationPreviewForChangedField('form2.polisMulai');
            context
                .read<PolisTanggalBloc>()
                .add(PolisMulaiChanged(dt)); // <- trigger event aja
          },
        );
      },
    );
  }

  Widget buildFieldPolisBerakhir() {
    return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
      buildWhen: (prev, curr) => prev.berakhir != curr.berakhir,
      builder: (context, state) {
        return AppDateField(
          key: ValueKey(state.berakhir.toIso8601String()),
          label: 'Tanggal Berakhir',
          enabled: false,
          initialValue: state.berakhir,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          validator: (_) => null,
          onChanged: (_) {},
        );
      },
    );
  }

  Widget _buildComboCurddId() => ReusableComboBoxV2<ComboRMatauangModel>(
        hintText: "Mata Uang",
        initItem: fieldComboRMatauang,
        loader: (q) => ComboRMatauangRepository().getComboRMatauang(),
        clientSideSearch: true,
        displayText: (item) => item.rmatauangSimbol,
        compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.mataUang'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboRMatauang = v;
            _defaultCurrencyApplied = false;
            _clearValidationPreviewChangedFields(['form2.mataUang']);
            _clearBackendValidationCacheIfAffected('form2.mataUang');
            if (v != null) clearErr('form2.mataUang');
          });
        },
        onSaveCallback: (value) => fieldComboRMatauang = value,
      );

  Widget _buildComboMMvjnscover() => ReusableComboBoxV2<ComboMMvjnscoverModel>(
        hintText: "Jenis Jaminan",
        initItem: fieldComboMMvjnscover,
        loader: (q) => ComboMMvjnscoverRepository().getComboMMvjnscover(),
        clientSideSearch: true,
        displayText: (i) => i.coverName,
        compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.jenisCover'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMMvjnscover = v;
            _clearValidationPreviewChangedFields(['form2.jenisCover']);
            _clearBackendValidationCacheIfAffected('form2.jenisCover');
            if (v != null) clearErr('form2.jenisCover');
          });
        },
        onSaveCallback: (value) => fieldComboMMvjnscover = value,
      );

  Widget _buildFieldIsEq() => CheckboxWidget(
        rightLabel: "Gempa Bumi",
        initialValue: toBoolean(fieldIsEqController.text),
        callback: (v) {
          fieldIsEqController.text = v.toString();
          _clearBackendValidationForChangedField('form2.isEq');
          _clearValidationPreviewForChangedField('form2.isEq');
        },
        leftLabel: "",
      );

  Widget _buildFieldIsFlood() => CheckboxWidget(
        rightLabel: "Banjir",
        initialValue: toBoolean(fieldIsFloodController.text),
        callback: (v) {
          fieldIsFloodController.text = v.toString();
          _clearBackendValidationForChangedField('form2.isFlood');
          _clearValidationPreviewForChangedField('form2.isFlood');
        },
        leftLabel: "",
      );

  Widget _buildFieldIsSrcc() => CheckboxWidget(
        rightLabel: "Kerusuhan",
        initialValue: toBoolean(fieldIsSrccController.text),
        callback: (v) {
          fieldIsSrccController.text = v.toString();
          _clearBackendValidationForChangedField('form2.isSrcc');
          _clearValidationPreviewForChangedField('form2.isSrcc');
        },
        leftLabel: "",
      );

  Widget _buildFieldIsTbod() => CheckboxWidget(
        rightLabel: "Pencurian Barang oleh Supir",
        initialValue: toBoolean(fieldIsTbodController.text),
        callback: (v) {
          fieldIsTbodController.text = v.toString();
          _clearBackendValidationForChangedField('form2.isTbod');
          _clearValidationPreviewForChangedField('form2.isTbod');
        },
        leftLabel: "",
      );

  Widget _buildFieldIsTerrorism() => CheckboxWidget(
        rightLabel: "Terorisme",
        initialValue: toBoolean(fieldIsTerrorismController.text),
        callback: (v) {
          fieldIsTerrorismController.text = v.toString();
          _clearBackendValidationForChangedField('form2.isTerrorism');
          _clearValidationPreviewForChangedField('form2.isTerrorism');
        },
        leftLabel: "",
      );

  Widget _buildFieldIsAw() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxWidget(
          rightLabel: "Bengkel Resmi",
          initialValue: toBoolean(fieldIsAwController.text),
          callback: (v) {
            fieldIsAwController.text = v.toString();
            _clearBackendValidationForChangedField('form2.isAw');
            _clearValidationPreviewForChangedField('form2.isAw');
            clearErr('form2.isAw');
          },
          leftLabel: "",
        ),
        _buildFormError('form2.isAw'),
      ],
    );
  }

  Widget _buildFieldPLL() => appTextField(
        label: "Tanggung Jawab Penumpang",
        controller: fieldPllController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form2.pll'),
        validator: (v) {
          final backendError = err('form2.pll');
          if (backendError != null) return backendError;
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
        },
        onChanged: (v) {
          final clean = v.replaceAll(",", "").trim();
          final angka = double.tryParse(clean);
          if (angka != null && angka >= 0) clearErr('form2.pll');
          _clearBackendValidationForChangedField('form2.pll');
          _clearValidationPreviewForChangedField('form2.pll');
        },
      );

  Widget _buildFieldTPL() => appTextField(
        label: "Tanggung Jawab Pihak Ketiga",
        controller: fieldTplController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form2.tpl'),
        validator: (v) {
          final backendError = err('form2.tpl');
          if (backendError != null) return backendError;
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
        },
        onChanged: (v) {
          final clean = v.replaceAll(",", "").trim();
          final angka = double.tryParse(clean);
          if (angka != null && angka >= 0) clearErr('form2.tpl');
          _clearBackendValidationForChangedField('form2.tpl');
          _clearValidationPreviewForChangedField('form2.tpl');
        },
      );

  Widget _buildFieldPAD() => appTextField(
        label: "Kecelakaan Diri Pengemudi",
        controller: fieldPadController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form2.pad'),
        validator: (v) {
          final backendError = err('form2.pad');
          if (backendError != null) return backendError;
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
        },
        onChanged: (v) {
          final clean = v.replaceAll(",", "").trim();
          final angka = double.tryParse(clean);
          if (angka != null && angka >= 0) clearErr('form2.pad');
          _clearBackendValidationForChangedField('form2.pad');
          _clearValidationPreviewForChangedField('form2.pad');
        },
      );

  Widget _buildFieldPAP() => appTextField(
        label: "Kecelakaan Diri Penumpang",
        controller: fieldPapController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form2.pap'),
        validator: (v) {
          final backendError = err('form2.pap');
          if (backendError != null) return backendError;
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
        },
        onChanged: (v) {
          final clean = v.replaceAll(",", "").trim();
          final angka = double.tryParse(clean);
          if (angka != null && angka >= 0) clearErr('form2.pap');
          _clearBackendValidationForChangedField('form2.pap');
          _clearValidationPreviewForChangedField('form2.pap');
        },
      );
  Widget _buildFieldPassengerCountCombo() {
    final counts = List<String>.generate(7, (i) => (i + 1).toString());

    return ReusableComboBoxV2<String>(
      hintText: "Jumlah Penumpang",
      initItem:
          selectedPassengerCount.isNotEmpty ? selectedPassengerCount : null,
      clientSideSearch: true,
      loader: (q) async => counts,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,
      validatorCallback: (v) => v == null ? kStringNullError : null,
      errorText: err('form2.passengerCount'),
      onChangedCallback: (v) {
        setState(() {
          selectedPassengerCount = v ?? "";
          _clearValidationPreviewChangedFields(['form2.passengerCount']);
          _clearBackendValidationCacheIfAffected('form2.passengerCount');

          if (v != null) {
            clearErr('form2.passengerCount');
          }
        });
      },
      onSaveCallback: (value) {
        selectedPassengerCount = value ?? "";
      },
    );
  }

  //form2

  //form3
  Widget _buildFieldComboTahun() {
    final yearNow = DateTime.now().year;
    final years = List<String>.generate(
      yearNow - 1980 + 1,
      (i) => (yearNow - i).toString(),
    );

    return ReusableComboBoxV2<String>(
      hintText: "Tahun Pembuatan",
      initItem: selectedYearform3.isNotEmpty ? selectedYearform3 : null,
      clientSideSearch: true,
      loader: (q) async => years,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,
      validatorCallback: (v) => v == null ? kStringNullError : null,
      errorText: err('form3.tahun'),
      onChangedCallback: (value) {
        setState(() {
          selectedYearform3 = value ?? "";
          _clearValidationPreviewChangedFields([
            'form3.tahun',
            'form3.hargaMobil',
          ]);
          _clearBackendValidationCacheIfAffected('form3.tahun');
          if (value != null) {
            clearErr('form3.tahun');
          }
        });
      },
      onSaveCallback: (value) {
        selectedYearform3 = value ?? "";
      },
    );
  }

  Widget _buildHargaMobil() => appTextField(
        label: "Harga Kendaraan",
        controller: fieldHargaController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        errorText: err('form3.hargaMobil'),
        validator: (_) => err('form3.hargaMobil'),
        onChanged: (v) {
          final clean = v.replaceAll(",", "").trim();
          final angka = double.tryParse(clean);
          if (angka != null && angka > 0) clearErr('form3.hargaMobil');
          _clearBackendValidationForChangedField('form3.hargaMobil');
          _clearValidationPreviewForChangedField('form3.hargaMobil');
        },
      );

  Widget _buildComboMWilayah() => ReusableComboBoxV2<ComboMWilayahModel>(
        hintText: "Wilayah",
        initItem: fieldComboMWilayah,
        loader: (q) => ComboMWilayahRepository().getComboMWilayah(),
        clientSideSearch: true,
        displayText: (i) => i.wilayahNama,
        compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.wilayah'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMWilayah = v;
            _clearValidationPreviewChangedFields(['form3.wilayah']);
            _clearBackendValidationCacheIfAffected('form3.wilayah');

            if (v != null) {
              clearErr('form3.wilayah');
            }
          });
        },
        onSaveCallback: (value) => fieldComboMWilayah = value,
      );

  Widget _buildFieldPlatNo() => appTextField(
        label: "No Plat",
        controller: fieldPlatNoController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          PlatNomorFormatter(),
        ],
        errorText: err('form3.platNo'),
        validator: (_) => err('form3.platNo'),
        onChanged: (v) {
          if (_isValidPlatNomor(v)) {
            clearErr('form3.platNo');
          }
          _clearBackendValidationForChangedField('form3.platNo');
          _clearValidationPreviewForChangedField('form3.platNo');
        },
      );

  Widget _buildFieldRangkaNo() => appTextField(
        label: "No Rangka",
        controller: fieldRangkaNoController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          RangkaNoFormatter(),
        ],
        errorText: err('form3.rangkaNo'),
        validator: (_) => err('form3.rangkaNo'),
        onChanged: (v) {
          final t = v.trim();
          if (t.isNotEmpty && t.length >= 5) clearErr('form3.rangkaNo');
          _clearBackendValidationForChangedField('form3.rangkaNo');
          _clearValidationPreviewForChangedField('form3.rangkaNo');
        },
      );

  Widget _buildFieldMesinNo() => appTextField(
        label: "No Mesin",
        controller: fieldMesinNoController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          RangkaNoFormatter(),
        ],
        errorText: err('form3.mesinNo'),
        validator: (_) => err('form3.mesinNo'),
        onChanged: (v) {
          final t = v.trim();
          if (t.isNotEmpty && t.length >= 5) clearErr('form3.mesinNo');
          _clearBackendValidationForChangedField('form3.mesinNo');
          _clearValidationPreviewForChangedField('form3.mesinNo');
        },
      );

  Widget _buildFieldMmvmerkId() => ReusableComboBoxV2<ComboMMvmerkModel>(
        hintText: "Merek",
        comboKey: comboMMvmerkKey,
        initItem: fieldComboMMvmerk,
        loader: (q) => ComboMMvmerkRepository().getComboMMvmerk(q.searchText),
        displayText: (item) => item.nmMerk,
        compareItems: (a, b) => a.mmvmerkId == b.mmvmerkId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.merek'),
        onChangedCallback: (v) {
          debugPrint(
              "[MMVMERK] onChanged -> ${v == null ? 'NULL' : '${v.mmvmerkId} | ${v.nmMerk}'}");
          setState(() {
            fieldComboMMvmerk = v;
            fieldComboMMvtipe = null;
            fieldComboMMvmodel = null;
            _clearValidationPreviewChangedFields([
              'form3.merek',
              'form3.model',
              'form3.subModel',
              'form3.tahun',
              'form3.hargaMobil',
            ]);
            _clearBackendValidationCacheIfAffected('form3.merek');
            if (v != null) {
              clearErr('form3.merek');
              regmv3formbloc?.add(ComboMMvmerkChangedEvent(comboMMvmerk: v));
            }
          });
        },
        onSaveCallback: (value) => fieldComboMMvmerk = value,
      );

  Widget _buildComboTipeId() => ReusableComboBoxV2<ComboMMvtipeModel>(
        hintText: "Model",
        comboKey: comboMMvtipeKey,
        initItem: fieldComboMMvtipe,
        isEnabled: fieldComboMMvmerk != null,
        dependencyKey: fieldComboMMvmerk?.mmvmerkId,
        params: {
          "mmvmerkId": fieldComboMMvmerk?.mmvmerkId ?? "",
        },
        loader: (q) {
          final mmvmerkId = q.get<String>("mmvmerkId") ?? "";
          return ComboMMvtipeRepository().getComboMMvtipe(
            mmvmerkId,
            q.searchText,
          );
        },
        displayText: (item) => item.nmTipe,
        compareItems: (a, b) => a.mmvtipeId == b.mmvtipeId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.model'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMMvtipe = v;
            fieldComboMMvmodel = null;
            _clearValidationPreviewChangedFields([
              'form3.model',
              'form3.subModel',
              'form3.tahun',
              'form3.hargaMobil',
            ]);
            _clearBackendValidationCacheIfAffected('form3.model');
            if (v != null) {
              clearErr('form3.model');
              regmv3formbloc?.add(ComboMMvtipeChangedEvent(comboMMvtipe: v));
            }
          });
        },
        onSaveCallback: (value) => fieldComboMMvtipe = value,
      );

  Widget _buildFieldMmvmodelId() => ReusableComboBoxV2<ComboMMvmodelModel>(
        hintText: "Sub Model",
        comboKey: comboMMvmodelKey,
        initItem: fieldComboMMvmodel,
        isEnabled: fieldComboMMvtipe != null,
        dependencyKey: fieldComboMMvtipe?.mmvtipeId,
        params: {
          "mmvtipeId": fieldComboMMvtipe?.mmvtipeId ?? "",
        },
        loader: (q) {
          final mmvtipeId = q.get<String>("mmvtipeId") ?? "";
          return ComboMMvmodelRepository().getComboMMvmodel(
            mmvtipeId,
            q.searchText,
          );
        },
        displayText: (item) => item.nmModel,
        compareItems: (a, b) => a.mmvmodelId == b.mmvmodelId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.subModel'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMMvmodel = v;
            _clearValidationPreviewChangedFields([
              'form3.subModel',
              'form3.tahun',
              'form3.hargaMobil',
            ]);
            _clearBackendValidationCacheIfAffected('form3.subModel');
            if (v != null) {
              clearErr('form3.subModel');
              regmv3formbloc?.add(ComboMMvmodelChangedEvent(comboMMvmodel: v));
            }
          });
        },
        onSaveCallback: (value) => fieldComboMMvmodel = value,
      );

  Widget _buildFieldMmvsubmodelId() => ReusableComboBoxV2<ComboMMvpakaiModel>(
        hintText: "Penggunaan",
        comboKey: comboMMvpakaiKey,
        initItem: fieldComboMMvpakai,
        loader: (q) => ComboMMvpakaiRepository().getComboMMvpakai(),
        clientSideSearch: true,
        displayText: (i) => i.pakaiNama,
        compareItems: (a, b) => a.mmvpakaiId == b.mmvpakaiId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.penggunaan'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMMvpakai = v;
            _clearValidationPreviewChangedFields(['form3.penggunaan']);
            _clearBackendValidationCacheIfAffected('form3.penggunaan');
            if (v != null) {
              clearErr('form3.penggunaan');
              regmv3formbloc?.add(ComboMMvpakaiChangedEvent(comboMMvpakai: v));
            }
          });
        },
        onSaveCallback: (value) => fieldComboMMvpakai = value,
      );

  Widget _buildComboWarnaId() => ReusableComboBoxV2<ComboMWarnaModel>(
        hintText: "Warna",
        comboKey: comboMWarnaKey,
        initItem: fieldComboMWarna,
        loader: (q) => ComboMWarnaRepository().getComboMWarna(q.searchText),
        displayText: (i) => i.warnaDesc,
        compareItems: (a, b) => a.mwarnaId == b.mwarnaId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.warna'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMWarna = v;
            _clearValidationPreviewChangedFields(['form3.warna']);
            _clearBackendValidationCacheIfAffected('form3.warna');
            if (v != null) {
              clearErr('form3.warna');
              regmv3formbloc?.add(ComboMWarnaChangedEvent(comboMWarna: v));
            }
          });
        },
        onSaveCallback: (value) => fieldComboMWarna = value,
      );

  Widget _buildFieldAksesoris() => appTextField(
        label: "Aksesoris (opsional)",
        controller: fieldAksesorisController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
        ],
        errorText: err('form3.aksesoris'),
        validator: (_) => err('form3.aksesoris'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('form3.aksesoris');
        },
      );
  //form3

  //form6
  Widget buildFieldDiskonPersen() => appTextField(
        label: "diskonPersen",
        controller: fieldDiskonPersenController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        errorText: err('form7.diskonPersen'),
        validator: (_) => err('form7.diskonPersen'),
        onChanged: (value) {
          final clean = value.replaceAll(",", "").trim();
          final x = double.tryParse(clean);
          if (x != null) clearErr('form7.diskonPersen');
        },
      );

  Widget buildFieldPremiAdd() => appTextField(
        label: "premiAdd",
        controller: fieldPremiAddController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        errorText: err('form7.premiAdd'),
        validator: (_) => err('form7.premiAdd'),
        onChanged: (value) {
          final clean = value.replaceAll(",", "").trim();
          final x = double.tryParse(clean);
          if (x != null) clearErr('form7.premiAdd');
        },
      );

  Widget buildFieldPremiCasco() => appTextField(
        label: "premiCasco",
        controller: fieldPremiCascoController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        errorText: err('form7.premiCasco'),
        validator: (_) => err('form7.premiCasco'),
        onChanged: (value) {
          final clean = value.replaceAll(",", "").trim();
          final x = double.tryParse(clean);
          if (x != null) clearErr('form7.premiCasco');
        },
      );

  Widget buildFieldPremiDiskon() => appTextField(
        label: "premiDiskon",
        controller: fieldPremiDiskonController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        enabled: false,
        errorText: err('form7.premiDiskon'),
        validator: (_) => err('form7.premiDiskon'),
        onChanged: (value) {
          final clean = value.replaceAll(",", "").trim();
          final x = double.tryParse(clean);
          if (x != null) clearErr('form7.premiDiskon');
        },
      );

  Widget buildFieldPremiNet() => appTextField(
        label: "premiNet",
        controller: fieldPremiNetController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        enabled: false,
        errorText: err('form7.premiNet'),
        validator: (_) => err('form7.premiNet'),
        onChanged: (value) {
          final clean = value.replaceAll(",", "").trim();
          final x = double.tryParse(clean);
          if (x != null) clearErr('form7.premiNet');
        },
      );

  Widget buildFieldPremiSubtotal() => appTextField(
        label: "premiSubtotal",
        controller: fieldPremiSubtotalController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        enabled: false,
        errorText: err('form7.premiSubtotal'),
        validator: (_) => err('form7.premiSubtotal'),
        onChanged: (value) {
          final clean = value.replaceAll(",", "").trim();
          final x = double.tryParse(clean);
          if (x != null) clearErr('form7.premiSubtotal');
        },
      );
  //form6

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

  Widget _buildFormError(String key) {
    final message = err(key);
    if (message == null || message.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          message,
          style: bodyTextStyle(context, fontSize: 12).copyWith(color: pRed),
        ),
      ),
    );
  }

  double getProgressValue() {
    final done = [
      isForm1Complete(),
      isForm2Complete(),
      isForm3Complete(),
      isForm4Complete(),
      isForm5Complete(),
      isForm7Complete(),
      isForm6Complete(), // form premi (record sudah ada)
    ].where((x) => x).length;

    return done / 7;
  }

  bool isForm1Complete() {
    return fieldCalmv1IdController.text.trim().isNotEmpty &&
        fieldTtgNamaController.text.trim().isNotEmpty &&
        fieldTtgAlamatController.text.trim().isNotEmpty;
  }

  bool isForm2Complete() {
    // samakan dengan validateForm2 yang kamu mau:
    // minimal mata uang, jenis cover, passengerCount, dan (tpl/pad/pap/pll >= 0) + minimal salah satu >0 (kalau itu aturanmu)
    if (fieldComboRMatauang == null) return false;
    if (fieldComboMMvjnscover == null) return false;
    if (selectedPassengerCount.trim().isEmpty) return false;

    double n(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '').trim()) ?? 0;

    return true;
  }

  bool isForm3Complete() {
    final harga =
        double.tryParse(fieldHargaController.text.replaceAll(',', '').trim()) ??
            0;

    return selectedYearform3.trim().isNotEmpty &&
        harga > 0 &&
        fieldComboMWilayah != null &&
        _isValidPlatNomor(fieldPlatNoController.text) &&
        fieldRangkaNoController.text.trim().length >= 5 &&
        fieldMesinNoController.text.trim().length >= 5 &&
        fieldComboMMvmerk != null &&
        fieldComboMMvtipe != null &&
        fieldComboMMvmodel != null &&
        fieldComboMMvpakai != null &&
        fieldComboMWarna != null;
    //&& fieldAksesorisController.text.trim().isNotEmpty;
  }

  bool isForm4Complete() =>
      context.read<RegmvUploadStnkBloc>().state.items.isNotEmpty;
  bool isForm5Complete() =>
      context.read<RegmvUploadFotoMobilBloc>().state.items.isNotEmpty;
  // bool isForm7Complete() => context.read<RegmvUploadFotoAccBloc>().state.items.isNotEmpty;
  bool isForm7Complete() => true;
  // form6 = premi sudah terhitung
  bool isForm6Complete() =>
      _hasValidRegmv6Premium(context.read<Regmv6FormBloc>().state.record);

  bool validateOpenedForm() {
    final opened = getOpenedIndex();

    // ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦ Tidak ada section yang sedang terbuka (awal halaman)
    if (opened < 0) return true;

    // ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦ Guard tambahan kalau suatu saat index out of range
    if (opened >= RegmvFormSection.values.length) return true;

    final section = RegmvFormSection.values[opened];

    switch (section) {
      case RegmvFormSection.form1:
        return validateForm1();
      case RegmvFormSection.form2:
        return validateForm2();
      case RegmvFormSection.form3:
        return validateForm3();
      case RegmvFormSection.form4:
        final ok4 = context.read<RegmvUploadStnkBloc>().state.items.isNotEmpty;
        if (!ok4) {
          setState(() => _showVal4 = true);
        }
        return ok4;
      case RegmvFormSection.form5:
        final ok5 =
            context.read<RegmvUploadFotoMobilBloc>().state.items.isNotEmpty;
        if (!ok5) {
          setState(() => _showVal5 = true);
        }
        return ok5;
      // case RegmvFormSection.form7: return context.read<RegmvUploadFotoAccBloc>().state.items.isNotEmpty;
      case RegmvFormSection.form7:
        return true; //opsional
      case RegmvFormSection.form6:
        return true;
    }
  }

  void openSection(
    RegmvFormSection section, {
    VoidCallback? onRefresh,
    bool showLoading = false,
  }) {
    final idx = sectionIndex(section);

    setState(() {
      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;
      if (showLoading) {
        _sectionLoadings.add(section);
      }
    });

    onRefresh?.call();
  }

  void tryOpenSection(
    RegmvFormSection section, {
    VoidCallback? onRefresh,
    bool showLoading = false,
  }) {
    final targetIdx = sectionIndex(section);
    final opened = getOpenedIndex();

    if (opened == targetIdx) return;

    final ok = validateOpenedForm();
    if (!ok) return;

    openSection(section, onRefresh: onRefresh, showLoading: showLoading);
  }

  int sectionIndex(RegmvFormSection s) => RegmvFormSection.values.indexOf(s);

  void resetUploadStates() {
    // reset flag error required
    _showVal4 = false;
    _showVal5 = false;
    _showVal7 = false;

    // clear state items di masing2 bloc (butuh event "Clear/Reset" di bloc)
    context
        .read<RegmvUploadStnkBloc>()
        .add(Regmv4UploadFotoObjectResetPreview());
    context
        .read<RegmvUploadFotoMobilBloc>()
        .add(Regmv5UploadFotoObjectResetPreview());
    context
        .read<RegmvUploadFotoAccBloc>()
        .add(Regmv7UploadFotoObjectResetPreview());
  }
}
