import 'package:joss_app/pages/simulmv/simulmvcrud_form_casco.dart';
import 'package:joss_app/pages/simulmv/simulmvcrud_form_opsi.dart';
import 'package:joss_app/pages/simulmv/simulmvcrud_form_premi.dart';
import 'package:joss_app/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class SimulmvCrudFormV2Page extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvCrudFormV2Page(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulmvCrudFormPageFormV2State createState() =>
      SimulmvCrudFormPageFormV2State();
}

class SimulmvCrudFormPageFormV2State extends State<SimulmvCrudFormV2Page> {
  @override
  Widget build(BuildContext context) {
    return Accordion(
        headerBorderColor: Colors.blueGrey,
        headerBorderColorOpened: Colors.transparent,
        // headerBorderWidth: 1,
        headerBackgroundColorOpened: Colors.green,
        contentBackgroundColor: Colors.white,
        contentBorderColor: Colors.green,
        contentBorderWidth: 3,
        contentHorizontalPadding: 5,
        scaleWhenAnimating: true,
        openAndCloseAnimation: true,
        headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        children: [
          AccordionSection(
            isOpen: true,
            contentHorizontalPadding: 15,
            contentVerticalPadding: 15,
            leftIcon:
                const Icon(Icons.car_crash, color: Colors.white),
            header: Text('Informasi Kendaraan', style: MyText.headerStyle()),
            content: SimulmvCrudFormCascoPage(viewMode: widget.viewMode, recordId: widget.recordId)
          ),
          AccordionSection(
            isOpen: true,
            contentHorizontalPadding: 15,
            contentVerticalPadding: 15,
            leftIcon:
                const Icon(Icons.checklist, color: Colors.white),
            header: Text('Cover Tambahan', style: MyText.headerStyle()),
            content: SimulmvCrudFormOpsiPage(viewMode: widget.viewMode, recordId: widget.recordId)
          ),
          AccordionSection(
            isOpen: true,
            contentHorizontalPadding: 15,
            contentVerticalPadding: 15,
            leftIcon:
                const Icon(Icons.calculate, color: Colors.white),
            header: Text('Perhitungan Premi', style: MyText.headerStyle()),
            content: SimulmvCrudFormPremiPage(viewMode: widget.viewMode, recordId: widget.recordId)
          ),
        ]);
  }
}
