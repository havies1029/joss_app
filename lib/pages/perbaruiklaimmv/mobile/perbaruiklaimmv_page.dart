import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvaccordion_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/apptheme/custom_progress_bar.dart';
import 'package:joss_app/widgets/apptheme/header_card_polis.dart';

// import 'klaim5cari_list.dart';
import '../../../blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import '../../perbaruiklaimpar/mobile/perbaruisuccess_page.dart';
import 'klaim5cari_list.dart';
import 'klaimmvaccordioncard.dart';
import 'klaimmvbengkelcrud_form.dart';
import 'klaimmvklaimcrud_form.dart';
import 'klaimmvpoliscrud_form.dart';
import 'klaimmvstatuscari_list.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';

class PerbaruiKlaimMvPage extends StatefulWidget {
  final String cobGroupNama;
  final String klaim1Id;
  final String cobGroupId;
  const PerbaruiKlaimMvPage({super.key, required this.klaim1Id, required this.cobGroupNama, required this.cobGroupId});

  @override
  PerbaruiKlaimMvPageState createState() => PerbaruiKlaimMvPageState();
}

class PerbaruiKlaimMvPageState extends State<PerbaruiKlaimMvPage> {

  bool _submitInProgress = false;
  bool _successShown = false;

  final GlobalKey<FormState> polisFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> klaimFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> bengkelFormKey = GlobalKey<FormState>();

  final GlobalKey<KlaimmvpoliscrudFormPageFormState> polisPageKey =
  GlobalKey<KlaimmvpoliscrudFormPageFormState>();

  final GlobalKey<KlaimmvklaimcrudFormPageFormState> klaimPageKey =
  GlobalKey<KlaimmvklaimcrudFormPageFormState>();

  final GlobalKey<KlaimmvbengkelcrudFormPageFormState> bengkelPageKey =
  GlobalKey<KlaimmvbengkelcrudFormPageFormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KlaimmvpoliscrudBloc>().add(
        KlaimmvpoliscrudLihatEvent(recordId: widget.klaim1Id),
      );

      context.read<KlaimmvklaimcrudBloc>().add(
        KlaimmvklaimcrudLihatEvent(recordId: widget.klaim1Id),
      );

      context.read<KlaimmvbengkelcrudBloc>().add(
        KlaimmvbengkelcrudLihatEvent(recordId: widget.klaim1Id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var klaimmvpoliscrudBloc = BlocProvider.of<KlaimmvpoliscrudBloc>(context);
    var klaimmvklaimcrudBloc = BlocProvider.of<KlaimmvklaimcrudBloc>(context);
    var klaimmvbengkelcrudBloc = BlocProvider.of<KlaimmvbengkelcrudBloc>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
          listener: (context, state) {
            if (_submitInProgress && state.hasFailure) {
              _submitInProgress = false;
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Gagal menyimpan Data Polis"),
              );
              return;
            }
            _checkSubmitCompleted(context);
          },
        ),

