
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../blocs/gen_calmv/calmv1list_bloc.dart';
import '../../../blocs/gen_calmv/calmvaccordion_bloc.dart';
import '../../../widgets/apptheme/accordion_page.dart';
import '../../../widgets/apptheme/header_card_polis.dart';
import '../../base/base_background_sidepage.dart';
import 'calmv/calmv_form1_remake2.dart';
import 'calmv/calmv_form2_remake2.dart';

class CalmvMainPageRemake2 extends StatefulWidget {

  const CalmvMainPageRemake2({
    super.key,
  });

  @override
  State<CalmvMainPageRemake2> createState() => _CalmvMainPageRemake2State();
}


class _CalmvMainPageRemake2State extends State<CalmvMainPageRemake2> {

  @override
  Widget build(BuildContext context) {
    var calmv1CrudBloc = BlocProvider.of<Calmv1CrudBloc>(context);
    var calmv2FormBloc = BlocProvider.of<Calmv2FormBloc>(context);
    var calmv3FormBloc = BlocProvider.of<Calmv2FormBloc>(context);
    var calmv1ListBloc = BlocProvider.of<Calmv1ListBloc>(context);

    return BaseBackgroundSidePage(
      title: "Kendaraan",
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        body: BlocConsumer<CalmvAccordionBloc, CalmvAccordionState>(
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
                  const SizedBox(height: hPadding * 1.5),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: const FormSectionHeader(
                      iconPath: "assets/icons/kendaraan.svg",
                      title: "Kendaraan",
                      subtitle: "Isi detail kendaraan, pilih pertanggungan, dan hitung premi secara otomatis.",
                    ),
                  ),

                  const SizedBox(height: hPadding * 1.5),

                  // ====== contoh accordion card 0 ======
                  AccordionPage(
                    title: "Data Kendaraan",
                    isOpen: acc.openedIndex == 0,
                    onTap: () => context
                        .read<CalmvAccordionBloc>()
                        .add(CalmvaccordionToggleEvent(index: 0)),
                    child: CalmvForm1Section2(),
                  ),

                  AccordionPage(
                    title: "Pertanggungan",
                    isOpen: acc.openedIndex == 1,
                    onTap: () => context
                        .read<CalmvAccordionBloc>()
                        .add(const CalmvaccordionToggleEvent(index: 1)),
                    child: CalmvForm2Section2(),
                  ),

                  AccordionPage(
                    title: "Hitung Premi",
                    isOpen: acc.openedIndex == 2,
                    onTap: () => context
                        .read<CalmvAccordionBloc>()
                        .add(const CalmvaccordionToggleEvent(index: 2)),
                    child: Container(),
                  ),

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}