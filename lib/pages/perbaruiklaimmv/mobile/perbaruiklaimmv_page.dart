import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvaccordion_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaim5cari_list.dart';
import 'package:joss_app/pages/perbaruiklaimmv/mobile/perbarui_sukses_widget.dart';
import 'package:joss_app/widgets/apptheme/custom_progress_bar.dart';
import 'package:joss_app/widgets/apptheme/header_card_polis.dart';

// import 'klaim5cari_list.dart';
import 'klaimmvaccordioncard.dart';
import 'klaimmvbengkelcrud_form.dart';
import 'klaimmvklaimcrud_form.dart';
import 'klaimmvpoliscrud_form.dart';
import 'klaimmvstatuscari_list.dart';

class PerbaruiKlaimMvPage extends StatefulWidget {
  final String cobGroupNama;
  final String klaim1Id;
  const PerbaruiKlaimMvPage({super.key, required this.klaim1Id, required this.cobGroupNama});

  @override
  PerbaruiKlaimMvPageState createState() => PerbaruiKlaimMvPageState();
}

class PerbaruiKlaimMvPageState extends State<PerbaruiKlaimMvPage> {

  @override
  Widget build(BuildContext context) {
    var klaimmvpoliscrudBloc = BlocProvider.of<KlaimmvpoliscrudBloc>(context);
    var klaimmvklaimcrudBloc = BlocProvider.of<KlaimmvklaimcrudBloc>(context);
    var klaimmvbengkelcrudBloc = BlocProvider.of<KlaimmvbengkelcrudBloc>(context);
    final polisFormKey = GlobalKey<FormState>();
    final klaimFormKey = GlobalKey<FormState>();
    final bengkelFormKey = GlobalKey<FormState>();

    return MultiBlocListener(
      listeners: [
        BlocListener<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(  
          listenWhen: (prev, curr) =>
            prev.isSaved != curr.isSaved && curr.isSaved, 
          listener: (context, state) {
            if (!state.hasFailure && state.saveFrom == "button") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PerbaruiSuksesWidget(
                      display: "Berhasil!",
                      description: "Data Klaim berhasil diperbarui.",
                      displayButton: "Tutup",
                      onButtonPressed: () {
                        Navigator.of(context).pop(); 
                        Navigator.of(context).pop(); 
                      },
                    ),
                  ),
                );
              }
          },
        ),
        BlocListener<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
          listenWhen: (prev, curr) =>
            prev.isSaved != curr.isSaved && curr.isSaved, 
          listener: (context, state) {
            if (!state.hasFailure && state.saveFrom == "button") {

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PerbaruiSuksesWidget(
                      display: "Berhasil!",
                      description: "Data Klaim berhasil diperbarui.",
                      displayButton: "Tutup",
                      onButtonPressed: () {
                        Navigator.of(context).pop(); 
                        Navigator.of(context).pop(); 
                      },
                    ),
                  ),
                );
              }
          },
        ),
        BlocListener<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
          listenWhen: (prev, curr) =>
            prev.isSaved != curr.isSaved && curr.isSaved, 
          listener: (context, state) {
            if (!state.hasFailure && state.saveFrom == "button") {

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PerbaruiSuksesWidget(
                      display: "Berhasil!",
                      description: "Data Klaim berhasil diperbarui.",
                      displayButton: "Tutup",
                      onButtonPressed: () {
                        Navigator.of(context).pop(); 
                        Navigator.of(context).pop(); 
                      },
                    ),
                  ),
                );
              }
          },
        ),
      ], 
      child: BaseBackgroundSidePage(
        title: widget.cobGroupNama,
        child: Container(
          color: secondaryBlackColor,
          padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 10),
          child: BlocConsumer<KlaimmvaccordionBloc, KlaimmvaccordionState>(
            builder: (context, acc) {
              return Column(
                children: [
                  const SizedBox(height: hPadding * 1.5),
      
                  FormSectionHeader(
                    iconPath: "assets/icons/kendaraan.svg",
                    title: "Polis Kendaraan",
                    subtitle:
                    "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                  ),
      
                  const SizedBox(height: hPadding * 1.5),
      
                  // progress (contoh: hitung completion dari tiap bloc)
                  BlocBuilder<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
                    builder: (_, polis) => BlocBuilder<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
                      builder: (_, klaim) => BlocBuilder<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
                        builder: (_, beng) {
                          final done = [
                            polis.isComplete,
                            klaim.isComplete,
                            beng.isComplete,
                          ].where((x) => x).length;
                          
                          final progress = done / 3.0;
                          
                          return Row(
                            children: [
                              Expanded(
                                  child: CustomProgressBar(
                                    progress: progress,
                                    barColor: primaryColor,
                                    borderRadius: cardBorderRadius,
                                  )),
                              // Expanded(child: LinearProgressIndicator(value: progress)),
                              // const SizedBox(width: 12),
                              // Text('${(progress * 100).round()}%'),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
      
                  const SizedBox(height: hPadding * 1.5),
      
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Klaimmvaccordioncard(
                            title: 'Data Polis',
                            isOpen: acc.openedIndex == 0,
                            onTap: () {
                              if (acc.openedIndex == 1) {
      
                                final isFormKlaimValid = klaimFormKey.currentState?.validate() ?? false;
                                if (!isFormKlaimValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
                                if (!klaimState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return;
                                }
                              }
      
                              if (acc.openedIndex == 4) {
      
                                final isFormBengkelValid = bengkelFormKey.currentState?.validate() ?? false;
                                if (!isFormBengkelValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;
                                if (!bengkelState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return;
                                }
                              }
      
                              context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 0));
                            },
                            child: KlaimmvpoliscrudFormPage(recordId: widget.klaim1Id, viewMode: "ubah", formKey: polisFormKey),
                          ),
                          Klaimmvaccordioncard(
                            title: 'Data Klaim',
                            isOpen: acc.openedIndex == 1,
                            onTap: () {
                              if (acc.openedIndex == 0) {
                                final isFormPolisValid = polisFormKey.currentState?.validate() ?? false;
                                if (!isFormPolisValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final polisState = context.read<KlaimmvpoliscrudBloc>().state;
                                if (!polisState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
                              }
      
      
                              if (acc.openedIndex == 4) {
      
                                final isFormBengkelValid = bengkelFormKey.currentState?.validate() ?? false;
                                if (!isFormBengkelValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;
                                if (!bengkelState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return;
                                }
                              }
      
                              context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 1));
                            },
                            child: KlaimmvklaimcrudFormPage(recordId:  widget.klaim1Id, viewMode: "ubah", formKey: klaimFormKey),
                          ),
                          Klaimmvaccordioncard(
                            title: 'Dokumen Klaim',
                            isOpen: acc.openedIndex == 2,
                            onTap: () {
      
                              if (acc.openedIndex == 0) {
                                final isFormPolisValid = polisFormKey.currentState?.validate() ?? false;
                                if (!isFormPolisValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final polisState = context.read<KlaimmvpoliscrudBloc>().state;
                                if (!polisState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindahv
                                }
                              }
      
                              if (acc.openedIndex == 1) {
      
                                final isFormKlaimValid = klaimFormKey.currentState?.validate() ?? false;
                                if (!isFormKlaimValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
                                if (!klaimState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return;
                                }
                              }
      
      
                              if (acc.openedIndex == 4) {
      
                                final isFormBengkelValid = bengkelFormKey.currentState?.validate() ?? false;
                                if (!isFormBengkelValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;
                                if (!bengkelState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return;
                                }
                              }
      
                              context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 2));
                            },
                            child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
                          ),
                          Klaimmvaccordioncard(
                            title: 'Kesimpulan Status Klaim',
                            isOpen: acc.openedIndex == 3,
                            onTap: () {
      
                              if (acc.openedIndex == 0) {
                                final isFormPolisValid = polisFormKey.currentState?.validate() ?? false;
                                if (!isFormPolisValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final polisState = context.read<KlaimmvpoliscrudBloc>().state;
                                if (!polisState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
                              }
      
                              if (acc.openedIndex == 1) {
      
                                final isFormKlaimValid = klaimFormKey.currentState?.validate() ?? false;
                                if (!isFormKlaimValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
                                if (!klaimState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return;
                                }
                              }
      
      
                              if (acc.openedIndex == 4) {
      
                                final isFormBengkelValid = bengkelFormKey.currentState?.validate() ?? false;
                                if (!isFormBengkelValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;
                                if (!bengkelState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Bengkel belum valid")),
                                  );
                                  return;
                                }
                              }
      
      
                              context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 3));
                            },
                            child:
                            KlaimmvstatuscariPage(klaim1Id: widget.klaim1Id),
                          ),
                          Klaimmvaccordioncard(
                            title: 'Bengkel yang dipilih',
                            isOpen: acc.openedIndex == 4,
                            onTap: () {
      
                              if (acc.openedIndex == 0) {
                                final isFormPolisValid = polisFormKey.currentState?.validate() ?? false;
                                if (!isFormPolisValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final polisState = context.read<KlaimmvpoliscrudBloc>().state;
                                if (!polisState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Polis belum valid")),
                                  );
                                  return; // tahan pindah
                                }
                              }
      
                              if (acc.openedIndex == 1) {
      
                                final isFormKlaimValid = klaimFormKey.currentState?.validate() ?? false;
                                if (!isFormKlaimValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return; // tahan pindah
                                }
      
                                final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
                                if (!klaimState.isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Data Klaim belum valid")),
                                  );
                                  return;
                                }
                              }
      
      
                              context
                                .read<KlaimmvaccordionBloc>()
                                .add(KlaimmvaccordionToggleEvent(index: 4));
                            },
                            child: KlaimmvbengkelcrudFormPage(recordId: widget.klaim1Id, viewMode: "ubah", formKey: bengkelFormKey),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
      
                  AppButton.primary(
                    onPressed: () {
                      switch(acc.openedIndex) {
                        case 0:
                          klaimmvpoliscrudBloc.add(KlaimmvPolisAutoSaveEvent(saveFrom: "button"));  
                          break;
                        case 1:
                          klaimmvklaimcrudBloc.add(KlaimmvklaimAutoSaveEvent(saveFrom: "button"));
                          break;
                        case 4:
                          klaimmvbengkelcrudBloc.add(KlaimmvbengkelAutoSaveEvent(saveFrom: "button"));
                          break;
                      }
                    },
                    text: 'Perbarui',
                    backgroundColor: pBlue,
                    textStyle: headingStyle(context, fontSize: 18),
                  ),
                ],
              );
            }, listener: (BuildContext context, KlaimmvaccordionState state) async {
            if (state.previousIndex != null &&
                state.previousIndex != state.openedIndex) {
      
              FocusManager.instance.primaryFocus?.unfocus();
              await Future.delayed(const Duration(milliseconds: 50));
      
              switch(state.previousIndex) {
                case 0:
                  klaimmvpoliscrudBloc.add(KlaimmvPolisAutoSaveEvent(saveFrom: "accordion"));
                  break;
                case 1:
                  klaimmvklaimcrudBloc.add(KlaimmvklaimAutoSaveEvent(saveFrom: "accordion"));
                  break;
                case 4:
                  klaimmvbengkelcrudBloc.add(KlaimmvbengkelAutoSaveEvent(saveFrom: "accordion"));
                  break;
              }
      
            }
          },
          ),
        ),
      ),
    );
  }
}