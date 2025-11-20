import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../blocs/gen_regmv/regmv1crud_bloc.dart';
import '../../../blocs/gen_regmv/regmv2form_bloc.dart';
import '../../../blocs/gen_regmv/regmv3form_bloc.dart';
import '../../../blocs/gen_regmv/regmv4form_bloc.dart';
import '../../../blocs/gen_regmv/regmv5form_bloc.dart';
import '../../../blocs/gen_regmv/regmv6form_bloc.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';

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
  List<bool> expanded = [true, false, false, false, false, false];

  final regmvform1key = GlobalKey<RegmvForm1SectionState>();
  final regmvform2key = GlobalKey<RegmvForm2SectionState>();
  final regmvform3key = GlobalKey<RegmvForm2SectionState>();
  final regmvform4key = GlobalKey<RegmvForm2SectionState>();
  final regmvform5key = GlobalKey<RegmvForm2SectionState>();

  String? calmv1Id;
  String? regmv1Id;
  String? regmv2Id;
  String? regmv3Id;
  String? regmv4Id;
  String? regmv5Id;
  String? regmv6Id;

  Map<String, dynamic>? _form3Payload;

  String form1ViewMode = "tambah";
  String form2ViewMode = "tambah";
  String form3ViewMode = "tambah";
  String form4ViewMode = "tambah";
  String form5ViewMode = "tambah";
  String form6ViewMode = "tambah";

  bool isHitungPremiClicked = false;

  double getProgressValue() {
    double p = 0.0;

    if (calmv1Id?.isNotEmpty == true) p += 0.16;
    if (regmv1Id?.isNotEmpty == true) p += 0.16;
    if (regmv2Id?.isNotEmpty == true) p += 0.16;
    if (regmv3Id?.isNotEmpty == true) p += 0.17;
    if (regmv4Id?.isNotEmpty == true) p += 0.17;
    if (regmv5Id?.isNotEmpty == true) p += 0.17;
    if (regmv6Id?.isNotEmpty == true) p += 0.17;


    return p;
  }


  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      blocListeners: [
        BlocListener<Regmv1CrudBloc, Regmv1CrudState>(
          listener: (context, state) {
            //diisi nanti
          },
        ),

        BlocListener<Regmv2FormBloc, Regmv2FormState>(
          listener: (context, state) {
            //diisi nanti
          },
        ),

        BlocListener<Regmv3FormBloc, Regmv3FormState>(
          listener: (context, state) {
            //diisi nanti
          },
        ),

        BlocListener<Regmv4FormBloc, Regmv4FormState>(
          listener: (context, state) {
            //diisi nanti
          },
        ),

        BlocListener<Regmv5FormBloc, Regmv5FormState>(
          listener: (context, state) {
            //diisi nanti
          },
        ),

        BlocListener<Regmv6FormBloc, Regmv6FormState>(
          listener: (context, state) {
            //diisi nanti
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

            // 🧩 FORM BODY UTAMA
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ------------------ FORM 1 ------------------
                  RegmvForm1Section(
                    key: regmvform1key,
                    viewMode: form1ViewMode,
                    recordId: regmv1Id ?? "",
                    isExpanded: expanded[0],
                    onToggle: (value) => {openForm1()},
                  ),

                  const SizedBox(height: hPadding),

                  // ------------------ FORM 2 ------------------
                  RegmvForm2Section(
                    key: regmvform2key,
                    viewMode: form2ViewMode,
                    recordId: regmv2Id ?? "",
                    isExpanded: expanded[1],
                    onToggle: (value) => {openForm2()},
                  ),

                  const SizedBox(height: hPadding),

                  // ------------------ TOMBOL HITUNG PREMI ------------------

                  RegmvForm3Section(
                    key: regmvform3key,
                    viewMode: form3ViewMode,
                    recordId: regmv3Id ?? "",
                    isExpanded: expanded[2],
                    onToggle: (value) => {openForm3()},
                  ),

                  const SizedBox(height: hPadding),

                  // ------------------ FORM 3 (PREMI) ------------------
                  RegmvForm4Section(
                    key: regmvform4key,
                    viewMode: form3ViewMode,
                    recordId: regmv4Id ?? "",
                    isExpanded: expanded[3],
                    onToggle: (value) => {openForm4()},
                  ),


                  const SizedBox(height: hPadding),

                  // ------------------ BUTTON LANJUTKAN ------------------
                  RegmvForm5Section(
                    key: regmvform5key,
                    viewMode: form4ViewMode,
                    recordId: regmv5Id ?? "",
                    isExpanded: expanded[4],
                    onToggle: (value) => {openForm5()},
                  ),


                  const SizedBox(height: hPadding),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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