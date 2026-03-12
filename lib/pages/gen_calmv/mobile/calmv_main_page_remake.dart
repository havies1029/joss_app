import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_calmv/calmv1crud_bloc.dart';
import '../../../blocs/gen_calmv/calmv1list_bloc.dart';
import '../../../blocs/gen_calmv/calmv2form_bloc.dart';
import '../../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../../../blocs/gen_calmv/calmv_flow_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/thousand_separator_input_formatter.dart';
import '../../../models/combobox/combommvgrupojk_model.dart';
import '../../../models/combobox/combommvjnscover_model.dart';
import '../../../models/combobox/combommvpakai_model.dart';
import '../../../models/combobox/combomwilayah_model.dart';
import '../../../models/combobox/combormatauang_model.dart';
import '../../../models/gen_calmv/calmv1crud_model.dart';
import '../../../models/gen_calmv/calmv2form_model.dart';
import '../../../models/gen_calmv/calmv3form_model.dart';
import '../../../models/user/user_model.dart';
import '../../../repositories/combobox/combommvgrupojk_repository.dart';
import '../../../repositories/combobox/combommvjnscover_repository.dart';
import '../../../repositories/combobox/combommvpakai_repository.dart';
import '../../../repositories/combobox/combomwilayah_repository.dart';
import '../../../repositories/combobox/combormatauang_repository.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../widgets/hitung_premi_widget.dart';
import '../../base/base_background_sidepage.dart';
import '../../gen_regmv/mobile/regmv_main_page_remake.dart';
import '../../profile/mobile/profile/form_section/popup/rekan_general_cmp.dart';
import '../../profile/mobile/profile/form_section/popup/rekan_general_idv.dart';
import '../../register/mobile/client/register_client_page.dart';

class CalmvMainPageRemake extends StatefulWidget {

  const CalmvMainPageRemake({
    super.key,
  });

  @override
  State<CalmvMainPageRemake> createState() => _CalmvMainPageRemakeState();
}


class _CalmvMainPageRemakeState extends State<CalmvMainPageRemake> {
  List<bool> expanded = [true, false, false];
  //untuk detect form mana yang terakhir dibuka
  int? lastOpenedIndex;
  int? currentOpenedIndex;
  int getOpenedIndex() => expanded.indexWhere((e) => e);
  String? calmv1Id;
  String? calmv2Id;
  String? calmv3Id;

  Calmv2FormModel? form2Record;
  Calmv3FormModel? form3Record;

  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  late final MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
 
  //form1
  final fieldCoverBulanController = TextEditingController();
  final fieldHargaController = TextEditingController();
  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  ComboMWilayahModel? fieldComboMWilayah;
  ComboRMatauangModel? fieldComboUang;
  final fieldCurrIdController = TextEditingController();
  ComboMMvpakaiModel? fieldComboMMvpakai;
  String selectedYearform1 = "";
  //form1

  //form2
  final fieldPadController = TextEditingController(text: "0");
  final fieldPapController = TextEditingController(text: "0");
  final fieldPllController = TextEditingController(text: "0");
  final fieldTplController = TextEditingController(text: "0");
  final fieldIsEqController = TextEditingController();
  final fieldIsFloodController = TextEditingController();
  final fieldIsSrccController = TextEditingController();
  final fieldIsTbodController = TextEditingController();
  final fieldIsTerrorismController = TextEditingController();
  final fieldIsAwController = TextEditingController();
  String selectedPassengerCount = "";
  //form2

  //form3
  final fieldDiskonPersenController = TextEditingController();
  final fieldPremiAddController = TextEditingController();
  final fieldPremiCascoController = TextEditingController();
  final fieldPremiDiskonController = TextEditingController();
  final fieldPremiNetController = TextEditingController();
  final fieldPremiSubtotalController = TextEditingController();
  final fieldCalmv1IdController = TextEditingController();
  //form3

  String cleanNum(num value) {
    final f = NumberFormat("#,###", "en_US");
    return f.format(value);
  }

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

