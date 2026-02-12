import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_regmv/regmv1crud_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
import 'package:joss_app/pages/gen_regmv/mobile/regmv/regmv_form4_remake.dart';
import 'package:string_validator/string_validator.dart';
import '../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../blocs/gen_regmv/regmv4cari_bloc.dart';
import '../../../blocs/gen_regmv/regmv4form_bloc.dart';
import '../../../blocs/gen_regmv/regmv5cari_bloc.dart';
import '../../../blocs/gen_regmv/regmv5form_bloc.dart';
import '../../../blocs/gen_regmv/regmv6form_bloc.dart';
import '../../../blocs/gen_regmv/regmv7cari_bloc.dart';
import '../../../blocs/gen_regmv/regmv7form_bloc.dart';
import '../../../blocs/gen_regmv/regmv_flow_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import '../../../common/app_data.dart';
import '../../../common/constants.dart';
import '../../../common/plat_nomor_formatter.dart';
import '../../../common/rangka_no_formatter.dart';
import '../../../common/thousand_separator_input_formatter.dart';
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
import '../../../models/gen_regmv/regmv4cari_model.dart';
import '../../../models/gen_regmv/regmv4form_model.dart';
import '../../../models/gen_regmv/regmv5cari_model.dart';
import '../../../models/gen_regmv/regmv5form_model.dart';
import '../../../models/gen_regmv/regmv6form_model.dart';
import '../../../models/gen_regmv/regmv7cari_model.dart';
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
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import 'konfirmasi_regmv_page.dart';

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
  List<bool> expanded = [false, false, false, false, false, false, false];

  String? regmv1Id;
  String? regmv2Id;
  String? regmv3Id;
  String? regmv4Id;
  String? regmv5Id;
  String? regmv6Id;
  String? regmv7Id;

  Regmv1CrudBloc? regmv1crudbloc;
  Regmv2FormBloc? regmv2formbloc;
  Regmv3FormBloc? regmv3formbloc;

  Regmv4FormBloc? regmv4formBloc;
  bool _form4HasError = false;
  String? _form4ErrorText;

  Regmv5FormBloc? regmv5formBloc;
  bool _form5HasError = false;
  String? _form5ErrorText;

  Regmv6FormBloc? regmv6formbloc;

  Regmv7FormBloc? regmv7formBloc;
  bool _form7HasError = false;
  String? _form7ErrorText;

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

  double getProgressValue() {
    final openedCount = expanded.where((v) => v).length;
    return openedCount / 7;
  }

  //form1
  final fieldCalmv1IdController = TextEditingController();
  final fieldTtgAlamatController = TextEditingController();
  final fieldTtgNamaController = TextEditingController();
  //form1

  //form2
  final fieldPolisAkhirController = TextEditingController();
  final fieldPolisMulaiController = TextEditingController();
  final fieldAwController = TextEditingController();
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
  final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  DateTime? kejadianMulaiTgl;
  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? kejadianBerakhirTgl;
  final _years = DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day);
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

  //form4
  List<Uint8List> _imagesRegmv4 = [];
  List<String> _fileNamesRegmv4 = [];
  List<Regmv4CariModel> _serverPhotosRegmv4 = [];
  final Set<String> _deletingServerIdsRegmv4 = {};
  //form4

  //form5
  List<Uint8List> _imagesRegmv5 = [];
  List<String> _fileNamesRegmv5 = [];
  List<Regmv5CariModel> _serverPhotosRegmv5 = [];
  final Set<String> _deletingServerIdsRegmv5 = {};
  //form5

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
  final fieldBiayaPolisController = TextEditingController();
  final fieldSumInsuredController = TextEditingController();
  final fieldRateTotalController = TextEditingController();
  //form6

  //form7
  List<Uint8List> _imagesRegmv7 = [];
  List<String> _fileNamesRegmv7 = [];
  List<Regmv7CariModel> _serverPhotosRegmv7 = [];
  final Set<String> _deletingServerIdsRegmv7 = {};
  //form7

  @override
  void initState() {
    super.initState();
    final regmv1 = context.read<Regmv1CrudBloc>().state.record?.regmv1Id ?? "";
    regmv1Id = widget.regmv1Id ?? regmv1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    });
  }

  @override
  void dispose(){
    //form1
    fieldCalmv1IdController.dispose();
    fieldTtgAlamatController.dispose();
    fieldTtgNamaController.dispose();
    //form1

    //form2
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();
    fieldAwController.dispose();
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
    fieldSumInsuredController.dispose();
    fieldRateTotalController.dispose();
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
    debugPrint("🔄 refreshForm4 CALLED");
    debugPrint("👉 recordId = $recordId");

    if (recordId == null || recordId.isEmpty) {
      debugPrint("❌ recordId null atau empty, RETURN");
      return;
    }

    debugPrint("➡️ Dispatch RefreshRegmv4CariEvent");

    context.read<Regmv4CariBloc>().add(
      RefreshRegmv4CariEvent(regmv1Id: recordId),
    );

    debugPrint("✅ RefreshRegmv4CariEvent SENT");
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
    if (fieldAwController.text.trim().isEmpty) {
      fieldAwController.text = record.aw.toString();
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

      if (mulai != null) {
        if (akhir != null && sameDay(mulai, akhir)) {
          debugPrint('⚠️ Polis invalid dari backend (mulai==akhir). Abaikan polisAkhir backend.');
        }

        context.read<PolisTanggalBloc>().add(PolisMulaiChanged(
          DateTime(mulai.year, mulai.month, mulai.day), // normalize
        ));
      }
      if (selectedPassengerCount.trim().isEmpty && record.passangerCount != null) {
        final v = record.passangerCount!.toString();
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
      if (selectedYearform3.trim().isEmpty && thn != null && thn != 0) {
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
    fieldSumInsuredController.text = cleanNum(record.tsi);
    fieldRateDasarController.text = record.rateDasar.toString();
    fieldRateLoadingController.text = record.rateLoading.toString();
    fieldRateSrccController.text = record.rateSrcc.toString();
    fieldRateFloodController.text = record.rateFlood.toString();
    fieldRateEqController.text = record.rateEq.toString();
    fieldRateTerrorismController.text = record.rateTerrorism.toString();
    fieldRatePadController.text = record.ratePad.toString();
    fieldRatePapController.text = record.ratePap.toString();
    fieldRateTotalController.text = record.rateTotal.toString();
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // penting: cegah pop otomatis dari back fisik/gesture
      onPopInvokedWithResult: (didPop, result) async {
        // kalau canPop=false, didPop biasanya false.
        // tapi tetap aman kalau suatu saat route sudah ke-pop.
        if (didPop) return;

        await _handleExit(context);
      },
      child: BaseBackgroundSidePage(
        onBack: () async {
          await _handleExit(context); // tombol back di BaseBackground → sama
        },
        title: "Kendaraan",
        blocListeners: [
          BlocListener<Regmv1CrudBloc, Regmv1CrudState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regmv1Id = state.record!.regmv1Id;
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform1(state.record!);
              }
            },
          ),

          BlocListener<Regmv2FormBloc, Regmv2FormState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regmv2Id = state.record!.regmv2Id;
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform2(state.record!);
              }
            },
          ),

          BlocListener<Regmv3FormBloc, Regmv3FormState>(
            listener: (context, state) {
              if (state.isSaved && !state.hasFailure && state.record != null) {
                setState(() {
                  regmv3Id = state.record!.regmv3Id;
                });
              }
              if (state.isLoaded && !state.hasFailure && state.record != null) {
                _payloadform3(state.record!);
              }
            },
          ),

          // server list update
          BlocListener<Regmv4CariBloc, Regmv4CariState>(
            listener: (context, state) {
              debugPrint("👂 Regmv4CariBloc listener CALLED");
              debugPrint("state.status: ${state.status}");
              debugPrint("state.items length: ${state.items.length}");

              if (state.status == ListStatus.success) {
                debugPrint("✅ Regmv4CariBloc SUCCESS");
                setState(() => _serverPhotosRegmv4 = List.from(state.items));
              }
            },
          ),

          // upload flow
          BlocListener<RegmvUploadStnkBloc, RegmvUploadStnkState>(
            listener: (context, state) {
              if (state is UploadStnkListPreview) {
                debugPrint("fileNames length: ${state.fileNames.length}");

                setState(() {
                  _imagesRegmv4 = List.from(state.images);
                  _fileNamesRegmv4 = List.from(state.fileNames);
                });
              }

              if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                debugPrint("🔄 refreshForm4 CALLED (general)");
                refreshForm4(recordId: regmv1Id);
              }

              if (state is UploadStnkSuccess) {
                debugPrint("✅ UploadStnkSuccess");

                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  debugPrint("🔄 refreshForm4 CALLED (success)");
                  refreshForm4(recordId: regmv1Id);
                }
              }

              if (state is UploadStnkFailure) {
                debugPrint("❌ UploadStnkFailure: ${state.error}");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),

          // delete server (state hanya flag)
          BlocListener<Regmv4FormBloc, Regmv4FormState>(
            listener: (context, state) {
              debugPrint("👂 Regmv4FormBloc listener CALLED");
              debugPrint("isSaved: ${state.isSaved}");
              debugPrint("hasFailure: ${state.hasFailure}");

              if (state.isSaved) {
                debugPrint("✅ Delete SUCCESS");
                _deletingServerIdsRegmv4.clear();

                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  debugPrint("🔄 refreshForm4 CALLED (delete success)");
                  refreshForm4(recordId: regmv1Id);
                }
              }

              if (state.hasFailure) {
                debugPrint("❌ Delete FAILURE");
                _deletingServerIdsRegmv4.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus foto. Mengambil ulang data..."),
                    backgroundColor: Colors.red,
                  ),
                );

                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  debugPrint("🔄 refreshForm4 CALLED (delete failure)");
                  refreshForm4(recordId: regmv1Id);
                }
              }
            },
          ),

          // server list update
          BlocListener<Regmv5CariBloc, Regmv5CariState>(
            listener: (context, state) {
              if (state.status == ListStatus.success) {
                setState(() => _serverPhotosRegmv5 = List.from(state.items));
              }
            },
          ),

          // upload flow
          BlocListener<RegmvUploadFotoMobilBloc, RegmvUploadFotoMobilState>(
            listener: (context, state) {
              if (state is UploadFotoMobilListPreview) {
                setState(() {
                  _imagesRegmv5 = List.from(state.images);
                  _fileNamesRegmv5 = List.from(state.fileNames);
                });
              }

              if (state is UploadFotoMobilSuccess) {
                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  refreshForm5(recordId: regmv1Id);
                }
              }

              if (state is UploadFotoMobilFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),

          // delete server (state hanya flag)
          BlocListener<Regmv5FormBloc, Regmv5FormState>(
            listener: (context, state) {
              if (state.isSaved) {
                _deletingServerIdsRegmv5.clear();
                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  refreshForm5(recordId: regmv1Id);
                }
              }

              if (state.hasFailure) {
                _deletingServerIdsRegmv5.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus foto. Mengambil ulang data..."),
                    backgroundColor: Colors.red,
                  ),
                );
                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  refreshForm5(recordId: regmv1Id);
                }
              }
            },
          ),

          BlocListener<Regmv6FormBloc, Regmv6FormState>(
            listener: (context, state) {
              if (state.record != null) {
                _payloadform6(state.record!);
                openForm7(recordId: regmv1Id);

                if (state.isSaved) {
                  setState(() {
                    regmv6Id = state.record!.regmv6Id;
                  });

                  if (state.record!.regmv6Id.isNotEmpty) {
                    openForm7(recordId: regmv1Id);
                  }
                }
              }
            },
          ),

          // server list update
          BlocListener<Regmv7CariBloc, Regmv7CariState>(
            listener: (context, state) {
              if (state.status == ListStatus.success) {
                setState(() => _serverPhotosRegmv7 = List.from(state.items));
              }
            },
          ),

          // upload flow
          BlocListener<RegmvUploadFotoAccBloc, RegmvUploadFotoAccState>(
            listener: (context, state) {
              if (state is UploadFotoAccListPreview) {
                setState(() {
                  _imagesRegmv7 = List.from(state.images);
                  _fileNamesRegmv7 = List.from(state.fileNames);
                });
              }

              if (state is UploadFotoAccSuccess) {
                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  refreshForm7(recordId: regmv1Id);
                }
              }

              if (state is UploadFotoAccFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),

          // delete server (state hanya flag)
          BlocListener<Regmv7FormBloc, Regmv7FormState>(
            listener: (context, state) {
              if (state.isSaved) {
                _deletingServerIdsRegmv7.clear();
                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  refreshForm7(recordId: regmv1Id);
                }
              }

              if (state.hasFailure) {
                _deletingServerIdsRegmv7.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus foto. Mengambil ulang data..."),
                    backgroundColor: Colors.red,
                  ),
                );
                if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                  refreshForm7(recordId: regmv1Id);
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
    final bool hasForm6Record =
        context.read<Regmv6FormBloc>().state.record != null;
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
                title: "Kendaraan",
                subtitle: "Isi detail kendaraan, pilih pertanggungan, dan hitung premi secara otomatis.",
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
                    title: "Data Kendaraan",
                    isExpanded: expanded[0],
                    onToggle: (v) => setState(() => expanded[0] = v),
                    onRefresh: () {
                      debugPrint("regmv1Id : ${regmv1Id} + widget.regmv1Id : ${widget.regmv1Id}");
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
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form2Page(
                    context: context,
                    title: "Pertanggungan",
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
                            Flexible(child: _buildFieldIsTbod()),
                            const Flexible(child: SizedBox.shrink()),
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
                            Flexible(child: _buildFieldAW()),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form3Page(
                    context: context,
                    title: "Premi",
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

                  const SizedBox(height: hPadding,),

                  Form4Page(
                    context: context,
                    title: "Upload Foto STNK",
                    isExpanded: expanded[3],
                    onToggle: (v) => setState(() => expanded[3] = v),
                    onRefresh: () {
                      if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                        refreshForm4(recordId: regmv1Id);
                      }
                    },
                    child: Column(
                      children: [
                        _buildBodyForm4(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form5Page(
                    context: context,
                    title: "Upload Foto Mobil",
                    isExpanded: expanded[4],
                    onToggle: (v) => setState(() => expanded[4] = v),
                    onRefresh: () {
                      if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                        refreshForm5(recordId: regmv1Id);
                      }
                    },
                    child: Column(
                      children: [
                        _buildBodyForm5(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form7Page(
                    context: context,
                    title: "Upload Foto Aksesoris",
                    isExpanded: expanded[5],
                    onToggle: (v) => setState(() => expanded[5] = v),
                    onRefresh: () {
                      if (regmv1Id != null && regmv1Id!.isNotEmpty) {
                        refreshForm7(recordId: regmv1Id);
                      }
                    },
                    child: Column(
                      children: [
                        _buildBodyForm7(),
                        const SizedBox(height: 15),
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
                              label: "Komprehensif::",
                              controller: fieldRateDasarController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Loading:",
                              controller: fieldRateLoadingController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Kerusuhan:",
                              controller: fieldRateSrccController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Terorisme & Sabotase:",
                              controller: fieldRateTerrorismController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Banjir:",
                              controller: fieldRateFloodController,
                              layoutType: HitungPremiLayoutType.horizontal,
                              // showValueBorder: true,
                              valueSuffix: "%",
                            ),
                            HitungPremiRow(
                              label: "Gempa Bumi:",
                              controller: fieldRateEqController,
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
                              label: "PREMI TAHUNAN",
                              description: "${fieldComboRMatauang?.rmatauangSimbol} ${fieldSumInsuredController.text} x ${fieldRateTotalController.text}% =",
                              controller: fieldPremiCascoController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
                              showValueBorder: true,
                              formatNumber: true,
                            ),
                            HitungPremiRow(
                              label: "PREMI TAMBAHAN",
                              description: "(For TPL & PAD & PAP)",
                              controller: fieldPremiAddController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
                              showValueBorder: true,
                              formatNumber: true,
                            ),
                            HitungPremiRow(
                              label: "DISKON 25%",
                              controller: fieldPremiDiskonController,
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
                              controller: fieldPremiNetController,
                              layoutType: HitungPremiLayoutType.vertical,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol,
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
                        : const SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Klik Hitung Premi untuk melihat hasil."),
                      ),
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  if (hasForm6Record) ...[
                    AppButton.iconRight(
                      text: "Lanjutkan",
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KonfirmasiRegMvPage(
                              recordId: regmv1Id ?? '',
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
    final record = Regmv1CrudModel(
      calmv1Id: widget.calmv1Id ?? "",
      regmv1Id: regmv1Id ?? "",
      ttgNama: fieldTtgNamaController.text ?? "",
      ttgAlamat: fieldTtgAlamatController.text ?? "",
    );

    context.read<Regmv1CrudBloc>().add(
      Regmv1DraftEvent(record: record),
    );
  }

  void draftForm2ToBloc(BuildContext context) {
    final polis = context.read<PolisTanggalBloc>().state;

    // DEBUG nilai dari bloc tanggal
    debugPrint("=== DEBUG POLIS TANGGAL ===");
    debugPrint("polis.mulai    : ${polis.mulai}");
    debugPrint("polis.berakhir : ${polis.berakhir}");
    debugPrint("==========================");

    final record = Regmv2FormModel(
      aw: double.tryParse(fieldAwController.text.replaceAll(',', '')) ?? 0,
      currId: fieldComboRMatauang?.rmatauangKode,
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      isTbod: toBoolean(fieldIsTbodController.text),
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

    // DEBUG isi record
    debugPrint("=== DEBUG RECORD FORM2 ===");
    debugPrint("record.polisMulai : ${record.polisMulai}");
    debugPrint("record.polisAkhir : ${record.polisAkhir}");
    debugPrint("=========================");

    context.read<Regmv2FormBloc>().add(Regmv2DraftEvent(record: record));
  }


  void draftForm3ToBloc(BuildContext context){
    final record = Regmv3FormModel(
      regmv1Id: regmv1Id ?? "",
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
      regmv3Id: regmv1Id ?? "",
      thnBuat: int.parse(selectedYearform3),
    );
    context.read<Regmv3FormBloc>().add(Regmv3DraftEvent(record: record));
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
      openForm1(recordId: regmv1Id);
      return;
    }

    final ok2 = validateForm2();
    if (!ok2) {
      openForm2(recordId: regmv1Id);
      return;
    }

    final ok3 = validateForm3();
    if (!ok3) {
      openForm3(recordId: regmv1Id);
      return;
    }

    final isUploading4 = context.read<RegmvUploadStnkBloc>().state is UploadStnkLoading;
    final isUploading5 = context.read<RegmvUploadFotoMobilBloc>().state is UploadFotoMobilLoading;
    final isUploading7 = context.read<RegmvUploadFotoAccBloc>().state is UploadFotoAccLoading;
    final ok4 = !isUploading4 &&
        (_imagesRegmv4.isNotEmpty || _serverPhotosRegmv4.isNotEmpty);

    final ok5 = !isUploading5 &&
        (_imagesRegmv5.isNotEmpty || _serverPhotosRegmv5.isNotEmpty);

    final ok7 = !isUploading7 &&
        (_imagesRegmv7.isNotEmpty || _serverPhotosRegmv7.isNotEmpty);

    setState(() {
      _form4HasError = !ok4;
      _form4ErrorText = !ok4 ? 'Bagian ini wajib diisi' : null;

      _form5HasError = !ok5;
      _form5ErrorText = !ok5 ? 'Bagian ini wajib diisi' : null;

      _form7HasError = !ok7;
      _form7ErrorText = !ok7 ? 'Bagian ini wajib diisi' : null;
    });

    if (!ok4 || !ok5 || !ok7) {
      if (!ok4) openForm4(recordId: regmv1Id);
      else if (!ok5) openForm5(recordId: regmv1Id);
      else if(!ok7) openForm6(recordId: regmv1Id);
      return;
    }

    _onUploadPressedForm4();
    _onUploadPressedForm5();
    _onUploadPressedForm7();

    draftForm1ToBloc(context);
    draftForm2ToBloc(context);
    draftForm3ToBloc(context);

    context.read<RegmvFlowBloc>().add(RegmvFlowStartEvent());
  }

  void openForm1({required String? recordId}) {
    setState(() {
      expanded = [true, false, false, false, false, false, false];
    });
    refreshForm1(recordId: recordId);
  }

  void openForm2({required String? recordId}) {
    setState(() {
      expanded = [false, true, false, false, false, false, false];
    });
    refreshForm2(recordId: recordId);
  }

  void openForm3({required String? recordId}) {
    setState(() {
      expanded = [false, false, true, false, false, false, false];
    });
    refreshForm3(recordId: recordId);
  }

  void openForm4({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, true, false, false, false];
    });
    refreshForm4(recordId: recordId);
  }

  void openForm5({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, false, true, false, false];
    });
    refreshForm5(recordId: recordId);
  }

  void openForm6({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, false, false, true, false];
    });
    refreshForm7(recordId: recordId);
  }

  void openForm7({required String? recordId}) {
    setState(() {
      expanded = [false, false, false, false, false, false, true];
    });
    // refreshForm6(recordId: recordId);
  }

    bool validateForm1() {
      clearErrsByPrefix('form1.');

      bool ok = true;

      // No SPPA (meskipun disabled, tetap wajib ada value)
      final sppa = fieldCalmv1IdController.text.trim();
      if (sppa.isEmpty) {
        setErr('form1.noSppa', kStringNullError);
        ok = false;
      }

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

  bool validateForm2() {
    clearErrsByPrefix('form2.');
    bool ok = true;

    // NOTE: Polis Mulai & Polis Berakhir sementara DISKIP dulu

    // Mata Uang (required)
    if (fieldComboRMatauang == null) {
      setErr('form2.mataUang', kStringNullError);
      ok = false;
    }

    // Jenis Cover (required)
    if (fieldComboMMvjnscover == null) {
      setErr('form2.jenisCover', kStringNullError);
      ok = false;
    }

    // AW (required, 0..100)
    final awRaw = fieldAwController.text.trim();
    if (awRaw.isEmpty) {
      setErr('form2.aw', kStringNullError);
      ok = false;
    } else {
      final x = double.tryParse(awRaw);
      if (x == null) {
        setErr('form2.aw', "Format tidak valid");
        ok = false;
      } else if (x < 0) {
        setErr('form2.aw', "Tidak boleh minus");
        ok = false;
      } else if (x > 100) {
        setErr('form2.aw', "Max 100%");
        ok = false;
      }
    }

    // Jumlah Penumpang (required)
    if (selectedPassengerCount.trim().isEmpty) {
      setErr('form2.passengerCount', kStringNullError);
      ok = false;
    }

    // TPL (optional, >= 0)
    final tplRaw = fieldTplController.text.trim();
    if (tplRaw.isNotEmpty) {
      final clean = tplRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) {
        setErr('form2.tpl', "Tidak boleh minus");
        ok = false;
      }
    }

    // PAD (optional, >= 0)
    final padRaw = fieldPadController.text.trim();
    if (padRaw.isNotEmpty) {
      final clean = padRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) {
        setErr('form2.pad', "Tidak boleh minus");
        ok = false;
      }
    }

    // PAP (optional, >= 0)
    final papRaw = fieldPapController.text.trim();
    if (papRaw.isNotEmpty) {
      final clean = papRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) {
        setErr('form2.pap', "Tidak boleh minus");
        ok = false;
      }
    }

    // PLL (optional, >= 0)
    final pllRaw = fieldPllController.text.trim();
    if (pllRaw.isNotEmpty) {
      final clean = pllRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka < 0) {
        setErr('form2.pll', "Tidak boleh minus");
        ok = false;
      }
    }

    // Kalau gagal, buka panel form2
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

    // Aksesoris (required)
    final aksesorisRaw = fieldAksesorisController.text.trim();
    if (aksesorisRaw.isEmpty) {
      setErr('form3.aksesoris', kStringNullError);
      ok = false;
    }

    // Kalau gagal, buka panel form3 (index 2)
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
      FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z ,.]")),
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
        final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        return AppDateField(
          label: 'Tanggal Mulai',
          initialValue: state.mulai,
          firstDate: today,
          lastDate: DateTime(2100),
          validator: (_) => null,
          onChanged: (dt) {
            if (dt == null) return;
            context.read<PolisTanggalBloc>().add(PolisMulaiChanged(dt)); // <- trigger event aja
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


  Widget _buildComboCurddId() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboRMatauang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (item) => item.rmatauangNama,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
    validatorCallback: (_) => err('form2.mataUang'),
    errorText: err('form2.mataUang'),
    onChangedCallback: (v) {
      fieldComboRMatauang = v;
      if (v != null) clearErr('form2.mataUang');
    },
    onSaveCallback: (value) => fieldComboRMatauang = value,
  );

  Widget _buildComboMMvjnscover() => ReusableComboBox<ComboMMvjnscoverModel>(
    hintText: "Jenis Cover",
    initItem: fieldComboMMvjnscover,
    dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
    displayText: (i) => i.coverName,
    compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
    validatorCallback: (_) => err('form2.jenisCover'),
    errorText: err('form2.jenisCover'),
    onChangedCallback: (v) {
      fieldComboMMvjnscover = v;
      if (v != null) clearErr('form2.jenisCover');
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


  Widget _buildFieldPLL() => appTextField(
    label: "Tanggung Jawab Penumpang",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
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

    return ReusableComboBox<String>(
      hintText: "Jumlah Penumpang",
      initItem: selectedPassengerCount.isNotEmpty ? selectedPassengerCount : null,
      dataLoader: () async => counts,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,
      validatorCallback: (_) => err('form2.passengerCount'),
      errorText: err('form2.passengerCount'),
      onChangedCallback: (value) {
        selectedPassengerCount = value ?? "";
        if ((value ?? "").trim().isNotEmpty) clearErr('form2.passengerCount');
      },
      onSaveCallback: (value) => selectedPassengerCount = value ?? "",
    );
  }

  Widget _buildFieldAW() => appTextField(
    label: "Bengkel Resmi",
    controller: fieldAwController,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    suffix: Text("%", style: bodyTextStyle(context)),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.isEmpty) return newValue;
        final value = double.tryParse(newValue.text);
        if (value == null) return newValue;
        if (value > 100) return oldValue;
        return newValue;
      }),
    ],
    errorText: err('form2.aw'),
    validator: (_) => err('form2.aw'),
    onChanged: (v) {
      final x = double.tryParse(v.trim());
      if (x != null && x >= 0 && x <= 100) clearErr('form2.aw');
    },
  );

  //form2

  //form3
  Widget _buildFieldComboTahun() {
    final yearNow = DateTime.now().year;
    final years = List<String>.generate(
      yearNow - 1980 + 1,
          (i) => (yearNow - i).toString(),
    );

    return ReusableComboBox<String>(
      hintText: "Tahun Pembuatan",
      initItem: selectedYearform3.isNotEmpty ? selectedYearform3 : null,
      dataLoader: () async => years,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,
      validatorCallback: (_) => err('form3.tahun'),
      errorText: err('form3.tahun'),
      onChangedCallback: (value) {
        selectedYearform3 = value ?? "";
        if ((value ?? "").trim().isNotEmpty) clearErr('form3.tahun');
      },
      onSaveCallback: (value) => selectedYearform3 = value ?? "",
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

  Widget _buildComboMWilayah() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,

    validatorCallback: (_) => err('form3.wilayah'),
    errorText: err('form3.wilayah'),

    onChangedCallback: (v) {
      fieldComboMWilayah = v;
      if (v != null) clearErr('form3.wilayah');
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

  Widget _buildFieldMmvmerkId() => ReusableComboBox<ComboMMvmerkModel>(
    hintText: "Merek",
    comboKey: comboMMvmerkKey,
    initItem: fieldComboMMvmerk,
    dataLoader: () => ComboMMvmerkRepository().getComboMMvmerk(""),
    displayText: (item) => item.nmMerk,
    compareItems: (a, b) => a.mmvmerkId == b.mmvmerkId,

    validatorCallback: (_) => err('form3.merek'),
    errorText: err('form3.merek'),

    onChangedCallback: (v) {
      debugPrint("[MMVMERK] onChanged -> ${v == null ? 'NULL' : '${v.mmvmerkId} | ${v.nmMerk}'}");

      if (v != null) {
        clearErr('form3.merek');
        regmv3formbloc?.add(ComboMMvmerkChangedEvent(comboMMvmerk: v));
        comboMMvtipeKey.currentState?.clear();
        comboMMvmodelKey.currentState?.clear();
      }

      fieldComboMMvmerk = v;
    },
    onSaveCallback: (value) => fieldComboMMvmerk = value,
  );

  Widget _buildComboTipeId() => ReusableComboBox<ComboMMvtipeModel>(
    hintText: "Model",
    comboKey: comboMMvtipeKey,
    initItem: fieldComboMMvtipe,
    dataLoader: () => ComboMMvtipeRepository()
        .getComboMMvtipe(fieldComboMMvmerk?.mmvmerkId ?? "", ""),
    displayText: (item) => item.nmTipe,
    compareItems: (a, b) => a.mmvtipeId == b.mmvtipeId,

    validatorCallback: (_) => err('form3.model'),
    errorText: err('form3.model'),

    onChangedCallback: (v) {
      if (v != null) {
        clearErr('form3.model');
        regmv3formbloc?.add(ComboMMvtipeChangedEvent(comboMMvtipe: v));
        comboMMvmodelKey.currentState?.clear();
      }
      fieldComboMMvtipe = v;
    },
    onSaveCallback: (value) => fieldComboMMvtipe = value,
  );

  Widget _buildFieldMmvmodelId() => ReusableComboBox<ComboMMvmodelModel>(
    hintText: "Sub Model",
    comboKey: comboMMvmodelKey,
    initItem: fieldComboMMvmodel,
    dataLoader: () => ComboMMvmodelRepository()
        .getComboMMvmodel(fieldComboMMvtipe?.mmvtipeId ?? "", ""),
    displayText: (item) => item.nmModel,
    compareItems: (a, b) => a.mmvmodelId == b.mmvmodelId,

    validatorCallback: (_) => err('form3.subModel'),
    errorText: err('form3.subModel'),

    onChangedCallback: (v) {
      if (v != null) {
        clearErr('form3.subModel');
        regmv3formbloc?.add(ComboMMvmodelChangedEvent(comboMMvmodel: v));
      }
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

    validatorCallback: (_) => err('form3.penggunaan'),
    errorText: err('form3.penggunaan'),

    onChangedCallback: (v) {
      if (v != null) {
        clearErr('form3.penggunaan');
        regmv3formbloc?.add(ComboMMvpakaiChangedEvent(comboMMvpakai: v));
      }
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

    validatorCallback: (_) => err('form3.warna'),
    errorText: err('form3.warna'),

    onChangedCallback: (v) {
      if (v != null) {
        clearErr('form3.warna');
        regmv3formbloc?.add(ComboMWarnaChangedEvent(comboMWarna: v));
      }
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
    ],
    errorText: err('form3.aksesoris'),
    validator: (_) => err('form3.aksesoris'),
    onChanged: (v) {
      if (v.trim().isNotEmpty) clearErr('form3.aksesoris');
    },
  );
  //form3

  //form4
  Widget _buildBodyForm4() {
    final uploadState = context.watch<RegmvUploadStnkBloc>().state;

    final bool hasPreview =
        uploadState is UploadStnkListPreview && uploadState.images.isNotEmpty;
    final bool hasServer = _serverPhotosRegmv4.isNotEmpty;

    final bool showIntro = !hasPreview && !hasServer;
    final bool isUploading = uploadState is UploadStnkLoading;

    final borderColor = _form4HasError ? Colors.red : sGrey;

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
          border: Border.all(color: borderColor, width: _form4HasError ? 1.5 : 1),
          color: formGrey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIntro) _buildIntroForm4(),
            if (!showIntro) _buildGalleryForm4(uploadState: uploadState),
            const SizedBox(height: hPadding),

            _buildPickButtonsForm4(
              disabled: isUploading,
              previewCount: _imagesRegmv4.length,
            ),

            if (_form4HasError && _form4ErrorText != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _form4ErrorText!,
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

  Widget _buildIntroForm4() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto STNK",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto STNK jelas, terang, dan tidak buram.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cardGrey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGalleryForm4({required RegmvUploadStnkState uploadState}) {
    final hasPreview =
        uploadState is UploadStnkListPreview && uploadState.images.isNotEmpty;

    if (hasPreview && uploadState is UploadStnkListPreview) {
      final images = uploadState.images;

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _photoTileForm4(
              child: Image.memory(images[index], fit: BoxFit.cover),
              onDelete: () => _deletePreviewForm4(index),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _serverPhotosRegmv4.length,
        itemBuilder: (context, index) {
          final item = _serverPhotosRegmv4[index];
          final url =
              "${AppData.apiDomain}api/regmv/regmv4cari/stnk/getfoto/${item.regmv4Id}";

          final isDeleting = _deletingServerIdsRegmv4.contains(item.regmv4Id);

          return _photoTileForm4(
            child: Image.network(
              url,
              headers: {"Authorization": "Bearer ${AppData.userToken}"},
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, err, st) =>
              const Icon(Icons.broken_image, color: Colors.red, size: 48),
            ),
            onDelete: isDeleting ? null : () => _deleteServerPhotoForm4(item),
          );
        },
      ),
    );
  }

  Widget _photoTileForm4({required Widget child, VoidCallback? onDelete}) {
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

  Widget _buildPickButtonsForm4({required bool disabled, required int previewCount}) {
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
                ? _maxReachedForm4
                : _pickFromGalleryForm4,
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
                ? _maxReachedForm4
                : _pickFromCameraForm4,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButtonForm4({required bool disabled}) {
    final canUpload = !disabled &&
        widget.regmv1Id != null &&
        widget.regmv1Id!.isNotEmpty &&
        _imagesRegmv4.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canUpload ? _onUploadPressedForm4 : null,
        child: const Text("Upload"),
      ),
    );
  }

  void _maxReachedForm4() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maksimal 10 foto."),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _deletePreviewForm4(int index) {
    _imagesRegmv4.removeAt(index);
    _fileNamesRegmv4.removeAt(index);

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkSelectedList(List.from(_imagesRegmv4), List.from(_fileNamesRegmv4)),
    );
  }

  void _deleteServerPhotoForm4(Regmv4CariModel item) {
    final id = item.regmv4Id;

    // mark deleting
    _deletingServerIdsRegmv4.add(id);

    // optimistic remove
    setState(() {
      _serverPhotosRegmv4.removeWhere((x) => x.regmv4Id == id);
    });

    // hit api hapus
    context.read<Regmv4FormBloc>().add(
      Regmv4FormHapusEvent(recordId: id),
    );
  }

  Future<void> _pickFromGalleryForm4() async {
    if (_imagesRegmv4.length >= 10) {
      _maxReachedForm4();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (_imagesRegmv4.length >= 10) break;
      if (file.bytes == null) continue;
      _imagesRegmv4.add(file.bytes!);
      _fileNamesRegmv4.add(file.name);
    }

    if (_imagesRegmv4.isNotEmpty) {
      setState(() {
        _form4HasError = false;
        _form4ErrorText = null;
      });
    }

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkSelectedList(
        List.from(_imagesRegmv4),
        List.from(_fileNamesRegmv4),
      ),
    );
  }

  Future<void> _pickFromCameraForm4() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }

    if (_imagesRegmv4.length >= 10) {
      _maxReachedForm4();
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    _imagesRegmv4.add(bytes);
    _fileNamesRegmv4.add(picked.name);

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkSelectedList(List.from(_imagesRegmv4), List.from(_fileNamesRegmv4)),
    );
  }

  void _onUploadPressedForm4() {
    debugPrint("🔥 _onUploadPressedForm4 CALLED");

    final id = widget.regmv1Id;
    debugPrint("regmv1Id: $id");

    if (id == null || id.isEmpty) {
      debugPrint("❌ regmv1Id null atau empty, return");
      return;
    }

    debugPrint("_imagesRegmv4 length: ${_imagesRegmv4.length}");
    debugPrint("_fileNamesRegmv4 length: ${_fileNamesRegmv4.length}");

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkBatchSubmit(
        regmv1Id: id,
        images: List.from(_imagesRegmv4),
        names: List.from(_fileNamesRegmv4),
      ),
    );

    debugPrint("✅ UploadStnkBatchSubmit event SENT");
  }

  //form4

  //form5
  Widget _buildBodyForm5() {
    final uploadState = context.watch<RegmvUploadFotoMobilBloc>().state;

    final bool hasPreview =
        uploadState is UploadFotoMobilListPreview && uploadState.images.isNotEmpty;
    final bool hasServer = _serverPhotosRegmv5.isNotEmpty;

    final bool showIntro = !hasPreview && !hasServer;
    final bool isUploading = uploadState is UploadFotoMobilLoading;

    final borderColor = _form5HasError ? Colors.red : sGrey;

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
          border: Border.all(color: borderColor, width: _form5HasError ? 1.5 : 1),
          color: formGrey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIntro) _buildIntroForm5(),
            if (!showIntro) _buildGalleryForm5(uploadState: uploadState),
            const SizedBox(height: hPadding),

            _buildPickButtonsForm5(
              disabled: isUploading,
              previewCount: _imagesRegmv5.length,
            ),

            if (_form5HasError && _form5ErrorText != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _form5ErrorText!,
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

  Widget _buildIntroForm5() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto Mobil",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto FotoMobil jelas, terang, dan tidak buram.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cardGrey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGalleryForm5({required RegmvUploadFotoMobilState uploadState}) {
    final hasPreview =
        uploadState is UploadFotoMobilListPreview && uploadState.images.isNotEmpty;

    if (hasPreview && uploadState is UploadFotoMobilListPreview) {
      final images = uploadState.images;

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _photoTileForm5(
              child: Image.memory(images[index], fit: BoxFit.cover),
              onDelete: () => _deletePreviewForm5(index),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _serverPhotosRegmv5.length,
        itemBuilder: (context, index) {
          final item = _serverPhotosRegmv5[index];
          final url =
              "${AppData.apiDomain}api/regmv/regmv5cari/mobil/getfoto/${item.regmv5Id}";

          final isDeleting = _deletingServerIdsRegmv5.contains(item.regmv5Id);

          return _photoTileForm5(
            child: Image.network(
              url,
              headers: {"Authorization": "Bearer ${AppData.userToken}"},
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, err, st) =>
              const Icon(Icons.broken_image, color: Colors.red, size: 48),
            ),
            onDelete: isDeleting ? null : () => _deleteServerPhotoForm5(item),
          );
        },
      ),
    );
  }

  Widget _photoTileForm5({required Widget child, VoidCallback? onDelete}) {
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

  Widget _buildPickButtonsForm5({required bool disabled, required int previewCount}) {
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
                ? _maxReachedForm5
                : _pickFromGalleryForm5,
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
                ? _maxReachedForm5
                : _pickFromCameraForm5,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButtonForm5({required bool disabled}) {
    final canUpload = !disabled &&
        widget.regmv1Id != null &&
        widget.regmv1Id!.isNotEmpty &&
        _imagesRegmv5.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canUpload ? _onUploadPressedForm5 : null,
        child: const Text("Upload"),
      ),
    );
  }

  void _maxReachedForm5() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maksimal 10 foto."),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _deletePreviewForm5(int index) {
    _imagesRegmv5.removeAt(index);
    _fileNamesRegmv5.removeAt(index);

    context.read<RegmvUploadFotoMobilBloc>().add(
      UploadFotoMobilSelectedList(List.from(_imagesRegmv5), List.from(_fileNamesRegmv5)),
    );
  }

  void _deleteServerPhotoForm5(Regmv5CariModel item) {
    final id = item.regmv5Id;

    // mark deleting
    _deletingServerIdsRegmv5.add(id);

    // optimistic remove
    setState(() {
      _serverPhotosRegmv5.removeWhere((x) => x.regmv5Id == id);
    });

    // hit api hapus
    context.read<Regmv5FormBloc>().add(
      Regmv5FormHapusEvent(recordId: id),
    );
  }

  Future<void> _pickFromGalleryForm5() async {
    if (_imagesRegmv5.length >= 10) {
      _maxReachedForm5();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (_imagesRegmv5.length >= 10) break;
      if (file.bytes == null) continue;
      _imagesRegmv5.add(file.bytes!);
      _fileNamesRegmv5.add(file.name);
    }

    if (_imagesRegmv5.isNotEmpty) {
      setState(() {
        _form5HasError = false;
        _form5ErrorText = null;
      });
    }

    context.read<RegmvUploadFotoMobilBloc>().add(
      UploadFotoMobilSelectedList(
        List.from(_imagesRegmv5),
        List.from(_fileNamesRegmv5),
      ),
    );
  }

  Future<void> _pickFromCameraForm5() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }

    if (_imagesRegmv5.length >= 10) {
      _maxReachedForm5();
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    _imagesRegmv5.add(bytes);
    _fileNamesRegmv5.add(picked.name);

    context.read<RegmvUploadFotoMobilBloc>().add(
      UploadFotoMobilSelectedList(List.from(_imagesRegmv5), List.from(_fileNamesRegmv5)),
    );
  }

  void _onUploadPressedForm5() {
    final id = widget.regmv1Id;
    if (id == null || id.isEmpty) return;

    context.read<RegmvUploadFotoMobilBloc>().add(
      UploadFotoMobilBatchSubmit(
        regmv1Id: id,
        images: List.from(_imagesRegmv5),
        names: List.from(_fileNamesRegmv5),
      ),
    );
  }
  //form5

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


  //form7
  Widget _buildBodyForm7() {
    final uploadState = context.watch<RegmvUploadFotoAccBloc>().state;

    final bool hasPreview =
        uploadState is UploadFotoAccListPreview && uploadState.images.isNotEmpty;
    final bool hasServer = _serverPhotosRegmv7.isNotEmpty;

    final bool showIntro = !hasPreview && !hasServer;
    final bool isUploading = uploadState is UploadFotoAccLoading;

    final borderColor = _form7HasError ? Colors.red : sGrey;

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
          border: Border.all(color: borderColor, width: _form7HasError ? 1.5 : 1),
          color: formGrey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIntro) _buildIntroForm7(),
            if (!showIntro) _buildGalleryForm7(uploadState: uploadState),
            const SizedBox(height: hPadding),

            _buildPickButtonsForm7(
              disabled: isUploading,
              previewCount: _imagesRegmv7.length,
            ),

            if (_form7HasError && _form7ErrorText != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _form7ErrorText!,
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

  Widget _buildIntroForm7() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto FotoAcc",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto FotoAcc jelas, terang, dan tidak buram.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cardGrey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGalleryForm7({required RegmvUploadFotoAccState uploadState}) {
    final hasPreview =
        uploadState is UploadFotoAccListPreview && uploadState.images.isNotEmpty;

    if (hasPreview && uploadState is UploadFotoAccListPreview) {
      final images = uploadState.images;

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _photoTileForm7(
              child: Image.memory(images[index], fit: BoxFit.cover),
              onDelete: () => _deletePreviewForm7(index),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _serverPhotosRegmv7.length,
        itemBuilder: (context, index) {
          final item = _serverPhotosRegmv7[index];
          final url =
              "${AppData.apiDomain}api/regmv/regmv7cari/FotoAcc/getfoto/${item.regmv7Id}";

          final isDeleting = _deletingServerIdsRegmv7.contains(item.regmv7Id);

          return _photoTileForm7(
            child: Image.network(
              url,
              headers: {"Authorization": "Bearer ${AppData.userToken}"},
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, err, st) =>
              const Icon(Icons.broken_image, color: Colors.red, size: 48),
            ),
            onDelete: isDeleting ? null : () => _deleteServerPhotoForm7(item),
          );
        },
      ),
    );
  }

  Widget _photoTileForm7({required Widget child, VoidCallback? onDelete}) {
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

  Widget _buildPickButtonsForm7({required bool disabled, required int previewCount}) {
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
                ? _maxReachedForm7
                : _pickFromGalleryForm7,
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
                ? _maxReachedForm7
                : _pickFromCameraForm7,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButtonForm7({required bool disabled}) {
    final canUpload = !disabled &&
        widget.regmv1Id != null &&
        widget.regmv1Id!.isNotEmpty &&
        _imagesRegmv7.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canUpload ? _onUploadPressedForm7 : null,
        child: const Text("Upload"),
      ),
    );
  }

  void _maxReachedForm7() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maksimal 10 foto."),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _deletePreviewForm7(int index) {
    _imagesRegmv7.removeAt(index);
    _fileNamesRegmv7.removeAt(index);

    context.read<RegmvUploadFotoAccBloc>().add(
      UploadFotoAccSelectedList(List.from(_imagesRegmv7), List.from(_fileNamesRegmv7)),
    );
  }

  void _deleteServerPhotoForm7(Regmv7CariModel item) {
    final id = item.regmv7Id;

    // mark deleting
    _deletingServerIdsRegmv7.add(id);

    // optimistic remove
    setState(() {
      _serverPhotosRegmv7.removeWhere((x) => x.regmv7Id == id);
    });

    // hit api hapus
    context.read<Regmv7FormBloc>().add(
      Regmv7FormHapusEvent(recordId: id),
    );
  }

  Future<void> _pickFromGalleryForm7() async {
    if (_imagesRegmv7.length >= 10) {
      _maxReachedForm7();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (_imagesRegmv7.length >= 10) break;
      if (file.bytes == null) continue;
      _imagesRegmv7.add(file.bytes!);
      _fileNamesRegmv7.add(file.name);
    }

    if (_imagesRegmv7.isNotEmpty) {
      setState(() {
        _form7HasError = false;
        _form7ErrorText = null;
      });
    }

    context.read<RegmvUploadFotoAccBloc>().add(
      UploadFotoAccSelectedList(
        List.from(_imagesRegmv7),
        List.from(_fileNamesRegmv7),
      ),
    );
  }

  Future<void> _pickFromCameraForm7() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }

    if (_imagesRegmv7.length >= 10) {
      _maxReachedForm7();
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    _imagesRegmv7.add(bytes);
    _fileNamesRegmv7.add(picked.name);

    context.read<RegmvUploadFotoAccBloc>().add(
      UploadFotoAccSelectedList(List.from(_imagesRegmv7), List.from(_fileNamesRegmv7)),
    );
  }

  void _onUploadPressedForm7() {
    final id = widget.regmv1Id;
    if (id == null || id.isEmpty) return;

    context.read<RegmvUploadFotoAccBloc>().add(
      UploadFotoAccBatchSubmit(
        regmv1Id: id,
        images: List.from(_imagesRegmv7),
        names: List.from(_fileNamesRegmv7),
      ),
    );
  }
//form7



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
}