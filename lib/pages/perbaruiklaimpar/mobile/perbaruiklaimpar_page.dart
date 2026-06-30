import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparaccordion_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/apptheme/custom_progress_bar.dart';
import 'package:joss_app/widgets/apptheme/header_card_polis.dart';

import '../../perbaruiklaimmv/mobile/klaim5cari_list.dart';
import 'perbaruisuccess_page.dart';
import 'klaimparaccordioncard.dart';
import 'klaimparklaimcrud_form.dart';

class PerbaruiKlaimParPage extends StatefulWidget {
  final String cobGroupId;
  final String cobGroupNama;
  final String klaim1Id;

  const PerbaruiKlaimParPage({
    super.key,
    required this.klaim1Id,
    required this.cobGroupId,
    required this.cobGroupNama,
  });

  @override
  PerbaruiKlaimParPageState createState() => PerbaruiKlaimParPageState();
}

class PerbaruiKlaimParPageState extends State<PerbaruiKlaimParPage> {
  final GlobalKey<FormState> klaimFormKey = GlobalKey<FormState>();
  final GlobalKey<KlaimparklaimcrudFormPageFormState> klaimPageKey =
  GlobalKey<KlaimparklaimcrudFormPageFormState>();

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(errorSnackBar(message));
  }

  void _openAccordion(int index) {
    context.read<KlaimparaccordionBloc>().add(
      KlaimparaccordionToggleEvent(index: index),
    );
  }

  Future<void> _autoSaveSection(int? index) async {
    if (index == null) return;

    switch (index) {
      case 0:
        final klaimState = context.read<KlaimparklaimcrudBloc>().state;

        if (klaimState.isDirty) {
          context.read<KlaimparklaimcrudBloc>().add(
            KlaimparklaimcrudAutoSaveEvent(),
          );

          await Future.delayed(const Duration(milliseconds: 150));
        }
        break;

      default:
        break;
    }
  }

  Future<void> _handleAccordionTap(int index, KlaimparaccordionState acc) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await _autoSaveSection(acc.openedIndex);

    _openAccordion(index);
  }

  Future<void> _handlePerbarui(KlaimparaccordionState acc) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await _autoSaveSection(acc.openedIndex);
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    final klaimState = context.read<KlaimparklaimcrudBloc>().state;

    if (klaimState.hasFailure) {
      _openAccordion(0);
      _showMessage('Penyimpanan data klaim gagal');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PerbaruiSuccessPage(
          display: "Klaim Berhasil Diperbarui",
          description: "Data klaim telah berhasil diperbarui.",
          displayButton: "Kembali",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconPath =
        "assets/icons/${widget.cobGroupNama.toLowerCase().replaceAll(' ', '')}.svg";

    return BaseBackgroundSidePage(
      title: widget.cobGroupNama,
      child: Container(
        color: secondaryBlackColor,
        child: BlocConsumer<KlaimparaccordionBloc, KlaimparaccordionState>(
          listener: (context, state) async {
            if (state.previousIndex == null ||
                state.previousIndex == state.openedIndex) {
              return;
            }

            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 50));

            if (!mounted) return;

            await _autoSaveSection(state.previousIndex);
          },
          builder: (context, acc) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: hPadding * 1.5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: FormSectionHeader(
                      iconPath: iconPath,
                      title: "Klaim ${widget.cobGroupNama}",
                      subtitle:
                      "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                    ),
                  ),
                  const SizedBox(height: hPadding * 1.5),
                  BlocBuilder<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
                    builder: (_, klaim) {
                      return BlocBuilder<Klaim5cariBloc, Klaim5cariState>(
                        builder: (_, dok) {
                          for (int i = 0; i < dok.items.length; i++) {
                            final x = dok.items[i];
                          }

                          final done = [
                            klaim.isComplete,
                            dok.isComplete,
                          ].where((x) => x).length;

                          final totalStep = 2.0;
                          final progress = done / totalStep;

                          return Row(
                            children: [
                              Expanded(
                                child: CustomProgressBar(
                                  progress: progress,
                                  barColor: primaryColor,
                                  borderRadius: cardBorderRadius,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: Column(
                      children: [
                        const SizedBox(height: hPadding * 1.5),
                        Klaimparaccordioncard(
                          title: 'Data Klaim',
                          isOpen: acc.openedIndex == 0,
                          onTap: () => _handleAccordionTap(0, acc),
                          child: KlaimparklaimcrudFormPage(
                            key: klaimPageKey,
                            recordId: widget.klaim1Id,
                            viewMode: "ubah",
                            cobGroupId: widget.cobGroupId,
                            formKey: klaimFormKey,
                          ),
                        ),
                        Klaimparaccordioncard(
                          title: 'Dokumen Klaim',
                          isOpen: acc.openedIndex == 1,
                          onTap: () => _handleAccordionTap(1, acc),
                          child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
                          builder: (context, state) {
                            return AppButton.primary(
                              onPressed: state.isSaving
                                  ? null
                                  : () => _handlePerbarui(acc),
                              text: 'Perbarui',
                              isLoading: state.isSaving,
                              backgroundColor: state.isSaving
                                  ? secondaryBlackColor
                                  : primaryColor,
                              textStyle: headingStyle(
                                context,
                                fontSize: getResponsiveFont(context, 18),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}