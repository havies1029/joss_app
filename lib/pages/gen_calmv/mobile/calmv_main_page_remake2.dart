
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../blocs/gen_calmv/calmv1list_bloc.dart';
import '../../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../../../blocs/gen_calmv/calmvaccordion_bloc.dart';
import '../../../widgets/apptheme/accordion_page.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import 'calmv/calmv_form1_remake2.dart';
import 'calmv/calmv_form2_remake2.dart';
import 'calmv/calmv_form3_remake2.dart';

class CalmvMainPageRemake2 extends StatefulWidget {

  const CalmvMainPageRemake2({
    super.key,
  });

  @override
  State<CalmvMainPageRemake2> createState() => _CalmvMainPageRemake2State();
}


class _CalmvMainPageRemake2State extends State<CalmvMainPageRemake2> {
  final calmv1FormKey = GlobalKey<FormState>();
  final calmv2FormKey = GlobalKey<FormState>();
  final calmv3FormKey = GlobalKey<FormState>();

  String? calmv1Id;

  @override
  Widget build(BuildContext context) {
    var calmv1CrudBloc = BlocProvider.of<Calmv1CrudBloc>(context);
    var calmv2FormBloc = BlocProvider.of<Calmv2FormBloc>(context);
    var calmv3FormBloc = BlocProvider.of<Calmv3FormBloc>(context);
    var calmv1ListBloc = BlocProvider.of<Calmv1ListBloc>(context);
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        body: MultiBlocListener(
          listeners: [
            BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
              listener: (context, state) {
                if (state.isSaved && !state.hasFailure && state.record != null) {
                  setState(() {
                    calmv1Id = state.record!.calmv1Id;
                  });
                }
              },
            ),
            BlocListener<Calmv2FormBloc, Calmv2FormState>(
              listener: (context, state) {
                if (state.isSaved && !state.hasFailure && state.record != null) {
                  setState(() {
                    calmv1Id = state.record!.calmv1Id;
                  });
                  calmv2FormBloc.add(FieldCalmv1IdChangedEvent(calmv1Id: calmv1Id ?? ""));
                }
              },
            ),
            BlocListener<Calmv2FormBloc, Calmv2FormState>(
              listener: (context, state) {
                if (state.isSaved && !state.hasFailure && state.record != null) {
                  setState(() {
                    calmv1Id = state.record!.calmv1Id;
                  });
                }
              },
            ),
          ],
          child: BlocConsumer<CalmvAccordionBloc, CalmvAccordionState>(
            listener: (context, acc) async {
              if (acc.previousIndex != null && acc.previousIndex != acc.openedIndex) {
                FocusManager.instance.primaryFocus?.unfocus();
                await Future.delayed(const Duration(milliseconds: 50));

                switch (acc.previousIndex) {
                  case 0:
                    calmv1CrudBloc.add(ClaimmvPolisAutoSaveEvent()); // sesuaikan event
                    break;
                  case 1:
                    calmv2FormBloc.add(Calmv2AutoSaveEvent()); // contoh, sesuaikan
                    break;
                // case 2:
                //   calmv3FormBloc.add(Calmv3AutoSaveEvent()); // contoh, sesuaikan
                //   break;
                }
              }
            },
            builder: (context, acc) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: hPadding),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                      child: const FormSectionHeader(
                        iconPath: "assets/icons/kendaraan.svg",
                        title: "Kendaraan",
                        subtitle: "Isi detail kendaraan, pilih pertanggungan, dan hitung premi secara otomatis.",
                      ),
                    ),

