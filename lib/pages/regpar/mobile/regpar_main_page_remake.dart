import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar_upload_foto_object_bloc.dart';
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
import '../../../blocs/regpar/regpar6form_bloc.dart';
import '../../../blocs/regpar/regpar_flow_bloc.dart';
import '../../../common/app_data.dart';
import '../../../common/constants.dart';
import '../../../common/thousand_separator_input_formatter.dart';
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
import '../../../models/regpar/regpar6cari_model.dart';
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
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import 'konfirmasi_regpar_page.dart';


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
  List<bool> expanded = [false, false, false, false, false, false];


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


  Regpar6FormBloc? regpar6formBloc;
  bool _form6HasError = false;
  String? _form6ErrorText;

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


  double getProgressValue() {
    final openedCount = expanded.where((v) => v).length;
    return openedCount / 6;
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
  //form5

  //form6
  List<Uint8List> _imagesRegpar6 = [];
  List<String> _fileNamesRegpar6 = [];
  List<Regpar6CariModel> _serverPhotosRegpar6 = [];
  final Set<String> _deletingServerIdsRegpar6 = {};
  //form6

  @override
  void initState() {
    super.initState();
    final regpar1 = context.read<Regpar1CrudBloc>().state.record?.regpar1Id ?? "";
    regpar1Id = widget.regpar1Id ?? regpar1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    });
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
        title: "Properti", // sesuaikan judulmu
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
            listener: (context, state) {
              if (state.record != null) {
                _payloadform5(state.record!);

                openForm6(recordId: regpar1Id);
                //
                // if (state.isLoaded) {
                //   setState(() {
                //     regpar6Id = state.record!.regpar6Id;
                //   });
                //
                //   _payloadform6(state.record!);
                //
                //   // if (state.record!.regpar6Id.isNotEmpty) {
                //   //   openForm7();
                //   // }
                //   openForm7();
                // }

                if (state.isSaved) {
                  setState(() {
                    regpar5Id = state.record!.regpar5Id;
                  });

                  if (state.record!.regpar5Id.isNotEmpty) {
                    openForm6(recordId: regpar1Id);
                  }
                }
              }
            },
          ),


          BlocListener<Regpar6CariBloc, Regpar6CariState>(
            listener: (context, state) {

              if (state.status == ListStatus.success) {
                debugPrint("✅ Regpar4CariBloc SUCCESS");
                setState(() => _serverPhotosRegpar6 = List.from(state.items));
              }
            },
          ),

          BlocListener<RegparUploadFotoObjectBloc, RegparUploadFotoObjectState>(
            listener: (context, state) {

              if (state is UploadFotoObjectListPreview) {
                debugPrint("fileNames length: ${state.fileNames.length}");

                setState(() {
                  _imagesRegpar6 = List.from(state.images);
                  _fileNamesRegpar6 = List.from(state.fileNames);
                });
              }

              if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                debugPrint("🔄 refreshForm6 CALLED (general)");
                refreshForm6(recordId: regpar1Id);
              }

              if (state is UploadFotoObjectSuccess) {
                debugPrint("✅ UploadFotoObjectSuccess");

                if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                  debugPrint("🔄 refreshForm4 CALLED (success)");
                  refreshForm6(recordId: regpar1Id);
                }
              }

              if (state is UploadFotoObjectFailure) {
                debugPrint("❌ UploadFotoObjectFailure: ${state.error}");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),

          BlocListener<Regpar6FormBloc, Regpar6FormState>(
            listener: (context, state) {

              if (state.isSaved) {
                _deletingServerIdsRegpar6.clear();

                if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                  refreshForm6(recordId: regpar1Id);
                }
              }

              if (state.hasFailure) {
                debugPrint("❌ Delete FAILURE");

                _deletingServerIdsRegpar6.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus foto. Mengambil ulang data..."),
                    backgroundColor: Colors.red,
                  ),
                );

                if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                  debugPrint("🔄 refreshForm6 CALLED (delete failure)");
                  refreshForm6(recordId: regpar1Id);
                }
              }
            },
          ),

        ],
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    final bool hasForm5Record =
        context.read<Regpar5FormBloc>().state.record != null;
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
                    onToggle: (v) => setState(() => expanded[0] = v),
                    onRefresh: () {
                      if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                        refreshForm1(recordId: regpar1Id);
                      }
                    },
                    child: Column(
                      children: [
                        buildFieldTtgAlamat(),
                        const SizedBox(height: hPadding),
                        buildFieldTtgNama(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: hPadding),

                  Form2Page(
                    context: context,
                    title: "Informasi Polis",
                    isExpanded: expanded[1],
                    onToggle: (v) => setState(() => expanded[1] = v),
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
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form3Page(
                    context: context,
                    title: "Pertanggungan",
                    isExpanded: expanded[2],
                    onToggle: (v) => setState(() => expanded[2] = v),
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
                    onToggle: (v) => setState(() => expanded[3] = v),
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
                    title: "Upload Foto Objek",
                    isExpanded: expanded[4],
                    onToggle: (v) => setState(() => expanded[4] = v),
                    onRefresh: () {
                      if (regpar1Id != null && regpar1Id!.isNotEmpty) {
                        refreshForm6(recordId: regpar1Id);
                      }
                    },
                    child: Column(
                      children: [
                        _buildBodyForm6(),
                        const SizedBox(height: 15),
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
                    onToggle: (v) => setState(() => expanded[5] = v),
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
                              controller: fieldPremiNetController,
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
                              label: "TOTAL PREMI",
                              controller: fieldPremiTotalController,
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

                  if (hasForm5Record) ...[
                    AppButton.iconRight(
                      text: "Lanjutkan",
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KonfirmasiRegParPage(
                              recordId: regpar1Id ?? '',
                              viewMode: 'ubah',
                            ),
                          ),
                        );
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
    required ValueChanged<bool> onToggle,
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
              onToggle(!isExpanded);
              onRefresh?.call();
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
    required ValueChanged<bool> onToggle,
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
              onToggle(!isExpanded);
              onRefresh?.call();
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
    required ValueChanged<bool> onToggle,
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
              onToggle(!isExpanded);
              onRefresh?.call();
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
    required ValueChanged<bool> onToggle,
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
              onToggle(!isExpanded);
              onRefresh?.call();
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
    required ValueChanged<bool> onToggle,
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
              onToggle(!isExpanded);
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
    required ValueChanged<bool> onToggle,
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
              onToggle(!isExpanded);
              onRefresh?.call();
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
      rokupasiId: fieldComboROkupasi?.rokupasiId, regpar1Id: widget.regpar1Id!, objectAlamat: fieldObjectAlamatController.text ?? '',
      objectPropinsiId: fieldComboMPropinsi?.mpropinsiId,
      objectKotaId: fieldComboMKota?.mkotaId,
      objectKecamatanId: fieldComboMKecamatan?.mkecamatanId,
      objectKelurahanId: fieldComboMKelurahan?.mkelurahanId,
    );

    context.read<Regpar2FormBloc>().add(Regpar2DraftEvent(record: record));
  }

  void draftForm3ToBloc(BuildContext context){
    final record = Regpar3FormModel(
      regpar1Id: regpar1Id ?? "",
      isEq: toBoolean(fieldIsEqController.text),
      isFlexas: toBoolean(fieldIsFlexasController.text),
      isOther: toBoolean(fieldIsOtherController.text),
      isRsmdcc: toBoolean(fieldIsRsmdccController.text),
      isTsfwd: toBoolean(fieldIsTsfwdController.text),
      kab2zonagempaId: fieldComboMKabZonaGempa?.mzonagempaId,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
      regpar3Id: regpar1Id ?? "",
    );
    context.read<Regpar3FormBloc>().add(Regpar3DraftEvent(record: record));
  }

  void draftForm4ToBloc(BuildContext context){
    final record = Regpar4FormModel(
      regpar1Id: regpar1Id ?? "",
      currId: fieldComboRMatauang?.rmatauangKode,
      siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
      siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
      siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
      siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
      siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
    );
    context.read<Regpar4FormBloc>().add(Regpar4DraftEvent(record: record));
  }

  Widget buildButtonHitungPremi() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: AppButton.primary(
      text: "Hitung Premi",
      onPressed: onHitungPremi,
    ),
  );

  Future<void>  onHitungPremi() async {
    final okForm1 = validateForm1();
    if (!okForm1) {
      openForm1(recordId: regpar1Id);
      return;
    }

    final ok2 = validateForm2();
    if (!ok2) {
      openForm2(recordId: regpar1Id);
      return;
    }

    final ok3 = validateForm3();
    if (!ok3) {
      openForm3(recordId: regpar1Id);
      return;
    }

    final ok4 = validateForm4();
    if (!ok4) {
      openForm4(recordId: regpar1Id);
      return;
    }

    final isUploading6 = context.read<RegparUploadFotoObjectBloc>().state is UploadFotoObjectLoading;
    final ok6 = !isUploading6 &&
        (_imagesRegpar6.isNotEmpty || _serverPhotosRegpar6.isNotEmpty);

    setState(() {
      _form6HasError = !ok6;
      _form6ErrorText = !ok6 ? 'Bagian ini wajib diisi' : null;
    });

    if (!ok6) {
      if (!ok6) openForm5(recordId: regpar1Id);
      return;
    }

    _onUploadPressedForm6();

    draftForm1ToBloc(context);
    draftForm2ToBloc(context);
    draftForm3ToBloc(context);
    draftForm4ToBloc(context);

    context.read<RegparFlowBloc>().add(RegparFlowStartEvent());
  }

  void openForm1({required String? recordId}) {
    setState(() {
      expanded = [true, false, false, false, false, false];
    });
    refreshForm1(recordId: recordId);
  }

  void openForm2({required String? recordId}) {
    setState(() {
      expanded = [false, true, false, false, false, false];
    });
    refreshForm2(recordId: recordId);
  }

  void openForm3({required String? recordId}) {
    setState(() {
      expanded = [false, false, true, false, false, false];
    });
    refreshForm3(recordId: recordId);
  }

  void openForm4({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, true, false, false];
    });
    refreshForm4(recordId: recordId);
  }

  void openForm5({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, false, true, false];
    });
    refreshForm6(recordId: recordId);
  }

  void openForm6({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, false, false, true];
    });
    // refreshForm5(recordId: recordId);
  }

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

    if (!ok) {
      setState(() => expanded[0] = true);
    }

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
    if (!ok) {
      setState(() => expanded[1] = true);
    }

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


    if (!ok) {
      setState(() => expanded[2] = true);
    }

    return ok;
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

      return true; // >= 0 OK
    }

    // SI fields (required, >= 0)
    if (!validateMoneyNonNegativeRequired(key: 'form4.siBuilding', controller: fieldSiBuildingController)) ok = false;
    if (!validateMoneyNonNegativeRequired(key: 'form4.siContent', controller: fieldSiContentController)) ok = false;
    if (!validateMoneyNonNegativeRequired(key: 'form4.siMachinery', controller: fieldSiMachineryController)) ok = false;
    if (!validateMoneyNonNegativeRequired(key: 'form4.siOther', controller: fieldSiOtherController)) ok = false;
    if (!validateMoneyNonNegativeRequired(key: 'form4.siStock', controller: fieldSiStockController)) ok = false;

    if (!ok) {
      setState(() => expanded[3] = true); // form4 panel index
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
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

  Widget buildFieldRkonstruksiojkId() => ReusableComboBox<ComboRKonstruksiojkModel>(
    hintText: "Kelas Konstruksi",
    initItem: fieldComboRKonstruksiojk,
    dataLoader: () => ComboRKonstruksiojkRepository().getComboRKonstruksiojk(),
    displayText: (i) => i.kelasNama,
    compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,

    validatorCallback: (_) => err('form2.kelasKonstruksi'),
    errorText: err('form2.kelasKonstruksi'),

    onChangedCallback: (v) {
      fieldComboRKonstruksiojk = v;
      if (v != null) clearErr('form2.kelasKonstruksi');

      if (v != null) {
        comboROkupasiKey.currentState?.clear();
        fieldComboROkupasi = null;
        clearErr('form2.okupasi');
      }
    },
    onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
  );

  Widget buildFieldRokupasiId() => ReusableComboBox<ComboROkupasiModel>(
    hintText: "Okupasi",
    comboKey: comboROkupasiKey,
    initItem: fieldComboROkupasi,
    dataLoader: () => ComboROkupasiRepository()
        .getComboROkupasi(fieldComboRKonstruksiojk?.rkonstruksiojkId ?? ""),
    displayText: (i) => i.okupasiDesc,
    compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
    validatorCallback: (_) => err('form2.okupasi'),
    errorText: err('form2.okupasi'),
    onChangedCallback: (v) {
      fieldComboROkupasi = v;
      if (v != null) {
        clearErr('form2.okupasi');
        regpar2formbloc?.add(ComboROkupasiChangedEvent(comboROkupasi: v));
      }
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

    // error-map pattern
    errorText: err('form2.alamatRumah'),
    validator: (_) => err('form2.alamatRumah'),

    onChanged: (v) {
      if (v.trim().isNotEmpty) clearErr('form2.alamatRumah');
    },
  );

  Widget buildFieldObjectPropinsiId() => ReusableComboBox<ComboMPropinsiModel>(
    hintText: "Provinsi",
    comboKey: comboMPropinsiKey,
    initItem: fieldComboMPropinsi,
    dataLoader: () => ComboMPropinsiRepository().getComboMPropinsi(""),
    displayText: (i) => i.propinsiNama,
    compareItems: (a, b) => a.mpropinsiId == b.mpropinsiId,

    validatorCallback: (_) => err('form2.provinsi'),
    errorText: err('form2.provinsi'),

    onChangedCallback: (v) {
      fieldComboMPropinsi = v;
      if (v != null) {
        clearErr('form2.provinsi');
        regpar2formbloc?.add(ComboMPropinsiChangedEvent(comboMPropinsi: v));

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
    },
    onSaveCallback: (value) => fieldComboMPropinsi = value,
  );

  Widget buildFieldObjectKotaId() => ReusableComboBox<ComboMKotaModel>(
    hintText: "Kota",
    comboKey: comboMKotaKey,
    initItem: fieldComboMKota,
    dataLoader: () => ComboMKotaRepository().getComboMKota(fieldComboMPropinsi?.mpropinsiId ?? ""),
    displayText: (i) => i.kotaDesc,
    compareItems: (a, b) => a.mkotaId == b.mkotaId,

    validatorCallback: (_) => err('form2.kota'),
    errorText: err('form2.kota'),

    onChangedCallback: (v) {
      fieldComboMKota = v;
      if (v != null) {
        clearErr('form2.kota');
        regpar2formbloc?.add(ComboMKotaChangedEvent(comboMKota: v));

        comboMKecamatanKey.currentState?.clear();
        comboMKelurahanKey.currentState?.clear();

        fieldComboMKecamatan = null;
        fieldComboMKelurahan = null;

        clearErr('form2.kecamatan');
        clearErr('form2.kelurahan');
      }
    },
    onSaveCallback: (value) => fieldComboMKota = value,
  );

  Widget buildFieldObjectKecamatanId() => ReusableComboBox<ComboMKecamatanModel>(
    hintText: "Kecamatan",
    comboKey: comboMKecamatanKey,
    initItem: fieldComboMKecamatan,
    dataLoader: () => ComboMKecamatanRepository().getComboMKecamatan(fieldComboMKota?.mkotaId ?? ""),
    displayText: (i) => i.kecamatanNama,
    compareItems: (a, b) => a.mkecamatanId == b.mkecamatanId,

    validatorCallback: (_) => err('form2.kecamatan'),
    errorText: err('form2.kecamatan'),

    onChangedCallback: (v) {
      fieldComboMKecamatan = v;
      if (v != null) {
        clearErr('form2.kecamatan');
        regpar2formbloc?.add(ComboMKecamatanChangedEvent(comboMKecamatan: v));

        comboMKelurahanKey.currentState?.clear();
        fieldComboMKelurahan = null;

        clearErr('form2.kelurahan');
      }
    },
    onSaveCallback: (value) => fieldComboMKecamatan = value,
  );

  Widget buildFieldObjectKelurahanId() => ReusableComboBox<ComboMKelurahanModel>(
    hintText: "Kelurahan",
    comboKey: comboMKelurahanKey,
    initItem: fieldComboMKelurahan,
    dataLoader: () => ComboMKelurahanRepository().getComboMKelurahan(fieldComboMKecamatan?.mkecamatanId ?? ""),
    displayText: (i) => i.kelurahanNama,
    compareItems: (a, b) => a.mkelurahanId == b.mkelurahanId,

    validatorCallback: (_) => err('form2.kelurahan'),
    errorText: err('form2.kelurahan'),

    onChangedCallback: (v) {
      fieldComboMKelurahan = v;
      if (v != null) {
        clearErr('form2.kelurahan');
        regpar2formbloc?.add(ComboMKelurahanChangedEvent(comboMKelurahan: v));
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

  Widget buildFieldMjnscoverparId() => ReusableComboBox<ComboMJnscoverParModel>(
    hintText: "Jenis Jaminan",
    initItem: fieldComboMJnscoverPar,
    dataLoader: () => ComboMJnscoverParRepository().getComboMJnscoverPar(),
    displayText: (i) => i.jenisNama,
    compareItems: (a, b) => a.mjnscoverparId == b.mjnscoverparId,

    validatorCallback: (_) => err('form3.jenisJaminan'),
    errorText: err('form3.jenisJaminan'),

    onChangedCallback: (v) {
      fieldComboMJnscoverPar = v;
      if (v != null) clearErr('form3.jenisJaminan');
      _applyCoverParRule(v?.mjnscoverparId);
    },
    onSaveCallback: (value) => fieldComboMJnscoverPar = value,
  );

  Widget buildFieldMwilayahId() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,

    validatorCallback: (_) => err('form3.wilayah'),
    errorText: err('form3.wilayah'),

    onChangedCallback: (v) {
      fieldComboMWilayah = v;
      if (v != null) {
        clearErr('form3.wilayah');
        fieldComboMKabZonaGempa = null;
        regpar3formbloc?.add(ComboMWilayahChangedEvent(comboMWilayah: v));
        comboMWilayahKey.currentState?.clear();
        clearErr('form3.zonaGempa');
      }
    },
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );

  Widget buildFieldKab2zonagempaId() => ReusableComboBox<ComboMKabZonaGempaModel>(
    hintText: "Zona gempa Bumi",
    initItem: fieldComboMKabZonaGempa,
    dataLoader: () {
      final wid = fieldComboMWilayah?.mwilayahId;
      final payload = (wid == null || wid.isEmpty) ? "" : "$wid|";
      return ComboMKabZonaGempaRepository().getComboMKabZonaGempa(payload);
    },
    dataLoaderWithFilter: (q) {
      final wid = fieldComboMWilayah?.mwilayahId;
      if (wid == null || wid.isEmpty) return ComboMKabZonaGempaRepository().getComboMKabZonaGempa("");
      final queryUser = (q ?? "").trim();
      return ComboMKabZonaGempaRepository().getComboMKabZonaGempa("$wid|$queryUser");
    },
    serverSearchMinChars: 2,
    displayText: (i) => i.kabupaten,
    compareItems: (a, b) => a.mkabzonagempaId == b.mkabzonagempaId,
    validatorCallback: (_) => err('form3.zonaGempa'),
    errorText: err('form3.zonaGempa'),

    onChangedCallback: (v) {
      fieldComboMKabZonaGempa = v;
      if (v != null) clearErr('form3.zonaGempa');
    },
    onSaveCallback: (value) => fieldComboMKabZonaGempa = value,
  );

  //form3

  //form4
  Widget _buildComboCurddId() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboRMatauang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (item) => item.rmatauangNama,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,

    // error-map pattern
    validatorCallback: (_) => err('form4.mataUang'),
    errorText: err('form4.mataUang'),

    onChangedCallback: (v) {
      fieldComboRMatauang = v;
      if (v != null) clearErr('form4.mataUang');
    },
    onSaveCallback: (value) => fieldComboRMatauang = value,
  );


  Widget buildFieldSiBuilding() => appTextField(
    label: "Bangunan",
    controller: fieldSiBuildingController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form7.premiTotal'),
    validator: (_) => err('form7.premiTotal'),
    onChanged: (v) => _clearIfNotEmpty('form7.premiTotal', v),
  );

  //form5

  //form6
  Widget _buildBodyForm6() {
    final uploadState = context.watch<RegparUploadFotoObjectBloc>().state;

    final bool hasPreview =
        uploadState is UploadFotoObjectListPreview && uploadState.images.isNotEmpty;
    final bool hasServer = _serverPhotosRegpar6.isNotEmpty;

    final bool showIntro = !hasPreview && !hasServer;
    final bool isUploading = uploadState is UploadFotoObjectLoading;

    final borderColor = _form6HasError ? Colors.red : sGrey;

    return Padding(
      padding: const EdgeInsets.only(
        left: hPadding,
        right: hPadding,
        bottom: hPadding,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: hPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: borderColor, width: _form6HasError ? 1.5 : 1),
          color: formGrey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIntro) _buildIntroForm6(),
            if (!showIntro) _buildGalleryForm6(uploadState: uploadState),
            const SizedBox(height: hPadding),

            _buildPickButtonsForm6(
              disabled: isUploading,
              previewCount: _imagesRegpar6.length,
            ),

            if (_form6HasError && _form6ErrorText != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _form6ErrorText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],

            if (isUploading) ...[
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIntroForm6() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto Object",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto jelas, terang, dan tidak buram.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cardGrey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGalleryForm6({required RegparUploadFotoObjectState uploadState}) {
    final hasPreview =
        uploadState is UploadFotoObjectListPreview && uploadState.images.isNotEmpty;

    if (hasPreview) {
      final images = uploadState.images;

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _photoTileForm6(
              child: Image.memory(images[index], fit: BoxFit.cover),
              onDelete: () => _deletePreviewForm6(index),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _serverPhotosRegpar6.length,
        itemBuilder: (context, index) {
          final item = _serverPhotosRegpar6[index];

          // 🔥 URL sesuai yang bos minta
          final url =
              "${AppData.apiDomain}api/regpar/regpar6cari/fotoobject/getfoto/${item.regpar6Id}";

          final isDeleting = _deletingServerIdsRegpar6.contains(item.regpar6Id);

          return _photoTileForm6(
            child: Image.network(
              url,
              headers: {"Authorization": "Bearer ${AppData.userToken}"},
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, err, st) =>
              const Icon(Icons.broken_image, color: Colors.red, size: 48),
            ),
            onDelete: isDeleting ? null : () => _deleteServerPhotoForm6(item),
          );
        },
      ),
    );
  }

  Widget _photoTileForm6({required Widget child, VoidCallback? onDelete}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 200,
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildPickButtonsForm6({required bool disabled, required int previewCount}) {
    return Row(
      children: [
        Expanded(
          child: AppButton.iconLeft(
            text: 'Pilih File',
            icon: SvgPicture.asset(
              'assets/icons/gallery_img.svg',
              width: 18,
              height: 18,
              color: Colors.white,
            ),
            backgroundColor: sGrey,
            onPressed: disabled
                ? null
                : previewCount >= 10
                ? _maxReachedForm6
                : _pickFromGalleryForm6,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppButton.iconLeft(
            text: 'Ambil Foto',
            icon: SvgPicture.asset(
              'assets/icons/photo_img.svg',
              width: 18,
              height: 18,
              color: Colors.white,
            ),
            onPressed: disabled
                ? null
                : previewCount >= 10
                ? _maxReachedForm6
                : _pickFromCameraForm6,
          ),
        ),
      ],
    );
  }
  void _onUploadPressedForm6() {

    final id = regpar1Id;

    if (id == null || id.isEmpty) {
      debugPrint("❌ regpar1Id null atau empty, return");
      return;
    }


    context.read<RegparUploadFotoObjectBloc>().add(
      UploadFotoObjectBatchSubmit(
        regpar1Id: id,
        images: List.from(_imagesRegpar6),
        names: List.from(_fileNamesRegpar6),
      ),
    );

    debugPrint("✅ UploadFotoObjectBatchSubmit event SENT");
  }

  void _maxReachedForm6() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maksimal 10 foto."),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _deletePreviewForm6(int index) {
    _imagesRegpar6.removeAt(index);
    _fileNamesRegpar6.removeAt(index);

    context.read<RegparUploadFotoObjectBloc>().add(
      UploadFotoObjectSelectedList(
        List.from(_imagesRegpar6),
        List.from(_fileNamesRegpar6),
      ),
    );
  }

  Future<void> _pickFromGalleryForm6() async {
    if (_imagesRegpar6.length >= 10) {
      _maxReachedForm6();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (_imagesRegpar6.length >= 10) break;
      if (file.bytes == null) continue;
      _imagesRegpar6.add(file.bytes!);
      _fileNamesRegpar6.add(file.name);
    }

    if (_imagesRegpar6.isNotEmpty) {
      setState(() {
        _form6HasError = false;
        _form6ErrorText = null;
      });
    }

    context.read<RegparUploadFotoObjectBloc>().add(
      UploadFotoObjectSelectedList(
        List.from(_imagesRegpar6),
        List.from(_fileNamesRegpar6),
      ),
    );
  }

  Future<void> _pickFromCameraForm6() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }

    if (_imagesRegpar6.length >= 10) {
      _maxReachedForm6();
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    _imagesRegpar6.add(bytes);
    _fileNamesRegpar6.add(picked.name);

    context.read<RegparUploadFotoObjectBloc>().add(
      UploadFotoObjectSelectedList(
        List.from(_imagesRegpar6),
        List.from(_fileNamesRegpar6),
      ),
    );
  }
  void _deleteServerPhotoForm6(Regpar6CariModel item) {
    final id = item.regpar6Id;

    _deletingServerIdsRegpar6.add(id);

    setState(() {
      _serverPhotosRegpar6.removeWhere((x) => x.regpar6Id == id);
    });

    context.read<Regpar6FormBloc>().add(
      Regpar6FormHapusEvent(recordId: id),
    );
  }

  //form6



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

}
