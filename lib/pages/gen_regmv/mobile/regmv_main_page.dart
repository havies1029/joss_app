import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/gen_regmv/mobile/regmv/regmv_form7.dart';
import '../../../blocs/gen_regmv/regmv1crud_bloc.dart';
import '../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../blocs/gen_regmv/regmv6form_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
import '../../../blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import '../../../helper/form_exit_guard.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';

import 'konfirmasi_regmv_page.dart';
import 'regmv/regmv_form1.dart';
import 'regmv/regmv_form2.dart';
import 'regmv/regmv_form3.dart';
import 'regmv/regmv_form4.dart';
import 'regmv/regmv_form5.dart';
import 'regmv/regmv_form6.dart';

class RegmvFormMain extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const RegmvFormMain({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  State<RegmvFormMain> createState() => _RegmvFormMainState();
}

class _RegmvFormMainState extends State<RegmvFormMain> {
  List<bool> expanded = [true, false, false, false, false, false, false];

  final regmvform1key = GlobalKey<RegmvForm1SectionState>();
  final regmvform2key = GlobalKey<RegmvForm2SectionState>();
  final regmvform3key = GlobalKey<RegmvForm3SectionState>();
  final regmvform4key = GlobalKey<RegmvForm4SectionState>();
  final regmvform5key = GlobalKey<RegmvForm5SectionState>();
  final regmvform6key = GlobalKey<RegmvForm6SectionState>();
  final regmvform7key = GlobalKey<RegmvForm7SectionState>();

  String? regmv1Id;
  String? regmv2Id;
  String? regmv3Id;
  List<String?> regmv4Id = List.filled(10, null);
  List<String?> regmv5Id = List.filled(10, null);
  String? regmv6Id;
  List<String?> regmv7Id = List.filled(10, null);


  Map<String, dynamic>? _form6Payload;

  String form1ViewMode = "ubah";
  String form2ViewMode = "ubah";
  String form3ViewMode = "ubah";
  String form4ViewMode = "tambah";
  String form5ViewMode = "tambah";
  String form6ViewMode = "tambah";
  String form7ViewMode = "tambah";

  bool isHitungPremiClicked = false;

  double getProgressValue() {
    double p = 0.0;

    if (regmv1Id?.isNotEmpty == true) p += 0.15;
    if (regmv2Id?.isNotEmpty == true) p += 0.15;
    if (regmv3Id?.isNotEmpty == true) p += 0.15;
    if (regmv4Id?.isNotEmpty == true) p += 0.15;
    if (regmv5Id?.isNotEmpty == true) p += 0.15;
    if (regmv7Id?.isNotEmpty == true) p += 0.15;
    if (_form6Payload != null) p += 0.10;


    return p;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        regmv1Id = widget.recordId;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      blocListeners: [
        BlocListener<Regmv1CrudBloc, Regmv1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null){

              if (isHitungPremiClicked == true){

              }

            }
          },
        ),

        BlocListener<Regmv2FormBloc, Regmv2FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null){



            }
          },
        ),

        BlocListener<Regmv3FormBloc, Regmv3FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null){




            }
          },
        ),

        // 4️⃣ FORM 4 (UPLOAD STNK)
        BlocListener<RegmvUploadStnkBloc, RegmvUploadStnkState>(
          listener: (context, state) {
            if (state is UploadStnkPreview && isHitungPremiClicked) {

            }
          },
        ),

        // 5️⃣ FORM 5 (UPLOAD FOTO MOBIL)
        BlocListener<RegmvUploadFotoMobilBloc, RegmvUploadFotoMobilState>(
          listener: (context, state) {
            if (state is UploadFotoMobilPreview && isHitungPremiClicked) {

            }
          },
        ),

        // 6️⃣ FORM 7 (UPLOAD FOTO ACC)
        BlocListener<RegmvUploadFotoAccBloc, RegmvUploadFotoAccState>(
          listener: (context, state) {
            if (state is UploadFotoAccPreview && isHitungPremiClicked) {

            }
          },
        ),

        BlocListener<Regmv6FormBloc, Regmv6FormState>(
          listenWhen: (prev, curr) {
            final changed = prev.isLoaded != curr.isLoaded;
            debugPrint("🟦 [LISTENWHEN] prev.isLoaded=${prev.isLoaded}, curr.isLoaded=${curr.isLoaded}, changed=$changed");
            return changed && curr.isLoaded && curr.record != null;
          },

          listener: (context, state) {
            debugPrint("🟨 [LISTENER] MASUK LISTENER FORM6");

            if (state.isLoaded && state.record != null) {
              final r = state.record!;

              debugPrint("🔥 [LISTENER] State LOADED. Record diterima = ${r.toJson()}");

              final payload = {
                "subtotalPremi": r.premiSubtotal ?? 0,
                "diskonPremi": r.premiDiskon ?? 0,
                "netPremi": r.premiNet ?? 0,
              };

              debugPrint("🟪 [LISTENER] Payload disiapkan: $payload");

              // update UI form6
              if (regmvform6key.currentState != null) {
                debugPrint("🟧 [LISTENER] injectPayload() dipanggil ke Form6");
                regmvform6key.currentState!.injectPayload(payload);
              } else {
                debugPrint("⛔ [LISTENER] regmvform6key.currentState == null, injectPayload DILEWATI");
              }

              debugPrint("🟩 [LISTENER] Membuka Form6 via openForm6()");
              openForm6();

              setState(() {
                debugPrint("🟫 [LISTENER] setState() dijalankan. Payload disimpan ke _form6Payload");
                _form6Payload = payload;
              });

              debugPrint("🟨 [LISTENER] AKHIR listener Form6");
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
                iconPath: "assets/icons/kendaraan.svg",
                title: "Kendaraan",
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
              child:  buildForm1Section(),
            ),

            const SizedBox(height: hPadding),

            // ------------------ FORM 2 ------------------

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm2Section(),
            ),

            const SizedBox(height: hPadding),

            // ------------------ TOMBOL HITUNG PREMI ------------------

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child:buildForm3Section(),
            ),

            const SizedBox(height: hPadding),

            // ------------------ FORM 3 (PREMI) ------------------

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm4Section(),
            ),

            const SizedBox(height: hPadding),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child:  buildForm5Section(),
            ),

            const SizedBox(height: hPadding),

            Padding(padding: EdgeInsets.symmetric(horizontal: hPadding),child: buildForm7Section()),

            const SizedBox(height: hPadding),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildButtonHitungPremi(),
            ),

            const SizedBox(height: hPadding),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: RegmvForm6Section(
                isExpanded: expanded[6],
                initialPayload: _form6Payload,
              ),
            ),

            const SizedBox(height: hPadding),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: AppButton.iconRight(
                text: "Lanjutkan",
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KonfirmasiRegMvPage(
                        recordId: widget.recordId ?? '',
                        viewMode: 'ubah',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //========================= form1 =========================
  Widget buildForm1Section() => RegmvForm1Section(
    key: regmvform1key,
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
    return RegmvForm2Section(
      key: regmvform2key,
      viewMode: form2ViewMode,
      regmv1Id: widget.recordId ?? "",
      recordId: regmv2Id ?? "",
      isExpanded: expanded[1],
      onToggle: (value) => onToggleForm2(value),
    );
  }

  Future<void> onToggleForm2(bool _) async {
    // final isValidForm1 = await regmvform1key.currentState?.validateAndReturn();

    openForm2();
  }

  Future<void> simulateToggleForm2() async {
    await onToggleForm2(true);
  }



  //========================= form3 =========================

  Widget buildForm3Section() {
    return RegmvForm3Section(
      key: regmvform3key,
      viewMode: form3ViewMode,
      regmv1Id: widget.recordId ?? "",
      recordId: regmv3Id ?? "",
      isExpanded: expanded[2],
      onToggle: (value) => onToggleForm3(value),
    );
  }

  Future<void> onToggleForm3(bool _) async {
    // final isValidForm1 = await regmvform1key.currentState?.validateAndReturn();
    // final isValidForm2 = await regmvform2key.currentState?.validateAndReturn();

    openForm3();
  }

  Future<void> simulateToggleForm3() async {
    await onToggleForm3(true);
  }


  //========================= form4 =========================
  Widget buildForm4Section() {
    return RegmvForm4Section(
      key: regmvform4key,
      viewMode: form4ViewMode,
      regmv1Id: regmv1Id ?? "",
      recordId: regmv4Id,
      isExpanded: expanded[3],
      onToggle: (value) => onToggleForm4(value),
    );
  }

  Future<void> onToggleForm4(bool _) async {
    // final isValidForm1 = await regmvform1key.currentState?.validateAndReturn();
    // final isValidForm2 = await regmvform2key.currentState?.validateAndReturn();
    // final isValidForm3 = await regmvform3key.currentState?.validateAndReturn();

    openForm4();
  }

  Future<void> simulateToggleForm4() async {
    await onToggleForm4(true);
  }



  //========================= form5 =========================


  Widget buildForm5Section() {
    return RegmvForm5Section(
      key: regmvform5key,
      viewMode: form5ViewMode,
      regmv1Id: regmv1Id ?? "",
      recordId: regmv5Id,
      isExpanded: expanded[4],
      onToggle: (value) => onToggleForm5(value),
    );
  }

  Future<void> onToggleForm5(bool _) async {
    // final isValidForm1 = await regmvform1key.currentState?.validateAndReturn();
    // final isValidForm2 = await regmvform2key.currentState?.validateAndReturn();
    // final isValidForm3 = await regmvform3key.currentState?.validateAndReturn();
    // final isValidForm4 = await regmvform4key.currentState?.validateAndReturn();
    openForm5();
  }

  Future<void> simulateToggleForm5() async {
    await onToggleForm5(true);
  }

  //========================= form5 =========================


  Widget buildForm7Section() {
    return RegmvForm7Section(
      key: regmvform7key,
      viewMode: form7ViewMode,
      regmv1Id: regmv1Id ?? "",
      recordId: regmv7Id,
      isExpanded: expanded[5],
      onToggle: (value) => onToggleForm7(value),
    );
  }

  Future<void> onToggleForm7(bool _) async {
    // final isValidForm1 = await regmvform1key.currentState?.validateAndReturn();
    // final isValidForm2 = await regmvform2key.currentState?.validateAndReturn();
    // final isValidForm3 = await regmvform3key.currentState?.validateAndReturn();
    // final isValidForm4 = await regmvform4key.currentState?.validateAndReturn();

    openForm7();
  }

  Future<void> simulateToggleForm7() async {
    await onToggleForm7(true);
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

    // Mau tutup semua kecuali Form 6 (index 5)
    final newExpanded = [false, false, false, false, false, true, false];

    // VALIDATOR
    final validators = <int, Future<bool> Function()>{
      0: () async => regmvform1key.currentState?.validateAndReturn() ?? false,
      1: () async => regmvform2key.currentState?.validateAndReturn() ?? false,
      2: () async => regmvform3key.currentState?.validateAndReturn() ?? false,
      // 3: () async => regmvform4key.currentState?.validateAndReturn() ?? false,
      // 4: () async => regmvform5key.currentState?.validateAndReturn() ?? false,
      // 5: () async => regmvform7key.currentState?.validateAndReturn() ?? false,
    };

    // SAVERS
    final savers = <int, Future<void> Function()>{
      0: () async => await regmvform1key.currentState?.saveForm1(),
      1: () async => await regmvform2key.currentState?.saveForm2(),
      2: () async => await regmvform3key.currentState?.saveForm3(),
      // 3: () async => {}, // upload STNK = auto di Bloc
      // 4: () async => {}, // upload mobil = auto di Bloc
      // 5: () async => {}, // upload acc = auto di Bloc
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
    if (regmv1Id != null && regmv1Id!.isNotEmpty) {
      context.read<Regmv6FormBloc>().add(
        Regmv6FormHitungPremiEvent(
          regmv1Id: regmv1Id!,
        ),
      );
      print("🚀 Event HitungPremi DIKIRIM");
    } else {
      print("❌ regmv1Id NULL atau kosong. Premi batal.");
    }
  }

  void openForm1() {
    setState(() {
      expanded = [true, false, false, false, false, false, false];
      regmvform1key.currentState?.onOpenedByParent();
    });
  }

  Future<void> openForm2() async {
    final oldState = List<bool>.from(expanded);
    final newState = [false, true, false, false, false, false, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regmvform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regmvform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regmvform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regmvform1key.currentState?.saveForm1(),
        1: () async => await regmvform2key.currentState?.saveForm2(),
        2: () async => await regmvform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[1] == true) {
        regmvform2key.currentState?.onOpenedByParent();
      }
    });
  }

  Future<void> openForm3() async {
    final oldState = List<bool>.from(expanded);
    final newState = [false, false, true, false, false, false, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regmvform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regmvform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regmvform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regmvform1key.currentState?.saveForm1(),
        1: () async => await regmvform2key.currentState?.saveForm2(),
        2: () async => await regmvform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
      if (expanded[2] == true) {
        regmvform3key.currentState?.onOpenedByParent();
      }
    });
  }


  Future<void> openForm4() async {
    final oldState = List<bool>.from(expanded);
    final newState = [false, false, false, true, false, false, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regmvform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regmvform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regmvform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regmvform1key.currentState?.saveForm1(),
        1: () async => await regmvform2key.currentState?.saveForm2(),
        2: () async => await regmvform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
    });
  }


  Future<void> openForm5() async {
    final oldState = List<bool>.from(expanded);
    final newState = [false, false, false, false, true, false, false];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regmvform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regmvform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regmvform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regmvform1key.currentState?.saveForm1(),
        1: () async => await regmvform2key.currentState?.saveForm2(),
        2: () async => await regmvform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
    });
  }


  void openForm6() {
    setState(() {
      expanded = [false, false, false, false, false, true, false];
    });
  }

  Future<void> openForm7() async {
    final oldState = List<bool>.from(expanded);
    final newState = [false, false, false, false, false, false, true];

    final allowed = await FormExitGuard.multiCheck(
      oldExpanded: oldState,
      newExpanded: newState,

      validators: {
        0: () async => await regmvform1key.currentState?.validateAndReturn() ?? false,
        1: () async => await regmvform2key.currentState?.validateAndReturn() ?? false,
        2: () async => await regmvform3key.currentState?.validateAndReturn() ?? false,
      },

      savers: {
        0: () async => await regmvform1key.currentState?.saveForm1(),
        1: () async => await regmvform2key.currentState?.saveForm2(),
        2: () async => await regmvform3key.currentState?.saveForm3(),
      },
    );

    if (!allowed) return;

    setState(() {
      expanded = newState;
    });
  }
}