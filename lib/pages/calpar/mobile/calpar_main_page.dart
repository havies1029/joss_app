import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../blocs/calpar/calpar1crud_bloc.dart';
import '../../../blocs/calpar/calpar2form_bloc.dart';
import '../../../blocs/calpar/calpar3form_bloc.dart';
import '../../../blocs/calpar/calpar4form_bloc.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import '../../regpar/mobile/regpar_main_page.dart';
import 'calpar_form/calpar_form1.dart';
import 'calpar_form/calpar_form2.dart';
import 'calpar_form/calpar_form3.dart';
import 'calpar_form/calpar_form4.dart';

class CalparFormMain extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const CalparFormMain({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  State<CalparFormMain> createState() => _CalparFormMainState();
}

class _CalparFormMainState extends State<CalparFormMain> {
  List<bool> expanded = [true, false, false, false];

  final calparform1key = GlobalKey<Calpar1CrudFormPageFormState>();
  final calparform2key = GlobalKey<Calpar2FormPageFormState>();
  final calparform3key = GlobalKey<Calpar3FormPageFormState>();
  final calparform4key = GlobalKey<Calpar4FormPageFormState>();

  String? calpar1Id;
  String? calpar2Id;
  String? calpar3Id;
  Map<String, dynamic>? _form4Payload;

  String form1ViewMode = "tambah";
  String form2ViewMode = "tambah";
  String form3ViewMode = "tambah";

  bool isHitungPremiClicked = false;
  bool isLanjutkanlicked = false;

  double getProgressValue() {
    double p = 0.0;

    if (calpar1Id?.isNotEmpty == true) p += 0.25;
    if (calpar2Id?.isNotEmpty == true) p += 0.25;
    if (calpar3Id?.isNotEmpty == true) p += 0.25;
    if (_form4Payload != null) p += 0.25;

    return p;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Properti",
      blocListeners: [
        // =================== LISTENER FORM 1 ===================
        BlocListener<Calpar1CrudBloc, Calpar1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.calpar1Id;

              if (newId != null && newId.isNotEmpty) {
                debugPrint("🔥 [LISTENER] calpar1 saved → result ID = $newId");
                final regpar = state.record!.regpar1Id;
                setState(() {
                  calpar1Id = newId;
                });

                if (isLanjutkanlicked == true){
                  isLanjutkanlicked = false;
                  debugPrint("woy ini new ID" + regpar!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegparFormMain(recordId: state.record!.regpar1Id, viewMode: 'ubah',),
                    ),
                  );
                }else {
                  if (form1ViewMode == "ubah") {
                    form1ViewMode = "tambah";
                    if (isHitungPremiClicked == true) {
                      debugPrint("isHitungPremiClicked");
                      isHitungPremiClicked = false;
                      onHitungPremi();
                    } else {
                      simulateToggleForm2();
                    }
                  } else {
                    simulateToggleForm2();
                  }
                }
              }
            }
          },
        ),

        // =================== LISTENER FORM 2 ===================
        BlocListener<Calpar2FormBloc, Calpar2FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.calpar2Id;

              if (newId != null && newId.isNotEmpty) {
                debugPrint("🔥 [LISTENER] calpar2 saved → result ID = $newId");

                setState(() {
                  calpar2Id = newId;
                });

                if (form2ViewMode == "ubah") {
                  form2ViewMode = "tambah";
                  if (isHitungPremiClicked == true) {
                    isHitungPremiClicked = false;
                    onHitungPremi();
                  } else {
                    simulateToggleForm3();
                  }
                } else {
                  simulateToggleForm3();
                }

              }
            }
          },
        ),

        // =================== LISTENER FORM 3 ===================
        BlocListener<Calpar3FormBloc, Calpar3FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.calpar3Id;

              if (newId != null && newId.isNotEmpty) {
                debugPrint("🔥 [LISTENER] calpar3 saved → result ID = $newId");

                setState(() {
                  calpar3Id = newId;
                });

                if (form3ViewMode == "ubah") {
                  form3ViewMode = "tambah";
                  debugPrint("listener form3 abis tambah");
                  onHitungPremi();
                } else {
                  debugPrint("listener form3");
                  onHitungPremi();
                }
              }
            }
          },
        ),

        // =================== LISTENER FORM 4 (PREMI) ===================
        BlocListener<Calpar4FormBloc, Calpar4FormState>(
          listener: (context, state) {
            if (state.isLoaded && state.record != null) {
              final r = state.record!;

              final payload = {
                "subtotalPremi": r.premiOther ?? 0,
                "diskonPremi": r.discNilai ?? 0,
                "netPremi": r.premiNet ?? 0,
              };

              if (calparform4key.currentState != null) {
                calparform4key.currentState!.injectPayload(payload);
              }

              openForm4();

              setState(() {
                _form4Payload = payload;
              });
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
                children: [
                  buildForm1Section(),
                  const SizedBox(height: hPadding),

                  buildForm2Section(),
                  const SizedBox(height: hPadding),

                  buildForm3Section(),
                  const SizedBox(height: hPadding),

                  buildButtonHitungPremi(),
                  const SizedBox(height: hPadding),

                  Calpar4FormPage(
                    key: calparform4key,
                    isExpanded: expanded[3],
                    initialPayload: _form4Payload,
                  ),

                  const SizedBox(height: hPadding),

                  (_form4Payload == null)
                      ? const SizedBox.shrink()
                      : AppButton.primary(
                    text: "Lanjutkan",
                    onPressed: onLanjutkanPressed,
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================= form1 =========================

  Widget buildForm1Section() => Calpar1CrudFormPage(
    key: calparform1key,
    viewMode: form1ViewMode,
    recordId: calpar1Id ?? "",
    isExpanded: expanded[0],
    onToggle: (value) => onToggleForm1(value),
  );

  Future<void> onToggleForm1(bool _) async {
    if (calpar1Id != null) {
      form1ViewMode = "ubah";
    } else {
      form1ViewMode = "tambah";
    }
    openForm1();
  }

  Future<void> simulateToggleForm1() async {
    await onToggleForm1(true);
  }

  // ========================= form2 =========================

  Widget buildForm2Section() {
    return Calpar2FormPage(
      key: calparform2key,
      viewMode: form2ViewMode,
      calpar1Id: calpar1Id ?? "",
      recordId: calpar2Id ?? "",
      isExpanded: expanded[1],
      onToggle: (value) => onToggleForm2(value),
    );
  }

  Future<void> onToggleForm2(bool _) async {
    final isValidForm1 = await calparform1key.currentState?.validateAndReturn();

    if (calpar1Id != null) {
      form2ViewMode = "tambah";

      if (form1ViewMode == "ubah") {
        await calparform1key.currentState?.saveForm1();
      } else {
        if (calpar2Id != null) {
          form2ViewMode = "ubah";
        }
        openForm2();
      }
    } else if (isValidForm1 == true) {
      await calparform1key.currentState?.saveForm1();
    }
  }

  Future<void> simulateToggleForm2() async {
    await onToggleForm2(true);
  }

  // ========================= form3 =========================

  Widget buildForm3Section() {
    return Calpar3FormPage(
      key: calparform3key,
      viewMode: form3ViewMode,
      calpar1Id: calpar1Id ?? "",
      recordId: calpar3Id ?? "",
      isExpanded: expanded[2],
      onToggle: (value) => onToggleForm3(value),
    );
  }

  Future<void> onToggleForm3(bool _) async {
    final isValidForm1 = await calparform1key.currentState?.validateAndReturn();
    final isValidForm2 = await calparform2key.currentState?.validateAndReturn();

    if (calpar1Id != null && calpar2Id != null) {
      form3ViewMode = "tambah";

      if (form1ViewMode == "ubah"){
        setState(() {
          isHitungPremiClicked = true;
        });
        await calparform1key.currentState?.saveForm1();
      }else {
        if (form2ViewMode == "ubah"){
          await calparform2key.currentState?.saveForm2();
        }else {
          debugPrint("🔥 Mode tambah aktif karena calpar1Id ada di form3");
          if (calpar3Id != null){
            form3ViewMode = "ubah";
            debugPrint("🔥 Mode ubah aktif karena calpar3Id tidak kosong");
          }
          openForm3();
        }
      }
    } else if (isValidForm1 == true) {
      await calparform1key.currentState?.saveForm1();
    }else if (isValidForm2 == true){
      await calparform2key.currentState?.saveForm2();
    }
  }

  Future<void> simulateToggleForm3() async {
    await onToggleForm3(true);
  }

  // ========================= hitung premi =========================

  Widget buildButtonHitungPremi() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: AppButton.primary(
      text: "Hitung Premi",
      backgroundColor: const Color(0xFF91C050),
      onPressed: onHitungPremi,
    ),
  );

  Future<void> onHitungPremi() async {
    final isValidForm1 = await calparform1key.currentState?.validateAndReturn();
    final isValidForm2 = await calparform2key.currentState?.validateAndReturn();
    final isValidForm3 = await calparform3key.currentState?.validateAndReturn();

    if (calpar1Id != null && calpar2Id != null && calpar3Id != null) {
      if (form1ViewMode == "ubah") {
        isHitungPremiClicked = true;
        await calparform1key.currentState?.saveForm1();
      } else {
        if (form2ViewMode == "ubah") {
          isHitungPremiClicked = true;
          await calparform2key.currentState?.saveForm2();
        }else{
          if (form3ViewMode == "ubah"){
            await calparform3key.currentState?.saveForm3();
          }else {
            debugPrint("hitungpar dikliik");
            context.read<Calpar4FormBloc>().add(
              Calpar4FormHitungPremiEvent(calpar1Id: calpar1Id ?? ""),
            );
          }
        }
      }
    } else if (calpar1Id == null) {
      if (isValidForm1 == true) {
        await calparform1key.currentState?.saveForm1();
        openForm2();
      } else {
        openForm1();
      }
    } else if (calpar2Id == null) {
      if (isValidForm2 == true) {
        await calparform2key.currentState?.saveForm2();
      }
    } else if (calpar3Id == null) {
      if (isValidForm3 == true) {
        await calparform3key.currentState?.saveForm3();
      }
    }
  }

  Future<void> onLanjutkanPressed() async {
    isLanjutkanlicked = true;

    // context.read<Calpar1CrudBloc>().add(
    //   CalpartoRegMvEvent(recordId: calpar1Id!),
    // );
  }

  // ========================= OPEN FORMS =========================

  void openForm1() {
    setState(() {
      expanded = [true, false, false, false];
    });
  }

  void openForm2() {
    setState(() {
      expanded = [false, true, false, false];
    });
  }

  void openForm3() {
    setState(() {
      expanded = [false, false, true, false];
    });
  }

  void openForm4() {
    setState(() {
      expanded = [false, false, false, true];
    });
  }
}