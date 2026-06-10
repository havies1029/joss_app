import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar_upload_foto_object_bloc.dart';
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
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/dropdown2.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import 'konfirmasi_regpar_page.dart';

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
  late List<bool> expanded;


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

  bool _lockCheckboxes = true;

  void _setBool(TextEditingController c, bool v) {
    c.text = v.toString();
  }

  void _applyCoverParRule(String? mjnscoverparId) {
    // default: tidak ada yg kecentang, tidak terkunci
    if (mjnscoverparId == null) {
      setState(() {
        _lockCheckboxes = false;
        _setBool(fieldIsEqController, false);
        _setBool(fieldIsTsfwdController, false);
        _setBool(fieldIsFlexasController, false);
        _setBool(fieldIsOtherController, false);
        _setBool(fieldIsRsmdccController, false);
      });
      return;
    }

    if (mjnscoverparId == "10") {
      // dengan gempa: semua centang termasuk gempa
      setState(() {
        _lockCheckboxes = true;
        _setBool(fieldIsEqController, true);
        _setBool(fieldIsTsfwdController, true);
        _setBool(fieldIsFlexasController, true);
        _setBool(fieldIsOtherController, true);
        _setBool(fieldIsRsmdccController, true);
      });
    } else if (mjnscoverparId == "20") {
      // tanpa gempa: semua centang selain gempa
      setState(() {
        _lockCheckboxes = true;
        _setBool(fieldIsEqController, false);
        _setBool(fieldIsTsfwdController, true);
        _setBool(fieldIsFlexasController, true);
        _setBool(fieldIsOtherController, true);
        _setBool(fieldIsRsmdccController, true);
      });
    } else {
      // id lain: balik ke default (atau sesuai kebutuhan)
      setState(() {
        _lockCheckboxes = false;
        _setBool(fieldIsEqController, false);
        _setBool(fieldIsTsfwdController, false);
        _setBool(fieldIsFlexasController, false);
        _setBool(fieldIsOtherController, false);
        _setBool(fieldIsRsmdccController, false);
      });
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
  final fieldTtgAlamatController = TextEditingController();
  final fieldTtgNamaController = TextEditingController();
  //form1

  //form2

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
  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day);
  //form2

  //form3
  final fieldIsEqController = TextEditingController();
  final fieldIsFlexasController = TextEditingController();
  final fieldIsOtherController = TextEditingController();
  final fieldIsRsmdccController = TextEditingController();
  final fieldIsTsfwdController = TextEditingController();

  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  final comboMKabZonaGempaKey = GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();
  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  final comboMJnscoverParKey = GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>();
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
  final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
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
  //form5

  @override
  void initState() {
    super.initState();

    expanded = List.filled(RegparSection.values.length, false);
    expanded[sectionIndex(RegparSection.form1)] = true;

    final regpar1 = context.read<Regpar1CrudBloc>().state.record?.regpar1Id ?? "";
    regpar1Id = widget.regpar1Id ?? regpar1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    });

    //reset foto dari record lama
    context.read<RegparUploadFotoObjectBloc>().add(RegparUploadReset());
  }

  @override
  void dispose() {
    // form1
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

  void _payloadform1(Regpar1CrudModel record) {
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
        debugPrint('⚠️ Polis invalid dari backend (mulai==akhir). Abaikan polisAkhir backend.');
      }

      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(
        DateTime(mulai.year, mulai.month, mulai.day), // normalize
      ));

      if (fieldComboRKonstruksiojk == null && record.comboRKonstruksiojk != null) {
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
      if (fieldComboMKabZonaGempa == null && record.comboMKabZonaGempa != null) {
        fieldComboMKabZonaGempa = record.comboMKabZonaGempa;
      }


      final jnsCoverPar = record.comboMJnscoverPar;
      if (fieldComboMJnscoverPar == null && jnsCoverPar != null) {
        fieldComboMJnscoverPar = jnsCoverPar;
        _applyCoverParRule(jnsCoverPar.mjnscoverparId); // ✅ sync dari data
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
      if (fieldComboRMatauang == null && record.comboRMatauang != null) {
        fieldComboRMatauang = record.comboRMatauang;
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

  bool _isLanjutkanLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
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
        title: "Properti",
        blocListeners: [
          BlocListener<Regpar1CrudBloc, Regpar1CrudState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regpar1Id = state.record!.regpar1Id;
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform1(state.record!);
              }
            },
          ),

          BlocListener<Regpar2FormBloc, Regpar2FormState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regpar2Id = state.record!.regpar2Id;
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform2(state.record!);
              }
            },
          ),

          BlocListener<Regpar3FormBloc, Regpar3FormState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regpar3Id = state.record!.regpar3Id;
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform3(state.record!);
              }
            },
          ),

          BlocListener<Regpar4FormBloc, Regpar4FormState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regpar4Id = state.record!.regpar1Id;//anomali
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform4(state.record!);
              }
            },
          ),

          BlocListener<Regpar5FormBloc, Regpar5FormState>(
            listenWhen: (prev, curr) =>
            prev.isCalculated != curr.isCalculated ||
                prev.hasFailure != curr.hasFailure,
            listener: (context, state) {
              if (state.hasFailure) {
                if (mounted) {
                  setState(() {
                    _isHitungPremiLoading = false;
                  });
                }
                return;
              }

              final rec = state.record;
              if (!state.isCalculated || rec == null) return;

              if (mounted) {
                setState(() {
                  _isHitungPremiLoading = false;
                  regpar5Id = rec.regpar5Id;
                });
              }

              _payloadform5(rec);
              openPremiSection(recordId: regpar1Id);
            },
          ),
        ],
        child: _buildForm(),
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
    final bool canShowLanjutkan = isAllFormComplete();
    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: SingleChildScrollView(
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
                    onRefresh: () {
                      if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                        refreshForm1(recordId: regpar1Id);
                      }
                    },
                    child: Column(
                      children: [
                        buildFieldTtgNama(),
                        const SizedBox(height: hPadding),
                        buildFieldTtgAlamat(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: hPadding),

                  Form2Page(
                    context: context,
                    title: "Informasi Polis",
                    isExpanded: expanded[1],
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
                            const SizedBox(width: hPadding,),
                            Flexible(child: buildFieldPolisBerakhir()),
                          ],
                        ),
                        const SizedBox(height: hPadding,),
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
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form3Page(
                    context: context,
                    title: "Pertanggungan",
                    isExpanded: expanded[2],
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
                        const SizedBox(height: hPadding),
                        buildFieldKab2zonagempaId(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form4Page(
                    context: context,
                    title: "Nilai Pertanggungan",
                    isExpanded: expanded[3],
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
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form6Page(
                    context: context,
                    title: "Upload Foto Bangunan",
                    isExpanded: expanded[4],
                    onRefresh: () {
                      if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                        refreshForm6(recordId: regpar1Id);
                      }
                    },
                    child: Column(
                      children: [
                        BlocBuilder<RegparUploadFotoObjectBloc, RegParUploadFotoObjectState>(
                          buildWhen: (p, c) => p.items.length != c.items.length,
                          builder: (context, state) {
                            if (_showVal6 && state.items.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() => _showVal6 = false);
                              });
                            }

                            return Regpar6StoragePickerSectionWidget(
                              showRequiredError: _showVal6 && state.items.isEmpty,
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
                    child: (hasForm5Record)
                        ? Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "RATE",
                            style: bodyTextStyle(context).copyWith(
                              color: primaryLightColor,
                              fontSize: getResponsiveFont(context, 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        HitungPremiWidget(
                          rows: [
                            HitungPremiRow(
                              label: "Kebakaran:",
                              controller: fieldRateParController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Kerusuhan:",
                              controller: fieldRateRsmdccController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Banjir:",
                              controller: fieldRateTsfwdController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Gempa Bumi:",
                              controller: fieldRateEqvetController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Lain-Lain:",
                              controller: fieldRateOtherController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Total Rate:",
                              controller: fieldRateTotalController,
                              layoutType: HitungPremiLayoutType.horizontal,
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
                              label: "PERHITUNGAN PREMI\n(Asuransi PAR Termasuk EQVET)",
                              description: "${fieldComboRMatauang?.rmatauangSimbol} ${formatControllerNumber(fieldSumInsuredController)} x ${fieldRateTotalController.text}% =",
                              controller: fieldPremiTotalController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
                              showValueBorder: true,
                              formatNumber: true,
                            ),
                            HitungPremiRow(
                              label: "DISKON",
                              controller: fieldDiskonNilaiController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
                              showValueBorder: true,
                              formatNumber: true,
                            ),
                            HitungPremiRow(
                              label: "BIAYA POLIS",
                              controller: fieldBiayaPolisController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
                              showValueBorder: true,
                              formatNumber: true,
                            ),
                            HitungPremiRow(
                              label: "BIAYA MATERAI",
                              controller: fieldBiayaMateraiController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
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
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
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
                        : const SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Klik Hitung Premi untuk melihat hasil."),
                      ),
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  if (canShowLanjutkan) ...[
                    AppButton.iconRight(
                      text: "Lanjutkan",
                      icon: Icon(Icons.arrow_forward),
                      isLoading: _isLanjutkanLoading,
                      onPressed: _isLanjutkanLoading
                          ? null
                          : () async {
                        setState(() {
                          _isLanjutkanLoading = true;
                        });

                        try {

                          draftForm1ToBloc(context);
                          draftForm2ToBloc(context);
                          draftForm3ToBloc(context);
                          draftForm4ToBloc(context);

                          context.read<RegparFlowBloc>().add(RegparFlowStartEvent());

                          await Future.delayed(const Duration(seconds: 2));

                          if (!mounted) return;

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KonfirmasiRegParPage(
                                recordId: regpar1Id ?? '',
                                viewMode: 'ubah',
                              ),
                            ),
                          );
                        } finally {
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
    );
  }

  Widget Form1Page({
    required BuildContext context,
    required bool isExpanded,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegparSection.form1, onRefresh: onRefresh);
            },

          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form2Page({
    required BuildContext context,
    required bool isExpanded,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegparSection.form2, onRefresh: onRefresh);
            },

          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form3Page({
    required BuildContext context,
    required bool isExpanded,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegparSection.form3, onRefresh: onRefresh);
            },

          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form4Page({
    required BuildContext context,
    required bool isExpanded,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegparSection.form4, onRefresh: onRefresh);
            },

          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form5Page({
    required BuildContext context,
    required bool isExpanded,
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
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 15,
              ),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget Form6Page({
    required BuildContext context,
    required bool isExpanded,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegparSection.form6, onRefresh: onRefresh);
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
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
      rokupasiId: fieldComboROkupasi?.rokupasiId,
      regpar1Id: widget.regpar1Id!,
      objectAlamat: fieldObjectAlamatController.text ?? '',
      objectPropinsiId: fieldComboMPropinsi?.mpropinsiId,
      objectKotaId: fieldComboMKota?.mkotaId,
      objectKecamatanId: fieldComboMKecamatan?.mkecamatanId,
      objectKelurahanId: fieldComboMKelurahan?.mkelurahanId,
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
      kab2zonagempaId: fieldComboMKabZonaGempa?.mkabzonagempaId,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
      regpar3Id: regpar1Id ?? "",
    );

    debugPrint("[draftForm3ToBloc] record => ${record.toJson()}");

    context.read<Regpar3FormBloc>().add(Regpar3DraftEvent(record: record));
  }

  void draftForm4ToBloc(BuildContext context) {
    final record = Regpar4FormModel(
      regpar1Id: regpar1Id ?? "",
      currId: fieldComboRMatauang?.rmatauangKode,
      siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
      siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
      siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
      siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
      siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
    );

    debugPrint("[draftForm4ToBloc] record => ${record.toJson()}");

    context.read<Regpar4FormBloc>().add(Regpar4DraftEvent(record: record));
  }

  bool _isHitungPremiLoading = false;

  Widget buildButtonHitungPremi() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: AppButton.primary(
      text: "Hitung Premi",
      isLoading: _isHitungPremiLoading,
      backgroundColor:
      _isHitungPremiLoading ? secondaryBlackColor : primaryColor,
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

  void openForm1({required String? recordId}) =>
    openSection(RegparSection.form1, onRefresh: () => refreshForm1(recordId: recordId));

  void openForm2({required String? recordId}) =>
      openSection(RegparSection.form2, onRefresh: () => refreshForm2(recordId: recordId));

  void openForm3({required String? recordId}) =>
      openSection(RegparSection.form3, onRefresh: () => refreshForm3(recordId: recordId));

  void openForm4({required String? recordId}) =>
      openSection(RegparSection.form4, onRefresh: () => refreshForm4(recordId: recordId));

  void openUploadFotoSection({required String? recordId}) =>
      openSection(RegparSection.form6, onRefresh: () => refreshForm6(recordId: recordId)); // catatan: ini Form6

  void openPremiSection({required String? recordId}) =>
    openSection(
      RegparSection.form5,
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

    if (fieldComboMKabZonaGempa == null) {
      setErr('form3.zonaGempa', kStringNullError);
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

    bool validateMoneyNonNegativeRequired({
      required String key,
      required TextEditingController controller,
    }) {
      final raw = controller.text.trim();
      if (raw.isEmpty) {
        setErr(key, kStringNullError);
        return false;
      }

      final clean = raw.replaceAll(",", "");
      final x = double.tryParse(clean);

      if (x == null) {
        setErr(key, "Format tidak valid");
        return false;
      }

      if (x < 0) {
        setErr(key, "Tidak boleh minus");
        return false;
      }

      if (hasLeadingZero(clean)) {
        setErr(key, "Format tidak disarankan (diawali 0)");
      }

      return true; // >= 0 OK
    }

    // SI fields (required, >= 0)
    if (!validateMoneyNonNegativeRequired(
      key: 'form4.siBuilding',
      controller: fieldSiBuildingController,
    )) {
      ok = false;
    }

    if (!validateMoneyNonNegativeRequired(
      key: 'form4.siContent',
      controller: fieldSiContentController,
    )) {
      ok = false;
    }

    if (!validateMoneyNonNegativeRequired(
      key: 'form4.siMachinery',
      controller: fieldSiMachineryController,
    )) {
      ok = false;
    }

    if (!validateMoneyNonNegativeRequired(
      key: 'form4.siOther',
      controller: fieldSiOtherController,
    )) {
      ok = false;
    }

    if (!validateMoneyNonNegativeRequired(
      key: 'form4.siStock',
      controller: fieldSiStockController,
    )) {
      ok = false;
    }

    if (!ok) {
      openSection(RegparSection.form4);
    }

    return ok;
  }

  //form1
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
        final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
        onChangedCallback: (item) async {
          if (item == null) return;
          final oldKonstruksi = previousKonstruksi;
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
          if (confirm == true) {
            setState(() {
              fieldComboRKonstruksiojk = item;
              previousKonstruksi = item;
              clearErr('form2.kelasKonstruksi');
            });
          } else {
            setState(() {
              comboRKonstruksiojkKey.currentState?.clear();
              fieldComboRKonstruksiojk = oldKonstruksi;
            });
          }
        },
        onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
      );

  Widget buildFieldRokupasiId() =>
      ReusableComboBoxV2<ComboROkupasiModel>(
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

            fieldComboRKonstruksiojk = null;
            previousKonstruksi = null;
            comboRKonstruksiojkKey.currentState?.clear();
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
        loader: (q) => ComboMPropinsiRepository().getComboMPropinsi(q.searchText),
        displayText: (i) => i.propinsiNama,
        compareItems: (a, b) => a.mpropinsiId == b.mpropinsiId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form2.provinsi'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMPropinsi = v;
            if (v != null) {
              clearErr('form2.provinsi');
              comboMKotaKey.currentState?.clear();
              comboMKecamatanKey.currentState?.clear();
              comboMKelurahanKey.currentState?.clear();
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

  Widget buildFieldObjectKotaId() =>
      ReusableComboBoxV2<ComboMKotaModel>(
        hintText: "Kota",
        comboKey: comboMKotaKey,
        initItem: fieldComboMKota,
        params: {
          "mpropinsiId": fieldComboMPropinsi?.mpropinsiId ?? "",
        },
        loader: (q) {
          final mpropinsiId = q.get<String>("mpropinsiId") ?? "";
          return ComboMKotaRepository().getComboMKota(mpropinsiId);
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
              comboMKecamatanKey.currentState?.clear();
              comboMKelurahanKey.currentState?.clear();
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
        params: {
          "mkotaId": fieldComboMKota?.mkotaId ?? "",
        },
        loader: (q) {
          final mkotaId = q.get<String>("mkotaId") ?? "";
          return ComboMKecamatanRepository().getComboMKecamatan(mkotaId);
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
              comboMKelurahanKey.currentState?.clear();
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
        params: {
          "mkecamatanId": fieldComboMKecamatan?.mkecamatanId ?? "",
        },
        loader: (q) {
          final mkecamatanId = q.get<String>("mkecamatanId") ?? "";
          return ComboMKelurahanRepository().getComboMKelurahan(mkecamatanId);
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
  Widget  buildFieldIsEq() => CheckboxWidget(
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

  Widget buildFieldMwilayahId() =>
      ReusableComboBoxV2<ComboMWilayahModel>(
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
              comboMKabZonaGempaKey.currentState?.clear();
              clearErr('form3.zonaGempa');
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
  Widget _buildComboCurddId() =>
      ReusableComboBoxV2<ComboRMatauangModel>(
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
    if (angka != null && angka >= 0) clearErr(key);
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

  bool isForm3Complete() =>
      fieldComboMJnscoverPar != null &&
      fieldComboMWilayah != null &&
      fieldComboMKabZonaGempa != null;

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

  void openSection(RegparSection section, {VoidCallback? onRefresh}) {
    final idx = sectionIndex(section);
    setState(() {
      expanded = List.filled(expanded.length, false);
      expanded[idx] = true;
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

  void tryOpenSection(RegparSection target, {VoidCallback? onRefresh}) {
    final targetIdx = sectionIndex(target);
    final opened = getOpenedIndex();
    if (opened == targetIdx) return;

    final ok = validateOpenedSection();
    if (!ok) return;

    openSection(target, onRefresh: onRefresh);
  }

}