import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form1.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form2.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form3.dart';
import 'package:joss_app/pages/regpar/mobile/regpar/regpar_form4.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import '../../gen_regmv/mobile/regmv/regmv_form6.dart';
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
  final regparform4key = GlobalKey<RegparForm4SectionState>();

  String? regpar1Id = "251200001";
  String? regpar2Id;
  String? regpar3Id;
  String? regpar4Id;
  String? regpar5Id;
  String? regpar6Id;

  Map<String, dynamic>? _form6Payload;

  String form1ViewMode = "ubah";
  String form2ViewMode = "ubah";
  String form3ViewMode = "ubah";
  String form4ViewMode = "tambah";
  String form5ViewMode = "tambah";
  String form6ViewMode = "tambah";

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
        BlocListener<Regpar1CrudBloc, Regpar1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.regpar1Id;

              if (newId != null && newId.isNotEmpty) {
                debugPrint("🔥 [LISTENER] regpar1 saved → result ID = $newId");

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

            // 🧩 FORM BODY UTAMA
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

            // ------------------ FORM 3 (PREMI) ------------------


            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: buildForm3Section(),
            ),

            const SizedBox(height: hPadding),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: RegmvForm6Section(
                isExpanded: expanded[5],
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
                      builder: (context) => KonfirmasiRegParPage(
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
  Widget buildForm1Section() => RegparForm1Section(
    key: regparform1key,
    viewMode: form1ViewMode,
    recordId: regpar1Id ?? "",
    isExpanded: expanded[0],
    onToggle: (value) => onToggleForm1(value),
  );

  Future<void> onToggleForm1(bool _) async {
    if (regpar1Id != null) {
      form1ViewMode = "ubah";
      debugPrint("🔥 Mode ubah aktif karena calpar1Id ada");
    } else {
      form1ViewMode = "tambah";
      debugPrint("🔥 Mode tambah aktif karena calpar1Id kosong");
    }
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
      regpar1Id: regpar1Id ?? "",
      recordId: regpar2Id ?? "",
      isExpanded: expanded[1],
      onToggle: (value) => onToggleForm2(value),
    );
  }

  Future<void> onToggleForm2(bool _) async {
    final isValidForm1 = await regparform1key.currentState?.validateAndReturn();
    if (regpar1Id != null) {

      if (form1ViewMode == "ubah"){
        //update form`1
        await regparform1key.currentState?.saveForm1();
      }else {
        debugPrint("🔥 Mode tambah aktif karena regpar1Id ada");
        if (regpar2Id != null){
          form2ViewMode = "ubah";
          debugPrint("🔥 Mode ubah aktif karena regpar2Id tidak kosong");
        }
        openForm2();
      }


    }else if (isValidForm1 == true) {
      await regparform1key.currentState?.saveForm1();
    }
  }
  
  Future<void> simulateToggleForm2() async {
    await onToggleForm2(true);
  }


  //========================= form3 =========================

  Widget buildForm3Section() {
    return RegparForm3Section(
      key: regparform3key,
      viewMode: form3ViewMode,
      regpar1Id: regpar1Id ?? "",
      recordId: regpar3Id ?? "",
      isExpanded: expanded[2],
      onToggle: (value) => onToggleForm3(value),
    );
  }

  Future<void> onToggleForm3(bool _) async {
    final isValidForm1 = await regparform1key.currentState?.validateAndReturn();
    final isValidForm2 = await regparform2key.currentState?.validateAndReturn();

    if (regpar1Id != null) {
      if (form1ViewMode == "ubah"){
        //update form`1
        await regparform1key.currentState?.saveForm1();
      }else {
        debugPrint("🔥 Mode tambah aktif karena regpar1Id ada");
        if (form2ViewMode == "ubah"){
          await regparform2key.currentState?.saveForm2();

          debugPrint("🔥 Mode ubah aktif karena regpar2Id tidak kosong");
        }else {
          if (regpar3Id != null){
            form3ViewMode = "ubah";
          }
          openForm3();
        }
      }


    }else if (isValidForm1 == true) {
      await regparform1key.currentState?.saveForm1();
    }else if (isValidForm2 == true) {
      await regparform2key.currentState?.saveForm2();
    }
  }

  Future<void> simulateToggleForm3() async {
    await onToggleForm3(true);
  }



  //========================= form4 =========================
  Widget buildForm4Section() {
    return RegparForm4Section(
      key: regparform4key,
      viewMode: form4ViewMode,
      regpar1Id: regpar1Id ?? "",
      recordId: regpar4Id,
      isExpanded: expanded[3],
      onToggle: (value) => onToggleForm4(value),
    );
  }

  Future<void> onToggleForm4(bool _) async {
    final isValidForm1 = await regparform1key.currentState?.validateAndReturn();
    final isValidForm2 = await regparform2key.currentState?.validateAndReturn();
    final isValidForm3 = await regparform3key.currentState?.validateAndReturn();

    if (regpar1Id != null) {
      if (form1ViewMode == "ubah"){
        await regparform1key.currentState?.saveForm1();
      }else {
        if (form2ViewMode == "ubah"){
          await regparform2key.currentState?.saveForm2();

        }else {
          debugPrint("🔥 Mode tambah aktif karena regpar1Id ada");

          if (form3ViewMode == "ubah"){
            await regparform3key.currentState?.saveForm3();
            debugPrint("🔥 Mode ubah aktif karena regpar3Id tidak kosong");
          }else {
            if (regpar4Id != null) {
              form4ViewMode = "ubah";
            }
            openForm4();
          }
        }
      }

    }else if (isValidForm1 == true) {
      await regparform1key.currentState?.saveForm1();
    }else if (isValidForm2 == true) {
      await regparform2key.currentState?.saveForm2();
    }else if (isValidForm3 == true) {
      await regparform3key.currentState?.saveForm3();
    }
  }

  Future<void> simulateToggleForm4() async {
    await onToggleForm4(true);
  }



  void openForm1() {
    setState(() {
      expanded = [true, false, false, false, false, false];
    });
  }

  void openForm2() {
    setState(() {
      expanded = [false, true, false, false, false, false];
    });
  }

  void openForm3() {
    setState(() {
      expanded = [false, false, true, false, false, false];
    });
  }

  void openForm4() {
    setState(() {
      expanded = [false, false, false, true, false, false];
    });
  }

  void openForm5() {
    setState(() {
      expanded = [false, false, false, false, true, false];
    });
  }

  void openForm6() {
    setState(() {
      expanded = [false, false, false, false, false, true];
    });
  }

}