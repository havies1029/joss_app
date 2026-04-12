import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/apptheme/custom_progress_bar.dart';
import 'package:joss_app/widgets/apptheme/header_card_polis.dart';

import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvaccordion_bloc.dart';

import 'package:joss_app/pages/perbaruiklaimmv/mobile/klaim5cari_list.dart';
import '../../../blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import '../../perbaruiklaimpar/mobile/perbaruisuccess_page.dart';
import '../../tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'klaimmvaccordioncard.dart';
import 'klaimmvklaimcrud_form.dart';
import 'klaimmvpoliscrud_form.dart';
import 'klaimmvstatuscari_list.dart';
import 'klaimmvbengkelcrud_form.dart';

class PerbaruiKlaimMvPageRemake extends StatefulWidget {
  final String cobGroupNama;
  final String klaim1Id;
  const PerbaruiKlaimMvPageRemake({super.key, required this.klaim1Id, required this.cobGroupNama});

  @override
  PerbaruiKlaimMvPageRemakeState createState() => PerbaruiKlaimMvPageRemakeState();
}

class PerbaruiKlaimMvPageRemakeState extends State<PerbaruiKlaimMvPageRemake> {
  late Klaim5cariBloc klaim5cariBloc;
  bool _isSubmittingPerbarui = false;

  bool _validatePolis(
      BuildContext context,
      GlobalKey<FormState> polisFormKey,
      GlobalKey<KlaimmvpoliscrudFormPageFormState> polisPageKey,
      ) {
    final isFormPolisValid = polisPageKey.currentState?.validateForm() ?? false;

    polisFormKey.currentState?.validate();

    if (!isFormPolisValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Data Polis belum valid"));
      return false;
    }

    final polisState = context.read<KlaimmvpoliscrudBloc>().state;
    if (!polisState.isValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Data Polis belum valid"));
      return false;
    }

    return true;
  }

  bool _validateKlaim(
      BuildContext context,
      GlobalKey<FormState> klaimFormKey,
      GlobalKey<KlaimmvklaimcrudFormPageFormState> klaimPageKey,
      ) {
    final isFormKlaimValid = klaimPageKey.currentState?.validateForm() ?? false;

    klaimFormKey.currentState?.validate();

    if (!isFormKlaimValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Data Klaim belum valid"));
      return false;
    }

    final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
    if (!klaimState.isValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Data Klaim belum valid"));
      return false;
    }

    return true;
  }

  bool _validateBengkel(
      BuildContext context,
      GlobalKey<FormState> bengkelFormKey,
      GlobalKey<KlaimmvbengkelcrudFormPageFormState> bengkelPageKey,
      ) {
    final isFormBengkelValid =
        bengkelPageKey.currentState?.validateForm() ?? false;

    bengkelFormKey.currentState?.validate();

    if (!isFormBengkelValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Data Bengkel belum valid"));
      return false;
    }

    final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;
    if (!bengkelState.isValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Data Bengkel belum valid"));
      return false;
    }

    return true;
  }

  void _openAccordion(BuildContext context, int index) {
    context.read<KlaimmvaccordionBloc>().add(
      KlaimmvaccordionToggleEvent(index: index),
    );
  }

