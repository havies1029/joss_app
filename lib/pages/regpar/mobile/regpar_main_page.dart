import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form1.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form2.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form3.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form4.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form5.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form6.dart';
import '../../../blocs/regpar/regpar5form_bloc.dart';
import '../../../helper/form_exit_guard.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import 'konfirmasi_regpar_page.dart';

class RegparFormMain extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const RegparFormMain({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  State<RegparFormMain> createState() => _RegparFormMainState();
}

class _RegparFormMainState extends State<RegparFormMain> {
  List<bool> expanded = [true, false, false, false, false, false];

  final regparform1key = GlobalKey<RegparForm1SectionState>();
  final regparform2key = GlobalKey<RegparForm2SectionState>();
  final regparform3key = GlobalKey<RegparForm3SectionState>();
  final  regparform4key = GlobalKey<RegparForm4SectionState>();
  final regparform5key = GlobalKey<RegparForm5SectionState>();
  final regparform6key = GlobalKey<RegparForm6SectionState>();

  String? regpar1Id;
  String? regpar2Id;
  String? regpar3Id;
  String? regpar4Id;
  String? regpar5Id;
  String? regpar6Id;

  Map<String, dynamic>? _form5Payload;

  String form1ViewMode = "ubah";
  String form2ViewMode = "ubah";
  String form3ViewMode = "ubah";
  String form4ViewMode = "ubah";
  String form5ViewMode = "ubah";
  String form6ViewMode = "ubah";

  bool isHitungPremiClicked = false;

  double getProgressValue() {
    double p = 0.0;

    if (regpar1Id?.isNotEmpty == true) p += 1 / 6;
    if (regpar2Id?.isNotEmpty == true) p += 1 / 6;
    if (regpar3Id?.isNotEmpty == true) p += 1 / 6;
    if (regpar4Id?.isNotEmpty == true) p += 1 / 6;
    if (regpar5Id?.isNotEmpty == true) p += 1 / 6;
    if (regpar6Id?.isNotEmpty == true) p += 1 / 6;

    return p;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Properti",
      blocListeners: [
        BlocListener<Regpar5FormBloc, Regpar5FormState>(
          listenWhen: (prev, curr) {
            return true;
          },

          listener: (context, state) {
            if(isHitungPremiClicked == true){
              // isHitungPremiClicked = false;
              simulateToggleForm6();
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
            // 🧾 Header Info Section (kartu atas)
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

            // ------------------ FORM 1 ------------------

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm1Section(),
            ),

            const SizedBox(height: hPadding),

            // ------------------ FORM 2 ------------------

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm2Section(),
            ),

            const SizedBox(height: hPadding),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm4Section(),
            ),

            const SizedBox(height: hPadding),

            // ------------------ FORM 3 ------------------


            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm3Section(),
            ),

            const SizedBox(height: hPadding),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm5Section(),
            ),

            const SizedBox(height: hPadding),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildButtonHitungPremi(),
            ),

            const SizedBox(height: hPadding),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm6Section(),
            ),

            const SizedBox(height: hPadding),

            if (isHitungPremiClicked == true) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                child: AppButton.iconRight(
                  text: "Lanjutkan",
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KonfirmasiRegParPage(
                          recordId: widget.recordId ?? '',
                          viewMode: 'ubah',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  //========================= form1 =========================
  Widget buildForm1Section() => RegparForm1Section(
    key: regparform1key,
    viewMode: form1ViewMode,
    recordId: widget.recordId ?? "",
    isExpanded: expanded[0],
    onToggle: (value) => onToggleForm1(value),
  );

  Future<void> onToggleForm1(bool _) async {
    openForm1();
  }

  Future<void> simulateToggleForm1() async {
    await onToggleForm1(true);
  }



  //========================= form2 =========================

  Widget buildForm2Section() {
    return RegparForm2Section(
      key: regparform2key,
      viewMode: form2ViewMode,
      regpar1Id: widget.recordId ?? "",
      recordId: regpar2Id ?? "",
      isExpanded: expanded[1],
      onToggle: (value) => onToggleForm2(value),
    );
  }

  Future<void> onToggleForm2(bool _) async {
    openForm2();
  }

  Future<void> simulateToggleForm2() async {
    await onToggleForm2(true);
  }


  //========================= form3 =========================

  Widget buildForm3Section() {
    return RegparForm3Section(
      key: regparform3key,
      viewMode: form3ViewMode,
      regpar1Id: widget.recordId ?? "",
      recordId: regpar3Id ?? "",
      isExpanded: expanded[2],
      onToggle: (value) => onToggleForm3(value),
    );
  }

  Future<void> onToggleForm3(bool _) async {
    openForm3();
  }

  Future<void> simulateToggleForm3() async {
    await onToggleForm3(true);
  }



  //========================= form4 =========================
  Widget buildForm4Section() {
    return RegparForm4Section(
      key: regparform4key,
      viewMode: form4ViewMode,
      regpar1Id: widget.recordId ?? "",
      recordId: regpar4Id,
      isExpanded: expanded[3],
      onToggle: (value) => onToggleForm4(value),
    );
  }

  Future<void> onToggleForm4(bool _) async {
    openForm4();

  }

  Future<void> simulateToggleForm4() async {
    await onToggleForm4(true);
  }


  //========================= form5 =========================
  Widget buildForm5Section() {
    return RegparForm5Section(
      key: regparform5key,
      viewMode: form5ViewMode,
      regpar1Id: widget.recordId ?? "",
      recordId: regpar5Id,
      isExpanded: expanded[4],
      onToggle: (value) => onToggleForm5(value),
    );
  }

  Future<void> onToggleForm5(bool _) async {
    openForm5();

  }

  Future<void> simulateToggleForm5() async {
    await onToggleForm5(true);
  }




  //========================= form6 =========================
  Widget buildForm6Section() {
    return RegparForm6Section(
      key: regparform6key,
      viewMode: form6ViewMode,
      regpar1Id: widget.recordId ?? "",
      recordId: regpar6Id,
      isExpanded: expanded[5],
      onToggle: (value) => onToggleForm5(value),
    );
  }

  Future<void> onToggleForm6(bool _) async {
    openForm6();

  }

  Future<void> simulateToggleForm6() async {
    await onToggleForm6(true);
  }




  //========================= hitung premi =========================




  Widget buildButtonHitungPremi() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: AppButton.primary(
      text: "Hitung Premi",
      onPressed: onHitungPremi,
    ),
  );

  Future<void> onHitungPremi() async {
    print("🔥 Tombol Hitung Premi ditekan");

    final oldExpanded = List<bool>.from(expanded);
    isHitungPremiClicked = true;
    final newExpanded = [false, false, false, false, false,true];

    // VALIDATOR
    final validators = <int, Future<bool> Function()>{
      0: () async => regparform1key.currentState?.validateAndReturn() ?? false,
      1: () async => regparform2key.currentState?.validateAndReturn() ?? false,
      2: () async => regparform3key.currentState?.validateAndReturn() ?? false,
      3: () async => regparform4key.currentState?.validateAndReturn() ?? false,
      4: () async => regparform5key.currentState?.validateAndReturn() ?? false,
    };

    // SAVERS
    final savers = <int, Future<void> Function()>{
      0: () async => await regparform1key.currentState?.saveForm1(),
      1: () async => await regparform2key.currentState?.saveForm2(),
      2: () async => await regparform3key.currentState?.saveForm3(),
      3: () async => await regparform4key.currentState?.saveForm4(),
      4: () async => await regparform5key.currentState?.saveForm5(),
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

    // Update UI
    setState(() => expanded = newExpanded);

    // Trigger Hitung Premi
    if (widget.recordId != null) {
      context.read<Regpar5FormBloc>().add(
        Regpar5FormHitungPremiEvent(
          recordId: widget.recordId!,
        ),
      );
      print("🚀 Event HitungPremi DIKIRIM");
    } else {
      print("❌ regpar1Id NULL atau kosong. Premi batal.");
    }
  }

  void openForm1() {
    setState(() {
      expanded = [true, false, false, false, false, false];
      regparform1key.currentState?.onOpenedByParent();
    });
  }

  void openForm2() async{
    final oldState = List<bool>.from(expanded);
    final newState = [false, true, false, false, false, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regparform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regparform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regparform3key.currentState?.validateAndReturn() ?? false,
        3: () async => await regparform4key.currentState?.validateAndReturn() ?? false,
        4: () async => await regparform5key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regparform1key.currentState?.saveForm1(),
        1: () async => await regparform2key.currentState?.saveForm2(),
        2: () async => await regparform3key.currentState?.saveForm3(),
        3: () async => await regparform4key.currentState?.saveForm4(),
        4: () async => await regparform5key.currentState?.saveForm5(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[1] == true) {
        regparform2key.currentState?.onOpenedByParent();
      }
    });
  }

  void openForm3() async{
    final oldState = List<bool>.from(expanded);

    final newState = [false, false, true, false, false, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regparform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regparform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regparform3key.currentState?.validateAndReturn() ?? false,
        3: () async => await regparform4key.currentState?.validateAndReturn() ?? false,
        4: () async => await regparform5key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regparform1key.currentState?.saveForm1(),
        1: () async => await regparform2key.currentState?.saveForm2(),
        2: () async => await regparform3key.currentState?.saveForm3(),
        3: () async => await regparform4key.currentState?.saveForm4(),
        4: () async => await regparform5key.currentState?.saveForm5(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[2] == true) {
        regparform3key.currentState?.onOpenedByParent();
      }
    });
  }

  void openForm4() async{
    final oldState = List<bool>.from(expanded);
    final newState = [false, false, false, true, false, false];


    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regparform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regparform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regparform3key.currentState?.validateAndReturn() ?? false,
        3: () async => await regparform4key.currentState?.validateAndReturn() ?? false,
        4: () async => await regparform5key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regparform1key.currentState?.saveForm1(),
        1: () async => await regparform2key.currentState?.saveForm2(),
        2: () async => await regparform3key.currentState?.saveForm3(),
        3: () async => await regparform4key.currentState?.saveForm4(),
        4: () async => await regparform5key.currentState?.saveForm5(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[3] == true) {
        regparform4key.currentState?.onOpenedByParent();
      }
    });

  }

  Future<void> openForm5() async {

    final oldState = List<bool>.from(expanded);

    final newState = [false, false, false, false, true, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regparform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regparform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regparform3key.currentState?.validateAndReturn() ?? false,
        3: () async => await regparform4key.currentState?.validateAndReturn() ?? false,
        4: () async => await regparform5key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regparform1key.currentState?.saveForm1(),
        1: () async => await regparform2key.currentState?.saveForm2(),
        2: () async => await regparform3key.currentState?.saveForm3(),
        3: () async => await regparform4key.currentState?.saveForm4(),
        4: () async => await regparform5key.currentState?.saveForm5(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[4] == true) {
        regparform5key.currentState?.onOpenedByParent();
      }
    });
  }

  void openForm6() {
    setState(() {
      expanded = [false, false, false, false, false, true];
    });
  }

}