// lib/pages/calmv/calmv_form_main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';

import '../../blocs/gen_calmv/calmv1crud_bloc.dart';
import '../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../../blocs/reusable_connection_flow/flow_parent_cubit.dart';
import '../../blocs/reusable_connection_flow/flow_parent_state.dart';
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
  final List<String> errors = [];
  Key _formMainKey = UniqueKey();
  String? _savedCalmv1Id;

  final form1Key = GlobalKey<CalmvForm1SectionState>();
  final form2Key = GlobalKey<CalmvForm2SectionState>();
  final form3Key = GlobalKey<CalmvForm3SectionState>();

  void _resetAllForms() {
    setState(() {
      // reset kunci widget agar form rebuild ulang
      _formMainKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlowParentCubit(),
      child: BlocConsumer<FlowParentCubit, FlowParentState>(
        listenWhen: (prev, curr) => prev.uiEvent != curr.uiEvent,
        listener: (context, state) {
          final event = state.uiEvent;

          // VALIDATE REQUEST
          if (event.type == FlowUiEventType.validateStep &&
              event.stepIndex != null) {
            if (event.stepIndex == 0) form1Key.currentState?.validateSelf();
            if (event.stepIndex == 1) form2Key.currentState?.validateSelf();
          }

          // SAVE REQUEST
          if (event.type == FlowUiEventType.saveStep &&
              event.stepIndex != null) {
            if (event.stepIndex == 0) form1Key.currentState?.saveSelf();
            if (event.stepIndex == 1) form2Key.currentState?.saveSelf();
          }

          // ACTIVATE STEP
          if (event.type == FlowUiEventType.activateStep &&
              event.stepIndex != null) {

          final id = state.steps[0].id;
          if (id != null && id.isNotEmpty) {
          _savedCalmv1Id = id;
          debugPrint("💾 [UI] calmv1Id DISIMPAN LOKAL = $_savedCalmv1Id");
          }

            switch (event.stepIndex) {
              case 0:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  form1Key.currentState?.activate();
                });
                break;

              case 1:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (state.steps[1].isActive) {
                    form2Key.currentState?.activate();
                  }
                });
                break;

              case 3:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  form3Key.currentState?.activate();

                  if (event.payload != null) {
                    form3Key.currentState?.injectPayload(event.payload!);
                  }

                });
                break;

            }
          }

          // FLOW COMPLETED → RESET
          if (event.type == FlowUiEventType.flowCompleted) {
            _resetAllForms();
          }
        },
        builder: (context, state) {
          final cubit = context.read<FlowParentCubit>();

          final form1Active = state.steps[0].isActive;
          final form2Active = state.steps[1].isActive;
          final buttonActive = state.steps[2].isActive;
          final form3Active = state.steps[3].isActive;

          return Scaffold(
            key: _formMainKey,
            appBar: AppBar(title: const Text("Kendaraan")),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                color: secondaryBlackColor,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= FORM 1 =================
                    CalmvForm1Section(
                      key: form1Key,
                      viewMode: widget.viewMode,
                      recordId: widget.recordId,
                      isExpanded: form1Active,
                      onToggle: (_) {
                        cubit.requestOpenStep(0);
                      },
                    ),
                    const SizedBox(height: 12),

                    // ================= FORM 2 =================
                    CalmvForm2Section(
                      key: form2Key,
                      viewMode: widget.viewMode,
                      calmv1Id: state.steps[0].id ?? widget.recordId,
                      isExpanded: form2Active,
                      onToggle: (_) {
                        cubit.requestOpenStep(1);
                      },
                    ),
                    const SizedBox(height: 12),

                    // ================= TOMBOL HITUNG PREMI =================
                    if (buttonActive)
                      AppButton.primary(
                        text: "Hitung Premi",
                        onPressed: () async {
                          debugPrint("🔥 [UI] ==== BUTTON HITUNG PREMI DIKLIK ====");
                          debugPrint("🔥 [UI] currentActiveIndex = ${cubit.state.currentActiveIndex}");
                          debugPrint("🔥 [UI] step[0] ID (calmv1) = ${cubit.state.steps[0].id}");
                          debugPrint("🔥 [UI] step[1] ID (calmv2) = ${cubit.state.steps[1].id}");

                          final calmv1Id = _savedCalmv1Id ?? cubit.state.steps[0].id;


                          if (calmv1Id == null || calmv1Id.isEmpty) {
                            debugPrint("❌ [UI] Tidak bisa hitung premi — calmv1Id kosong");
                            return;
                          }

                          // 👉 PANGGIL API HARI INI YA INI YG PENTING
                          context.read<Calmv3FormBloc>().add(
                            Calmv3FormHitungPremiEvent(calmv1Id: calmv1Id),
                          );

                          debugPrint("🚀 [UI] Event HitungPremi dikirim dengan calmv1Id=$calmv1Id");

                          // cubit → berpindah ke form3 seperti biasa
                          cubit.onButtonTriggered(
                            index: 2,
                            payload: {}, // payload kosong → nanti API yg update field
                          );
                        },
                      )
                    else
                      AppButton.primary(
                        text: "Hitung Premi",
                        onPressed: () {
                          // user klik → minta buka step button
                          cubit.requestOpenStep(2);
                        },
                      ),

                    const SizedBox(height: 12),

                    // ================= FORM 3 =================
                    CalmvForm3Section(
                      key: form3Key,
                      isExpanded: form3Active,
                    ),

                    const SizedBox(height: 12),

                    if (form3Active)
                      AppButton.primary(
                        text: "Lanjutkan",
                        onPressed: () async {
                          final calmv1Id = _savedCalmv1Id ?? state.steps[0].id;

                          // panggil API ke RegMv
                          context.read<Calmv1CrudBloc>().add(
                            CalmvtoRegMvEvent(recordId: calmv1Id!),
                          );

                          // Beritahu parent (opsional)
                          cubit.onButtonTriggered(index: 4, payload: {});
                        },
                      )else
                      AppButton.primary(
                        text: "Lanjutkan",
                        onPressed: null,                 // disable
                        textColor: pGrey,                    // warna disabled
                      ),

                    const SizedBox(height: 25),
                    FormError(errors: errors, key: null),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
