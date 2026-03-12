import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparaccordion_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/apptheme/custom_progress_bar.dart';
import 'package:joss_app/widgets/apptheme/header_card_polis.dart';

import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';
import '../../perbaruiklaimmv/mobile/klaim5cari_list.dart';
import '../../tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'klaimparaccordioncard.dart';
import 'klaimparklaimcrud_form.dart';

class PerbaruiKlaimParPage extends StatefulWidget {
  final String cobGroupId;
  final String cobGroupNama;
  final String klaim1Id;
  const PerbaruiKlaimParPage(
      {super.key,
      required this.klaim1Id,
      required this.cobGroupId,
      required this.cobGroupNama});

  @override
  PerbaruiKlaimParPageState createState() => PerbaruiKlaimParPageState();
}

class PerbaruiKlaimParPageState extends State<PerbaruiKlaimParPage> {
  @override
  Widget build(BuildContext context) {
    var klaimparklaimcrudBloc = BlocProvider.of<KlaimparklaimcrudBloc>(context);
    final iconPath =
        "assets/icons/${widget.cobGroupNama.toLowerCase().replaceAll(' ', '')}.svg";
    return BaseBackgroundSidePage(
      title: widget.cobGroupNama,
      child: Container(
        color: secondaryBlackColor,
        padding: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 10),
        child: BlocConsumer<KlaimparaccordionBloc, KlaimparaccordionState>(
          builder: (context, acc) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: hPadding * 1.5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: FormSectionHeader(
                      iconPath: iconPath,
                      title: "Polis ${widget.cobGroupNama}",
                      subtitle:
                          "Sebelum lanjut x, pastikan data kamu sudah lengkap, ya!",
                    ),
                  ),
                  const SizedBox(height: hPadding * 1.5),
                  BlocBuilder<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
                    builder: (_, klaim) =>
                        BlocBuilder<Klaim5cariBloc, Klaim5cariState>(
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
                            )),
                            const SizedBox(width: 12),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: hPadding * 1.5),
                  Klaimparaccordioncard(
                    title: 'Data Klaim',
                    isOpen: acc.openedIndex == 0,
                    onTap: () => context
                        .read<KlaimparaccordionBloc>()
                        .add(KlaimparaccordionToggleEvent(index: 0)),
                    child: KlaimparklaimcrudFormPage(
                        recordId: widget.klaim1Id,
                        viewMode: "ubah",
                        cobGroupId: widget.cobGroupId),
                  ),
                  Klaimparaccordioncard(
                    title: 'Dokumen Klaim',
                    isOpen: acc.openedIndex == 1,
                    onTap: () => context
                        .read<KlaimparaccordionBloc>()
                        .add(KlaimparaccordionToggleEvent(index: 1)),
                    child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
                  ),
                  const SizedBox(height: 24),
                  AppButton.primary(
                    onPressed: () {
                      debugPrint('=== BUTTON PERBARUI CLICKED ===');
                      debugPrint('openedIndex: ${acc.openedIndex}');

                      switch (acc.openedIndex) {
                        case 0:
                          debugPrint('trigger -> save klaim par from button');
                          klaimparklaimcrudBloc.add(
                            KlaimparklaimcrudAutoSaveEvent(),
                          );
                          break;

                        case 1:
                          debugPrint('trigger -> final check before finish');

                          final klaimState = context.read<KlaimparklaimcrudBloc>().state;
                          final dokState = context.read<Klaim5cariBloc>().state;

                          final hasValidDoc = dokState.items.any(
                                (x) => x.fileUrl!.isNotEmpty || x.fileName!.isNotEmpty,
                          );

                          final allDone =
                              !klaimState.isDirty &&
                                  !klaimState.hasFailure &&
                                  hasValidDoc;

                          debugPrint('klaimState.isDirty: ${klaimState.isDirty}');
                          debugPrint('klaimState.hasFailure: ${klaimState.hasFailure}');
                          debugPrint('dok items count: ${dokState.items.length}');
                          debugPrint('hasValidDoc: $hasValidDoc');
                          debugPrint('allDone: $allDone');

                          if (allDone) {
                            debugPrint('SEMUA STEP SUDAH SELESAI -> lanjut');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentSuccess(
                                  display: "Klaim Berhasil Diperbarui",
                                  description: "Data klaim telah berhasil diperbarui.",
                                  displayButton: "Kembali",
                                  onButtonPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => KlaimMainPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            debugPrint('BELUM SEMUA DATA LENGKAP');

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dokumen klaim belum lengkap'),
                              ),
                            );
                          }
                          break;

                        default:
                          debugPrint(
                            'trigger -> tidak ada handler untuk openedIndex: ${acc.openedIndex}',
                          );
                      }

                      debugPrint('=== BUTTON PERBARUI END ===');
                    },
                    text: 'Perbarui',
                    textStyle: headingStyle(context, fontSize: 18),
                  ),
                ],
              ),
            );
          },
          listener: (BuildContext context, KlaimparaccordionState state) async {
            debugPrint('=== ACCORDION LISTENER TRIGGERED ===');
            debugPrint('previousIndex: ${state.previousIndex}');
            debugPrint('openedIndex: ${state.openedIndex}');

            if (state.previousIndex != null &&
                state.previousIndex != state.openedIndex) {

              debugPrint('accordion pindah section -> autosave previous section');

              FocusManager.instance.primaryFocus?.unfocus();
              debugPrint('focus unfocus done');

              await Future.delayed(const Duration(milliseconds: 50));
              debugPrint('delay selesai, cek previousIndex...');

              switch (state.previousIndex) {
                case 0:
                  debugPrint('trigger -> autosave klaim par from accordion');
                  klaimparklaimcrudBloc.add(
                    KlaimparklaimcrudAutoSaveEvent(),
                  );
                  break;

                default:
                  debugPrint(
                    'tidak ada autosave handler untuk previousIndex: ${state.previousIndex}',
                  );
              }
            } else {
              debugPrint('accordion listener lewat, tapi tidak ada perpindahan section');
            }

            debugPrint('=== ACCORDION LISTENER END ===');
          },
        ),
      ),
    );
  }
}
