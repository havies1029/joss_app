import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/calpar/calpar1crud_bloc.dart';
import '../../../blocs/calpar/calpar1list_bloc.dart';
import '../../../blocs/calpar/calpar2form_bloc.dart';
import '../../../blocs/calpar/calpar3form_bloc.dart';
import '../../../blocs/calpar/calpar4form_bloc.dart';
import '../../../blocs/calpar/calpar_flow_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/thousand_separator_input_formatter.dart';
import '../../../models/calpar/calpar1crud_model.dart';
import '../../../models/calpar/calpar2form_model.dart';
import '../../../models/calpar/calpar3form_model.dart';
import '../../../models/calpar/calpar4form_model.dart';
import '../../../models/combobox/combombiindemnityojk_model.dart';
import '../../../models/combobox/combomjnscoverpar_model.dart';
import '../../../models/combobox/combomkabzonagempa_model.dart';
import '../../../models/combobox/combomwilayah_model.dart';
import '../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../models/combobox/combormatauang_model.dart';
import '../../../models/combobox/comborokupasi_model.dart';
import '../../../models/user/user_model.dart';
import '../../../repositories/combobox/combomjnscoverpar_repository.dart';
import '../../../repositories/combobox/combomkabzonagempa_repository.dart';
import '../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../repositories/combobox/comborkonstruksiojk_repository.dart';
import '../../../repositories/combobox/combormatauang_repository.dart';
import '../../../repositories/combobox/comborokupasi_repository.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import '../../profile/mobile/profile/form_section/popup/rekan_general_cmp.dart';
import '../../profile/mobile/profile/form_section/popup/rekan_general_idv.dart';
import '../../register/mobile/client/register_client_page.dart';
import '../../regpar/mobile/regpar_main_page_remake.dart';

enum CalparFormSection { form1, form2, form3, form4 }

class CalparMainPageRemake extends StatefulWidget {

  const CalparMainPageRemake({
    super.key,
  });

  @override
  State<CalparMainPageRemake> createState() => _CalparMainPageRemakeState();
}


class _CalparMainPageRemakeState extends State<CalparMainPageRemake> {
  List<bool> expanded = List.filled(CalparFormSection.values.length, false);

  int getOpenedIndex() => expanded.indexWhere((e) => e);
  int sectionIndex(CalparFormSection s) => CalparFormSection.values.indexOf(s);

  String? calpar1Id;
  String? calpar2Id;
  String? calpar3Id;
  String? calpar4Id;

  Calpar1CrudModel? form1Record;
  Calpar2FormModel? form2Record;
  Calpar3FormModel? form3Record;
  Calpar4FormModel? form4Record;

  Calpar3FormBloc? calpar3formBloc;
  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;

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

  //form1
  final fieldCoverBulanController = TextEditingController();
  ComboRKonstruksiojkModel? previousKonstruksi;
  ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
  final konstruksiKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
  ComboROkupasiModel? fieldComboROkupasi;
  //form1

  //form2
  final fieldBiIndexRateController = TextEditingController();
  final fieldBiTotalController = TextEditingController();
  final fieldSiBiController = TextEditingController();
  final fieldSiBuildingController = TextEditingController();
  final fieldSiContentController = TextEditingController();
  final fieldSiMachineryController = TextEditingController();
  final fieldSiOtherController = TextEditingController();
  final fieldSiStockController = TextEditingController();
  final fieldStockAdjustableController = TextEditingController();
  ComboMBiindemnityOjkModel? fieldComboMBiindemnityOjk;
  ComboRMatauangModel? fieldComboRMatauang;
  //form2

  //form3
  final fieldIsEqController = TextEditingController();
  final fieldIsTsfwdController = TextEditingController();
  final fieldIsFlexasController = TextEditingController();
  final fieldIsOtherController = TextEditingController();
  final fieldIsRsmdccController = TextEditingController();
  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  final ComboMWilayah = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  //form3

  //form4
  final fieldDiscNilaiController = TextEditingController();
  final fieldDiscPersenController = TextEditingController();
  final fieldPremiBiController = TextEditingController();
  final fieldPremiEqvetController = TextEditingController();
  final fieldPremiNetController = TextEditingController();
  final filedPremiTotalController = TextEditingController();
  final fieldPremiOtherController = TextEditingController();
  final fieldPremiParController = TextEditingController();
  final fieldPremiRsmdccController = TextEditingController();
  final fieldPremiTsfwdController = TextEditingController();
  //form4