    // default passenger count = 1
    selectedPassengerCount = selectedPassengerCount.trim().isEmpty ? "1" : selectedPassengerCount;

  }

  @override
  void dispose() {
    //form1
    fieldCoverBulanController.dispose();
    fieldHargaController.dispose();
    fieldCurrIdController.dispose();
    //form1

    //form2
    fieldPadController.dispose();
    fieldPapController.dispose();
    fieldPllController.dispose();
    fieldTplController.dispose();
    fieldIsEqController.dispose();
    fieldIsFloodController.dispose();
    fieldIsSrccController.dispose();
    fieldIsTbodController.dispose();
    fieldIsTerrorismController.dispose();
    fieldIsAwController.dispose();
    //form2

    //form3
    fieldDiskonPersenController.dispose();
    fieldPremiAddController.dispose();
    fieldPremiCascoController.dispose();
    fieldPremiDiskonController.dispose();
    fieldPremiNetController.dispose();
    fieldPremiSubtotalController.dispose();
    fieldCalmv1IdController.dispose();
    //form3

    super.dispose();
  }

  void refreshForm1({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Calmv1CrudBloc>().add(
      Calmv1CrudLihatEvent(recordId: recordId),
    );
  }

  void refreshForm2({required String? recordId}) {
    if (recordId == null || recordId.isEmpty) return;
    context.read<Calmv2FormBloc>().add(
      Calmv2FormLihatEvent(recordId: recordId),
    );
  }

  void _payloadform1(Calmv1CrudModel record) {
    if (fieldCoverBulanController.text.trim().isEmpty) {
      fieldCoverBulanController.text = record.coverBulan.toString();
    }

    if (fieldCurrIdController.text.trim().isEmpty) {
      fieldCurrIdController.text = record.currId.toString();
    }

    if (fieldHargaController.text.trim().isEmpty) {
      fieldHargaController.text = record.harga.toString();
    }

    setState(() {
      if (selectedYearform1.isEmpty){
        selectedYearform1 = record.thnBuat.toString();
      }

      final ojk = record.comboMMvgrupOjk;
      if (fieldComboMMvgrupOjk == null && ojk != null) {
        fieldComboMMvgrupOjk = ojk;
      }

      final cover = record.comboMMvjnscover;
      if (fieldComboMMvjnscover == null && cover != null) {
        fieldComboMMvjnscover = cover;
      }

      final wilayah = record.comboMWilayah;
      if (fieldComboMWilayah == null && wilayah != null) {
        fieldComboMWilayah = wilayah;
      }
    });
  }

  void _payloadform2(Calmv2FormModel record) {

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

    if (fieldIsAwController.text.trim().isEmpty) {
      fieldIsAwController.text = record.isAw.toString();
    }

    setState(() {
      if (selectedPassengerCount.isEmpty) {
        selectedPassengerCount = record.passangerCount.toString();
      }
    });
  }

  void _payloadform3(Calmv3FormModel record) {
    fieldDiskonPersenController.text = cleanNum(record.diskonPersen);
    fieldPremiAddController.text = cleanNum(record.premiAdd);
    fieldPremiCascoController.text = cleanNum(record.premiCasco);
    fieldPremiDiskonController.text = cleanNum(record.premiDiskon);
    fieldPremiNetController.text = cleanNum(record.premiNet);
    fieldPremiSubtotalController.text = cleanNum(record.premiSubtotal);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      blocListeners: [
        BlocListener<Calmv1ListBloc, Calmv1ListState>(
          listenWhen: (prev, curr) {
            return prev.processMessage != curr.processMessage &&
                (curr.processMessage).isNotEmpty;
          },
          listener: (context, state) {
            final calmv1Id = context.read<Calmv1CrudBloc>().state.record?.calmv1Id ?? "";
            context.read<Calmv1ListBloc>().add(ClearProcessMessageEvent());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegmvFormMainRemake(regmv1Id: state.processMessage, calmv1Id: calmv1Id,),
              ),
            );
            if (calmv1Id.isNotEmpty) {
              context.read<Calmv1CrudBloc>().add(Calmv1CrudLihatEvent(recordId: calmv1Id));
            }
          },
        ),

        BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calmv1Id = state.record!.calmv1Id;
              });
            }
            if (state.isLoaded && !state.hasFailure && state.record != null) {
              _payloadform1(state.record!);
            }
          },
        ),

        BlocListener<Calmv2FormBloc, Calmv2FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calmv2Id = state.record!.calmv2Id;
                appSnackBar(message: calmv2Id??"");
              });
            }
            if (state.isLoaded && !state.hasFailure && state.record != null) {
              _payloadform2(state.record!);
            }
          },
        ),

        BlocListener<Calmv3FormBloc, Calmv3FormState>(
          listener: (context, state) {
            if (state.record != null) {
              if (state.isLoaded) {
                setState(() {
                  calmv3Id = state.record!.calmv3Id;
                });

                _payloadform3(state.record!);

                if (state.record!.calmv3Id.isNotEmpty) {
                  openForm3();
                }
              }

              // kalau ada flow lain yang memang pakai isSaved
              if (state.isSaved) {
                setState(() {
                  calmv3Id = state.record!.calmv3Id;
                });

                if (state.record!.calmv3Id.isNotEmpty) {
                  openForm3();
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
                    idx: 0,
                    context: context,
                    title: "Data Kendaraan",
                    isExpanded: expanded[0],
                    //onToggle: (v) => setState(() => expanded[0] = v),
                    onRefresh: () {
                      if (calmv1Id != null && calmv1Id!.isNotEmpty) {
                        refreshForm1(recordId: calmv1Id);
                      }
                    },
                    child: Column(
                      children: [
                        _buildComboMMvgrupOjk(),
                        const SizedBox(height: hPadding),
                        Row(
                          children: [
                            Flexible(child: _buildComboMMvjnscover()),
                            const SizedBox(width: 8),
                            Flexible(child: _buildHarga()),
                          ],
                        ),
                        const SizedBox(height: hPadding),
                        Row(
                          children: [
                            Flexible(child: _buildComboCurddId()),
                            const SizedBox(width: 8),
                            Flexible(child: buildFieldComboTahun()),
                          ],
                        ),
                        const SizedBox(height: hPadding),
                        _buildComboMWilayah(),
                        const SizedBox(height: hPadding),
                        _buildFieldMmvpakaiId(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  Form2Page(
                    idx: 1,
                    context: context,
                    title: "Pertanggungan",
                    isExpanded: expanded[1],
                    //onToggle: (v) => setState(() => expanded[1] = v),
                    onRefresh: () {
                      if (calmv2Id != null && calmv2Id!.isNotEmpty) {
                        refreshForm2(recordId: calmv2Id);
                      }
                    },
                    child: Column(
                      children: [
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
                            Expanded(child: _buildFieldPassengerCountCombo()),
                            const SizedBox(width: 8),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
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
                            const SizedBox(width: 8),
                            Flexible(child: _buildFieldIsAw()),
                          ],
                        ),

                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: hPadding),

                  buildButtonHitungPremi(),

                  const SizedBox(height: hPadding),

                  Form3Page(
                    idx: 2,
                    context: context,
                    title: "Perhitungan Premi",
                    isExpanded: expanded[2],
                    //onToggle: (v) => setState(() => expanded[2] = v),
                    child: (calmv3Id?.isNotEmpty == true)
                        ? Column(
                      children: [
                        HitungPremiWidget(
                          rows: [
                            HitungPremiRow(
                              label: "Premi",
                              controller: fieldPremiSubtotalController,
                              layoutType: HitungPremiLayoutType.vertical,
                              showValueBorder: true,
                              formatNumber: true,
                              valuePrefix: fieldComboUang?.rmatauangSimbol ?? "",
                            ),
                            HitungPremiRow(
                              label: "Diskon",
                              controller: fieldPremiDiskonController,
                              layoutType: HitungPremiLayoutType.vertical,
                              showValueBorder: true,
                              formatNumber: true,
                              valuePrefix: fieldComboUang?.rmatauangSimbol ?? "",
                            ),
                            HitungPremiRow(
                              label: "Net Premi",
                              controller: fieldPremiNetController,
                              layoutType: HitungPremiLayoutType.vertical,
                              showValueBorder: true,
                              formatNumber: true,
                              valuePrefix: fieldComboUang?.rmatauangSimbol ?? "",
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

                  if (calmv3Id?.isNotEmpty == true) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BlocBuilder<Calmv1ListBloc, Calmv1ListState>(
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
    required int idx,
    required BuildContext context,
    required bool isExpanded,
    //required ValueChanged<bool> onToggle,
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
              tryOpenSection(idx, onRefresh: onRefresh);
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
    required int idx,
    required BuildContext context,
    required bool isExpanded,
    //required ValueChanged<bool> onToggle,
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
              tryOpenSection(idx, onRefresh: onRefresh);
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
    required int idx,
    required BuildContext context,
    required bool isExpanded,
    //required ValueChanged<bool> onToggle,
    required Widget child,
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
              child: SvgPicture.asset(
                "assets/icons/dropdown.svg",
                width: 16,
              ),
            ),
            onTap: () {
              tryOpenSection(idx);
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

  void draftForm1ToBloc(BuildContext context) {
    final record = Calmv1CrudModel(
      calmv1Id: calmv1Id ?? "",
      harga: double.tryParse(fieldHargaController.text.replaceAll(",", "")) ?? 0,
      currId: fieldComboUang?.rmatauangKode ?? "",
      coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(",", "")) ?? 12,
      thnBuat: int.tryParse(selectedYearform1) ?? 0,
      mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      mmvpakaiId: fieldComboMMvpakai?.mmvpakaiId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
    );
    context.read<Calmv1CrudBloc>().add(Calmv1DraftEvent(record: record));
  }

  void draftForm2ToBloc(BuildContext context){
    final record = Calmv2FormModel(
      calmv2Id: calmv2Id ?? "",
      calmv1Id: calmv1Id ?? "",
      isEq: toBoolean(fieldIsEqController.text),
      isFlood: toBoolean(fieldIsFloodController.text),
      isSrcc: toBoolean(fieldIsSrccController.text),
      isTbod: toBoolean(fieldIsTbodController.text),
      isTerrorism: toBoolean(fieldIsTerrorismController.text),
      isAw: toBoolean(fieldIsAwController.text),
      pad: double.tryParse(fieldPadController.text.replaceAll(",", "")) ?? 0,
      pap: double.tryParse(fieldPapController.text.replaceAll(",", "")) ?? 0,
      passangerCount: int.tryParse(selectedPassengerCount) ?? 0,
      pll: double.tryParse(fieldPllController.text.replaceAll(",", "")) ?? 0,
      tpl: double.tryParse(fieldTplController.text.replaceAll(",", "")) ?? 0,
    );
    context.read<Calmv2FormBloc>().add(Calmv2FormDraftEvent(record: record));
  }

  bool _isHitungPremiLoading = false;

  Widget buildButtonHitungPremi() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: AppButton.primary(
      text: _isHitungPremiLoading ? "Memproses..." : "Hitung Premi",
      isLoading: _isHitungPremiLoading,
      onPressed: _isHitungPremiLoading
          ? null
          : () async {
        if (_isHitungPremiLoading) return;

        setState(() {
          _isHitungPremiLoading = true;
        });

        try {
          await Future.delayed(const Duration(milliseconds: 2));
          await onHitungPremi();
        } finally {
          if (mounted) {
            setState(() {
              _isHitungPremiLoading = false;
            });
          }
        }
      },
    ),
  );

  Future<void> onHitungPremi() async {
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

    draftForm1ToBloc(context);
    draftForm2ToBloc(context);

    context.read<CalmvFlowBloc>().add(CalmvFlowStartEvent());
  }

  bool validateForm1() {
    clearErrsByPrefix('form1.');

    bool ok = true;

    if (fieldComboMMvgrupOjk == null) {
      setErr('form1.jenisKendaraan', kStringNullError);
      ok = false;
    }
    if (fieldComboMMvjnscover == null) {
      setErr('form1.jenisCover', kStringNullError);
      ok = false;
    }
    if (fieldComboUang == null) {
      setErr('form1.mataUang', kStringNullError);
      ok = false;
    }
    if (selectedYearform1.trim().isEmpty) {
      setErr('form1.tahun', kStringNullError);
      ok = false;
    }
    if (fieldComboMMvpakai == null) {
      setErr('form1.penggunaan', kStringNullError);
      ok = false;
    }
    if (fieldComboMWilayah == null) {
      setErr('form1.wilayah', kStringNullError);
      ok = false;
    }

    final hargaRaw = fieldHargaController.text.trim();
    if (hargaRaw.isEmpty) {
      setErr('form1.hargaKendaraan', kStringNullError);
      ok = false;
    } else {
      final clean = hargaRaw.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) {
        setErr('form1.hargaKendaraan', "Harga harus lebih dari 0");
        ok = false;
      }
    }

    if (!ok) {
      openForm1Force();
    }

    return ok;
  }

  bool validateForm2() {
    bool ok = true;
    clearErrsByPrefix('form2.');

    // Passenger Count (required) - default 1 dari initState
    if (selectedPassengerCount.trim().isEmpty) {
      setErr('form2.passengerCount', kStringNullError);
      ok = false;
    }

    String cleanNum(String v) => v.replaceAll(",", "").trim();

    double parseOrDefaultZero(TextEditingController controller) {
      final raw = cleanNum(controller.text);

      if (raw.isEmpty) {
        controller.text = "0"; // auto default
        return 0;
      }

      return double.tryParse(raw) ?? double.nan;
    }

    bool validateNonNegative({
      required String key,
      required double value,
    }) {
      if (value.isNaN) {
        setErr(key, "Format tidak valid");
        return false;
      }

      if (value < 0) {
        setErr(key, "Tidak boleh minus");
        return false;
      }

      clearErr(key);
      return true;
    }

    final tpl = parseOrDefaultZero(fieldTplController);
    final pad = parseOrDefaultZero(fieldPadController);
    final pap = parseOrDefaultZero(fieldPapController);
    final pll = parseOrDefaultZero(fieldPllController);

    final a = validateNonNegative(key: 'form2.tpl', value: tpl);
    final b = validateNonNegative(key: 'form2.pad', value: pad);
    final c = validateNonNegative(key: 'form2.pap', value: pap);
    final d = validateNonNegative(key: 'form2.pll', value: pll);

    ok = a && ok;
    ok = b && ok;
    ok = c && ok;
    ok = d && ok;

    if (ok) {
      final anyGreaterThanZero = tpl > 0 || pad > 0 || pap > 0 || pll > 0;

      if (!anyGreaterThanZero) {
        const msg = "Minimal salah satu nilai harus lebih dari 0";
        setErr('form2.tpl', msg);
        setErr('form2.pad', msg);
        setErr('form2.pap', msg);
        setErr('form2.pll', msg);
        ok = false;
      }
    }

    return ok;
  }


  Future<void> onLanjutkanPressed() async {
    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;
    if (context.read<Calmv1ListBloc>().state.isProcessing) return;
    if (context.read<AuthenticationBloc>().state is AuthenticationAuthenticated) {
      User user = (context.read<AuthenticationBloc>().state as AuthenticationAuthenticated).user;
      if (user.userType == "C"){
        if (mjenisClient == "10") {
          final mRekanNama1 =
              context.read<MRekanGeneralIdvCrudBloc>().state.record?.rekanNama ?? "";
          debugPrint("MREKANNAMA! = ${mRekanNama1}");

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
        context.read<Calmv1ListBloc>().add(
          CalMv2RegMvEvent(calmv1Id: calmv1Id!),
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
                    builder: (context) => RegisterClient(requestFrom: 'calmv_page')
                ),
              );
            },
          ),
        );
      }
    }
  }

  void openForm1() => tryOpenSection(0);
  void openForm2() => tryOpenSection(1);
  void openForm3() => openForm3Force();

  void openForm1Force() => openSection(0);
  void openForm2Force() => openSection(1);
  void openForm3Force() => openSection(2);

  //form1 field
  Widget _buildComboMMvgrupOjk() => ReusableComboBox<ComboMMvgrupOjkModel>(
    hintText: "Jenis Kendaraan",
    initItem: fieldComboMMvgrupOjk,
    dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
    displayText: (i) => i.grupNama,
    compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form1.jenisKendaraan'),
    onChangedCallback: (v) {
      fieldComboMMvgrupOjk = v;
      if (v != null) clearErr('form1.jenisKendaraan');
    },
    onSaveCallback: (value) => fieldComboMMvgrupOjk = value,
  );

  Widget _buildComboMMvjnscover() => ReusableComboBox<ComboMMvjnscoverModel>(
    hintText: "Jenis Cover",
    initItem: fieldComboMMvjnscover,
    dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
    displayText: (i) => i.coverName,
    compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form1.jenisCover'),
    onChangedCallback: (v) {
      fieldComboMMvjnscover = v;
      if (v != null) clearErr('form1.jenisCover');
    },
    onSaveCallback: (value) => fieldComboMMvjnscover = value,
  );

  Widget _buildComboMWilayah() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form1.wilayah'),
    onChangedCallback: (v) {
      fieldComboMWilayah = v;
      if (v != null) clearErr('form1.wilayah');
    },
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );

  Widget _buildComboCurddId() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboUang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (item) => item.rmatauangSimbol,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form1.mataUang'),
    onChangedCallback: (v) {
      fieldComboUang = v;
      if (v != null) clearErr('form1.mataUang');
    },
    onSaveCallback: (value) => fieldComboUang = value,
  );

  Widget _buildFieldMmvpakaiId() => ReusableComboBox<ComboMMvpakaiModel>(
    hintText: "Penggunaan",
    initItem: fieldComboMMvpakai,
    dataLoader: () => ComboMMvpakaiRepository().getComboMMvpakai(),
    displayText: (item) => item.pakaiNama,
    compareItems: (a, b) => a.mmvpakaiId == b.mmvpakaiId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    errorText: err('form1.penggunaan'),
    onChangedCallback: (v) {
      fieldComboMMvpakai = v;
      if (v != null) clearErr('form1.penggunaan');
    },
    onSaveCallback: (value) => fieldComboMMvpakai = value,
  );

  Widget buildFieldComboTahun() {
    // Buat list tahun dari sekarang → 1980
    final yearNow = DateTime.now().year;
    final years = List<String>.generate(
      yearNow - 1980 + 1,
          (i) => (yearNow - i).toString(),
    );

    return ReusableComboBox<String>(
      hintText: "Tahun Pembuatan",
      initItem: selectedYearform1.isNotEmpty ? selectedYearform1 : null,
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
      errorText: err('form1.tahun'),
      onChangedCallback: (v) {
        selectedYearform1 = v ?? "";
        if (v != null) clearErr('form1.tahun');
      },
      onSaveCallback: (value) {
        selectedYearform1 = value ?? "";
      },
    );
  }

  Widget _buildHarga() => appTextField(
    label: "Harga Kendaraan",
    controller: fieldHargaController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form1.hargaKendaraan'),
    validator: (_) => err('form1.hargaKendaraan'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka > 0) {
        clearErr('form1.hargaKendaraan');
      }
    },
  );
//form1 field

  Widget _buildFieldPAD() => appTextField(
    label: "Kecelakaan Diri Pengemudi",
    controller: fieldPadController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.pad'),
    validator: (_) => err('form2.pad'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form2.pad');
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
    errorText: err('form2.pap'),
    validator: (_) => err('form2.pap'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) clearErr('form2.pap');
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

      errorText: err('form2.passengerCount'),
      validatorCallback: (_) => err('form2.passengerCount'),

      onChangedCallback: (v) {
        selectedPassengerCount = v ?? "";
        if (selectedPassengerCount.isNotEmpty) clearErr('form2.passengerCount');
      },

      onSaveCallback: (value) {
        selectedPassengerCount = value ?? "";
      },
    );
  }


  Widget _buildFieldPLL() => appTextField(
    label: "Tanggung Jawab Penumpang",
    controller: fieldPllController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    errorText: err('form2.pll'),
    validator: (_) => err('form2.pll'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form2.pll');
      }
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
    errorText: err('form2.tpl'),
    validator: (_) => err('form2.tpl'),
    onChanged: (v) {
      clearErr('form2.tpl');
      clearErr('form2.pad');
      clearErr('form2.pap');
      clearErr('form2.pll');

      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form2.tpl');
      }
    },
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

  Widget _buildFieldIsAw() => CheckboxWidget(
    rightLabel: "Bengkel Resmi",
    initialValue: toBoolean(fieldIsAwController.text),
    callback: (v) => fieldIsAwController.text = v.toString(),
    leftLabel: "",
  );

  Widget _buildFieldIsTerrorism() => CheckboxWidget(
    rightLabel: "Terorisme",
    initialValue: toBoolean(fieldIsTerrorismController.text),
    callback: (v) => fieldIsTerrorismController.text = v.toString(),
    leftLabel: "",
  );
//form2 field



//form3 field

  Widget buildFieldPremiSubtotal() => appTextField(
    label: "Subtotal Premi",
    controller: fieldPremiSubtotalController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    enabled: false,
    errorText: err('form3.premiSubtotal'),
    validator: (_) => err('form3.premiSubtotal'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form3.premiSubtotal');
      }
    },
  );

  Widget buildFieldPremiDiskon() => appTextField(
    label: "Premi Diskon",
    controller: fieldPremiDiskonController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    enabled: false,
    errorText: err('form3.premiDiskon'),
    validator: (_) => err('form3.premiDiskon'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form3.premiDiskon');
      }
    },
  );

  Widget buildFieldPremiNet() => appTextField(
    label: "Net Premi",
    controller: fieldPremiNetController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    enabled: false,
    errorText: err('form3.premiNet'),
    validator: (_) => err('form3.premiNet'),
    onChanged: (v) {
      final clean = v.replaceAll(",", "").trim();
      final angka = double.tryParse(clean);
      if (angka != null && angka >= 0) {
        clearErr('form3.premiNet');
      }
    },
  );

//form3 field

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

  void openSection(int idx, {VoidCallback? onRefresh}) {
    final prev = expanded.indexWhere((e) => e);
    setState(() {
      lastOpenedIndex = (prev == -1) ? null : prev;
      currentOpenedIndex = idx;

      // single-open
      expanded = List<bool>.filled(expanded.length, false);
      expanded[idx] = true;
    });

    onRefresh?.call();
  }

  bool validateOpenedForm() {
    final opened = getOpenedIndex();
    switch (opened) {
      case 0:
        final ok = validateForm1();
        //if (!ok) openForm1Force();
        return ok;
      case 1:
        final ok = validateForm2();
        //if (!ok) openForm2Force();
        return ok;
      case 2:
        // kalau form3 tidak perlu divalidasi, return true
        return true;
      default:
        return true;
    }
  }

  void tryOpenSection(int targetIdx, {VoidCallback? onRefresh}) {
    final opened = getOpenedIndex();

    if (opened == targetIdx) return;
    // kalau klik header form yang sedang terbuka -> toggle close/open (optional)
    // if (opened == targetIdx) {
    //   setState(() {
    //     final next = !expanded[targetIdx];
    //     expanded[targetIdx] = next;
    //     currentOpenedIndex = next ? targetIdx : null;
    //     if (!next) lastOpenedIndex = targetIdx;
    //   });
    //   return;
    // }

    // pindah form: validasi form yang sedang terbuka dulu
    final ok = validateOpenedForm();
    if (!ok) return; // stop: tidak boleh pindah

    // pindah
    openSection(targetIdx, onRefresh: onRefresh);
  }

  bool isForm1Complete() {
    final hargaRaw = fieldHargaController.text.replaceAll(",", "").trim();
    final harga = double.tryParse(hargaRaw) ?? 0;

    return fieldComboMMvgrupOjk != null &&
        fieldComboMMvjnscover != null &&
        fieldComboUang != null &&
        selectedYearform1.trim().isNotEmpty &&
        fieldComboMMvpakai != null &&
        fieldComboMWilayah != null &&
        harga > 0;
  }

  bool isForm2Complete() {
    if (selectedPassengerCount.trim().isEmpty) return false;

    double parseNum(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(",", "").trim()) ?? 0;

    final tpl = parseNum(fieldTplController);
    final pad = parseNum(fieldPadController);
    final pap = parseNum(fieldPapController);
    final pll = parseNum(fieldPllController);

    return (tpl > 0) || (pad > 0) || (pap > 0) || (pll > 0);
  }

  double getProgressValue() {
    final f1 = isForm1Complete();
    final f2 = isForm2Complete();

    int completed = 0;
    if (f1) completed = 1;
    if (f1 && f2) completed = 2;
    if (calmv3Id?.isNotEmpty == true) completed = 3;

    return completed / 3;
  }

}

