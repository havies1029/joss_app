import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar_upload_foto_object_bloc.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/pages/regpar/mobile/preview/regpar6_unified_preview_page.dart';
import 'package:string_validator/string_validator.dart';

import '../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../blocs/regpar/regpar1crud_bloc.dart';
import '../../../blocs/regpar/regpar2form_bloc.dart';
import '../../../blocs/regpar/regpar3form_bloc.dart';
import '../../../blocs/regpar/regpar4form_bloc.dart';
import '../../../blocs/regpar/regpar5form_bloc.dart';
import '../../../blocs/regpar/regpar6cari_bloc.dart';
import '../../../blocs/regpar/regpar_flow_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/loading_indicator.dart';
import '../../../common/thousand_separator_input_formatter.dart';
import '../../../helper/navigation_keys.dart';
import '../../../models/combobox/combomjnscoverpar_model.dart';
import '../../../models/combobox/combomkabzonagempa_model.dart';
import '../../../models/combobox/combomkecamatan_model.dart';
import '../../../models/combobox/combomkelurahan_model.dart';
import '../../../models/combobox/combomkota_model.dart';
import '../../../models/combobox/combompropinsi_model.dart';
import '../../../models/combobox/combomwilayah_model.dart';
import '../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../models/combobox/combormatauang_model.dart';
import '../../../models/combobox/comborokupasi_model.dart';
import '../../../models/regpar/regpar1crud_model.dart';
import '../../../models/regpar/regpar2form_model.dart';
import '../../../models/regpar/regpar3form_model.dart';
import '../../../models/regpar/regpar4form_model.dart';
import '../../../models/regpar/regpar5form_model.dart';
import '../../../models/regpar/regpar6form_model.dart';
import '../../../models/regpar/regpar_validation_preview_model.dart';
import '../../../repositories/combobox/combomjnscoverpar_repository.dart';
import '../../../repositories/combobox/combomkabzonagempa_repository.dart';
import '../../../repositories/combobox/combomkecamatan_repository.dart';
import '../../../repositories/combobox/combomkelurahan_repository.dart';
import '../../../repositories/combobox/combomkota_repository.dart';
import '../../../repositories/combobox/combompropinsi_repository.dart';
import '../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../repositories/combobox/comborkonstruksiojk_repository.dart';
import '../../../repositories/combobox/combormatauang_repository.dart';
import '../../../repositories/combobox/comborokupasi_repository.dart';
import '../../../repositories/regpar/regpar_validation_preview_repository.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/dropdown2.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/apptheme/hitung_premi_empty_view.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import 'konfirmasi_regpar_page.dart';
import '../../../helper/cob_access_guard.dart';

enum RegparSection { form1, form2, form3, form4, form6, form5 }
// urutan sesuai UI kamu sekarang: 1,2,3,4,6,5 (premi terakhir)

class RegparFormMainRemake extends StatefulWidget {
  final String? regpar1Id;
  final String? calpar1Id;

  const RegparFormMainRemake({
    required this.regpar1Id,
    required this.calpar1Id,
    super.key,
  });

  @override
  State<RegparFormMainRemake> createState() => _RegparFormMainRemakeState();
}

class _RegparFormMainRemakeState extends State<RegparFormMainRemake> {
  static const double _maxSumInsuredValue = 999000000000;
  static const String _maxSumInsuredLabel = '999,000,000,000';

  bool _accessDeniedDialogShown = false;
  late List<bool> expanded;
  final Set<RegparSection> _sectionLoadings = <RegparSection>{};

  String? regpar1Id;
  String? regpar2Id;
  String? regpar3Id;
  String? regpar4Id;
  String? regpar5Id;
  String? regpar6Id;

  Regpar1CrudBloc? regpar1crudbloc;
  Regpar2FormBloc? regpar2formbloc;
  Regpar3FormBloc? regpar3formbloc;
  Regpar4FormBloc? regpar4formbloc;
  Regpar5FormBloc? regpar5formbloc;

  bool _showVal6 = false;

  Regpar1CrudModel? form1Record;
  Regpar2FormModel? form2Record;
  Regpar3FormModel? form3Record;
  Regpar4FormModel? form4Record;
  Regpar5FormModel? form5Record;
  Regpar6FormModel? form6Record;

  bool _showZonaGempa = true;
  bool _lockCheckboxes = false;
  bool _defaultCurrencyApplied = false;

  void _setBool(TextEditingController c, bool v) {
    c.text = v.toString();
  }

  void _applyCoverParRule(String? mjnscoverparId) {
    _lockCheckboxes = false;
    _showZonaGempa = true;

    _setBool(fieldIsEqController, false);
    _setBool(fieldIsTsfwdController, false);
    _setBool(fieldIsFlexasController, false);
    _setBool(fieldIsOtherController, false);
    _setBool(fieldIsRsmdccController, false);

    if (mjnscoverparId == "10") {
      // PAR Dengan Gempa
      _lockCheckboxes = true;
      _showZonaGempa = true;

      _setBool(fieldIsEqController, true);
      _setBool(fieldIsTsfwdController, true);
      _setBool(fieldIsFlexasController, true);
      _setBool(fieldIsOtherController, true);
      _setBool(fieldIsRsmdccController, true);
    } else if (mjnscoverparId == "20") {
      // PAR Tanpa Gempa
      _lockCheckboxes = true;
      _showZonaGempa = false;

      _setBool(fieldIsEqController, false);
      _setBool(fieldIsTsfwdController, true);
      _setBool(fieldIsFlexasController, true);
      _setBool(fieldIsOtherController, true);
      _setBool(fieldIsRsmdccController, true);

      fieldComboMKabZonaGempa = null;
      clearErr('form3.kab2zonagempaId');
    }
  }

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

  String formatControllerNumber(TextEditingController c) {
    if (c.text.isEmpty) return '';
    final value = num.tryParse(c.text.replaceAll(',', ''));
    if (value == null) return c.text;
    return cleanNum(value);
  }

  //form1
  final fieldRegpar1IdController = TextEditingController();
  final fieldTtgAlamatController = TextEditingController();
  final fieldTtgNamaController = TextEditingController();
  //form1

  //form2

  final fieldObjectAlamatController = TextEditingController();
  final fieldCoverLamaController = TextEditingController();
  final fieldPolisAkhirController = TextEditingController();
  final fieldPolisMulaiController = TextEditingController();

  ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
  final comboRKonstruksiojkKey =
      GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
  ComboROkupasiModel? fieldComboROkupasi;
  final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();
  ComboMKecamatanModel? fieldComboMKecamatan;
  final comboMKecamatanKey =
      GlobalKey<DropdownSearchState<ComboMKecamatanModel>>();
  ComboMKelurahanModel? fieldComboMKelurahan;
  final comboMKelurahanKey =
      GlobalKey<DropdownSearchState<ComboMKelurahanModel>>();
  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey =
      GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
  DateTime? kejadianMulaiTgl;
  final _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  //form2

  //form3
  final fieldIsEqController = TextEditingController();
  final fieldIsFlexasController = TextEditingController();
  final fieldIsOtherController = TextEditingController();
  final fieldIsRsmdccController = TextEditingController();
  final fieldIsTsfwdController = TextEditingController();

  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  final comboMKabZonaGempaKey =
      GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();
  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  final comboMJnscoverParKey =
      GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  //form3

  //form4
  final fieldSiBuildingController = TextEditingController();
  final fieldSiContentController = TextEditingController();
  final fieldSiMachineryController = TextEditingController();
  final fieldSiOtherController = TextEditingController();
  final fieldSiStockController = TextEditingController();
  ComboRMatauangModel? fieldComboRMatauang;
  final comboRMatauangKey =
      GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  //form4

  //form5
  final fieldDiskonNilaiController = TextEditingController();
  final fieldDiskonPersenController = TextEditingController();
  final fieldPremiEqvetController = TextEditingController();
  final fieldPremiNetController = TextEditingController();
  final fieldPremiOtherController = TextEditingController();
  final fieldPremiParController = TextEditingController();
  final fieldPremiRsmdccController = TextEditingController();
  final fieldPremiTotalController = TextEditingController();
  final fieldPremiTsfwdController = TextEditingController();
  final fieldRateParController = TextEditingController();
  final fieldRateRsmdccController = TextEditingController();
  final fieldRateTsfwdController = TextEditingController();
  final fieldRateEqvetController = TextEditingController();
  final fieldRateOtherController = TextEditingController();
  final fieldRateTotalController = TextEditingController();
  final fieldSumInsuredController = TextEditingController();
  final fieldBiayaPolisController = TextEditingController();
  final fieldBiayaMateraiController = TextEditingController();
  final fieldTotalTagihanController = TextEditingController();

  Iterable<TextEditingController> get _premiInputControllers =>
      <TextEditingController>[
        fieldRegpar1IdController,
        fieldTtgAlamatController,
        fieldTtgNamaController,
        fieldObjectAlamatController,
        fieldCoverLamaController,
        fieldPolisAkhirController,
        fieldPolisMulaiController,
        fieldIsEqController,
        fieldIsFlexasController,
        fieldIsOtherController,
        fieldIsRsmdccController,
        fieldIsTsfwdController,
        fieldSiBuildingController,
        fieldSiContentController,
        fieldSiMachineryController,
        fieldSiOtherController,
        fieldSiStockController,
      ];
  //form5