                    const SizedBox(height: hPadding),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                      child: AccordionPage(
                        title: "Data Kendaraan",
                        isOpen: acc.openedIndex == 0,
                        onTap: () {
                          if (acc.openedIndex == 1) {
                            final calmv1State = context.read<Calmv1CrudBloc>().state;
                            if (!calmv1State.isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Data Pertanggungan belum valid#1")),
                              );
                              return; // tahan pindah
                            }
                          }
                          context.read<CalmvAccordionBloc>().add(CalmvaccordionToggleEvent(index: 0));
                        },
                        child: CalmvForm1Section2(
                          formKey: calmv1FormKey,
                        ),
                      ),
                    ),

                    const SizedBox(height: hPadding),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                      child: AccordionPage(
                        title: "Pertanggungan",
                        isOpen: acc.openedIndex == 1,
                        onTap: () {
                          if (acc.openedIndex == 0) {
                            final calmv1State = context.read<Calmv1CrudBloc>().state;
                            if (!calmv1State.isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Data Kendaraan belum valid")),
                              );
                              return; // tahan pindah
                            }
                          }

                          context.read<CalmvAccordionBloc>().add(const CalmvaccordionToggleEvent(index: 1));
                        },
                        child: CalmvForm2Section2(
                          formKey: calmv2FormKey,
                        ),
                      ),
                    ),

                    const SizedBox(height: hPadding),

                    buildButtonHitungPremi(),

                    const SizedBox(height: hPadding),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                      child: AccordionPage(
                        title: "Perhitung Premi",
                        isOpen: acc.openedIndex == 2,
                        onTap: () {}, // disabled manual tap
                        child: CalmvForm3Section2(
                          formKey: calmv3FormKey,
                        ),
                      ),
                    ),

                    const SizedBox(height: vPadding),

                    // tombol simpan manual sesuai index yang lagi open
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     height: 52,
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         switch (acc.openedIndex) {
                    //           case 0:
                    //             calmv1CrudBloc.add(ClaimmvPolisAutoSaveEvent());
                    //             break;
                    //           case 1:
                    //             calmv2FormBloc.add(Calmv2AutoSaveEvent());
                    //             break;
                    //           case 2:
                    //             calmv3FormBloc.add(Calmv3AutoSaveEvent());
                    //             break;
                    //         }
                    //       },
                    //       child: const Text("Simpan"),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  bool _guardBeforeOpen({
    required BuildContext context,
    required int targetIndex,
  }) {
    final calmv1CrudBloc = context.read<Calmv1CrudBloc>();
    final calmv2FormBloc = context.read<Calmv2FormBloc>();

    // target 1: butuh form1 lengkap + sudah punya calmv1Id
    if (targetIndex == 1) {
      final s1 = calmv1CrudBloc.state;

      if (!s1.isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Kendaraan belum lengkap")),
        );
        return false;
      }

      final id1 = s1.record?.calmv1Id ?? "";
      if (id1.isEmpty) {
        debugPrint("🚀 Form1 lengkap tapi belum ada ID → AUTOSAVE TRIGGERED");
        calmv1CrudBloc.add(ClaimmvPolisAutoSaveEvent());
        return false;
      }
    }

    if (targetIndex == 2) {
      // --- Form1: minimal lengkap + id ada (karena hitung premi perlu parent id)
      final s1 = calmv1CrudBloc.state;

      if (!s1.isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Kendaraan belum lengkap")),
        );
        return false;
      }

      final id1 = s1.record?.calmv1Id ?? "";
      if (id1.isEmpty) {
        debugPrint("🚀 Form1 lengkap tapi belum ada ID → AUTOSAVE TRIGGERED");
        calmv1CrudBloc.add(ClaimmvPolisAutoSaveEvent());
        return false;
      }

      // --- Form2: lengkap?
      final s2 = calmv2FormBloc.state;

      if (!s2.isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Pertanggungan belum lengkap#2")),
        );
        return false;
      }

      // --- Form2: sudah punya calmv2Id?
      final id2 = s2.record?.calmv2Id ?? "";
      if (id2.isEmpty) {
        debugPrint("🚀 Form2 lengkap tapi belum ada ID → AUTOSAVE TRIGGERED");
        calmv2FormBloc.add(Calmv2AutoSaveEvent());
        return false;
      }

      // kalau lolos semua -> boleh buka index 2 / hitung premi
    }

    return true;
  }

  Widget buildButtonHitungPremi() => Padding(
    padding: EdgeInsets.symmetric(horizontal: vPadding),
    child: AppButton.primary(
      text: "Hitung Premi",
      onPressed: () => onHitungPremi(context),
    ),
  );

  void onHitungPremi(BuildContext context) {
    final ok = _guardBeforeOpen(context: context, targetIndex: 2);
    if (!ok) return;

    final record = context.read<Calmv1CrudBloc>();
    final calmv1Id = record.state.record!.calmv1Id;
    if(calmv1Id.isNotEmpty){
      context.read<Calmv3FormBloc>().add(
        Calmv3FormHitungPremiEvent(calmv1Id: calmv1Id ?? ""),
      );
    }else{
      return;
    }

    context.read<CalmvAccordionBloc>().add(const CalmvaccordionToggleEvent(index: 2));
  }

}