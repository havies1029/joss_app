import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv3form_bloc.dart';
import 'package:joss_app/repositories/gen_calmv/calmv1crud_repository.dart';
import 'package:joss_app/repositories/gen_calmv/calmv2form_repository.dart';
// import 'package:joss_app/repositories/gen_calmv/calmv3form_repository.dart';

import '../../blocs/reusable_connection_flow/reusable_connection_flow_bloc.dart';
import '../../blocs/reusable_connection_flow/reusable_connection_flow_state.dart';
import '../../widgets/apptheme/header_card_polis.dart';
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
  final List<String> errors = [];
  final GlobalKey<CalmvForm1SectionState> form1Key =
  GlobalKey<CalmvForm1SectionState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ReusableConnectionFlow()),
        BlocProvider(create: (_) => Calmv1CrudBloc(repository: Calmv1CrudRepository())),
        BlocProvider(create: (_) => Calmv2FormBloc(repository: Calmv2FormRepository())),
      ],
      child: BlocConsumer<ReusableConnectionFlow, ReusableConnectionFlowState>(
        listener: (context, flow) {
          if (flow.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(flow.errorMessage ?? 'Terjadi kesalahan'),
            );
          }

          if (flow.isForm1Saving) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("💾 Menyimpan Data Kendaraan...")),
            );
          }

          if (flow.isForm1Saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Data kendaraan tersimpan")),
            );
          }
        },
        builder: (context, flow) {
          return BaseBackgroundSidePage(
            title: "Kendaraan",
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                color: secondaryBlackColor,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormSectionHeader(
                      iconPath: "assets/icons/kendaraan.svg",
                      title: "Beli Polis",
                      subtitle:
                      "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                    ),
                    const SizedBox(height: vPadding),

                    // ================= FORM 1 =================
                    CalmvForm1Section(
                      key: form1Key,
                      externalKey: form1Key,
                      viewMode: widget.viewMode,
                      recordId: widget.recordId,
                      isExpanded: flow.activeStage == "form1",
                      onToggle: (v) {
                        if (v) {
                          context.read<ReusableConnectionFlow>().moveTo("form1");
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // ================= FORM 2 =================
                    CalmvForm2Section(
                      viewMode: widget.viewMode,
                      calmv1Id: flow.activeId,
                      isExpanded: flow.activeStage == "form2",
                      onToggle: (v) async {
                        final flowCubit = context.read<ReusableConnectionFlow>();
                        final form1State = form1Key.currentState;

                        // --- Validasi Form1 dulu ---
                        if (form1State == null) return;

                        final isValid = form1State.validateFormFields();
                        flowCubit.markForm1Valid(isValid);

                        if (!isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar("Lengkapi Data Kendaraan terlebih dahulu."),
                          );
                          return;
                        }

                        // --- Cegah race save ---
                        if (flowCubit.state.isForm1Saving || flowCubit.state.isTransitioning) return;

                        flowCubit.markForm1Saving();

                        // --- Jika belum pernah disimpan (insert pertama) ---
                        if (!flowCubit.state.isForm1Saved || flowCubit.state.activeId == null) {
                          debugPrint("🆕 [Main] Insert Form1 pertama kali sebelum buka Form2");
                          await form1State.autoSaveWithFlow();
                        } else {
                          // --- Jika sudah punya calmv1_id, lakukan update ulang ---
                          debugPrint("♻️ [Main] Update Form1 sebelum buka Form2");
                          await form1State.autoSaveWithFlow();
                        }

                        // --- Buka Form2 hanya setelah data kendaraan tersimpan ---
                        if (v && flowCubit.state.isForm1Saved) {
                          flowCubit.moveTo("form2", id: flowCubit.state.activeId);
                        }

                      },
                    ),


                    const SizedBox(height: 12),

                    // ================= FORM 3 =================
                    CalmvForm3Section(
                      isExpanded: flow.activeStage == "form3",
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