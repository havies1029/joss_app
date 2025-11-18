import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../blocs/gen_calmv/calmv1crud_bloc.dart';
import '../../blocs/gen_calmv/calmv2form_bloc.dart';
import '../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../base/base_background_sidepage.dart';
import 'calmv/calmv_form1.dart';
import 'calmv/calmv_form2.dart';
import 'calmv/calmv_form3.dart';

class CalmvFormMain extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const CalmvFormMain({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  State<CalmvFormMain> createState() => _CalmvFormMainState();
}


class _CalmvFormMainState extends State<CalmvFormMain> {
  List<bool> expanded = [true, false, false];

  final form1Key = GlobalKey<CalmvForm1SectionState>();
  final form2Key = GlobalKey<CalmvForm2SectionState>();
  final form3Key = GlobalKey<CalmvForm3SectionState>();

  String? calmv1Id;
  String? calmv2Id;
  Map<String, dynamic>? _form3Payload;

  String form1ViewMode = "tambah";
  String form2ViewMode = "tambah";

  bool isHitungPremiClicked = false;

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      blocListeners: [
        BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.calmv1Id;

              if (newId != null && newId.isNotEmpty) {
                debugPrint("🔥 [LISTENER] calmv1 saved → result ID = $newId");

                setState(() {
                  calmv1Id = newId;
                });

                if (form1ViewMode == "ubah"){
                  form1ViewMode = "tambah";
                  if (isHitungPremiClicked == true){
                    debugPrint("isHitungPremiClicked");
                    isHitungPremiClicked = false;
                    onHitungPremi();
                  }else {
                    simulateToggleForm2();
                  }
                }else {
                  simulateToggleForm2();
                }
              }
            }
          },
        ),

        BlocListener<Calmv2FormBloc, Calmv2FormState>(
          listener: (context, state) {
            if (state.isSaved && !state.hasFailure && state.record != null) {
              final newId = state.record!.calmv2Id;

              if (newId != null && newId.isNotEmpty) {
                debugPrint("🔥 [LISTENER] calmv2 saved → result ID = $newId");

                setState(() {
                  calmv2Id = newId;
                });

                if (form2ViewMode == "ubah"){
                  form2ViewMode = "tambah";
                  onHitungPremi();
                }else {
                  onHitungPremi();
                }


              }
            }
          },
        ),

        BlocListener<Calmv3FormBloc, Calmv3FormState>(
          listener: (context, state) {
            if (state.isLoaded && state.record != null) {
              final r = state.record!;

              debugPrint("🔥 [LISTENER FORM3] Premi diterima: ${r.toJson()}");

              final payload = {
                "subtotalPremi": r.premiSubtotal ?? 0,
                "diskonPremi": r.premiDiskon ?? 0,
                "netPremi": r.premiNet ?? 0,
              };

              // update UI form3
              if (form3Key.currentState != null) {
                form3Key.currentState!.injectPayload(payload);
              }

              openForm3();

              setState(() {
                _form3Payload = payload;
              });
            }
          },
        ),
      ],

      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(title: const Text("Kendaraan")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: secondaryBlackColor,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ------------------ FORM 1 ------------------
              buildForm1Section(),

              const SizedBox(height: hPadding * 1.5),

              // ------------------ FORM 2 ------------------
              buildForm2Section(),

              const SizedBox(height: hPadding * 1.5),

              buildButtonHitungPremi(),

              const SizedBox(height: hPadding * 1.5),

              // ------------------ FORM 3 ------------------
              CalmvForm3Section(
                key: form3Key,
                isExpanded: expanded[2],
                initialPayload: _form3Payload,
              ),

              const SizedBox(height: hPadding * 1.5),


              (_form3Payload == null)
                  ? const SizedBox.shrink()
                  : AppButton.primary(
                text: "Lanjutkan",
                onPressed: () async {
                  context.read<Calmv1CrudBloc>().add(
                    CalmvtoRegMvEvent(recordId: calmv1Id ?? ""),
                  );
                },
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  //========================= form1 =========================

  Widget buildForm1Section() => CalmvForm1Section(
    key: form1Key,
    viewMode: form1ViewMode,
    recordId: calmv1Id ?? "",
    isExpanded: expanded[0],
    onToggle: (value) => onToggleForm1(value),
  );

  Future<void> onToggleForm1(bool _) async {
    if (calmv1Id != null) {
      form1ViewMode = "ubah";
      debugPrint("🔥 Mode ubah aktif karena calmv1Id ada");
    } else {
      form1ViewMode = "tambah";
      debugPrint("🔥 Mode tambah aktif karena calmv1Id kosong");
    }
    openForm1();
  }

  Future<void> simulateToggleForm1() async {
    await onToggleForm1(true);
  }




  //========================= form2 =========================





  Widget buildForm2Section() {
    return CalmvForm2Section(
      key: form2Key,
      viewMode: form2ViewMode,
      calmv1Id: calmv1Id ?? "",
      calmv2Id: calmv2Id ?? "",
      isExpanded: expanded[1],
      onToggle: (value) => onToggleForm2(value),
    );
  }

  Future<void> onToggleForm2(bool _) async {
    final isValidForm1 = await form1Key.currentState?.validateAndReturn();
    if (calmv1Id != null) {
      form2ViewMode = "tambah";

      if (form1ViewMode == "ubah"){
        //update form`1
        await form1Key.currentState?.saveForm1();
      }else {
        debugPrint("🔥 Mode tambah aktif karena calmv1Id ada");
        if (calmv2Id != null){
          form2ViewMode = "ubah";
          debugPrint("🔥 Mode ubah aktif karena calmv2Id tidak kosong");
        }
        openForm2();
      }


    }else if (isValidForm1 == true) {
      await form1Key.currentState?.saveForm1();
    }
  }

  Future<void> simulateToggleForm2() async {
    await onToggleForm2(true);
  }




  //========================= hitung premi =========================




  Widget buildButtonHitungPremi() => AppButton.primary(
    text: "Hitung Premi",
    onPressed: onHitungPremi,
  );

  Future<void>  onHitungPremi() async {
    final isValidForm1 = await form1Key.currentState?.validateAndReturn();
    final isValidForm2 = await form2Key.currentState?.validateAndReturn();

    if (calmv1Id != null && calmv2Id != null){

      if (form1ViewMode == "ubah"){
        setState(() {
          isHitungPremiClicked = true;
        });
        await form1Key.currentState?.saveForm1();
      }else {
        if (form2ViewMode == "ubah"){
          await form2Key.currentState?.saveForm2();
        }else {
          context.read<Calmv3FormBloc>().add(
            Calmv3FormHitungPremiEvent(calmv1Id: calmv1Id ?? ""),
          );
        }
      }
    }
    else if (calmv1Id == null) {
      if (isValidForm1 == true){
        await form1Key.currentState?.saveForm1();
        openForm2();
      }else {
        openForm1();
      }
    }
    else if (calmv2Id == null) {
      if (isValidForm2 == true){
        await form2Key.currentState?.saveForm2();
      }
    }
  }







  void openForm1() {
    setState(() {
      expanded = [true, false, false];
    });
  }

  void openForm2() {
    setState(() {
      expanded = [false, true, false];
    });
  }

  void openForm3() {
    setState(() {
      expanded = [false, false, true];
    });
  }
}