  @override
  void initState() {
    super.initState();
    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();
    mRekanGeneralCmpCrudBloc = context.read<MRekanGeneralCmpCrudBloc>();

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mjenisClient == "10") {
        mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
      }else if (mjenisClient == "20"){
        mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());
      }
    });

    fieldCoverBulanController.text = "12";

    expanded = List.filled(CalparFormSection.values.length, false);
    expanded[sectionIndex(CalparFormSection.form1)] = true;
  }

  @override
  void dispose() {
    //form1
    fieldCoverBulanController.dispose();
    //form1

    //form2
    fieldBiIndexRateController.dispose();
    fieldBiTotalController.dispose();
    fieldSiBiController.dispose();
    fieldSiBuildingController.dispose();
    fieldSiContentController.dispose();
    fieldSiMachineryController.dispose();
    fieldSiOtherController.dispose();
    fieldSiStockController.dispose();
    fieldStockAdjustableController.dispose();

    //form3
    fieldIsEqController.dispose();
    fieldIsTsfwdController.dispose();
    fieldIsFlexasController.dispose();
    fieldIsOtherController.dispose();
    fieldIsRsmdccController.dispose();

    //form4
    fieldDiscNilaiController.dispose();
    fieldDiscPersenController.dispose();
    fieldPremiBiController.dispose();
    fieldPremiEqvetController.dispose();
    fieldPremiNetController.dispose();
    fieldPremiOtherController.dispose();
    fieldPremiParController.dispose();
    fieldPremiRsmdccController.dispose();
    fieldPremiTsfwdController.dispose();
    filedPremiTotalController.dispose();
    super.dispose();
  }

  void refreshForm1({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Calpar1CrudBloc>().add(
      Calpar1CrudLihatEvent(recordId: recordId),
    );
  }

  void refreshForm2({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Calpar2FormBloc>().add(
      Calpar2FormLihatEvent(recordId: recordId),
    );
  }

  void refreshForm3({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Calpar3FormBloc>().add(
      Calpar3FormLihatEvent(recordId: recordId),
    );
  }

  void _payloadform1(Calpar1CrudModel record) {
    setState(() {
      final jnsCoverPar = record.comboMJnscoverPar;
      if (fieldComboMJnscoverPar == null && jnsCoverPar != null) {
        fieldComboMJnscoverPar = jnsCoverPar;
        _applyCoverParRule(jnsCoverPar.mjnscoverparId); // ✅ sync dari data
      }

      final konstruksi = record.comboRKonstruksiojk;
      if (fieldComboRKonstruksiojk == null && konstruksi != null) {
        fieldComboRKonstruksiojk = konstruksi;
      }

      if (previousKonstruksi == null && konstruksi != null) {
        previousKonstruksi = konstruksi;
      }

      final okupasi = record.comboROkupasi;
      if (fieldComboROkupasi == null && okupasi != null) {
        fieldComboROkupasi = okupasi;
      }
    });
  }

  void _payloadform2(Calpar2FormModel record) {
    if (fieldBiIndexRateController.text.trim().isEmpty) {
      fieldBiIndexRateController.text = record.biIndexRate.toString();
    }

    if (fieldBiTotalController.text.trim().isEmpty) {
      fieldBiTotalController.text = record.biTotal.toString();
    }

    if (fieldSiBiController.text.trim().isEmpty) {
      fieldSiBiController.text = record.siBi.toString();
    }

    if (fieldSiBuildingController.text.trim().isEmpty) {
      fieldSiBuildingController.text = record.siBuilding.toString();
    }

    if (fieldSiContentController.text.trim().isEmpty) {
      fieldSiContentController.text = record.siContent.toString();
    }

    if (fieldSiMachineryController.text.trim().isEmpty) {
      fieldSiMachineryController.text = record.siMachinery.toString();
    }

    if (fieldSiOtherController.text.trim().isEmpty) {
      fieldSiOtherController.text = record.siOther.toString();
    }

    if (fieldSiStockController.text.trim().isEmpty) {
      fieldSiStockController.text = record.siStock.toString();
    }

    if (fieldStockAdjustableController.text.trim().isEmpty) {
      fieldStockAdjustableController.text = record.stockAdjustable.toString();
    }

    setState(() {
      final indemnity = record.comboMBiindemnityOjk;
      if (fieldComboMBiindemnityOjk == null && indemnity != null) {
        fieldComboMBiindemnityOjk = indemnity;
      }

      final mataUang = record.comboRMatauang;
      if (fieldComboRMatauang == null && mataUang != null) {
        fieldComboRMatauang = mataUang;
      }
    });
  }

  void _payloadform3(Calpar3FormModel record) {
    if (fieldIsEqController.text.trim().isEmpty) {
      fieldIsEqController.text = (record.isEq ?? false).toString();
    }

    if (fieldIsTsfwdController.text.trim().isEmpty) {
      fieldIsTsfwdController.text = (record.isTsfwd ?? false).toString();
    }

    if (fieldIsFlexasController.text.trim().isEmpty) {
      fieldIsFlexasController.text = (record.isFlexas ?? false).toString();
    }

    if (fieldIsOtherController.text.trim().isEmpty) {
      fieldIsOtherController.text = (record.isOther ?? false).toString();
    }

    if (fieldIsRsmdccController.text.trim().isEmpty) {
      fieldIsRsmdccController.text = (record.isRsmdcc ?? false).toString();
    }

    setState(() {
      final jnsCoverPar = record.comboMJnscoverPar;
      if (fieldComboMJnscoverPar == null && jnsCoverPar != null) {
        fieldComboMJnscoverPar = jnsCoverPar;
      }

      final zonaGempa = record.comboMKabZonaGempa;
      if (fieldComboMKabZonaGempa == null && zonaGempa != null) {
        fieldComboMKabZonaGempa = zonaGempa;
      }

      final wilayah = record.comboMWilayah;
      if (fieldComboMWilayah == null && wilayah != null) {
        fieldComboMWilayah = wilayah;
      }
    });
  }

  void _payloadform4(Calpar4FormModel record) {
    fieldDiscNilaiController.text = record.discNilai.toString();
    fieldDiscPersenController.text = record.discPersen.toString();
    fieldPremiBiController.text = record.premiBi.toString();
    fieldPremiEqvetController.text = record.premiEqvet.toString();
    fieldPremiNetController.text = record.premiNet.toString();
    fieldPremiOtherController.text = record.premiOther.toString();
    fieldPremiParController.text = record.premiPar.toString();
    fieldPremiRsmdccController.text = record.premiRsmdcc.toString();
    fieldPremiTsfwdController.text = record.premiTsfwd.toString();
    filedPremiTotalController.text = record.premiTotal.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Properti",
      blocListeners: [
        BlocListener<Calpar1ListBloc, Calpar1ListState>(
          listenWhen: (prev, curr) {
            return prev.processMessage != curr.processMessage &&
                (curr.processMessage).isNotEmpty;
          },
          listener: (context, state) {
            final calpar1 = context.read<Calpar1CrudBloc>().state.record?.calpar1Id ?? "";
            context.read<Calpar1ListBloc>().add(ClearProcessMessageEvent());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegparFormMainRemake(regpar1Id: state.processMessage, calpar1Id: calpar1Id,),
              ),
            );

            if (calpar1.isNotEmpty) {
              context.read<Calpar1CrudBloc>().add(Calpar1CrudLihatEvent(recordId: calpar1));
            }
          },
        ),

        BlocListener<Calpar1CrudBloc, Calpar1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calpar1Id = state.record!.calpar1Id;
              });
            }
            if (state.isLoaded && !state.hasFailure && state.record != null) {
              _payloadform1(state.record!);
            }
          },
        ),

        BlocListener<Calpar2FormBloc, Calpar2FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calpar2Id = state.record!.calpar2Id;
              });
            }
            if (state.isLoaded && !state.hasFailure && state.record != null) {
              _payloadform2(state.record!);
            }
          },
        ),

        BlocListener<Calpar3FormBloc, Calpar3FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calpar3Id = state.record!.calpar3Id;
              });
            }
            if (state.isLoaded && !state.hasFailure && state.record != null) {
              _payloadform3(state.record!);
            }
          },
        ),

        BlocListener<Calpar4FormBloc, Calpar4FormState>(
          listener: (context, state) {
            if (state.record != null) {
              if (state.isLoaded) {
                setState(() {
                  calpar4Id = state.record!.calpar4Id;
                });

                _payloadform4(state.record!);

                if (state.record!.calpar4Id.isNotEmpty) {
                  openForm4();
                }
              }

              // kalau ada flow lain yang memang pakai isSaved
              if (state.isSaved) {
                setState(() {
                  calpar4Id = state.record!.calpar4Id;
                });

                if (state.record!.calpar4Id.isNotEmpty) {
                  openForm4();
                }
              }
            }
          },
        ),

      ],
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
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
                title: "Properti",
                subtitle:
                "Isi semua detail untuk menghitung premi secara otomatis.",
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
                    title: "Informasi Bangunan",
                    isExpanded: expanded[0],
                    onToggle: (v) => setState(() => expanded[0] = v),
                    onRefresh: () {
                      if (calpar1Id != null && calpar1Id!.isNotEmpty) {
                        refreshForm1(recordId: calpar1Id);
                      }
                    },
                    child: Column(
                      children: [
                        buildFieldCoverBulan(),
                        const SizedBox(height: hPadding),
                        buildFieldRokupasiId(),
                        const SizedBox(height: hPadding),
                        buildFieldRkonstruksiojkId(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form2Page(
                    context: context,
                    title: "Nilai Pertanggungan",
                    isExpanded: expanded[1],
                    onToggle: (v) => setState(() => expanded[1] = v),
                    onRefresh: () {
                      if (calpar2Id != null && calpar2Id!.isNotEmpty) {
                        refreshForm2(recordId: calpar2Id);
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(child: buildFieldRmatauangKode()),
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

                  Form3Page(
                    context: context,
                    title: "Perhitungan Tarif",
                    isExpanded: expanded[2],
                    onToggle: (v) => setState(() => expanded[2] = v),
                    onRefresh: () {
                      if (calpar3Id != null && calpar3Id!.isNotEmpty) {
                        refreshForm3(recordId: calpar3Id);
                      }
                    },
                    child: Column(
                      children: [
                        buildFieldMjnscoverparId(),
                        const SizedBox(height: hPadding),
                        Row(
                          children: [
                            Flexible(child: buildFieldIsEq()),
                            const SizedBox(width: 8),
                            Flexible(child: buildFieldIsTsfwd()),
                          ],
                        ),
                        const SizedBox(height: hPadding),
                        Row(
                          children: [
                            Flexible(child: buildFieldIsFlexas()),
                            const SizedBox(width: 8),
                            Flexible(child: buildFieldIsRsmdcc()),
                          ],
                        ),
                        const SizedBox(height: hPadding),
                        Row(
                          children: [
                            Flexible(child: buildFieldIsOther()),
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

                  buildButtonHitungPremi(),

                  const SizedBox(height: hPadding),

                  Form4Page(
                    context: context,
                    title: "Perhitungan Premi",
                    isExpanded: expanded[3],
                    onToggle: (v) => setState(() => expanded[3] = v),
                    child: (calpar4Id?.isNotEmpty == true)
                        ? Column(
                      children: [
                        HitungPremiWidget(
                          rows: [
                            HitungPremiRow(
                              label: "Premi",
                              controller: filedPremiTotalController,
                              layoutType: HitungPremiLayoutType.vertical,
                              showValueBorder: true,
                              formatNumber: true,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol ?? "",
                            ),
                            HitungPremiRow(
                              label: "Diskon",
                              controller: fieldDiscNilaiController,
                              layoutType: HitungPremiLayoutType.vertical,
                              showValueBorder: true,
                              formatNumber: true,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol ?? "",
                            ),
                            HitungPremiRow(
                              label: "Net Premi",
                              controller: fieldPremiNetController,
                              layoutType: HitungPremiLayoutType.vertical,
                              showValueBorder: true,
                              formatNumber: true,
                              valuePrefix: fieldComboRMatauang?.rmatauangSimbol ?? "",
                            ),
                          ],
                        ),
                        // buildFieldPremiNet(),
                        // const SizedBox(height: hPadding),
                        // buildFieldDiscNilai(),
                        // const SizedBox(height: hPadding),
                        // buildFieldPremiOther(),
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

                  if (calpar4Id?.isNotEmpty == true) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BlocBuilder<Calpar1ListBloc, Calpar1ListState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "*Dengan melanjutkan, Anda akan diminta mengisi detail tambahan terkait kategori yang dipilih untuk memastikan data polis lebih akurat.",
                                style: bodyTextStyle(context).copyWith(
                                  color: primaryLightColor,
                                  fontSize: getResponsiveFont(context, 14),
                                ),
                              ),
                              const SizedBox(height: hPadding),
                              AppButton.primary(
                                text: state.isProcessing ? "Memproses..." : "Lanjutkan",
                                isLoading: state.isProcessing,
                                onPressed: state.isProcessing ? null : onLanjutkanPressed,
                              ),
                            ],
                          );
                        },
                      ),
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
              tryOpenSection(CalparFormSection.form1, onRefresh: onRefresh);
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
            tryOpenSection(CalparFormSection.form2, onRefresh: onRefresh);
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
              tryOpenSection(CalparFormSection.form3, onRefresh: onRefresh);
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
              child: SvgPicture.asset(
                "assets/icons/dropdown.svg",
                width: 16,
              ),
            ),
            onTap: () {
              tryOpenSection(CalparFormSection.form4);
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

  Future<void> onLanjutkanPressed() async {
    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;
    if (context
        .read<Calpar1ListBloc>()
        .state
        .isProcessing) {
      return;
    }


    if (context
        .read<AuthenticationBloc>()
        .state is AuthenticationAuthenticated) {
      User user = (context
          .read<AuthenticationBloc>()
          .state as AuthenticationAuthenticated).user;
      if (user.userType == "C") {
        if (mjenisClient == "10") {
          final mRekanNama1 =
              context.read<MRekanGeneralIdvCrudBloc>().state.record?.rekanNama ?? "";

          if (mRekanNama1.isEmpty) {
            showDialog(
              context: context,
              barrierDismissible: true, // klik luar = close
              barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
              builder: (context) => RegisterClientPopUp(
                header: 'Isi Data Pribadi Anda',
                description:
                'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
                buttonText: 'Lengkapi Data Pribadi',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MRekanGeneralIdvPopUpPage(popTwice: false,),
                    ),
                  );
                },
              ),
            );
            return;
          }
        }
        else if (mjenisClient == "20") {
          final mRekanNama2 =
              context.read<MRekanGeneralCmpCrudBloc>().state.record?.rekanNama ?? "";

          if (mRekanNama2.isEmpty) {
            showDialog(
              context: context,
              barrierDismissible: true, // klik luar = close
              barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
              builder: (context) => RegisterClientPopUp(
                header: 'Isi Data Pribadi Anda',
                description:
                'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
                buttonText: 'Lengkapi Data Pribadi',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MRekanGeneralCmpPopUpPage(popTwice: false,),
                    ),
                  );
                },
              ),
            );
            return;
          }
        }
        context.read<Calpar1ListBloc>().add(
          CalPar2RegParEvent(calpar1Id: calpar1Id!),
        );
      }
      else {
        showDialog(
          context: context,
          barrierDismissible: true, // klik luar = close
          barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
          builder: (context) => RegisterClientPopUp(
            header: 'Data Klien Belum Terdaftar!',
            description:
            'Untuk melanjutkan ke proses Klaim Baru, Anda perlu mendaftarkan data klien terlebih dahulu.',
            buttonText: 'Daftar Klien',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterClient(requestFrom: 'calpar_page')
                ),
              );
            },
          ),
        );
      }
    }
  }

  void draftForm1ToBloc(BuildContext context) {
    final record = Calpar1CrudModel(
      calpar1Id: calpar1Id ?? "",
      coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(",", "")) ?? 12,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
      rokupasiId: fieldComboROkupasi?.rokupasiId,
    );
    context.read<Calpar1CrudBloc>().add(Calpar1DraftEvent(record: record));
  }

  void draftForm2ToBloc(BuildContext context) {
    final record = Calpar2FormModel(
      calpar2Id: calpar2Id ?? "",
      calpar1Id: calpar1Id ?? "",
      biIndexRate: double.tryParse(fieldBiIndexRateController.text.replaceAll(',', '')) ?? 0,
      biTotal: double.tryParse(fieldBiTotalController.text.replaceAll(',', '')) ?? 0,
      siBi: double.tryParse(fieldSiBiController.text.replaceAll(',', '')) ?? 0,
      stockAdjustable: double.tryParse(fieldStockAdjustableController.text.replaceAll(',', '')) ?? 0,
      mbiindemnityojkId: fieldComboMBiindemnityOjk?.mbiindemnityojkId,
      rmatauangKode: fieldComboRMatauang?.rmatauangKode,
      siBuilding: double.parse(fieldSiBuildingController.text.replaceAll(',', '')),
      siContent: double.parse(fieldSiContentController.text.replaceAll(',', '')),
      siMachinery: double.parse(fieldSiMachineryController.text.replaceAll(',', '')),
      siOther: double.parse(fieldSiOtherController.text.replaceAll(',', '')),
      siStock: double.parse(fieldSiStockController.text.replaceAll(',', '')),
    );

    context.read<Calpar2FormBloc>().add(Calpar2DraftEvent(record: record));
  }

  void draftForm3ToBloc(BuildContext context) {
    final record = Calpar3FormModel(
      calpar3Id: calpar3Id ?? "",
      calpar1Id: calpar1Id ?? "",
      isEq: toBoolean(fieldIsEqController.text),
      isTsfwd: toBoolean(fieldIsTsfwdController.text),
      isFlexas: toBoolean(fieldIsFlexasController.text),
      isOther: toBoolean(fieldIsOtherController.text),
      isRsmdcc: toBoolean(fieldIsRsmdccController.text),
      kab2zonagempaId: fieldComboMKabZonaGempa?.mkabzonagempaId,
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
    );

    context.read<Calpar3FormBloc>().add(Calpar3DraftEvent(record: record));
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
      openForm1();
      return;
    }
    final ok2 = validateForm2();
    if (!ok2) {
      openForm2();
      return;
    }

    final ok3 = validateForm3();
    if (!ok3) {
      openForm3();
      return;
    }

    draftForm1ToBloc(context);
    draftForm2ToBloc(context);
    draftForm3ToBloc(context);

    context.read<CalparFlowBloc>().add(CalparFlowStartEvent());
  }

  void openForm1() => openSection(CalparFormSection.form1);
  void openForm2() => openSection(CalparFormSection.form2);
  void openForm3() => openSection(CalparFormSection.form3);
  void openForm4() => openSection(CalparFormSection.form4);

  bool validateForm1() {
    clearErrsByPrefix('form1.');

    bool ok = true;

    // Cover Bulan (required, > 0)
    final coverRaw = fieldCoverBulanController.text.trim();
    if (coverRaw.isEmpty) {
      setErr('form1.coverBulan', kStringNullError);
      ok = false;
    } else {
      final clean = coverRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null) {
        setErr('form1.coverBulan', "Format tidak valid");
        ok = false;
      } else if (angka < 0) {
        setErr('form1.coverBulan', "Harus lebih dari 0");
        ok = false;
      }
    }

    // Konstruksi (required)
    if (fieldComboRKonstruksiojk == null) {
      setErr('form1.rkonstruksiojkId', kStringNullError);
      ok = false;
    }

    // Okupasi (required)
    if (fieldComboROkupasi == null) {
      setErr('form1.rokupasiId', kStringNullError);
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

    double parseOrZeroAutoFill(TextEditingController c) {
      final raw = c.text.trim();
      if (raw.isEmpty) {
        c.text = '0';
        return 0;
      }
      final clean = raw.replaceAll(",", "");
      return double.tryParse(clean) ?? double.nan; // nan untuk tandain invalid
    }

    bool optionalPositiveNumAutoZero(TextEditingController c, String key) {
      final angka = parseOrZeroAutoFill(c);

      if (angka.isNaN) {
        setErr(key, kString0);
        return false;
      }

      if (angka < 0) {
        setErr(key, kString0);
        return false;
      }

      return true;
    }

    if (fieldComboRMatauang == null) {
      setErr('form2.mataUang', kStringNullError);
      ok = false;
    }

    ok = optionalPositiveNumAutoZero(fieldSiMachineryController, 'form2.siMachinery') && ok;
    ok = optionalPositiveNumAutoZero(fieldSiBuildingController, 'form2.siBuilding') && ok;
    ok = optionalPositiveNumAutoZero(fieldSiContentController, 'form2.siContent') && ok;
    ok = optionalPositiveNumAutoZero(fieldSiStockController, 'form2.siStock') && ok;
    ok = optionalPositiveNumAutoZero(fieldSiOtherController, 'form2.siOther') && ok;

    if (ok) {
      final vMachinery = parseOrZeroAutoFill(fieldSiMachineryController);
      final vBuilding  = parseOrZeroAutoFill(fieldSiBuildingController);
      final vContent   = parseOrZeroAutoFill(fieldSiContentController);
      final vStock     = parseOrZeroAutoFill(fieldSiStockController);
      final vOther     = parseOrZeroAutoFill(fieldSiOtherController);

      final anyGreaterThanZero =
          vMachinery > 0 || vBuilding > 0 || vContent > 0 || vStock > 0 || vOther > 0;

      if (!anyGreaterThanZero) {
        setErr('form2.siMachinery', 'Minimal salah satu nilai harus lebih dari 0');
        ok = false;
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

    if (fieldComboMJnscoverPar == null) {
      setErr('form3.mjnscoverparId', kStringNullError);
      ok = false;
    }

    if (fieldComboMWilayah == null) {
      setErr('form3.mwilayahId', kStringNullError);
      ok = false;
    }

    if (fieldComboMKabZonaGempa == null) {
      setErr('form3.kab2zonagempaId', kStringNullError);
      ok = false;
    }

    if (!ok) {
      setState(() => expanded[2] = true);
    }

    return ok;
  }



  //form1
  Widget buildFieldCoverBulan() => appTextField(
    label: "Lama Cover",
    controller: fieldCoverBulanController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    suffix: const Padding(
      padding: EdgeInsets.only(right: 8),
      child: Text("Bulan"),
    ),
    errorText: err('form1.coverBulan'),
    validator: (_) => err('form1.coverBulan'),
    enabled: false,
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) {
        clearErr('form1.coverBulan');
      }
    },
  );

  Widget buildFieldRkonstruksiojkId() =>
      ReusableComboBox<ComboRKonstruksiojkModel>(
        hintText: "Konstruksi",
        comboKey: konstruksiKey,
        maxHeight: 200,
        initItem: fieldComboRKonstruksiojk,
        dataLoader: () =>
            ComboRKonstruksiojkRepository().getComboRKonstruksiojk(),
        displayText: (i) => i.kelasNama,
        compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.rkonstruksiojkId'),

        onChangedCallback: (item) async {
          if (item == null) return;

          final subtitle = getKonstruksiSubtitle(item.kelasNama);

          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: formGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.kelasNama,
                        style: bodyTextStyle(context),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: bodyTextStyle(context, fontSize: 15)
                            .copyWith(color: hintGrey),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Text("Apakah Anda yakin ingin memilih kelas ini?",
                        style: bodyTextStyle(context, fontSize: 15)
                            .copyWith(color: hintGrey),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.primary(
                            text: "Tidak",
                            backgroundColor: sGrey,
                            onPressed: () =>
                                Navigator.pop(context, false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton.primary(
                            text: "Iya",
                            onPressed: () =>
                                Navigator.pop(context, true),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );

          if (confirm == true) {
            setState(() {
              fieldComboRKonstruksiojk = item;
              previousKonstruksi = item;
              clearErr('form1.rkonstruksiojkId');
            });
          } else {
            setState(() {
              konstruksiKey.currentState?.clear();
              fieldComboRKonstruksiojk = null;
              previousKonstruksi = null;
            });
          }
        },

        onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
      );

  Widget buildFieldRokupasiId() =>
      ReusableComboBox<ComboROkupasiModel>(
        hintText: "Okupasi",
        initItem: fieldComboROkupasi,
        dataLoader: () => ComboROkupasiRepository().getComboROkupasi(""),
        displayText: (item) => '${item.kodeOjk} - ${item.okupasiDesc}',
        compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.rokupasiId'),

        onChangedCallback: (v) {
          fieldComboROkupasi = v;
          if (v != null) clearErr('form1.rokupasiId');
        },

        onSaveCallback: (value) => fieldComboROkupasi = value,
      );

  //form1

  //form2

  Widget buildFieldRmatauangKode() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboRMatauang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (i) => i.rmatauangSimbol,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form2.mataUang'),
    onChangedCallback: (v) {
      fieldComboRMatauang = v;
      if (v != null) clearErr('form2.mataUang');
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
    errorText: err('form2.siBuilding'),
    validator: (_) => err('form2.siBuilding'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) clearErr('form2.siBuilding');
    },
  );

  Widget buildFieldSiContent() => appTextField(
    label: "Inventaris",
    controller: fieldSiContentController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.siContent'),
    validator: (_) => err('form2.siContent'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) clearErr('form2.siContent');
    },
  );

  Widget buildFieldSiMachinery() => appTextField(
    label: "Mesin",
    controller: fieldSiMachineryController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.siMachinery'),
    validator: (_) => err('form2.siMachinery'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) clearErr('form2.siMachinery');
    },
  );


  Widget buildFieldSiOther() => appTextField(
    label: "Lainnya",
    controller: fieldSiOtherController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.siOther'),
    validator: (_) => err('form2.siOther'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) clearErr('form2.siOther');
    },
  );

  Widget buildFieldSiStock() => appTextField(
    label: "Stok",
    controller: fieldSiStockController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.siStock'),
    validator: (_) => err('form2.siStock'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) clearErr('form2.siStock');
    },
  );
  //form2

  //form3
  Widget buildFieldIsEq()=> CheckboxWidget(
    rightLabel: "Gempa Bumi",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (v) => fieldIsEqController.text = v.toString(),
    leftLabel: "",
    enabled: !_lockCheckboxes,
  );

  Widget buildFieldIsTsfwd()=> CheckboxWidget(
    rightLabel: "Banjir",
    initialValue: toBoolean(fieldIsTsfwdController.text),
    callback: (v) => fieldIsTsfwdController.text = v.toString(),
    leftLabel: "",
    enabled: !_lockCheckboxes,
  );

  Widget buildFieldIsFlexas()=> CheckboxWidget(
    rightLabel: "Kebakaran/Petir",
    initialValue: toBoolean(fieldIsFlexasController.text),
    callback: (v) => fieldIsFlexasController.text = v.toString(),
    leftLabel: "",
    enabled: !_lockCheckboxes,
  );

  Widget buildFieldIsOther()=> CheckboxWidget(
    rightLabel: "Lain-Lain",
    initialValue: toBoolean(fieldIsOtherController.text),
    callback: (v) => fieldIsOtherController.text = v.toString(),
    leftLabel: "",
    enabled: !_lockCheckboxes,
  );

  Widget buildFieldIsRsmdcc()=> CheckboxWidget(
    rightLabel: "Huru Hara/Kerusuhan",
    initialValue: toBoolean(fieldIsRsmdccController.text),
    callback: (v) => fieldIsRsmdccController.text = v.toString(),
    leftLabel: "",
    enabled: !_lockCheckboxes,

  );

  Widget buildFieldMjnscoverparId() => ReusableComboBox<ComboMJnscoverParModel>(
    hintText: "Jenis Jaminan",
    maxHeight: 200,
    initItem: fieldComboMJnscoverPar,
    dataLoader: () => ComboMJnscoverParRepository().getComboMJnscoverPar(),
    displayText: (i) => i.jenisNama,
    compareItems: (a, b) => a.mjnscoverparId == b.mjnscoverparId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form3.mjnscoverparId'),
    onChangedCallback: (v) {
      fieldComboMJnscoverPar = v;
      if (v != null) {
        clearErr('form3.mjnscoverparId');
      }

      _applyCoverParRule(v?.mjnscoverparId);
    },
    onSaveCallback: (value) => fieldComboMJnscoverPar = value,
  );

  Widget buildFieldMwilayahId() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    maxHeight: 150,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form3.mwilayahId'),
    onChangedCallback: (v) {
      fieldComboMWilayah = v;

      if (v != null) {
        clearErr('form3.mwilayahId');
        calpar3formBloc?.add(ComboMWilayahChangedEvent(comboMWilayah: v));
        ComboMWilayah.currentState?.clear();
      }

    },
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );

  Widget buildFieldKab2zonagempaId() => ReusableComboBox<ComboMKabZonaGempaModel>(
    hintText: "Zona Gempa Bumi",
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
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form3.kab2zonagempaId'),
    onChangedCallback: (v) {
      fieldComboMKabZonaGempa = v;
      if (v != null) clearErr('form3.kab2zonagempaId');
    },
    onSaveCallback: (value) => fieldComboMKabZonaGempa = value,
  );

  //form3


  //form4
  Widget buildFieldDiscNilai() => appTextField(
    label: "Disc Nilai",
    controller: fieldDiscNilaiController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.discNilai'),
    validator: (_) => err('form4.discNilai'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.discNilai');
    },
  );

  Widget buildFieldDiscPersen() => appTextField(
    label: "Disc Persen",
    controller: fieldDiscPersenController,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    suffix: Text("%", style: bodyTextStyle(context)),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.isEmpty) return newValue;
        final x = double.tryParse(newValue.text);
        if (x == null) return newValue;
        if (x > 100) return oldValue;
        return newValue;
      }),
    ],
    errorText: err('form4.discPersen'),
    validator: (_) => err('form4.discPersen'),
    onChanged: (v) {
      final x = double.tryParse(v.trim());
      if (x != null && x >= 0 && x <= 100) clearErr('form4.discPersen');
    },
  );

  Widget buildFieldPremiBi() => appTextField(
    label: "Premi BI",
    controller: fieldPremiBiController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiBi'),
    validator: (_) => err('form4.premiBi'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiBi');
    },
  );

  Widget buildFieldPremiEqvet() => appTextField(
    label: "Premi EQVET",
    controller: fieldPremiEqvetController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiEqvet'),
    validator: (_) => err('form4.premiEqvet'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiEqvet');
    },
  );

  Widget buildFieldPremiNet() => appTextField(
    label: "Premi Net",
    controller: fieldPremiNetController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiNet'),
    validator: (_) => err('form4.premiNet'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiNet');
    },
  );

  Widget buildFieldPremiOther() => appTextField(
    label: "Premi Other",
    controller: fieldPremiOtherController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiOther'),
    validator: (_) => err('form4.premiOther'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiOther');
    },
  );

  Widget buildFieldPremiPar() => appTextField(
    label: "Premi PAR",
    controller: fieldPremiParController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiPar'),
    validator: (_) => err('form4.premiPar'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiPar');
    },
  );

  Widget buildFieldPremiRsmdcc() => appTextField(
    label: "Premi RSMDCC",
    controller: fieldPremiRsmdccController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiRsmdcc'),
    validator: (_) => err('form4.premiRsmdcc'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiRsmdcc');
    },
  );

  Widget buildFieldPremiTsfwd() => appTextField(
    label: "Premi TSFWD",
    controller: fieldPremiTsfwdController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form4.premiTsfwd'),
    validator: (_) => err('form4.premiTsfwd'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form4.premiTsfwd');
    },
  );

  //form4


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

  bool validateOpenedForm() {
    final opened = getOpenedIndex();
    if (opened < 0) return true;
    if (opened >= CalparFormSection.values.length) return true;

    final section = CalparFormSection.values[opened];

    switch (section) {
      case CalparFormSection.form1: return validateForm1();
      case CalparFormSection.form2: return validateForm2();
      case CalparFormSection.form3: return validateForm3();
      case CalparFormSection.form4: return true; // hasil saja
    }
  }

  void openSection(CalparFormSection section, {VoidCallback? onRefresh}) {
    final idx = sectionIndex(section);

    setState(() {
      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;
    });

    onRefresh?.call();
  }

  void tryOpenSection(CalparFormSection section, {VoidCallback? onRefresh}) {
    final targetIdx = sectionIndex(section);
    final opened = getOpenedIndex();

    if (opened == targetIdx) return;

    final ok = validateOpenedForm();
    if (!ok) return;

    openSection(section, onRefresh: onRefresh);
  }

  double getProgressValue() {
    final done = [
      isForm1Complete(),
      isForm2Complete(),
      isForm3Complete(),
      isForm4Complete(),
    ].where((x) => x).length;

    return done / CalparFormSection.values.length;
  }

  bool isForm1Complete() =>
    fieldCoverBulanController.text.trim().isNotEmpty &&
    fieldComboRKonstruksiojk != null &&
    fieldComboROkupasi != null;

  bool isForm2Complete() {
    if (fieldComboRMatauang == null) return false;

    double n(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '').trim()) ?? 0;

    final vMachinery = n(fieldSiMachineryController);
    final vBuilding  = n(fieldSiBuildingController);
    final vContent   = n(fieldSiContentController);
    final vStock     = n(fieldSiStockController);
    final vOther     = n(fieldSiOtherController);

    return (vMachinery > 0 || vBuilding > 0 || vContent > 0 || vStock > 0 || vOther > 0);
  }

  bool isForm3Complete() =>
      fieldComboMJnscoverPar != null &&
      fieldComboMWilayah != null &&
      fieldComboMKabZonaGempa != null;

  bool isForm4Complete() => (calpar4Id?.isNotEmpty == true);

}