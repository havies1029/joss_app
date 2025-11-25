import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'form1.dart';
import 'form2.dart';
import 'form3.dart';
import 'form4.dart';
import 'form5.dart';
import 'form6.dart';

class RegmvAllFormPage extends StatefulWidget {
  final String recordId;

  const RegmvAllFormPage({super.key, required this.recordId});

  @override
  State<RegmvAllFormPage> createState() => _RegmvAllFormPageState();
}

class _RegmvAllFormPageState extends State<RegmvAllFormPage> {
  String? _regmv1IdFromForm1;
  String? _regmv2IdFromForm2;
  String? _regmv3IdFromForm3;
  final GlobalKey<Regmv1CrudFormPageState> _form1Key = GlobalKey<Regmv1CrudFormPageState>();
  final GlobalKey<Regmv2FormFormPageState> _form2Key = GlobalKey<Regmv2FormFormPageState>();
  final GlobalKey<Regmv3FormFormPageState> _form3Key = GlobalKey<Regmv3FormFormPageState>(); // 🔥 key untuk Form 3
  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              color: secondaryBlackColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Accordion(
                    headerBackgroundColor: pGrey,
                    headerBackgroundColorOpened: pGrey,
                    contentBackgroundColor: pGrey,
                    scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding: const EdgeInsets.all(16),
                    maxOpenSections: 1,
                    paddingListTop: 0,
                    paddingListBottom: 0,
                    children: [
                      AccordionSection(
                        isOpen: true,
                        header: Text(
                          "Data Tertanggung",
                          style: bodyTextStyle(context),
                        ),
                        contentBorderColor: Colors.transparent,
                        onCloseSection: () {
                          debugPrint("🔥 [ACCORDION] Data Tertanggung closed - auto saving...");
                          _form1Key.currentState?.saveForm();
                        },
                        content: Regmv1CrudFormPage(
                          key: _form1Key,
                          viewMode: "tambah",
                          recordId: widget.recordId,
                          onRegmv1Created: (newId) {
                            debugPrint("🔥 [PARENT] ID baru dari Form1 = $newId");
                            setState(() => _regmv1IdFromForm1 = newId);
                          },
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        header: Text(
                          "Data Polis",
                          style: bodyTextStyle(context),
                        ),
                        contentBorderColor: Colors.transparent,
                        onCloseSection: () {
                          debugPrint(
                              "🔥 [ACCORDION] Data Polis closed - auto saving...");
                          _form2Key.currentState?.saveForm();
                        },
                        content: Regmv2FormFormPage(
                          key: _form2Key,
                          viewMode: "tambah",
                          recordId: _regmv2IdFromForm2 ?? "",
                          parentRegmv1Id: _regmv1IdFromForm1,
                          onRegmv2Created: (newId) {
                            debugPrint(
                                "🔥 [PARENT] ID baru dari Form2 = $newId");
                            setState(() => _regmv2IdFromForm2 = newId);
                          },
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        header: Text(
                          "Data Kendaraan",
                          style: bodyTextStyle(context),
                        ),
                        contentBorderColor: Colors.transparent,
                        onCloseSection: () {
                          debugPrint("🔥 [ACCORDION] Data Kendaraan closed - auto saving...");
                          _form3Key.currentState?.saveForm();
                        },
                        content: Regmv3FormFormPage(
                          key: _form3Key,
                          viewMode: "tambah",
                          recordId: _regmv3IdFromForm3 ?? "",
                          parentRegmv1Id: _regmv1IdFromForm1,
                          onRegmv3Created: (newId) {
                            debugPrint("🔥 [PARENT] ID baru dari Form3 = $newId");
                            setState(() => _regmv3IdFromForm3 = newId);
                          },
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        header: Text(
                          "Foto STNK",
                          style: bodyTextStyle(context),
                        ),
                        contentBorderColor: Colors.transparent,
                        content: Regmv4FormFormPage(
                          viewMode: "tambah",
                          recordId: "",
                          parentRegmv1Id: _regmv1IdFromForm1,
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        header: Text(
                          "Foto Mobil",
                          style: bodyTextStyle(context),
                        ),
                        contentBorderColor: Colors.transparent,
                        content: Regmv5FormFormPage(
                          viewMode: "tambah",
                          recordId: "",
                          parentRegmv1Id: _regmv1IdFromForm1,
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        header: Text(
                          "Perhitungan Premi",
                          style: bodyTextStyle(context),
                        ),
                        contentBorderColor: Colors.transparent,
                        content: Regmv6FormFormPage(
                          viewMode: "tambah",
                          recordId: "",
                          parentRegmv1Id: _regmv1IdFromForm1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}