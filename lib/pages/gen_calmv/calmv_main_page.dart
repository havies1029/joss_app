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

import '../../blocs/reusable_connection_flow/calmv2_id_cubit.dart';
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

  Future<void> _onHitungPremi(BuildContext context) async {
    final flow = context.read<ReusableConnectionFlow>();
    final calmv1Id = flow.state.activeId;
    final calmv2Id = context.read<Calmv2IdCubit>().state;

    if (calmv1Id == null || calmv1Id.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar("⚠️ Data kendaraan belum lengkap."));
      return;
    }

    if (calmv2Id == null || calmv2Id.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar("⚠️ Data perlindungan belum disimpan."));
      return;
    }

    debugPrint("🧮 [Main] Hitung premi untuk calmv1Id=$calmv1Id");

    final bloc = context.read<Calmv3FormBloc>();
    bloc.add(Calmv3FormHitungPremiEvent(calmv1Id: calmv1Id));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🔄 Menghitung premi, mohon tunggu...")),
    );

    /// 🔥 Dengarkan hasil bloc dan lempar ke flow
    bloc.stream.listen((state) {
      if (state.isLoaded && state.record != null) {
        final r = state.record!;
        debugPrint("✅ [Main] Premi diterima: ${r.toJson()}");

        /// kirim ke flow.sharedData supaya form3 bisa render
        flow.moveTo("form3", data: [
          r.premiDiskon?.toString() ?? "0",
          r.premiNet?.toString() ?? "0",
          r.premiSubtotal?.toString() ?? "0",
        ]);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Premi berhasil dihitung!")),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ReusableConnectionFlow()),
        BlocProvider(create: (_) => Calmv1CrudBloc(repository: Calmv1CrudRepository())),
        BlocProvider(create: (_) => Calmv2FormBloc(repository: Calmv2FormRepository())),
        // BlocProvider(create: (_) => Calmv3FormBloc(repository: Calmv3FormRepository())),
        BlocProvider(create: (_) => Calmv2IdCubit()), // ✅ Cubit ditambahkan
      ],
      child: BlocConsumer<ReusableConnectionFlow, ReusableConnectionFlowState>(
        listener: (context, flow) {
          if (flow.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(flow.errorMessage ?? 'Terjadi kesalahan'),
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
                constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                color: secondaryBlackColor,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormSectionHeader(
                      iconPath: "assets/icons/kendaraan.svg",
                      title: "Beli Polis",
                      subtitle: "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
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
                        if (form1State == null) return;

                        if (flowCubit.state.isForm1Saving ||
                            flowCubit.state.isTransitioning) return;

                        if (!flowCubit.state.isForm1Saved ||
                            flowCubit.state.activeId == null) {
                          final isValid = form1State.validateFormFields();
                          flowCubit.markForm1Valid(isValid);
                          if (!isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar("Lengkapi Data Kendaraan terlebih dahulu."),
                            );
                            return;
                          }

                          flowCubit.markForm1Saving();
                          await form1State.autoSaveWithFlow();

                          if (v && flowCubit.state.isForm1Saved) {
                            flowCubit.moveTo("form2", id: flowCubit.state.activeId);
                          }
                          return;
                        }

                        flowCubit.markForm1Valid(true);
                        if (v) {
                          await form1State.autoSaveWithFlow();
                          flowCubit.moveTo("form2", id: flowCubit.state.activeId);
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    // ================= HITUNG PREMI BUTTON =================
                    BlocBuilder<Calmv2IdCubit, String?>(
                      builder: (context, calmv2Id) {
                        final flow = context.watch<ReusableConnectionFlow>();
                        final calmv1Id = flow.state.activeId;
                        final isEnabled = (calmv1Id != null && calmv1Id.isNotEmpty) &&
                            (calmv2Id != null && calmv2Id.isNotEmpty);

                        return AppButton.primary(
                          text: "Hitung Premi",
                          backgroundColor: isEnabled ? sBlue : pGrey,
                          onPressed: isEnabled
                              ? () async => await _onHitungPremi(context)
                              : null,
                        );
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