  bool _validateDokumen(BuildContext context, {required bool isDokumenIncomplete}) {
    if (isDokumenIncomplete) {
      _openAccordion(context, 2);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar("Dokumen klaim belum lengkap"));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var klaimmvpoliscrudBloc = BlocProvider.of<KlaimmvpoliscrudBloc>(context);
    var klaimmvklaimcrudBloc = BlocProvider.of<KlaimmvklaimcrudBloc>(context);
    var klaimmvbengkelcrudBloc = BlocProvider.of<KlaimmvbengkelcrudBloc>(context);

    final polisFormKey = GlobalKey<FormState>();
    final klaimFormKey = GlobalKey<FormState>();
    final bengkelFormKey = GlobalKey<FormState>();

    final klaimPageKey = GlobalKey<KlaimmvklaimcrudFormPageFormState>();
    final bengkelPageKey = GlobalKey<KlaimmvbengkelcrudFormPageFormState>();
    final GlobalKey<KlaimmvpoliscrudFormPageFormState> polisPageKey =
    GlobalKey<KlaimmvpoliscrudFormPageFormState>();

    klaim5cariBloc = context.read<Klaim5cariBloc>();

    final dokumenState = context.watch<Klaim5cariBloc>().state;
    final isDokumenIncomplete = dokumenState.emptyDocumentIds.isNotEmpty;

    return MultiBlocListener(
      listeners: [
        BlocListener<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
          listenWhen: (prev, curr) =>
          prev.isSaved != curr.isSaved && curr.isSaved,
          listener: (context, state) {
            // if (!state.hasFailure && state.saveFrom == "button") {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (_) => PerbaruiSuksesWidget(
            //         display: "Berhasil!",
            //         description: "Data Klaim berhasil diperbarui.",
            //         displayButton: "Tutup",
            //         onButtonPressed: () {
            //           Navigator.of(context).pop();
            //           Navigator.of(context).pop();
            //         },
            //       ),
            //     ),
            //   );
            // }
          },
        ),
        BlocListener<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
          listenWhen: (prev, curr) =>
          prev.isSaved != curr.isSaved && curr.isSaved,
          listener: (context, state) {
            // if (!state.hasFailure && state.saveFrom == "button") {
            //
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (_) => PerbaruiSuksesWidget(
            //         display: "Berhasil!",
            //         description: "Data Klaim berhasil diperbarui.",
            //         displayButton: "Tutup",
            //         onButtonPressed: () {
            //           Navigator.of(context).pop();
            //           Navigator.of(context).pop();
            //         },
            //       ),
            //     ),
            //   );
            // }
          },
        ),
        BlocListener<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
          listenWhen: (prev, curr) =>
          prev.isSaved != curr.isSaved && curr.isSaved,
          listener: (context, state) {
            // if (!state.hasFailure && state.saveFrom == "button") {
            //
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (_) => PerbaruiSuksesWidget(
            //         display: "Berhasil!",
            //         description: "Data Klaim berhasil diperbarui.",
            //         displayButton: "Tutup",
            //         onButtonPressed: () {
            //           Navigator.of(context).pop();
            //           Navigator.of(context).pop();
            //         },
            //       ),
            //     ),
            //   );
            // }
          },
        ),
      ],
      child: BaseBackgroundSidePage(
        title: widget.cobGroupNama,
        child: Container(
          color: secondaryBlackColor,
          child: BlocConsumer<KlaimmvaccordionBloc, KlaimmvaccordionState>(
            builder: (context, acc) {
              return Column(
                children: [
                  const SizedBox(height: hPadding * 1.5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5,
                    ),
                    child: FormSectionHeader(
                      iconPath: "assets/icons/kendaraan.svg",
                      title: "Polis Kendaraan",
                      subtitle:
                      "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                    ),
                  ),
                  const SizedBox(height: hPadding * 1.5),
                  BlocBuilder<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
                    builder: (_, polis) =>
                        BlocBuilder<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
                          builder: (_, klaim) =>
                              BlocBuilder<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
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
                                        ),
                                      ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: hPadding * 1.5,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Klaimmvaccordioncard(
                                    title: 'Data Polis',
                                    isOpen: acc.openedIndex == 0,
                                    onTap: () {
                                      if (acc.openedIndex == 1) {
                                        if (!_validateKlaim(context, klaimFormKey,klaimPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 4) {
                                        if (!_validateBengkel(context, bengkelFormKey,bengkelPageKey)) {
                                          return;
                                        }
                                      }

                                      _openAccordion(context, 0);
                                    },
                                    child: KlaimmvpoliscrudFormPage(
                                      key: polisPageKey,
                                      recordId: widget.klaim1Id,
                                      viewMode: "ubah",
                                      formKey: polisFormKey,
                                    ),
                                  ),
                                  Klaimmvaccordioncard(
                                    title: 'Data Klaim',
                                    isOpen: acc.openedIndex == 1,
                                    onTap: () {
                                      if (acc.openedIndex == 0) {
                                        if (!_validatePolis(context, polisFormKey,polisPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 4) {
                                        if (!_validateBengkel(context, bengkelFormKey,bengkelPageKey)) {
                                          return;
                                        }
                                      }

                                      _openAccordion(context, 1);
                                    },
                                    child: KlaimmvklaimcrudFormPage(
                                      recordId: widget.klaim1Id,
                                      viewMode: "ubah",
                                      formKey: klaimFormKey,
                                      key: klaimPageKey,
                                    ),
                                  ),
                                  Klaimmvaccordioncard(
                                    title: 'Dokumen Klaim',
                                    isOpen: acc.openedIndex == 2,
                                    onTap: () {
                                      if (acc.openedIndex == 0) {
                                        if (!_validatePolis(context, polisFormKey,polisPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 1) {
                                        if (!_validateKlaim(context, klaimFormKey,klaimPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 4) {
                                        if (!_validateBengkel(context, bengkelFormKey,bengkelPageKey)) {
                                          return;
                                        }
                                      }

                                      if (!_validateDokumen(
                                        context,
                                        isDokumenIncomplete: isDokumenIncomplete,
                                      )) {
                                        return;
                                      }

                                      _openAccordion(context, 2);
                                    },
                                    child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
                                  ),
                                  Klaimmvaccordioncard(
                                    title: 'Kesimpulan Status Klaim',
                                    isOpen: acc.openedIndex == 3,
                                    onTap: () {
                                      if (acc.openedIndex == 0) {
                                        if (!_validatePolis(context, polisFormKey,polisPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 1) {
                                        if (!_validateKlaim(context, klaimFormKey, klaimPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 4) {
                                        if (!_validateBengkel(context, bengkelFormKey, bengkelPageKey)) {
                                          return;
                                        }
                                      }

                                      _openAccordion(context, 3);
                                    },
                                    child: KlaimmvstatuscariPage(
                                      klaim1Id: widget.klaim1Id,
                                    ),
                                  ),
                                  Klaimmvaccordioncard(
                                    title: 'Bengkel yang dipilih',
                                    isOpen: acc.openedIndex == 4,
                                    onTap: () {
                                      if (acc.openedIndex == 0) {
                                        if (!_validatePolis(context, polisFormKey,polisPageKey)) {
                                          return;
                                        }
                                      }

                                      if (acc.openedIndex == 1) {
                                        if (!_validateKlaim(context, klaimFormKey,klaimPageKey)) {
                                          return;
                                        }
                                      }

                                      _openAccordion(context, 4);
                                    },
                                    child: KlaimmvbengkelcrudFormPage(
                                      recordId: widget.klaim1Id,
                                      viewMode: "ubah",
                                      formKey: bengkelFormKey,
                                      key: bengkelPageKey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppButton.primary(
                            onPressed: _isSubmittingPerbarui
                                ? null
                                : () async {
                              setState(() {
                                _isSubmittingPerbarui = true;
                              });

                              try {
                                switch (acc.openedIndex) {
                                  case 0:
                                    klaimmvpoliscrudBloc.add(
                                      KlaimmvPolisAutoSaveEvent(saveFrom: "accordion"),
                                    );
                                    break;
                                  case 1:
                                    klaimmvklaimcrudBloc.add(
                                      KlaimmvklaimAutoSaveEvent(saveFrom: "accordion"),
                                    );
                                    break;
                                  case 4:
                                    klaimmvbengkelcrudBloc.add(
                                      KlaimmvbengkelAutoSaveEvent(saveFrom: "accordion"),
                                    );
                                    break;
                                }
                                final isFormKlaimValid =
                                    klaimPageKey.currentState?.validateForm() ?? false;

                                klaimFormKey.currentState?.validate();

                                if (!isFormKlaimValid) {
                                  _openAccordion(context, 1);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(successSnackBar("Data Klaim belum valid"));
                                  return;
                                }

                                final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
                                if (!klaimState.isValid) {
                                  _openAccordion(context, 1);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(successSnackBar("Data Klaim belum valid"));
                                  return;
                                }

                                final isFormBengkelValid =
                                    bengkelPageKey.currentState?.validateForm() ?? false;

                                bengkelFormKey.currentState?.validate();

                                if (!isFormBengkelValid) {
                                  _openAccordion(context, 4);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(successSnackBar("Data Bengkel belum valid"));
                                  return;
                                }

                                final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;
                                if (!bengkelState.isValid) {
                                  _openAccordion(context, 4);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(successSnackBar("Data Bengkel belum valid"));
                                  return;
                                }

                                if (!mounted) return;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PerbaruiSuccessPage(
                                      display: "Klaim Berhasil Diperbarui",
                                      description: "Data klaim telah berhasil diperbarui.",
                                      displayButton: "Kembali",
                                    ),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isSubmittingPerbarui = false;
                                  });
                                }
                              }
                            },
                            text: 'Perbarui',
                            isLoading: _isSubmittingPerbarui,
                            backgroundColor:
                            _isSubmittingPerbarui ? secondaryBlackColor : primaryColor,
                            textStyle: headingStyle(context, fontSize: getResponsiveFont(context, 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            listener: (BuildContext context, KlaimmvaccordionState state) async {
              if (state.previousIndex != null &&
                  state.previousIndex != state.openedIndex) {
                FocusManager.instance.primaryFocus?.unfocus();
                await Future.delayed(const Duration(milliseconds: 50));

                switch (state.previousIndex) {
                  case 0:
                    klaimmvpoliscrudBloc.add(
                      KlaimmvPolisAutoSaveEvent(saveFrom: "accordion"),
                    );
                    break;
                  case 1:
                    klaimmvklaimcrudBloc.add(
                      KlaimmvklaimAutoSaveEvent(saveFrom: "accordion"),
                    );
                    break;
                  case 4:
                    klaimmvbengkelcrudBloc.add(
                      KlaimmvbengkelAutoSaveEvent(saveFrom: "accordion"),
                    );
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