        BlocListener<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
          listener: (context, state) {
            if (_submitInProgress && state.hasFailure) {
              _submitInProgress = false;
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Gagal menyimpan Data Klaim"),
              );
              return;
            }
            _checkSubmitCompleted(context);
          },
        ),

        BlocListener<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
          listener: (context, state) {
            if (_submitInProgress && state.hasFailure) {
              _submitInProgress = false;
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Gagal menyimpan Data Bengkel"),
              );
              return;
            }
            _checkSubmitCompleted(context);
          },
        ),
      ],
      child: BaseBackgroundSidePage(
        title: widget.cobGroupNama,
        child: Container(
          color: secondaryBlackColor,
          padding: EdgeInsets.symmetric(
              horizontal: hPadding * 1.5),
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
                                context.read<KlaimmvaccordionBloc>().add(
                                  KlaimmvaccordionToggleEvent(index: 0),
                                );
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
                                context.read<KlaimmvaccordionBloc>().add(
                                  KlaimmvaccordionToggleEvent(index: 1),
                                );
                              },
                              child: KlaimmvklaimcrudFormPage(
                                cobGroupId: widget.cobGroupId,
                                key: klaimPageKey,
                                recordId: widget.klaim1Id,
                                viewMode: "ubah",
                                formKey: klaimFormKey,
                              ),
                            ),
                            Klaimmvaccordioncard(
                              title: 'Dokumen Klaim',
                              isOpen: acc.openedIndex == 2,
                              onTap: () {
                                context.read<KlaimmvaccordionBloc>().add(
                                  KlaimmvaccordionToggleEvent(index: 2),
                                );
                              },
                              child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
                            ),
                            Klaimmvaccordioncard(
                              title: 'Kesimpulan Status Klaim',
                              isOpen: acc.openedIndex == 3,
                              onTap: () {
                                context.read<KlaimmvaccordionBloc>().add(
                                  KlaimmvaccordionToggleEvent(index: 3),
                                );
                              },
                              child:
                              KlaimmvstatuscariPage(klaim1Id: widget.klaim1Id),
                            ),
                            Klaimmvaccordioncard(
                              title: 'Bengkel yang dipilih',
                              isOpen: acc.openedIndex == 4,
                              onTap: () {
                                context.read<KlaimmvaccordionBloc>().add(
                                  KlaimmvaccordionToggleEvent(index: 4),
                                );
                              },
                              child: KlaimmvbengkelcrudFormPage(
                                key: bengkelPageKey,
                                recordId: widget.klaim1Id,
                                viewMode: "ubah",
                                formKey: bengkelFormKey,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    AppButton.primary(
                      onPressed: () async {
                        if (_submitInProgress) return;

                        debugPrint('=== BUTTON PERBARUI CLICKED ===');

                        FocusManager.instance.primaryFocus?.unfocus();
                        await Future.delayed(const Duration(milliseconds: 50));

                        if (!mounted) return;

                        setState(() {
                          _submitInProgress = true;
                          _successShown = false;
                        });

                        context.read<KlaimmvpoliscrudBloc>().add(
                          KlaimmvPolisAutoSaveEvent(saveFrom: "button"),
                        );

                        context.read<KlaimmvklaimcrudBloc>().add(
                          KlaimmvklaimAutoSaveEvent(saveFrom: "button"),
                        );

                        context.read<KlaimmvbengkelcrudBloc>().add(
                          KlaimmvbengkelAutoSaveEvent(saveFrom: "button"),
                        );

                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          _checkSubmitCompleted(context);
                        });
                      },
                      text: 'Perbarui',
                      textStyle: headingStyle(context, fontSize: 18),
                    ),
                  ],
                );
              },
              listener: (BuildContext context, KlaimmvaccordionState state) async {
                if (state.previousIndex == null ||
                    state.previousIndex == state.openedIndex) {
                  return;
                }

                FocusManager.instance.primaryFocus?.unfocus();
                await Future.delayed(const Duration(milliseconds: 50));

                switch (state.previousIndex) {
                  case 0:
                    final polisState = klaimmvpoliscrudBloc.state;
                    if (polisState.isDirty) {
                      klaimmvpoliscrudBloc.add(
                        KlaimmvPolisAutoSaveEvent(saveFrom: "accordion"),
                      );
                    }
                    break;

                  case 1:
                    final klaimState = klaimmvklaimcrudBloc.state;
                    if (klaimState.isDirty) {
                      klaimmvklaimcrudBloc.add(
                        KlaimmvklaimAutoSaveEvent(saveFrom: "accordion"),
                      );
                    }
                    break;

                  case 4:
                    final bengkelState = klaimmvbengkelcrudBloc.state;
                    if (bengkelState.isDirty) {
                      klaimmvbengkelcrudBloc.add(
                        KlaimmvbengkelAutoSaveEvent(saveFrom: "accordion"),
                      );
                    }
                    break;
                }
              }
          ),
        ),
      ),
    );
  }
  void _checkSubmitCompleted(BuildContext context) {
    if (!_submitInProgress || _successShown) return;

    final polisState = context.read<KlaimmvpoliscrudBloc>().state;
    final klaimState = context.read<KlaimmvklaimcrudBloc>().state;
    final bengkelState = context.read<KlaimmvbengkelcrudBloc>().state;

    debugPrint("===== CHECK SUBMIT =====");
    debugPrint("POLIS   saving:${polisState.isSaving}, dirty:${polisState.isDirty}, failure:${polisState.hasFailure}");
    debugPrint("KLAIM   saving:${klaimState.isSaving}, dirty:${klaimState.isDirty}, failure:${klaimState.hasFailure}, recordNull:${klaimState.record == null}");
    debugPrint("BENGKEL saving:${bengkelState.isSaving}, dirty:${bengkelState.isDirty}, failure:${bengkelState.hasFailure}");
    debugPrint("========================");

    final allDone =
        !polisState.isSaving &&
            !klaimState.isSaving &&
            !bengkelState.isSaving &&
            !polisState.isDirty &&
            !klaimState.isDirty &&
            !bengkelState.isDirty &&
            !polisState.hasFailure &&
            !bengkelState.hasFailure &&
            !(klaimState.hasFailure && klaimState.isDirty);

    if (!allDone) return;

    _successShown = true;
    _submitInProgress = false;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PerbaruiSuccessPage(
          display: "Klaim Berhasil Diperbarui",
          description: "Data klaim telah berhasil diperbarui.",
          displayButton: "Kembali",
          onButtonPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const KlaimMainPage(),
              ),
                  (route) => route.isFirst,
            );
          },
        ),
      ),
    );
  }
}