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

  Future<bool> _autoSaveSection(int? index) async {
    if (index == null || index != 0) return true;

    switch (index) {
      case 0:
        final bloc = context.read<KlaimparklaimcrudBloc>();
        final record = klaimPageKey.currentState?.buildRecordForSave(
          validateAll: false,
        );

        if (record == null) {
          _openAccordion(0);
          _showMessage('Nomor telepon PIC belum valid');
          return false;
        }

        if (!bloc.state.isDirty) return true;

        final success = await bloc.saveRecord(record);
        if (!success) {
          _openAccordion(0);
          _showMessage('Penyimpanan data klaim gagal');
        }
        return success;

      default:
        return true;
    }
  }

  Future<void> _handleAccordionTap(
      int index, KlaimparaccordionState acc) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final saved = await _autoSaveSection(acc.openedIndex);
    if (!saved) return;

    _openAccordion(index);
  }

  Future<void> _handlePerbarui() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final record = klaimPageKey.currentState?.buildRecordForSave();
    if (record == null) {
      _openAccordion(0);
      _showMessage('Form data klaim belum valid');
      return;
    }

    final success =
        await context.read<KlaimparklaimcrudBloc>().saveRecord(record);

    if (!mounted) return;

    if (!success) {
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
          klaimMainInitialTab: 1,
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
        child: BlocBuilder<KlaimparaccordionBloc, KlaimparaccordionState>(
          builder: (context, acc) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: hPadding * 1.5),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
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
                          isLoading: context
                              .watch<KlaimparklaimcrudBloc>()
                              .state
                              .isLoading,
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
                        BlocBuilder<KlaimparklaimcrudBloc,
                            KlaimparklaimcrudState>(
                          builder: (context, state) {
                            return AppButton.primary(
                              onPressed:
                                  state.isSaving ? null : _handlePerbarui,
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
