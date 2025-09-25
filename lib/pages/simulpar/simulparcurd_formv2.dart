import 'package:joss_app/pages/simulpar/simulparcrud_form_bangunan.dart';
import 'package:joss_app/pages/simulpar/simulparcrud_form_premi.dart';
import 'package:joss_app/pages/simulpar/simulparcrud_form_coverv2.dart';
import 'package:joss_app/pages/simulpar/simulparcrud_form_si.dart';
import 'package:joss_app/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class SimulparCrudFormV2Page extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparCrudFormV2Page(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparCrudFormPageFormV2State createState() =>
      SimulparCrudFormPageFormV2State();
}

class SimulparCrudFormPageFormV2State extends State<SimulparCrudFormV2Page> {
  

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
                const Icon(Icons.factory, color: Colors.white),
            header: Text('Informasi Bangunan', style: MyText.headerStyle()),
            content: SimulparCrudFormBangunanPage(viewMode: widget.viewMode, recordId: widget.recordId,)
          ),
          AccordionSection(
            isOpen: true,
            contentHorizontalPadding: 15,
            contentVerticalPadding: 15,
            leftIcon:
                const Icon(Icons.money, color: Colors.white),
            header: Text('Sum Insured', style: MyText.headerStyle()),
            content: SimulparCrudFormSumInsuredPage(viewMode: widget.viewMode, recordId: widget.recordId,)
          ),
          AccordionSection(
            isOpen: true,
            contentHorizontalPadding: 15,
            contentVerticalPadding: 15,
            leftIcon:
                const Icon(Icons.security, color: Colors.white),
            header: Text('Rate', style: MyText.headerStyle()),
            content: SimulparCrudFormCoverV2Page(viewMode: widget.viewMode, recordId: widget.recordId,)
          ),
          AccordionSection(
            isOpen: true,
            contentHorizontalPadding: 5,
            contentVerticalPadding: 5,
            leftIcon:
                const Icon(Icons.calculate, color: Colors.white),
            header: Text('Perhitungan Premi', style: MyText.headerStyle()),
            content: SimulparCrudFormPremiPage(viewMode: widget.viewMode, recordId: widget.recordId,)
          ),
        ]);
  }
}
