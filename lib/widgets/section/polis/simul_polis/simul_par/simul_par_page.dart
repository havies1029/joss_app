import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_coverv2.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_si.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_bangunan.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_premi.dart';

import '../../../../../blocs/local_prefs/simulasi_par_local_cubit.dart';
import '../../../../../models/combobox/combomkabzonagempa_model.dart';
import '../../../../../models/combobox/combomwilayah_model.dart';
import '../../../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../../../models/combobox/comborokupasi_model.dart';
import '../../../../../pages/polis/sppa/sppa_polis_par.dart';
import '../../real_polis/sppa_par/sppa_par_page.dart';

class SimulParPage extends StatefulWidget {
  const SimulParPage({super.key});

  @override
  State<SimulParPage> createState() => _SimulParPageState();
}

class _SimulParPageState extends State<SimulParPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPremiSection = false;

  @override
  void initState() {
    super.initState();
    context.read<SimulparCrudBloc>().add(SimulPARCrudInitValueEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Rumah & Properti",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<SimulparCrudBloc, SimulparCrudState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    color: secondaryBlackColor,
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(), const SizedBox(height: vPadding),
                          const SizedBox(height: 15),
                          // Informasi Bangunan
                          Text(
                            "Informasi Bangunan",
                            style: bodyTextStyle(context),
                          ),
                          const SizedBox(height: 10),
                          const SimulparFormBangunanPage(
                            viewMode: 'tambah',
                            recordId: '',
                          ),
                          const SizedBox(height: vPadding),

                          Text(
                            "Jumlah Pertanggungan",
                            style: bodyTextStyle(context),
                          ),
                          const SizedBox(height: 10),
                          const SimulparFormSumInsuredPage(
                            viewMode: 'tambah',
                            recordId: '',
                          ),
                          const SizedBox(height: vPadding),

                          Text(
                            "Perhitungan Tarif",
                            style: bodyTextStyle(context),
                          ),
                          const SizedBox(height: 10),
                          const SimulparFormCoverV2Page(
                            viewMode: 'tambah',
                            recordId: '',
                          ),
                          const SizedBox(height: vPadding),

                          /// Hitung Premi
                          AppButton.primary(
                            text: "Hitung Premi",
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(
                                    "Terjadi kesalahan, coba lagi!",
                                  ),
                                );
                              }
                              context.read<SimulparCrudBloc>().add(
                                HitungPremiPAREvent(),
                              );
                            },
                          ),
                          const SizedBox(height: vPadding),

                          // TAMPILKAN PREMI & LANJUT BUTTON
                          BlocBuilder<SimulparCrudBloc, SimulparCrudState>(
                            buildWhen:
                                (p, c) =>
                                    p.isLoaded != c.isLoaded ||
                                    p.isGroupFieldPremiChanged !=
                                        c.isGroupFieldPremiChanged ||
                                    p.errors != c.errors,
                            builder: (context, s) {
                              final showPremi =
                                  s.isGroupFieldPremiChanged || s.isLoaded;
                              if (!showPremi) return const SizedBox.shrink();

                              final record = s.record;
                              if (record == null) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Perhitungan Premi",
                                    style: bodyTextStyle(context),
                                  ),
                                  const SizedBox(height: 10),
                                  const SimulparFormPremiPage(
                                    viewMode: 'tambah',
                                    recordId: '',
                                  ),
                                  const SizedBox(height: vPadding),

                                  // Lanjut SPPA
                                  AppButton.primary(
                                    text: "Lanjut Isi SPPA",
                                    onPressed: () {
                                      context
                                          .read<SimulasiParLocalCubit>()
                                          .setFromSimulasi(
                                            siBuilding: record.siBuilding ?? 0,
                                            siContent: record.siContent ?? 0,
                                            siMachinery:
                                                record.siMachinery ?? 0,
                                            siStock: record.siStock ?? 0,
                                            siOther: record.siOther ?? 0,
                                            stockAdjustable:
                                                record.stockAdjustable ?? 0,
                                            ratePar: record.ratePar ?? 0,
                                            rateEqvet: record.rateEqvet ?? 0,
                                            rateRsmdcc: record.rateRsmdcc ?? 0,
                                            rateTsfwd: record.rateTsfwd ?? 0,
                                            rateOther: record.rateOther ?? 0,
                                            rateTotal: record.rateTotal ?? 0,
                                            premiEqvet: record.premiEqvet ?? 0,
                                            premiRsmdcc:
                                                record.premiRsmdcc ?? 0,
                                            premiTsfwd: record.premiTsfwd ?? 0,
                                            premiOther: record.premiOthers ?? 0,
                                            premiTotal: record.premiTotal ?? 0,
                                            wilayah:
                                                record.comboMWilayah ??
                                                const ComboMWilayahModel(),
                                            zonaGempa:
                                                record.comboMKabZonaGempa ??
                                                const ComboMKabZonaGempaModel(),
                                            konstruksi:
                                                record.comboRKonstruksiojk ??
                                                const ComboRKonstruksiojkModel(),
                                            okupasi:
                                                record.comboROkupasi ??
                                                const ComboROkupasiModel(),
                                          );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const SppaParPage(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: vPadding),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SVG
          SvgPicture.asset("assets/icons/properti.svg", width: 40, height: 40),
          const SizedBox(width: 10),

          // Teks Header
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Polis Rumah & Properti',
                  style: bodyTextStyle(context, fontSize: 20),
                ),
                Text(
                  "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: sGrey,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _showPremiSection ? 1.0 : 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: vPadding),
        Text(
          _showPremiSection ? '100%' : '50%',
          style: bodyTextStyle(context, fontSize: 16),
        ),
      ],
    );
  }
}
