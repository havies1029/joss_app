import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/gen_calmv/calmv1crud_bloc.dart';
import '../../../blocs/gen_calmv/calmv1list_bloc.dart';
import '../../../blocs/gen_calmv/calmv2form_bloc.dart';
import '../../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../../../common/constants.dart';
import '../../../models/gen_calmv/calmv2form_model.dart';
import '../../../models/gen_calmv/calmv3form_model.dart';
import '../../../widgets/apptheme/custom_progress_bar.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import '../../gen_regmv/mobile/regmv_main_page.dart';
import 'calmv/calmv_form1_remake.dart';
import 'calmv/calmv_form2_remake.dart';
import 'calmv/calmv_form3_remake.dart';

class CalmvMainPageRemake extends StatefulWidget {

  const CalmvMainPageRemake({
    super.key,
  });

  @override
  State<CalmvMainPageRemake> createState() => _CalmvMainPageRemakeState();
}


class _CalmvMainPageRemakeState extends State<CalmvMainPageRemake> {
  List<bool> expanded = [true, false, false];

  final calmvform1key = GlobalKey<CalmvForm1SectionState>();
  final calmvform2key = GlobalKey<CalmvForm2SectionState>();
  final calmvform3key = GlobalKey<CalmvForm3SectionState>();

  String? calmv1Id;
  String? calmv2Id;
  String? calmv3Id;

  Calmv2FormModel? form2Record;
  Calmv3FormModel? form3Record;

  double getProgressValue() {
    double p = 0.0;

    if (calmv1Id?.isNotEmpty == true) p += 0.35;
    if (calmv2Id?.isNotEmpty == true) p += 0.35;
    if (calmv3Id?.isNotEmpty == true) p += 0.3;

    return p;
  }

  @override
  void initState() {
    super.initState();

    final calmv1State = context.read<Calmv1CrudBloc>().state;
    calmv1Id = calmv1State.record?.calmv1Id;

    final calmv2State = context.read<Calmv2FormBloc>().state;
    calmv2Id = calmv2State.record?.calmv2Id;

    final calmv3State = context.read<Calmv3FormBloc>().state;
    calmv3Id = calmv3State.record?.calmv3Id;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      blocListeners: [
        BlocListener<Calmv1ListBloc, Calmv1ListState>(
          listener: (context, state) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegmvFormMain(recordId: state.processMessage, viewMode: 'ubah',),
              ),
            );
          },
        ),

        BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calmv1Id = state.record!.calmv1Id;
              });

               if (calmv2Id == null) {
                 onHitungPremi();
              }
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
          },
        ),

        BlocListener<Calmv3FormBloc, Calmv3FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              setState(() {
                calmv3Id = state.record!.calmv3Id;
                // form3Record = state.record;
              });
            }

            if (state.isLoaded && state.record != null) {
              final r = state.record!;


              // final payload = {
              //   "subtotalPremi": r.premiSubtotal ?? 0,
              //   "diskonPremi": r.premiDiskon ?? 0,
              //   "netPremi": r.premiNet ?? 0,
              // };


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

                  buildForm1Section(),

                  const SizedBox(height: hPadding),

                  buildForm2Section(),

                  const SizedBox(height: hPadding),

                  buildButtonHitungPremi(),

                  const SizedBox(height: hPadding),

                  // ------------------ BUTTON LANJUTKAN ------------------
                  if (calmv3Id?.isNotEmpty == true) ...[
                    buildForm3Section(),
                    const SizedBox(height: hPadding),

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

  Future<void> onLanjutkanPressed() async {
    context.read<Calmv1ListBloc>().add(
      CalMv2RegMvEvent(calmv1Id: calmv1Id!),
    );
  }


  Widget buildForm1Section() => CalmvForm1Section(
    key: calmvform1key,
    recordId: calmv1Id ?? "",
    isExpanded: expanded[0],
    onToggle: (value) {
      setState(() {
        expanded = [false, false, false];
        expanded[0] = value;
      });
    },
  );

  Widget buildForm2Section() => CalmvForm2Section(
    key: calmvform2key,
    calmv1Id: calmv1Id ?? "",
    recordId: calmv2Id ?? "",
    isExpanded: expanded[1],
    onToggle: (value) {
      setState(() {
        expanded = [false, false, false];
        expanded[1] = value;
      });
    },
  );

  Widget buildForm3Section() => CalmvForm3Section(
    key: calmvform3key,
    isExpanded: expanded[2],
    onToggle: (value) {
      setState(() {
        expanded = [false, false, false];
        expanded[2] = value;
      });
    },
  );

  Widget buildButtonHitungPremi() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: AppButton.primary(
      text: "Hitung Premi",
      onPressed: onHitungPremi,
    ),
  );

  Future<void>  onHitungPremi() async {
    final isValidForm1 = await calmvform1key.currentState?.validateAndReturn();
    final isValidForm2 = await calmvform2key.currentState?.validateAndReturn();

    if (calmv1Id == null) {
      if (isValidForm1 == true) {
        await calmvform1key.currentState?.saveForm1();
      }
    }
    else if (calmv2Id == null) {
      if (isValidForm2 == true){
        await calmvform2key.currentState?.saveForm2(calmv1Id);
      }
    }
  }

  void openForm1() {
    setState(() {
      expanded = [true, false, false];
    });
  }

  void openForm2() {
    setState(() {
      expanded = [false, true, false];
    });
  }

  void openForm3() {
    setState(() {
      expanded = [false, false, true];
    });
  }
}

