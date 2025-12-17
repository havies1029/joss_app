import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../blocs/calpar/calpar1crud_bloc.dart';
import '../../../blocs/calpar/calpar1list_bloc.dart';
import '../../../blocs/calpar/calpar2form_bloc.dart';
import '../../../blocs/calpar/calpar3form_bloc.dart';
import '../../../blocs/calpar/calpar4form_bloc.dart';
import '../../../helper/form_exit_guard.dart';
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
  String form4ViewMode = "tambah";

  bool isHitungPremiClicked = false;

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
        BlocListener<Calpar1CrudBloc, Calpar1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.calpar1Id;

              if (newId != null && newId.isNotEmpty) {
                setState(() {
                  calpar1Id = newId;
                });
              }
            }
          },
        ),

        BlocListener<Calpar4FormBloc, Calpar4FormState>(
          listener: (context, state) {
            if(isHitungPremiClicked == true){
              simulateToggleForm4();
            }
          },
        ),

        BlocListener<Calpar1ListBloc, Calpar1ListState>(
          listener: (context, state) {
            if (state.isProcessing) {
              showDialog(
                context: context,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            }

            if (state.isProcessed) {
              Navigator.pop(context);


              if (state.hasFailure) {
                // Jika gagal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${state.processMessage}")),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegparFormMain(recordId: state.processMessage, viewMode: 'ubah',),
                  ),
                );
                debugPrint("hasil debug ${state.processMessage}");
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

                  buildForm4Section(),

                  const SizedBox(height: hPadding),
                  if (isHitungPremiClicked == true) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
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
                            text: "Lanjutkan",
                            onPressed: onLanjutkanPressed,
                          ),
                        ],
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

  // ========================= form1 =========================

  Widget buildForm1Section() => Calpar1CrudFormPage(
    key: calparform1key,
    viewMode: form1ViewMode,
    recordId: calpar1Id ?? "",
    isExpanded: expanded[0],
    onToggle: (value) => onToggleForm1(value),
  );

  Future<void> onToggleForm1(bool _) async {
    isHitungPremiClicked = false;
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
    isHitungPremiClicked = false;
    openForm2();
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
    isHitungPremiClicked = false;
    openForm3();
  }

  Future<void> simulateToggleForm3() async {
    await onToggleForm3(true);
  }

  Widget buildForm4Section(){
    return Calpar4FormPage(
      key: calparform4key,
      viewMode: form3ViewMode,
      calpar1Id: calpar1Id ?? "",
      recordId: calpar3Id ?? "",
      isExpanded: expanded[3],
      onToggle: (value) => onToggleForm3(value),
    );
  }

  Future<void> onToggleForm4(bool _) async {
    openForm4();
  }

  Future<void> simulateToggleForm4() async {
    await onToggleForm4(true);
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

    final oldExpanded = List<bool>.from(expanded);
    isHitungPremiClicked = true;
    final newExpanded = [false, false, false,true];

    // VALIDATOR
    final validators = <int, Future<bool> Function()>{
      0: () async => await calparform1key.currentState?.validateAndReturn() ?? false,
      1: () async => await calparform2key.currentState?.validateAndReturn() ?? false,
      2: () async => await calparform3key.currentState?.validateAndReturn() ?? false,
    };

    // SAVERS
    final savers = <int, Future<void> Function()>{
      0: () async => await calparform1key.currentState?.saveForm1(),
      1: () async => await calparform2key.currentState?.saveForm2(),
      2: () async => await calparform3key.currentState?.saveForm3(),
    };

    print("🔎 Cek semua form sebelum pindah ke Form 6...");

    final allow = await FormExitGuard.multiCheck(
      oldExpanded: oldExpanded,
      newExpanded: newExpanded,
      validators: validators,
      savers: savers,
    );

    if (!allow) {
      print("⛔ GA BOLEH pindah, karena ada form invalid.");
      return;
    }

    print("✅ Semua valid & saved → lanjut hitung premi");

    setState(() => expanded = newExpanded);
    if (calpar1Id != null) {
      context.read<Calpar4FormBloc>().add(
        Calpar4FormHitungPremiEvent(calpar1Id: calpar1Id ?? ""),
      );
    }
  }

  Future<void> onLanjutkanPressed() async {
    context.read<Calpar1ListBloc>().add(
      CalPar2RegParEvent(calpar1Id: calpar1Id!),
    );
  }

  // ========================= OPEN FORMS =========================

  void openForm1() {
    setState(() {
      expanded = [true, false, false, false];
      calparform1key.currentState?.onOpenedByParent();
    });
  }

  Future<void> openForm2() async {
    final oldState = List<bool>.from(expanded);
    final newState = [false, true, false, false];
    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await calparform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await calparform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await calparform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await calparform1key.currentState?.saveForm1(),
        1: () async => await calparform2key.currentState?.saveForm2(),
        2: () async => await calparform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[1] == true) {
        calparform2key.currentState?.onOpenedByParent();
      }
    });
  }

  Future<void> openForm3() async {
    final oldState = List<bool>.from(expanded);

    final newState = [false, false, true, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await calparform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await calparform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await calparform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await calparform1key.currentState?.saveForm1(),
        1: () async => await calparform2key.currentState?.saveForm2(),
        2: () async => await calparform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[2] == true) {
        calparform3key.currentState?.onOpenedByParent();
      }
    });
  }

  void openForm4() {
    setState(() {
      expanded = [false, false, false, true];
    });
  }
}