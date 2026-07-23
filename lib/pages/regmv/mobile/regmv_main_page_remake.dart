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
import '../../../repositories/combobox/combommvjnscover_repository.dart';
import '../../../repositories/combobox/combommvmerk_repository.dart';
import '../../../repositories/combobox/combommvmodel_repository.dart';
import '../../../repositories/combobox/combommvpakai_repository.dart';
import '../../../repositories/combobox/combommvtipe_repository.dart';
import '../../../repositories/combobox/combomwarna_repository.dart';
import '../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../repositories/combobox/combormatauang_repository.dart';
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
  //form6

  @override
  void initState() {
    super.initState();

    final regmv1 = context.read<Regmv1CrudBloc>().state.record?.regmv1Id ?? "";
    regmv1Id = widget.regmv1Id ?? regmv1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      resetUploadStates(); // ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦ ini yang bikin foto lama hilang

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    });
  }

  @override
  void dispose() {
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

      if (fieldComboRMatauang == null && record.comboRMatauang != null) {
        fieldComboRMatauang = record.comboRMatauang;
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
                }
              },
            ),
            BlocListener<Regmv2FormBloc, Regmv2FormState>(
              listener: (context, state) {
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
                }
              },
            ),
            BlocListener<Regmv3FormBloc, Regmv3FormState>(
              listener: (context, state) {
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
                }
              },
            ),
            BlocListener<Regmv6FormBloc, Regmv6FormState>(
              listener: (context, state) {
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

                if (state.isCalculated) {
                  if (mounted) {
                    setState(() {
                      _isHitungPremiLoading = false;
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
    final bool hasForm6Record =
        context.read<Regmv6FormBloc>().state.record != null;
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
                    onToggle: (v) => setState(() => expanded[1] = v),
                    onRefresh: () {
                      if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                        refreshForm2(recordId: regmv1Id);
                      }
                    },
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
                            Flexible(child: _buildFieldPassengerCountCombo()),
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
                    onToggle: (v) => setState(() => expanded[2] = v),
                    onRefresh: () {
                      if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                        refreshForm3(recordId: regmv1Id);
                      }
                    },
                    child: Column(
                      children: [
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
                          buildWhen: (p, c) => p.items.length != c.items.length,
                          builder: (context, state) {
                            if (_showVal4 && state.items.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() => _showVal4 = false);
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
                          buildWhen: (p, c) => p.items.length != c.items.length,
                          builder: (context, state) {
                            if (_showVal5 && state.items.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() => _showVal5 = false);
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
                          buildWhen: (p, c) => p.items.length != c.items.length,
                          builder: (context, state) {
                            if (_showVal7 && state.items.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() => _showVal7 = false);
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
                                    fontSize: getResponsiveFont(context, 20),
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
                                    controller: fieldRateTerrorismController,
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
                                    layoutType: HitungPremiLayoutType.vertical,
                                    valuePrefix:
                                        fieldComboRMatauang?.rmatauangSimbol,
                                    showValueBorder: true,
                                    formatNumber: true,
                                  ),
                                  HitungPremiRow(
                                    label: "PREMI TAMBAHAN",
                                    description: "(For TPL & PAD & PAP)",
                                    controller: fieldPremiAddController,
                                    layoutType: HitungPremiLayoutType.vertical,
                                    valuePrefix:
                                        fieldComboRMatauang?.rmatauangSimbol,
                                    showValueBorder: true,
                                    formatNumber: true,
                                  ),
                                  HitungPremiRow(
                                    label: "DISKON",
                                    controller: fieldPremiDiskonController,
                                    layoutType: HitungPremiLayoutType.vertical,
                                    valuePrefix:
                                        fieldComboRMatauang?.rmatauangSimbol,
                                    showValueBorder: true,
                                    formatNumber: true,
                                  ),
                                  HitungPremiRow(
                                    label: "BIAYA POLIS",
                                    controller: fieldBiayaPolisController,
                                    layoutType: HitungPremiLayoutType.vertical,
                                    valuePrefix:
                                        fieldComboRMatauang?.rmatauangSimbol,
                                    showValueBorder: true,
                                    formatNumber: true,
                                  ),
                                  HitungPremiRow(
                                    label: "BIAYA MATERAI",
                                    controller: fieldBiayaMateraiController,
                                    layoutType: HitungPremiLayoutType.vertical,
                                    valuePrefix:
                                        fieldComboRMatauang?.rmatauangSimbol,
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
                                    layoutType: HitungPremiLayoutType.vertical,
                                    valuePrefix:
                                        fieldComboRMatauang?.rmatauangSimbol,
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
                      text: _isLanjutkanLoading ? "Memproses..." : "Lanjutkan",
                      isLoading: _isLanjutkanLoading,
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

                                await Future.delayed(
                                    const Duration(seconds: 2));

                                if (!mounted) return;

                                _hideGlobalLoading();

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KonfirmasiRegMvPage(
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
              tryOpenSection(RegmvFormSection.form1, onRefresh: onRefresh);
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
              tryOpenSection(RegmvFormSection.form2,
                  onRefresh: onRefresh); // untuk Form2
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
              tryOpenSection(RegmvFormSection.form3,
                  onRefresh: onRefresh); // untuk Form3
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
              tryOpenSection(RegmvFormSection.form4,
                  onRefresh: onRefresh); // untuk Form4
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

  Widget Form5Page({
    required BuildContext context,
    required bool isExpanded,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegmvFormSection.form5,
                  onRefresh: onRefresh); // untuk Form5
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
              tryOpenSection(RegmvFormSection.form6,
                  onRefresh: onRefresh); // untuk Form6
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

  Widget Form7Page({
    required BuildContext context,
    required bool isExpanded,
    required ValueChanged<bool> onToggle,
    required Widget child,
    VoidCallback? onRefresh,
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
              tryOpenSection(RegmvFormSection.form7,
                  onRefresh: onRefresh); // untuk Form7
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
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      // isTbod: toBoolean(fieldIsTbodController.text),
      isTbod: false,
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      pad: double.tryParse(fieldPadController.text.replaceAll(',', '')) ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(',', '')) ?? 0,
      passangerCount: int.tryParse(selectedPassengerCount ?? '') ?? 0,
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

  Widget buildButtonHitungPremi() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppButton.primary(
          text: _isHitungPremiLoading ? "Memproses..." : "Hitung Premi",
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

  void openForm1({required String? recordId}) {
    openSection(RegmvFormSection.form1);
    refreshForm1(recordId: recordId);
  }

  void openForm2({required String? recordId}) {
    openSection(RegmvFormSection.form2);
    refreshForm2(recordId: recordId);
  }

  void openForm3({required String? recordId}) {
    openSection(RegmvFormSection.form3);
    refreshForm3(recordId: recordId);
  }

  void openForm4({required String? recordId}) {
    openSection(RegmvFormSection.form4);
    refreshForm4(recordId: recordId);
  }

  void openForm5({required String? recordId}) {
    openSection(RegmvFormSection.form5);
    refreshForm5(recordId: recordId);
  }

  void openForm6({required String? recordId}) {
    openSection(RegmvFormSection.form6);
    refreshForm6(recordId: recordId);
  }

  void openPremiSection({required String? recordId}) => openSection(
        RegmvFormSection.form6,
        onRefresh: () {
          final st = context.read<Regmv6FormBloc>().state;
          if (st.record == null) {
            refreshForm6(recordId: recordId);
          }
        },
      );

  void openForm7({required String? recordId}) {
    openSection(RegmvFormSection.form7);
    refreshForm7(recordId: recordId);
  }

  bool validateForm1() {
    clearErrsByPrefix('form1.');

    bool ok = true;

    // No SPPA (meskipun disabled, tetap wajib ada value)
    // final sppa = fieldCalmv1IdController.text.trim();
    // if (sppa.isEmpty) {
    //   setErr('form1.noSppa', kStringNullError);
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

    // No Polisi (required, length 3..9 setelah spasi dihapus)
    final platRaw = fieldPlatNoController.text.trim();
    if (platRaw.isEmpty) {
      setErr('form3.platNo', kStringNullError);
      ok = false;
    } else {
      final cleaned = platRaw.replaceAll(' ', '');
      if (cleaned.length < 3 || cleaned.length > 9) {
        setErr('form3.platNo', "Format plat nomor tidak valid");
        ok = false;
      }
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
        label: "No SPPA",
        controller: fieldCalmv1IdController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
        ],
        enabled: false,
        errorText: err('form1.noSppa'),
        validator: (_) => err('form1.noSppa'),
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
            if (v != null) clearErr('form2.jenisCover');
          });
        },
        onSaveCallback: (value) => fieldComboMMvjnscover = value,
      );

  Widget _buildFieldIsEq() => CheckboxWidget(
        rightLabel: "Gempa Bumi",
        initialValue: toBoolean(fieldIsEqController.text),
        callback: (v) => fieldIsEqController.text = v.toString(),
        leftLabel: "",
      );

  Widget _buildFieldIsFlood() => CheckboxWidget(
        rightLabel: "Banjir",
        initialValue: toBoolean(fieldIsFloodController.text),
        callback: (v) => fieldIsFloodController.text = v.toString(),
        leftLabel: "",
      );

  Widget _buildFieldIsSrcc() => CheckboxWidget(
        rightLabel: "Kerusuhan",
        initialValue: toBoolean(fieldIsSrccController.text),
        callback: (v) => fieldIsSrccController.text = v.toString(),
        leftLabel: "",
      );

  Widget _buildFieldIsTbod() => CheckboxWidget(
        rightLabel: "Pencurian Barang oleh Supir",
        initialValue: toBoolean(fieldIsTbodController.text),
        callback: (v) => fieldIsTbodController.text = v.toString(),
        leftLabel: "",
      );

  Widget _buildFieldIsTerrorism() => CheckboxWidget(
        rightLabel: "Terorisme",
        initialValue: toBoolean(fieldIsTerrorismController.text),
        callback: (v) => fieldIsTerrorismController.text = v.toString(),
        leftLabel: "",
      );

  Widget _buildFieldIsAw() => CheckboxWidget(
        rightLabel: "Bengkel Resmi",
        initialValue: toBoolean(fieldIsAwController.text),
        callback: (v) => fieldIsAwController.text = v.toString(),
        leftLabel: "",
      );

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
        validator: (v) {
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
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
        validator: (v) {
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
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
        validator: (v) {
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
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
        validator: (v) {
          if (v == null || v.isEmpty) return null;
          final clean = v.replaceAll(",", "");
          final angka = double.tryParse(clean);
          if (angka == null || angka < 0) return "Tidak boleh minus";
          return null;
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
        label: "Harga Mobil",
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
          final t = v.trim();
          if (t.isEmpty) return;

          final cleaned = t.replaceAll(' ', '');
          if (cleaned.length >= 3 && cleaned.length <= 9) {
            clearErr('form3.platNo');
          }
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
        fieldPlatNoController.text.replaceAll(' ', '').trim().length >= 3 &&
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
      context.read<Regmv6FormBloc>().state.record != null;

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

  void openSection(RegmvFormSection section, {VoidCallback? onRefresh}) {
    final idx = sectionIndex(section);

    setState(() {
      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;
    });

    onRefresh?.call();
  }

  void tryOpenSection(RegmvFormSection section, {VoidCallback? onRefresh}) {
    final targetIdx = sectionIndex(section);
    final opened = getOpenedIndex();

    if (opened == targetIdx) return;

    final ok = validateOpenedForm();
    if (!ok) return;

    openSection(section, onRefresh: onRefresh);
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