  @override
  void initState() {
    super.initState();

    for (final controller in _premiInputControllers) {
      controller.addListener(_refreshPremiSnapshotVisibility);
    }

    expanded = List.filled(RegparSection.values.length, false);
    expanded[sectionIndex(RegparSection.form1)] = true;

    final regpar1 =
        context.read<Regpar1CrudBloc>().state.record?.regpar1Id ?? "";
    regpar1Id = widget.regpar1Id ?? regpar1;
    _loadDefaultCurrency();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));

      if (regpar1Id != null && regpar1Id!.isNotEmpty) {
        refreshForm1(recordId: regpar1Id);
      }
    });

    //reset foto dari record lama
    context.read<RegparUploadFotoObjectBloc>().add(RegparUploadReset());
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
      fieldErrors.remove('form4.mataUang');
    });
  }

  @override
  void dispose() {
    for (final controller in _premiInputControllers) {
      controller.removeListener(_refreshPremiSnapshotVisibility);
    }

    // form1
    fieldRegpar1IdController.dispose();
    fieldTtgAlamatController.dispose();
    fieldTtgNamaController.dispose();

    // form2
    fieldObjectAlamatController.dispose();
    fieldCoverLamaController.dispose();
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();

    // form3
    fieldIsEqController.dispose();
    fieldIsFlexasController.dispose();
    fieldIsOtherController.dispose();
    fieldIsRsmdccController.dispose();
    fieldIsTsfwdController.dispose();

    // form4
    fieldSiBuildingController.dispose();
    fieldSiContentController.dispose();
    fieldSiMachineryController.dispose();
    fieldSiOtherController.dispose();
    fieldSiStockController.dispose();

    // form5
    fieldDiskonNilaiController.dispose();
    fieldDiskonPersenController.dispose();
    fieldPremiEqvetController.dispose();
    fieldPremiNetController.dispose();
    fieldPremiOtherController.dispose();
    fieldPremiParController.dispose();
    fieldPremiRsmdccController.dispose();
    fieldPremiTotalController.dispose();
    fieldPremiTsfwdController.dispose();
    fieldRateParController.dispose();
    fieldRateRsmdccController.dispose();
    fieldRateTsfwdController.dispose();
    fieldRateEqvetController.dispose();
    fieldRateOtherController.dispose();
    fieldRateTotalController.dispose();
    fieldSumInsuredController.dispose();
    fieldBiayaPolisController.dispose();
    fieldBiayaMateraiController.dispose();
    fieldTotalTagihanController.dispose();
    // form5

    super.dispose();
  }

  void refreshForm1({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regpar1CrudBloc>().add(
          Regpar1CrudLihatEvent(recordId: recordId),
        );
  }

  void refreshForm2({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regpar2FormBloc>().add(
          Regpar2FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm3({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regpar3FormBloc>().add(
          Regpar3FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm4({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regpar4FormBloc>().add(
          Regpar4FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm5({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Regpar5FormBloc>().add(
          Regpar5FormLihatEvent(recordId: recordId),
        );
  }

  void refreshForm6({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) {
      return;
    }
    context.read<Regpar6CariBloc>().add(
          RefreshRegpar6CariEvent(regpar1Id: recordId),
        );
  }

  bool _isSectionLoading(RegparSection section) =>
      _sectionLoadings.contains(section);

  void _stopSectionLoading(RegparSection section) {
    if (!_sectionLoadings.contains(section) || !mounted) return;
    setState(() {
      _sectionLoadings.remove(section);
    });
  }

  void _clearLoadedErrors(RegparSection section) {
    bool hasText(TextEditingController controller) =>
        controller.text.trim().isNotEmpty;

    bool hasNonNegativeNumber(TextEditingController controller) {
      final raw = controller.text.trim();
      if (raw.isEmpty) return false;
      final value = double.tryParse(raw.replaceAll(',', ''));
      return value != null && value >= 0;
    }

    final keys = <String>[];

    switch (section) {
      case RegparSection.form1:
        if (hasText(fieldTtgNamaController)) keys.add('form1.namaTertanggung');
        if (hasText(fieldTtgAlamatController)) {
          keys.add('form1.alamatTertanggung');
        }
        break;
      case RegparSection.form2:
        if (fieldComboRKonstruksiojk != null) {
          keys.add('form2.kelasKonstruksi');
        }
        if (fieldComboROkupasi != null) keys.add('form2.okupasi');
        if (hasText(fieldObjectAlamatController)) keys.add('form2.alamatRumah');
        if (fieldComboMPropinsi != null) keys.add('form2.provinsi');
        if (fieldComboMKota != null) keys.add('form2.kota');
        if (fieldComboMKecamatan != null) keys.add('form2.kecamatan');
        if (fieldComboMKelurahan != null) keys.add('form2.kelurahan');
        break;
      case RegparSection.form3:
        if (fieldComboMJnscoverPar != null) keys.add('form3.jenisJaminan');
        if (fieldComboMWilayah != null) keys.add('form3.wilayah');
        if (!_showZonaGempa || fieldComboMKabZonaGempa != null) {
          keys.add('form3.kab2zonagempaId');
        }
        break;
      case RegparSection.form4:
        if (fieldComboRMatauang != null) keys.add('form4.mataUang');

        final siControllers = <String, TextEditingController>{
          'form4.siBuilding': fieldSiBuildingController,
          'form4.siContent': fieldSiContentController,
          'form4.siMachinery': fieldSiMachineryController,
          'form4.siOther': fieldSiOtherController,
          'form4.siStock': fieldSiStockController,
        };
        final hasPositiveSi = siControllers.values.any((controller) {
          final value =
              double.tryParse(controller.text.trim().replaceAll(',', ''));
          return value != null && value > 0;
        });

        for (final entry in siControllers.entries) {
          if (hasNonNegativeNumber(entry.value) && hasPositiveSi) {
            keys.add(entry.key);
          }
        }
        break;
      case RegparSection.form6:
        break;
      case RegparSection.form5:
        break;
    }

    if (keys.isEmpty || !mounted) return;
    setState(() {
      for (final key in keys) {
        fieldErrors.remove(key);
      }
    });
  }

  void _payloadform1(Regpar1CrudModel record) {
    if (fieldRegpar1IdController.text.trim().isEmpty) {
      fieldRegpar1IdController.text = record.regpar1Id.toString();
    }

    if (fieldTtgNamaController.text.trim().isEmpty) {
      fieldTtgNamaController.text = record.ttgNama.toString();
    }

    if (fieldTtgAlamatController.text.trim().isEmpty) {
      fieldTtgAlamatController.text = record.ttgAlamat.toString();
    }
  }

  void _payloadform2(Regpar2FormModel record) {
    if (fieldObjectAlamatController.text.trim().isEmpty) {
      fieldObjectAlamatController.text = record.objectAlamat ?? '';
    }

    if (fieldPolisMulaiController.text.trim().isEmpty) {
      fieldPolisMulaiController.text = record.polisMulai.toIso8601String();
    }

    if (fieldPolisAkhirController.text.trim().isEmpty) {
      fieldPolisAkhirController.text = record.polisAkhir.toIso8601String();
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

      if (fieldComboRKonstruksiojk == null &&
          record.comboRKonstruksiojk != null) {
        fieldComboRKonstruksiojk = record.comboRKonstruksiojk;
      }

      if (fieldComboROkupasi == null && record.comboROkupasi != null) {
        fieldComboROkupasi = record.comboROkupasi;
      }

      if (fieldComboMPropinsi == null && record.comboMPropinsi != null) {
        fieldComboMPropinsi = record.comboMPropinsi;
      }

      if (fieldComboMKota == null && record.comboMKota != null) {
        fieldComboMKota = record.comboMKota;
      }

      if (fieldComboMKecamatan == null && record.comboMKecamatan != null) {
        fieldComboMKecamatan = record.comboMKecamatan;
      }

      if (fieldComboMKelurahan == null && record.comboMKelurahan != null) {
        fieldComboMKelurahan = record.comboMKelurahan;
      }
    });
  }

  void _payloadform3(Regpar3FormModel record) {
    if (fieldIsEqController.text.trim().isEmpty) {
      fieldIsEqController.text = record.isEq.toString();
    }

    if (fieldIsFlexasController.text.trim().isEmpty) {
      fieldIsFlexasController.text = record.isFlexas.toString();
    }

    if (fieldIsOtherController.text.trim().isEmpty) {
      fieldIsOtherController.text = record.isOther.toString();
    }

    if (fieldIsRsmdccController.text.trim().isEmpty) {
      fieldIsRsmdccController.text = record.isRsmdcc.toString();
    }

    if (fieldIsTsfwdController.text.trim().isEmpty) {
      fieldIsTsfwdController.text = record.isTsfwd.toString();
    }

    setState(() {
      if (fieldComboMKabZonaGempa == null &&
          record.comboMKabZonaGempa != null) {
        fieldComboMKabZonaGempa = record.comboMKabZonaGempa;
      }

      final jnsCoverPar = record.comboMJnscoverPar;
      if (fieldComboMJnscoverPar == null && jnsCoverPar != null) {
        fieldComboMJnscoverPar = jnsCoverPar;
        _applyCoverParRule(
            jnsCoverPar.mjnscoverparId); // ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦ sync dari data
      }

      if (fieldComboMWilayah == null && record.comboMWilayah != null) {
        fieldComboMWilayah = record.comboMWilayah;
      }
    });
  }

  void _payloadform4(Regpar4FormModel record) {
    if (fieldSiBuildingController.text.trim().isEmpty) {
      fieldSiBuildingController.text = cleanNum(record.siBuilding);
    }

    if (fieldSiContentController.text.trim().isEmpty) {
      fieldSiContentController.text = cleanNum(record.siContent);
    }

    if (fieldSiMachineryController.text.trim().isEmpty) {
      fieldSiMachineryController.text = cleanNum(record.siMachinery);
    }

    if (fieldSiOtherController.text.trim().isEmpty) {
      fieldSiOtherController.text = cleanNum(record.siOther);
    }

    if (fieldSiStockController.text.trim().isEmpty) {
      fieldSiStockController.text = cleanNum(record.siStock);
    }

    setState(() {
      if ((fieldComboRMatauang == null || _defaultCurrencyApplied) &&
          record.comboRMatauang != null) {
        fieldComboRMatauang = record.comboRMatauang;
        _defaultCurrencyApplied = false;
      }
    });
  }

  void _payloadform5(Regpar5FormModel record) {
    fieldDiskonNilaiController.text = record.diskonNilai.toString();
    fieldDiskonPersenController.text = record.diskonPersen.toString();
    fieldPremiEqvetController.text = record.premiEqvet.toString();
    fieldPremiNetController.text = record.premiNet.toString();
    fieldPremiOtherController.text = record.premiOther.toString();
    fieldPremiParController.text = record.premiPar.toString();
    fieldPremiRsmdccController.text = record.premiRsmdcc.toString();
    fieldPremiTotalController.text = record.premiTotal.toString();
    fieldPremiTsfwdController.text = record.premiTsfwd.toString();
    fieldRateParController.text = record.ratePar.toString();
    fieldRateRsmdccController.text = record.rateRsmdcc.toString();
    fieldRateTsfwdController.text = record.rateTsfwd.toString();
    fieldRateEqvetController.text = record.rateEqvet.toString();
    fieldRateOtherController.text = record.rateOther.toString();
    fieldRateTotalController.text = record.rateTotal.toString();
    fieldSumInsuredController.text = record.tsi.toString();
    fieldBiayaPolisController.text = record.biayaPolis.toString();
    fieldBiayaMateraiController.text = cleanNum(record.biayaMaterai);
    fieldTotalTagihanController.text = record.totalTagihan.toString();
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
      context.read<Regpar1CrudBloc>().add(
            Regpar1CrudHapusEvent(recordId: regpar1Id ?? ""),
          );
      Navigator.pop(context);
    }
  }

  Future<void> _handleExit2(BuildContext context) async {
    final shouldLeave = await showExitConfirmDialog(context);

    if (shouldLeave == true) {
      context.read<Regpar1CrudBloc>().add(
            Regpar1CrudHapusEvent(recordId: regpar1Id ?? ""),
          );

      final homeState = homeTabKey.currentState;

      if (homeState != null) {
        homeState.goToHeroPage();
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _handleAccessDeniedExit(BuildContext context) {
    context.read<Regpar1CrudBloc>().add(
          Regpar1CrudHapusEvent(recordId: regpar1Id ?? ""),
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
          title: "Polis Properti",
          blocListeners: [
            CobAccessGuard.buildHakaksesListener(
              cobId: CobAccessGuard.cobProperti,
              isDialogShown: () => _accessDeniedDialogShown,
              markDialogShown: () {
                _accessDeniedDialogShown = true;
              },
              onAccessDeniedReturn: () => _handleAccessDeniedExit(context),
            ),
            BlocListener<Regpar1CrudBloc, Regpar1CrudState>(
              listener: (context, state) {
                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regpar1Id = state.record!.regpar1Id;
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform1(state.record!);
                  _clearLoadedErrors(RegparSection.form1);
                }
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegparSection.form1);
                }
              },
            ),
            BlocListener<Regpar2FormBloc, Regpar2FormState>(
              listener: (context, state) {
                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regpar2Id = state.record!.regpar2Id;
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform2(state.record!);
                  _clearLoadedErrors(RegparSection.form2);
                }
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegparSection.form2);
                }
              },
            ),
            BlocListener<Regpar3FormBloc, Regpar3FormState>(
              listener: (context, state) {
                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regpar3Id = state.record!.regpar3Id;
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform3(state.record!);
                  _clearLoadedErrors(RegparSection.form3);
                }
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegparSection.form3);
                }
              },
            ),
            BlocListener<Regpar4FormBloc, Regpar4FormState>(
              listener: (context, state) {
                if (state.isSaved &&
                    !state.hasFailure &&
                    state.record != null) {
                  setState(() {
                    regpar4Id = state.record!.regpar1Id; //anomali
                  });
                }
                if (state.isLoaded &&
                    !state.hasFailure &&
                    state.record != null) {
                  _payloadform4(state.record!);
                  _clearLoadedErrors(RegparSection.form4);
                }
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegparSection.form4);
                }
              },
            ),
            BlocListener<PolisTanggalBloc, PolisTanggalState>(
              listenWhen: (prev, curr) =>
                  prev.mulai != curr.mulai || prev.berakhir != curr.berakhir,
              listener: (_, __) => _refreshPremiSnapshotVisibility(),
            ),
            BlocListener<RegparUploadFotoObjectBloc,
                RegParUploadFotoObjectState>(
              listenWhen: (prev, curr) => prev.items != curr.items,
              listener: (_, __) => _refreshPremiSnapshotVisibility(),
            ),
            BlocListener<Regpar6CariBloc, Regpar6CariState>(
              listenWhen: (prev, curr) => prev.status != curr.status,
              listener: (context, state) {
                if (state.status == ListStatus.success ||
                    state.status == ListStatus.failure) {
                  _stopSectionLoading(RegparSection.form6);
                }
              },
            ),
            BlocListener<Regpar5FormBloc, Regpar5FormState>(
              listenWhen: (prev, curr) =>
                  prev.isLoaded != curr.isLoaded ||
                  prev.isCalculated != curr.isCalculated ||
                  prev.hasFailure != curr.hasFailure,
              listener: (context, state) {
                if (state.isLoaded || state.hasFailure) {
                  _stopSectionLoading(RegparSection.form5);
                }

                if (state.hasFailure) {
                  if (mounted) {
                    setState(() {
                      _isHitungPremiLoading = false;
                    });
                  }
                  return;
                }

                final rec = state.record;
                if (state.isLoaded && rec != null) {
                  if (mounted) {
                    setState(() {
                      regpar5Id = rec.regpar5Id;
                    });
                  }
                  _payloadform5(rec);
                }

                if (!state.isCalculated || rec == null) return;

                if (mounted) {
                  setState(() {
                    _isHitungPremiLoading = false;
                    regpar5Id = rec.regpar5Id;
                    _lastCalculatedPremiKey = _currentPremiInputKey();
                  });
                }

                _payloadform5(rec);
                openPremiSection(recordId: regpar1Id);
              },
            ),
          ],
          child: _buildForm(),
        ),
      ),
    );
  }

  bool isAllFormComplete() {
    final done = [
      isForm1Complete(),
      isForm2Complete(),
      isForm3Complete(),
      isForm4Complete(),
      isForm6Complete(),
      isForm5Complete(),
    ].where((x) => x).length;

    return done == RegparSection.values.length;
  }

  Widget _buildForm() {
    final bool hasForm5Record =
        context.read<Regpar5FormBloc>().state.record != null;
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
                    iconPath: "assets/icons/properti.svg",
                    title: "Polis Properti",
                    subtitle:
                        "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
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
                        isLoading: _isSectionLoading(RegparSection.form1),
                        showLoadingOnRefresh: _canRefreshRecord(regpar1Id),
                        onRefresh: () {
                          if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                            refreshForm1(recordId: regpar1Id);
                          }
                        },
                        child: Column(
                          children: [
                            buildFieldRegpar1Id(),
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
                        title: "Informasi Polis",
                        isExpanded: expanded[1],
                        isLoading: _isSectionLoading(RegparSection.form2),
                        showLoadingOnRefresh: _canRefreshRecord(regpar1Id),
                        onRefresh: () {
                          if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                            refreshForm2(recordId: regpar1Id);
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(child: buildFieldPolisMulai()),
                                const SizedBox(
                                  width: hPadding,
                                ),
                                Flexible(child: buildFieldPolisBerakhir()),
                              ],
                            ),
                            const SizedBox(
                              height: hPadding,
                            ),
                            buildFieldRokupasiId(),
                            const SizedBox(height: hPadding),
                            buildFieldRkonstruksiojkId(),
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
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form3Page(
                        context: context,
                        title: "Pertanggungan",
                        isExpanded: expanded[2],
                        isLoading: _isSectionLoading(RegparSection.form3),
                        showLoadingOnRefresh: _canRefreshRecord(regpar1Id),
                        onRefresh: () {
                          if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                            refreshForm3(recordId: regpar1Id);
                          }
                        },
                        child: Column(
                          children: [
                            buildFieldMjnscoverparId(),
                            const SizedBox(height: hPadding),
                            Text(
                              "Jenis asuransi All Risk mencakup:",
                              style: bodyTextStyle(context).copyWith(
                                color: primaryLightColor,
                                fontSize: getResponsiveFont(context, 16),
                              ),
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: buildFieldIsFlexas()),
                                const SizedBox(width: 8),
                                Flexible(child: buildFieldIsEq()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: buildFieldIsRsmdcc()),
                                const SizedBox(width: 8),
                                Flexible(child: buildFieldIsTsfwd()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: buildFieldIsOther()),
                                const SizedBox(width: 8),
                                const Flexible(child: SizedBox.shrink()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            buildFieldMwilayahId(),
                            if (!_showZonaGempa) ...[
                              const SizedBox(height: 8),
                            ],
                            if (_showZonaGempa) ...[
                              const SizedBox(height: hPadding),
                              buildFieldKab2zonagempaId(),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form4Page(
                        context: context,
                        title: "Nilai Pertanggungan",
                        isExpanded: expanded[3],
                        isLoading: _isSectionLoading(RegparSection.form4),
                        showLoadingOnRefresh: _canRefreshRecord(regpar1Id),
                        onRefresh: () {
                          if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                            refreshForm4(recordId: regpar1Id);
                          }
                        },
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
                                Flexible(child: buildFieldSiContent()),
                              ],
                            ),
                            const SizedBox(height: hPadding),
                            Row(
                              children: [
                                Flexible(child: buildFieldSiStock()),
                                const SizedBox(width: 8),
                                Flexible(child: buildFieldSiOther()),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      Form6Page(
                        context: context,
                        title: "Upload Foto Bangunan",
                        isExpanded: expanded[4],
                        isLoading: _isSectionLoading(RegparSection.form6),
                        showLoadingOnRefresh: _canRefreshRecord(regpar1Id),
                        onRefresh: () {
                          if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                            refreshForm6(recordId: regpar1Id);
                          }
                        },
                        child: Column(
                          children: [
                            BlocBuilder<RegparUploadFotoObjectBloc,
                                RegParUploadFotoObjectState>(
                              buildWhen: (p, c) =>
                                  p.items.length != c.items.length,
                              builder: (context, state) {
                                if (_showVal6 && state.items.isNotEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted)
                                      setState(() => _showVal6 = false);
                                  });
                                }

                                return Regpar6StoragePickerSectionWidget(
                                  showRequiredError:
                                      _showVal6 && state.items.isEmpty,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: hPadding),
                      buildButtonHitungPremi(),
                      const SizedBox(height: hPadding),
                      Form5Page(
                        context: context,
                        title: "Premi",
                        isExpanded: expanded[5],
                        isLoading: _isSectionLoading(RegparSection.form5),
                        child: (hasForm5Record)
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
                                        label: "Kebakaran:",
                                        controller: fieldRateParController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Kerusuhan:",
                                        controller: fieldRateRsmdccController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Banjir:",
                                        controller: fieldRateTsfwdController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Gempa Bumi:",
                                        controller: fieldRateEqvetController,
                                        layoutType:
                                            HitungPremiLayoutType.horizontal,
                                        // showValueBorder: true,
                                        valueSuffix: "%",
                                      ),
                                      HitungPremiRow(
                                        label: "Lain-Lain:",
                                        controller: fieldRateOtherController,
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
                                        label:
                                            "PERHITUNGAN PREMI\n(Asuransi PAR Termasuk EQVET)",
                                        description:
                                            "${fieldComboRMatauang?.rmatauangSimbol} ${formatControllerNumber(fieldSumInsuredController)} x ${fieldRateTotalController.text}% =",
                                        controller: fieldPremiTotalController,
                                        layoutType:
                                            HitungPremiLayoutType.vertical,
                                        valuePrefix: fieldComboRMatauang
                                            ?.rmatauangSimbol,
                                        showValueBorder: true,
                                        formatNumber: true,
                                      ),
                                      HitungPremiRow(
                                        label: "DISKON",
                                        controller: fieldDiskonNilaiController,
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
                                  // buildFieldPremiEqvet(),
                                  //                         // const SizedBox(height: hPadding),
                                  //                         // buildFieldDiskonNilai(),
                                  //                         // const SizedBox(height: hPadding),
                                  //                         // buildFieldPremiNet(),
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
                          backgroundColor: pGreen2,
                          onPressed: _isLanjutkanLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLanjutkanLoading = true;
                                  });

                                  final canContinueByPreview =
                                      await _runValidationPreviewBeforeFlow();
                                  if (!mounted || !canContinueByPreview) {
                                    if (mounted) {
                                      setState(() {
                                        _isLanjutkanLoading = false;
                                      });
                                    }
                                    return;
                                  }

                                  _showGlobalLoading();

                                  try {
                                    draftForm1ToBloc(context);
                                    draftForm2ToBloc(context);
                                    draftForm3ToBloc(context);
                                    draftForm4ToBloc(context);

                                    context.read<RegparFlowBloc>().add(
                                          RegparFlowStartEvent(),
                                        );

                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    if (!mounted) return;

                                    _hideGlobalLoading();

                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KonfirmasiRegParPage(
                                          recordId: regpar1Id ?? '',
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
                RegparSection.form1,
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
                RegparSection.form2,
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

  Widget Form3Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
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
                RegparSection.form3,
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

  Widget Form4Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
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
                RegparSection.form4,
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

  Widget Form5Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
    required Widget child,
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
              tryOpenSection(RegparSection.form5);
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

  Widget Form6Page({
    required BuildContext context,
    required bool isExpanded,
    required bool isLoading,
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
                RegparSection.form6,
                onRefresh: onRefresh,
                showLoading: showLoadingOnRefresh,
              );
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
    final record = Regpar1CrudModel(
      regpar1Id: regpar1Id ?? "",
      ttgNama: fieldTtgNamaController.text ?? "",
      ttgAlamat: fieldTtgAlamatController.text ?? "",
    );

    debugPrint("[draftForm1ToBloc] record => ${record.toJson()}");

    context.read<Regpar1CrudBloc>().add(
          Regpar1DraftEvent(record: record),
        );
  }

  void draftForm2ToBloc(BuildContext context) {
    final polis = context.read<PolisTanggalBloc>().state;

    final record = Regpar2FormModel(
      polisMulai: polis.mulai,
      polisAkhir: polis.berakhir,
      regpar2Id: regpar1Id ?? "",
      rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
      comboRKonstruksiojk: fieldComboRKonstruksiojk,
      rokupasiId: fieldComboROkupasi?.rokupasiId,
      comboROkupasi: fieldComboROkupasi,
      regpar1Id: widget.regpar1Id!,
      objectAlamat: fieldObjectAlamatController.text ?? '',
      objectPropinsiId: fieldComboMPropinsi?.mpropinsiId,
      comboMPropinsi: fieldComboMPropinsi,
      objectKotaId: fieldComboMKota?.mkotaId,
      comboMKota: fieldComboMKota,
      objectKecamatanId: fieldComboMKecamatan?.mkecamatanId,
      comboMKecamatan: fieldComboMKecamatan,
      objectKelurahanId: fieldComboMKelurahan?.mkelurahanId,
      comboMKelurahan: fieldComboMKelurahan,
    );

    context.read<Regpar2FormBloc>().add(Regpar2DraftEvent(record: record));
  }

  void draftForm3ToBloc(BuildContext context) {
    final record = Regpar3FormModel(
      regpar1Id: regpar1Id ?? "",
      isEq: toBoolean(fieldIsEqController.text),
      isFlexas: toBoolean(fieldIsFlexasController.text),
      isOther: toBoolean(fieldIsOtherController.text),
      isRsmdcc: toBoolean(fieldIsRsmdccController.text),
      isTsfwd: toBoolean(fieldIsTsfwdController.text),
      kab2zonagempaId:
          _showZonaGempa ? fieldComboMKabZonaGempa?.mkabzonagempaId : '',
      comboMKabZonaGempa: _showZonaGempa ? fieldComboMKabZonaGempa : null,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      comboMJnscoverPar: fieldComboMJnscoverPar,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
      comboMWilayah: fieldComboMWilayah,
      regpar3Id: regpar1Id ?? "",
    );

    debugPrint("[draftForm3ToBloc] record => ${record.toJson()}");

    context.read<Regpar3FormBloc>().add(Regpar3DraftEvent(record: record));
  }

  void draftForm4ToBloc(BuildContext context) {
    final record = Regpar4FormModel(
      regpar1Id: regpar1Id ?? "",
      currId: fieldComboRMatauang?.rmatauangKode,
      comboRMatauang: fieldComboRMatauang,
      siBuilding: _parseMoney(fieldSiBuildingController.text),
      siContent: _parseMoney(fieldSiContentController.text),
      siMachinery: _parseMoney(fieldSiMachineryController.text),
      siOther: _parseMoney(fieldSiOtherController.text),
      siStock: _parseMoney(fieldSiStockController.text),
    );

    debugPrint("[draftForm4ToBloc] record => ${record.toJson()}");

    context.read<Regpar4FormBloc>().add(Regpar4DraftEvent(record: record));
  }

  bool _isHitungPremiLoading = false;
  int _hitungPremiAttempt = 0;
  final RegparValidationPreviewRepository _validationPreviewRepository =
      RegparValidationPreviewRepository();
  RegparValidationPreviewResponseModel? _lastValidationPreviewResponse;
  String? _lastValidationPreviewKey;
  String? _lastCalculatedPremiKey;
  bool _showValidationPreviewFloatingIcon = false;
  bool _isValidationPreviewDialogOpen = false;
  final Set<String> _validationPreviewFieldErrorKeys = <String>{};

  Widget buildButtonHitungPremi() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppButton.primary(
          text: _isHitungPremiLoading ? "Memproses..." : "Hitung Premi",
          isLoading: _isHitungPremiLoading,
          backgroundColor:
              _isHitungPremiLoading ? secondaryBlackColor : pGreen2,
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
      openForm1(recordId: regpar1Id);
      return;
    }

    final okForm2 = validateForm2();
    if (!okForm2) {
      openForm2(recordId: regpar1Id);
      return;
    }

    final okForm3 = validateForm3();
    if (!okForm3) {
      openForm3(recordId: regpar1Id);
      return;
    }

    final okForm4 = validateForm4();
    if (!okForm4) {
      openForm4(recordId: regpar1Id);
      return;
    }

    final form6State = context.read<RegparUploadFotoObjectBloc>().state;
    final okForm6 = form6State.items.isNotEmpty;

    if (!okForm6) {
      if (mounted) {
        setState(() {
          _showVal6 = true;
        });
      }
      openUploadFotoSection(recordId: regpar1Id);
      return;
    }

    if (mounted) {
      setState(() {
        _isHitungPremiLoading = true;
      });
    }

    final canContinueByPreview = await _runValidationPreviewBeforeFlow();
    if (!mounted || !canContinueByPreview) return;

    if (mounted) {
      setState(() {
        _isHitungPremiLoading = true;
      });
    }
    _startHitungPremiTimeout();

    final localIds6 = form6State.items.map((e) => e.localId).toList();

    context.read<RegparUploadFotoObjectBloc>().add(
          RegparStorageUploadMany(
            regpar1Id: regpar1Id!,
            localIds: localIds6,
          ),
        );

    draftForm1ToBloc(context);
    draftForm2ToBloc(context);
    draftForm3ToBloc(context);
    draftForm4ToBloc(context);

    context.read<RegparFlowBloc>().add(RegparFlowStartEvent());
  }

  Future<bool> _runValidationPreviewBeforeFlow() async {
    final previewKey = _currentValidationPreviewKey();
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
          .check(_buildValidationPreviewRequest())
          .timeout(
            const Duration(seconds: 8),
            onTimeout: RegparValidationPreviewResponseModel.failure,
          );

      if (!mounted) return false;

      if (!response.success) {
        debugPrint(
          '[REGPAR VALIDATION PREVIEW] Technical failure, continue main flow.',
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
        '[REGPAR VALIDATION PREVIEW] Exception, continue main flow: $e',
      );
      return true;
    }
  }

  RegparValidationPreviewRequestModel _buildValidationPreviewRequest() {
    return RegparValidationPreviewRequestModel(
      regpar1Id: regpar1Id ?? '',
      rokupasiId: fieldComboROkupasi?.rokupasiId,
      currId: fieldComboRMatauang?.rmatauangKode,
      siBuilding: _parseMoney(fieldSiBuildingController.text),
      siMachinery: _parseMoney(fieldSiMachineryController.text),
      siContent: _parseMoney(fieldSiContentController.text),
      siStock: _parseMoney(fieldSiStockController.text),
      siOther: _parseMoney(fieldSiOtherController.text),
    );
  }

  double _parseMoney(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  String _currentValidationPreviewKey() {
    String moneyKey(TextEditingController controller) =>
        _parseMoney(controller.text).toStringAsFixed(2);

    return [
      regpar1Id ?? '',
      fieldComboROkupasi?.rokupasiId ?? '',
      fieldComboRMatauang?.rmatauangKode ?? '',
      moneyKey(fieldSiBuildingController),
      moneyKey(fieldSiMachineryController),
      moneyKey(fieldSiContentController),
      moneyKey(fieldSiStockController),
      moneyKey(fieldSiOtherController),
    ].map(_keyPart).join('|');
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
    final polis = context.read<PolisTanggalBloc>().state;
    final values = <String>[
      _currentValidationPreviewKey(),
      fieldTtgNamaController.text.trim(),
      fieldTtgAlamatController.text.trim(),
      polis.mulai.toIso8601String(),
      polis.berakhir.toIso8601String(),
      fieldComboRKonstruksiojk?.rkonstruksiojkId ?? '',
      fieldComboROkupasi?.rokupasiId ?? '',
      fieldObjectAlamatController.text.trim(),
      fieldComboMPropinsi?.mpropinsiId ?? '',
      fieldComboMKota?.mkotaId ?? '',
      fieldComboMKecamatan?.mkecamatanId ?? '',
      fieldComboMKelurahan?.mkelurahanId ?? '',
      fieldComboMJnscoverPar?.mjnscoverparId ?? '',
      fieldComboMWilayah?.mwilayahId ?? '',
      _showZonaGempa.toString(),
      fieldComboMKabZonaGempa?.mkabzonagempaId ?? '',
      toBoolean(fieldIsEqController.text).toString(),
      toBoolean(fieldIsFlexasController.text).toString(),
      toBoolean(fieldIsOtherController.text).toString(),
      toBoolean(fieldIsRsmdccController.text).toString(),
      toBoolean(fieldIsTsfwdController.text).toString(),
      _uploadItemsKey(
        context.read<RegparUploadFotoObjectBloc>().state.items,
      ),
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

  void _applyValidationPreviewIssue(
    RegparValidationPreviewResponseModel response,
    String previewKey,
  ) {
    final issues = response.issues
        .where((issue) => issue.hasError && issue.message.trim().isNotEmpty)
        .toList();

    if (issues.isEmpty) return;

    final idx = sectionIndex(RegparSection.form4);

    setState(() {
      _hitungPremiAttempt++;
      _isHitungPremiLoading = false;
      _isLanjutkanLoading = false;
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

  String _fieldKeyFromPreviewIssue(RegparValidationPreviewIssueModel issue) {
    final fieldKey = issue.fieldKey.trim();
    if (fieldKey.isNotEmpty) return fieldKey;
    return 'form4.siOther';
  }

  void _clearValidationPreviewForChangedFields(Iterable<String> fieldKeys) {
    if (_lastValidationPreviewResponse == null) return;
    final keys = fieldKeys.where(_isValidationPreviewFieldKey).toList();
    if (keys.isEmpty) return;

    setState(() {
      _clearValidationPreviewChangedFields(keys);
    });
  }

  bool _isValidationPreviewFieldKey(String fieldKey) {
    return fieldKey.startsWith('form2.') || fieldKey.startsWith('form4.');
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
    RegparValidationPreviewResponseModel response,
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
        _lastValidationPreviewKey == _currentValidationPreviewKey();
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
    RegparValidationPreviewResponseModel response,
  ) {
    final issues = response.issues.where((issue) => issue.hasError).toList();
    final propertyLabel = response.propertyLabel.trim();
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
                      'Validasi Properti',
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
                    if (propertyLabel.isNotEmpty) ...[
                      Text(
                        propertyLabel,
                        style: bodyTextStyle(context, fontSize: 16).copyWith(
                          color: primaryLightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'Nilai pertanggungan belum sesuai ketentuan asuransi. Sesuaikan nilai berikut sebelum hitung premi.',
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
                backgroundColor: pGreen2,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildValidationPreviewIssueCards(
    List<RegparValidationPreviewIssueModel> issues,
  ) {
    final widgets = <Widget>[];

    for (var i = 0; i < issues.length; i++) {
      widgets.add(_buildValidationPreviewIssueCard(issues[i]));

      if (i < issues.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }

  Widget _buildValidationPreviewIssueCard(
    RegparValidationPreviewIssueModel issue,
  ) {
    final details = _validationPreviewIssueDetails(issue);
    final suggestion = issue.suggestion.trim();

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
    RegparValidationPreviewIssueModel issue,
  ) {
    final rows = <Widget>[];

    if (issue.expectedValue.trim().isNotEmpty) {
      rows.add(_buildValidationPreviewDetailRow(
        'Total saat ini',
        _formatValidationIdr(issue.expectedValue),
      ));
    }

    if (issue.maxValue.trim().isNotEmpty) {
      rows.add(_buildValidationPreviewDetailRow(
        'Batas maksimum',
        _formatValidationIdr(issue.maxValue),
      ));
    }

    return rows;
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
    final number = double.tryParse(value.replaceAll(',', '').trim());
    if (number == null) return value.trim();
    return 'IDR ${NumberFormat.decimalPattern('en_US').format(number)}';
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

  bool _canRefreshRecord(String? recordId) =>
      recordId != null && recordId.isNotEmpty;

  void openForm1({required String? recordId}) => openSection(
        RegparSection.form1,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm1(recordId: recordId),
      );

  void openForm2({required String? recordId}) => openSection(
        RegparSection.form2,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm2(recordId: recordId),
      );

  void openForm3({required String? recordId}) => openSection(
        RegparSection.form3,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm3(recordId: recordId),
      );

  void openForm4({required String? recordId}) => openSection(
        RegparSection.form4,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm4(recordId: recordId),
      );

  void openUploadFotoSection({required String? recordId}) => openSection(
        RegparSection.form6,
        showLoading: _canRefreshRecord(recordId),
        onRefresh: () => refreshForm6(recordId: recordId),
      ); // catatan: ini Form6

  void openPremiSection({required String? recordId}) => openSection(
        RegparSection.form5,
        showLoading: _canRefreshRecord(recordId) &&
            context.read<Regpar5FormBloc>().state.record == null,
        onRefresh: () {
          final st = context.read<Regpar5FormBloc>().state;
          if (st.record == null) {
            refreshForm5(recordId: recordId);
          }
        },
      );

  bool validateForm1() {
    clearErrsByPrefix('form1.');
    bool ok = true;

    final nama = fieldTtgNamaController.text.trim();
    if (nama.isEmpty) {
      setErr('form1.namaTertanggung', kStringNullError);
      ok = false;
    }

    final alamat = fieldTtgAlamatController.text.trim();
    if (alamat.isEmpty) {
      setErr('form1.alamatTertanggung', kStringNullError);
      ok = false;
    }

    if (!ok) openSection(RegparSection.form1);

    return ok;
  }

  bool validateForm2() {
    clearErrsByPrefix('form2.');
    bool ok = true;

    // --- Combo Konstruksi (required) ---
    if (fieldComboRKonstruksiojk == null) {
      setErr('form2.kelasKonstruksi', kStringNullError);
      ok = false;
    }

    // --- Combo Okupasi (required) ---
    if (fieldComboROkupasi == null) {
      setErr('form2.okupasi', kStringNullError);
      ok = false;
    }

    // --- Alamat Rumah (required) ---
    final alamat = fieldObjectAlamatController.text.trim();
    if (alamat.isEmpty) {
      setErr('form2.alamatRumah', kAddressNullError);
      ok = false;
    }

    // --- Wilayah berjenjang (required) ---
    if (fieldComboMPropinsi == null) {
      setErr('form2.provinsi', kStringNullError);
      ok = false;
    }
    if (fieldComboMKota == null) {
      setErr('form2.kota', kStringNullError);
      ok = false;
    }
    if (fieldComboMKecamatan == null) {
      setErr('form2.kecamatan', kStringNullError);
      ok = false;
    }
    if (fieldComboMKelurahan == null) {
      setErr('form2.kelurahan', kStringNullError);
      ok = false;
    }

    // kalau gagal, buka panel form2 (index 1)
    if (!ok) openSection(RegparSection.form2);

    return ok;
  }

  bool validateForm3() {
    clearErrsByPrefix('form3.');
    bool ok = true;

    if (fieldComboMJnscoverPar == null) {
      setErr('form3.jenisJaminan', kStringNullError);
      ok = false;
    }

    // Wilayah (required)
    if (fieldComboMWilayah == null) {
      setErr('form3.wilayah', kStringNullError);
      ok = false;
    }

    if (_showZonaGempa && fieldComboMKabZonaGempa == null) {
      setErr('form3.kab2zonagempaId', kStringNullError);
      ok = false;
    }

    if (!ok) openSection(RegparSection.form3);

    return ok;
  }

  bool hasLeadingZero(String raw) {
    return raw.length > 1 && raw.startsWith('0');
  }

  bool validateForm4() {
    clearErrsByPrefix('form4.');
    bool ok = true;

    if (fieldComboRMatauang == null) {
      setErr('form4.mataUang', kStringNullError);
      ok = false;
    }

    double parseOrZero(TextEditingController controller) {
      final raw = controller.text.trim();
      if (raw.isEmpty) return 0;

      final clean = raw.replaceAll(",", "");
      return double.tryParse(clean) ?? double.nan;
    }

    bool optionalPositiveNumOrEmpty({
      required String key,
      required TextEditingController controller,
    }) {
      final x = parseOrZero(controller);

      if (x.isNaN) {
        setErr(key, "Format tidak valid");
        return false;
      }

      if (x < 0) {
        setErr(key, "Tidak boleh minus");
        return false;
      }

      if (x > _maxSumInsuredValue) {
        setErr(key, "Maksimal $_maxSumInsuredLabel");
        return false;
      }

      final clean = controller.text.trim().replaceAll(",", "");
      if (hasLeadingZero(clean)) {
        setErr(key, "Format tidak disarankan (diawali 0)");
      }

      return true;
    }

    // SI fields are optional individually, but at least one must be > 0.
    if (!optionalPositiveNumOrEmpty(
      key: 'form4.siBuilding',
      controller: fieldSiBuildingController,
    )) {
      ok = false;
    }

    if (!optionalPositiveNumOrEmpty(
      key: 'form4.siContent',
      controller: fieldSiContentController,
    )) {
      ok = false;
    }

    if (!optionalPositiveNumOrEmpty(
      key: 'form4.siMachinery',
      controller: fieldSiMachineryController,
    )) {
      ok = false;
    }

    if (!optionalPositiveNumOrEmpty(
      key: 'form4.siOther',
      controller: fieldSiOtherController,
    )) {
      ok = false;
    }

    if (!optionalPositiveNumOrEmpty(
      key: 'form4.siStock',
      controller: fieldSiStockController,
    )) {
      ok = false;
    }

    if (ok) {
      final vBuilding = parseOrZero(fieldSiBuildingController);
      final vContent = parseOrZero(fieldSiContentController);
      final vMachinery = parseOrZero(fieldSiMachineryController);
      final vOther = parseOrZero(fieldSiOtherController);
      final vStock = parseOrZero(fieldSiStockController);

      final anyGreaterThanZero = vBuilding > 0 ||
          vContent > 0 ||
          vMachinery > 0 ||
          vOther > 0 ||
          vStock > 0;

      if (!anyGreaterThanZero) {
        setErr(
            'form4.siMachinery', 'Minimal salah satu nilai harus lebih dari 0');
        ok = false;
      }
    }

    if (!ok) {
      openSection(RegparSection.form4);
    }

    return ok;
  }

  //form1
  Widget buildFieldRegpar1Id() => appTextField(
        label: "No Registrasi",
        controller: fieldRegpar1IdController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
        ],
        enabled: false,
      );

  Widget buildFieldTtgNama() => appTextField(
        label: "Nama Tertanggung",
        controller: fieldTtgNamaController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
        ],
        errorText: err('form1.namaTertanggung'),
        validator: (_) => err('form1.namaTertanggung'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('form1.namaTertanggung');
        },
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
            context.read<PolisTanggalBloc>().add(PolisMulaiChanged(dt));
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

  ComboRKonstruksiojkModel? previousKonstruksi;

  String getKonstruksiSubtitle(String kelasNama) {
    switch (kelasNama) {
      case "Kelas Konstruksi 1":
        return "Bangunan permanen dengan struktur beton bertulang atau pasangan bata.";
      case "Kelas Konstruksi 2":
        return "Bangunan semi permanen, kombinasi bata dan kayu.";
      case "Kelas Konstruksi 3":
        return "Bangunan dengan dominasi material kayu atau mudah terbakar.";
      default:
        return "Deskripsi konstruksi tidak tersedia.";
    }
  }

  Widget buildFieldRkonstruksiojkId() =>
      ReusableComboBoxV2<ComboRKonstruksiojkModel>(
        hintText: "Konstruksi",
        comboKey: comboRKonstruksiojkKey,
        maxHeight: 200,
        initItem: fieldComboRKonstruksiojk,
        isEnabled: fieldComboROkupasi != null,
        dependencyKey: fieldComboROkupasi?.rokupasiId,
        params: {
          "rokupasiId": fieldComboROkupasi?.rokupasiId ?? "",
        },
        loader: (q) {
          final okupasiId = q.get<String>("rokupasiId") ?? "";
          return ComboRKonstruksiojkRepository()
              .getComboRKonstruksiojk(okupasiId);
        },
        minSearchChars: 2,
        displayText: (i) => i.kelasNama,
        compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.kelasKonstruksi'),
        onBeforeChangeCallback: (_, item) async {
          if (item == null) return false;

          final subtitle = getKonstruksiSubtitle(item.kelasNama);
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: formGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.kelasNama,
                      style: bodyTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: bodyTextStyle(context, fontSize: 15)
                          .copyWith(color: hintGrey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Apakah Anda yakin ingin memilih kelas ini?",
                      style: bodyTextStyle(context, fontSize: 15)
                          .copyWith(color: hintGrey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.primary(
                            text: "Tidak",
                            backgroundColor: sGrey,
                            onPressed: () => Navigator.pop(context, false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton.primary(
                            text: "Iya",
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          return confirm == true;
        },
        onChangedCallback: (item) {
          if (item == null) return;

          setState(() {
            fieldComboRKonstruksiojk = item;
            previousKonstruksi = item;
            clearErr('form2.kelasKonstruksi');
          });
        },
        onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
      );

  Widget buildFieldRokupasiId() => ReusableComboBoxV2<ComboROkupasiModel>(
        hintText: "Okupasi",
        comboKey: comboROkupasiKey,
        initItem: fieldComboROkupasi,
        loader: (q) => ComboROkupasiRepository().getComboROkupasi(q.searchText),
        displayText: (item) => '${item.kodeOjk} - ${item.okupasiDesc}',
        compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.okupasi'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboROkupasi = v;
            clearErr('form2.okupasi');
            _clearValidationPreviewChangedFields([
              'form2.okupasi',
              'form4.siOther',
            ]);

            fieldComboRKonstruksiojk = null;
            previousKonstruksi = null;
            clearErr('form2.kelasKonstruksi');
          });
          if (v != null) {
            regpar2formbloc?.add(
              ComboROkupasiChangedEvent(comboROkupasi: v),
            );
          }
        },
        onSaveCallback: (value) => fieldComboROkupasi = value,
      );

  Widget buildFieldObjectAlamat() => appTextField(
        label: "Alamat lokasi Risiko",
        controller: fieldObjectAlamatController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z ,./\-#()]")),
        ],

        // error-map pattern
        errorText: err('form2.alamatRumah'),
        validator: (_) => err('form2.alamatRumah'),

        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('form2.alamatRumah');
        },
      );

  Widget buildFieldObjectPropinsiId() =>
      ReusableComboBoxV2<ComboMPropinsiModel>(
        hintText: "Provinsi",
        comboKey: comboMPropinsiKey,
        initItem: fieldComboMPropinsi,
        loader: (q) =>
            ComboMPropinsiRepository().getComboMPropinsi(q.searchText),
        displayText: (i) => i.propinsiNama,
        compareItems: (a, b) => a.mpropinsiId == b.mpropinsiId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.provinsi'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMPropinsi = v;
            if (v != null) {
              clearErr('form2.provinsi');
              fieldComboMKota = null;
              fieldComboMKecamatan = null;
              fieldComboMKelurahan = null;
              clearErr('form2.kota');
              clearErr('form2.kecamatan');
              clearErr('form2.kelurahan');
            }
          });
          if (v != null) {
            regpar2formbloc?.add(
              ComboMPropinsiChangedEvent(comboMPropinsi: v),
            );
          }
        },
        onSaveCallback: (value) => fieldComboMPropinsi = value,
      );

  Widget buildFieldObjectKotaId() => ReusableComboBoxV2<ComboMKotaModel>(
        hintText: "Kota",
        comboKey: comboMKotaKey,
        initItem: fieldComboMKota,
        isEnabled: fieldComboMPropinsi != null,
        dependencyKey: fieldComboMPropinsi?.mpropinsiId,
        params: {
          "mpropinsiId": fieldComboMPropinsi?.mpropinsiId ?? "",
        },
        loader: (q) {
          final mpropinsiId = q.get<String>("mpropinsiId") ?? "";
          return ComboMKotaRepository()
              .getComboMKota(mpropinsiId, q.searchText);
        },
        displayText: (i) => i.kotaDesc,
        compareItems: (a, b) => a.mkotaId == b.mkotaId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.kota'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMKota = v;
            if (v != null) {
              clearErr('form2.kota');
              fieldComboMKecamatan = null;
              fieldComboMKelurahan = null;
              clearErr('form2.kecamatan');
              clearErr('form2.kelurahan');
            }
          });
          if (v != null) {
            regpar2formbloc?.add(
              ComboMKotaChangedEvent(comboMKota: v),
            );
          }
        },
        onSaveCallback: (value) => fieldComboMKota = value,
      );

  Widget buildFieldObjectKecamatanId() =>
      ReusableComboBoxV2<ComboMKecamatanModel>(
        hintText: "Kecamatan",
        comboKey: comboMKecamatanKey,
        initItem: fieldComboMKecamatan,
        isEnabled: fieldComboMKota != null,
        dependencyKey: fieldComboMKota?.mkotaId,
        params: {
          "mkotaId": fieldComboMKota?.mkotaId ?? "",
        },
        loader: (q) {
          final mkotaId = q.get<String>("mkotaId") ?? "";
          return ComboMKecamatanRepository()
              .getComboMKecamatan(mkotaId, q.searchText);
        },
        displayText: (i) => i.kecamatanNama,
        compareItems: (a, b) => a.mkecamatanId == b.mkecamatanId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.kecamatan'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMKecamatan = v;
            if (v != null) {
              clearErr('form2.kecamatan');
              fieldComboMKelurahan = null;
              clearErr('form2.kelurahan');
            }
          });
          if (v != null) {
            regpar2formbloc?.add(
              ComboMKecamatanChangedEvent(comboMKecamatan: v),
            );
          }
        },
        onSaveCallback: (value) => fieldComboMKecamatan = value,
      );

  Widget buildFieldObjectKelurahanId() =>
      ReusableComboBoxV2<ComboMKelurahanModel>(
        hintText: "Kelurahan",
        comboKey: comboMKelurahanKey,
        initItem: fieldComboMKelurahan,
        isEnabled: fieldComboMKecamatan != null,
        dependencyKey: fieldComboMKecamatan?.mkecamatanId,
        params: {
          "mkecamatanId": fieldComboMKecamatan?.mkecamatanId ?? "",
        },
        loader: (q) {
          final mkecamatanId = q.get<String>("mkecamatanId") ?? "";
          return ComboMKelurahanRepository()
              .getComboMKelurahan(mkecamatanId, q.searchText);
        },
        displayText: (i) => i.kelurahanNama,
        compareItems: (a, b) => a.mkelurahanId == b.mkelurahanId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.kelurahan'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMKelurahan = v;
            if (v != null) {
              clearErr('form2.kelurahan');
            }
          });
          if (v != null) {
            regpar2formbloc?.add(
              ComboMKelurahanChangedEvent(comboMKelurahan: v),
            );
          }
        },
        onSaveCallback: (value) => fieldComboMKelurahan = value,
      );

  //form2

  //form3
  Widget buildFieldIsEq() => CheckboxWidget(
        rightLabel: "Gempa Bumi",
        initialValue: toBoolean(fieldIsEqController.text),
        callback: (v) => fieldIsEqController.text = v.toString(),
        leftLabel: "",
        enabled: !_lockCheckboxes,
      );

  Widget buildFieldIsFlexas() => CheckboxWidget(
        leftLabel: "",
        rightLabel: "Kebakaran/Petir",
        initialValue: toBoolean(fieldIsFlexasController.text),
        callback: (v) => fieldIsFlexasController.text = v.toString(),
        enabled: !_lockCheckboxes,
      );

  Widget buildFieldIsOther() => CheckboxWidget(
        leftLabel: "",
        rightLabel: "Lain-Lain",
        initialValue: toBoolean(fieldIsOtherController.text),
        callback: (v) => fieldIsOtherController.text = v.toString(),
        enabled: !_lockCheckboxes,
      );

  Widget buildFieldIsRsmdcc() => CheckboxWidget(
        leftLabel: "",
        rightLabel: "Kerusuhan",
        initialValue: toBoolean(fieldIsRsmdccController.text),
        callback: (v) => fieldIsRsmdccController.text = v.toString(),
        enabled: !_lockCheckboxes,
      );

  Widget buildFieldIsTsfwd() => CheckboxWidget(
        leftLabel: "",
        rightLabel: "Banjir",
        initialValue: toBoolean(fieldIsTsfwdController.text),
        callback: (v) => fieldIsTsfwdController.text = v.toString(),
        enabled: !_lockCheckboxes,
      );

  Widget buildFieldMjnscoverparId() =>
      ReusableComboBoxV2<ComboMJnscoverParModel>(
        hintText: "Jenis Jaminan",
        initItem: fieldComboMJnscoverPar,
        loader: (q) => ComboMJnscoverParRepository().getComboMJnscoverPar(),
        clientSideSearch: true,
        displayText: (i) => i.jenisNama,
        compareItems: (a, b) => a.mjnscoverparId == b.mjnscoverparId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.jenisJaminan'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMJnscoverPar = v;
            if (v != null) {
              clearErr('form3.jenisJaminan');
            }
            _applyCoverParRule(v?.mjnscoverparId);
          });
        },
        onSaveCallback: (value) => fieldComboMJnscoverPar = value,
      );

  Widget buildFieldMwilayahId() => ReusableComboBoxV2<ComboMWilayahModel>(
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
            if (v != null) {
              clearErr('form3.wilayah');
              fieldComboMKabZonaGempa = null;
              clearErr('form3.kab2zonagempaId');
            }
          });
          if (v != null) {
            regpar3formbloc?.add(
              ComboMWilayahChangedEvent(comboMWilayah: v),
            );
          }
        },
        onSaveCallback: (value) => fieldComboMWilayah = value,
      );

  Widget buildFieldKab2zonagempaId() =>
      ReusableComboBoxV2<ComboMKabZonaGempaModel>(
        hintText: "Zona Gempa Bumi",
        initItem: fieldComboMKabZonaGempa,
        comboKey: comboMKabZonaGempaKey,
        isEnabled: _showZonaGempa && fieldComboMWilayah != null,
        dependencyKey: fieldComboMWilayah?.mwilayahId,
        params: {
          "mwilayahId": fieldComboMWilayah?.mwilayahId ?? "",
        },
        loader: (query) {
          return ComboMKabZonaGempaRepository().getComboMKabZonaGempa(
            query.params["mwilayahId"] ?? "",
            query.searchText,
          );
        },
        displayText: (i) => i.kabupaten,
        compareItems: (a, b) => a.mkabzonagempaId == b.mkabzonagempaId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form3.kab2zonagempaId'),
        onChangedCallback: (v) {
          fieldComboMKabZonaGempa = v;
          if (v != null) {
            clearErr('form3.kab2zonagempaId');
          }
        },
        onSaveCallback: (value) => fieldComboMKabZonaGempa = value,
      );
  //form3

  //form4
  Widget _buildComboCurddId() => ReusableComboBoxV2<ComboRMatauangModel>(
        hintText: "Mata Uang",
        initItem: fieldComboRMatauang,
        loader: (q) => ComboRMatauangRepository().getComboRMatauang(),
        clientSideSearch: true,
        displayText: (item) => item.rmatauangSimbol,
        compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form4.mataUang'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboRMatauang = v;
            _defaultCurrencyApplied = false;
            _clearValidationPreviewChangedFields(['form4.mataUang']);
            if (v != null) {
              clearErr('form4.mataUang');
            }
          });
        },
        onSaveCallback: (value) => fieldComboRMatauang = value,
      );

  Widget buildFieldSiBuilding() => appTextField(
        label: "Bangunan",
        controller: fieldSiBuildingController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],

        // error-map pattern
        errorText: err('form4.siBuilding'),
        validator: (_) => err('form4.siBuilding'),

        onChanged: (v) => _clearIfNonNegativeNumber('form4.siBuilding', v),
      );

  Widget buildFieldSiContent() => appTextField(
        label: "Inventaris",
        controller: fieldSiContentController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form4.siContent'),
        validator: (_) => err('form4.siContent'),
        onChanged: (v) => _clearIfNonNegativeNumber('form4.siContent', v),
      );

  Widget buildFieldSiMachinery() => appTextField(
        label: "Mesin",
        controller: fieldSiMachineryController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form4.siMachinery'),
        validator: (_) => err('form4.siMachinery'),
        onChanged: (v) => _clearIfNonNegativeNumber('form4.siMachinery', v),
      );

  Widget buildFieldSiOther() => appTextField(
        label: "Total",
        controller: fieldSiOtherController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form4.siOther'),
        validator: (_) => err('form4.siOther'),
        onChanged: (v) => _clearIfNonNegativeNumber('form4.siOther', v),
      );

  Widget buildFieldSiStock() => appTextField(
        label: "Stok",
        controller: fieldSiStockController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form4.siStock'),
        validator: (_) => err('form4.siStock'),
        onChanged: (v) => _clearIfNonNegativeNumber('form4.siStock', v),
      );
  //form4

  //form5
  Widget buildFieldDiskonNilai() => appTextField(
        label: "Diskon Nilai",
        controller: fieldDiskonNilaiController,
        keyboardType: TextInputType.number,
        enabled: false,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.diskonNilai'),
        validator: (_) => err('form7.diskonNilai'),
        onChanged: (v) => _clearIfNotEmpty('form7.diskonNilai', v),
      );

  Widget buildFieldDiskonPersen() => appTextField(
        label: "Diskon Persen",
        controller: fieldDiskonPersenController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.diskonPersen'),
        validator: (_) => err('form7.diskonPersen'),
        onChanged: (v) => _clearIfNotEmpty('form7.diskonPersen', v),
      );

  Widget buildFieldPremiEqvet() => appTextField(
        label: "Premi EQVET",
        controller: fieldPremiEqvetController,
        keyboardType: TextInputType.number,
        enabled: false,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiEqvet'),
        validator: (_) => err('form7.premiEqvet'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiEqvet', v),
      );

  Widget buildFieldPremiNet() => appTextField(
        label: "Premi Net",
        controller: fieldPremiNetController,
        keyboardType: TextInputType.number,
        enabled: false,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiNet'),
        validator: (_) => err('form7.premiNet'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiNet', v),
      );

  Widget buildFieldPremiOther() => appTextField(
        label: "Premi Lain-lain",
        controller: fieldPremiOtherController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiOther'),
        validator: (_) => err('form7.premiOther'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiOther', v),
      );

  Widget buildFieldPremiPar() => appTextField(
        label: "Premi PAR",
        controller: fieldPremiParController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiPar'),
        validator: (_) => err('form7.premiPar'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiPar', v),
      );

  Widget buildFieldPremiRsmdcc() => appTextField(
        label: "Premi RSMDCC",
        controller: fieldPremiRsmdccController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiRsmdcc'),
        validator: (_) => err('form7.premiRsmdcc'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiRsmdcc', v),
      );

  Widget buildFieldPremiTsfwd() => appTextField(
        label: "Premi TSFWD",
        controller: fieldPremiTsfwdController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiTsfwd'),
        validator: (_) => err('form7.premiTsfwd'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiTsfwd', v),
      );

  Widget buildFieldPremiTotal() => appTextField(
        label: "Premi Total",
        controller: fieldPremiTotalController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyTextInputFormatter.currency(
            locale: 'en',
            decimalDigits: 0,
            symbol: '',
          ),
        ],
        errorText: err('form7.premiTotal'),
        validator: (_) => err('form7.premiTotal'),
        onChanged: (v) => _clearIfNotEmpty('form7.premiTotal', v),
      );

  //form5

  void _clearIfNonNegativeNumber(String key, String v) {
    final clean = v.replaceAll(",", "").trim();
    final angka = double.tryParse(clean);
    if (angka != null && angka >= 0 && angka <= _maxSumInsuredValue) {
      clearErr(key);
    }
    _clearValidationPreviewForChangedFields([key, 'form4.siOther']);
  }

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

  void _clearIfNotEmpty(String key, String v) {
    if (v.trim().isNotEmpty) clearErr(key);
  }

  int sectionIndex(RegparSection s) => RegparSection.values.indexOf(s);

  double getProgressValue() {
    final done = [
      isForm1Complete(),
      isForm2Complete(),
      isForm3Complete(),
      isForm4Complete(),
      isForm6Complete(),
      isForm5Complete(), // premi (hasil)
    ].where((x) => x).length;

    return done / RegparSection.values.length;
  }

  bool isForm1Complete() =>
      fieldTtgNamaController.text.trim().isNotEmpty &&
      fieldTtgAlamatController.text.trim().isNotEmpty;

  bool isForm2Complete() =>
      fieldComboRKonstruksiojk != null &&
      fieldComboROkupasi != null &&
      fieldObjectAlamatController.text.trim().isNotEmpty &&
      fieldComboMPropinsi != null &&
      fieldComboMKota != null &&
      fieldComboMKecamatan != null &&
      fieldComboMKelurahan != null;

  bool isForm3Complete() {
    if (fieldComboMJnscoverPar == null) return false;
    if (fieldComboMWilayah == null) return false;

    if (_showZonaGempa && fieldComboMKabZonaGempa == null) {
      return false;
    }

    return true;
  }

  bool isForm4Complete() {
    if (fieldComboRMatauang == null) return false;

    double n(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '').trim()) ?? 0;

    // minimal salah satu SI > 0 (atau aturan kamu)
    final a = n(fieldSiBuildingController);
    final b = n(fieldSiContentController);
    final c1 = n(fieldSiMachineryController);
    final d = n(fieldSiStockController);
    final e = n(fieldSiOtherController);

    return (a > 0 || b > 0 || c1 > 0 || d > 0 || e > 0);
  }

  bool isForm6Complete() {
    final st = context.read<RegparUploadFotoObjectBloc>().state;
    return st.items.isNotEmpty;
  }

  bool isForm5Complete() {
    // premi sudah ada hasil dari backend
    return context.read<Regpar5FormBloc>().state.record != null;
  }

  int getOpenedIndex() => expanded.indexWhere((e) => e);

  void openSection(
    RegparSection section, {
    VoidCallback? onRefresh,
    bool showLoading = false,
  }) {
    final idx = sectionIndex(section);
    setState(() {
      expanded = List.filled(expanded.length, false);
      expanded[idx] = true;
      if (showLoading) {
        _sectionLoadings.add(section);
      }
    });
    onRefresh?.call();
  }

  bool validateOpenedSection() {
    final opened = getOpenedIndex();
    if (opened < 0) return true;

    final section = RegparSection.values[opened];
    switch (section) {
      case RegparSection.form1:
        return validateForm1();
      case RegparSection.form2:
        return validateForm2();
      case RegparSection.form3:
        return validateForm3();
      case RegparSection.form4:
        return validateForm4();
      case RegparSection.form6:
        final ok6 = isForm6Complete();
        if (!ok6) {
          setState(() => _showVal6 = true);
        }
        return ok6;
      case RegparSection.form5:
        return true; // hasil
    }
  }

  void tryOpenSection(
    RegparSection target, {
    VoidCallback? onRefresh,
    bool showLoading = false,
  }) {
    final targetIdx = sectionIndex(target);
    final opened = getOpenedIndex();
    if (opened == targetIdx) return;

    final ok = validateOpenedSection();
    if (!ok) return;

    openSection(target, onRefresh: onRefresh, showLoading: showLoading);
  }
}
