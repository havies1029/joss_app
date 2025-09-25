import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_coverv2.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_si.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_bangunan.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_par/simul_form/simulparcrud_form_premi.dart';

import '../../../../../blocs/home/home_bloc.dart';
import '../../../../../blocs/local_prefs/simulasi_par_local_cubit.dart';
import '../../../../../models/combobox/combomkabzonagempa_model.dart';
import '../../../../../models/combobox/combomwilayah_model.dart';
import '../../../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../../../models/combobox/comborokupasi_model.dart';
import '../../../../../pages/polis/sppa/sppa_polis_par.dart';


class SimulParPage extends StatefulWidget {
  const SimulParPage({super.key});

  @override
  State<SimulParPage> createState() => _SimulParPageState();
}

class _SimulParPageState extends State<SimulParPage> {
  final _formKey = GlobalKey<FormState>();
  static const _fontFamily = 'Satoshi-Regular';

  @override
  void initState() {
    super.initState();
    context.read<SimulparCrudBloc>().add(SimulPARCrudInitValueEvent());
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveHelper(constraints);

        return BlocBuilder<SimulparCrudBloc, SimulparCrudState>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Center(
                  child: Container(
                    width: responsive.maxWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: responsive.sectionSpacing),
                          _buildHeader(responsive),
                          SizedBox(height: responsive.sectionSpacing),

                          _buildSectionHeader('Informasi Bangunan', responsive),
                          const SimulparFormBangunanPage(viewMode: 'tambah', recordId: ''),
                          SizedBox(height: responsive.sectionSpacing),

                          _buildSectionHeader('Sum Insured', responsive),
                          const SimulparFormSumInsuredPage(viewMode: 'tambah', recordId: ''),
                          SizedBox(height: responsive.sectionSpacing),

                          _buildSectionHeader('Rate', responsive),
                          const SimulparFormCoverV2Page(viewMode: 'tambah', recordId: ''),
                          SizedBox(height: responsive.sectionSpacing),

                          // 🔘 TOMBOL HITUNG
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.calculate),
                              label: const Text('Hitung Premi'),
                              onPressed: () {
                                context.read<SimulparCrudBloc>().add(HitungPremiPAREvent());
                              },
                            ),
                          ),

                          SizedBox(height: responsive.sectionSpacing),

                          // 🔽 TAMPILKAN PREMI & LANJUT BUTTON
                          BlocBuilder<SimulparCrudBloc, SimulparCrudState>(
                            buildWhen: (p, c) =>
                            p.isLoaded != c.isLoaded ||
                                p.isGroupFieldPremiChanged != c.isGroupFieldPremiChanged ||
                                p.errors != c.errors,
                            builder: (context, s) {
                              final showPremi = s.isGroupFieldPremiChanged || s.isLoaded;
                              if (!showPremi) return const SizedBox.shrink();

                              final record = s.record;
                              if (record == null) return const SizedBox.shrink();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader('Perhitungan Premi', responsive),
                                  const SimulparFormPremiPage(viewMode: 'tambah', recordId: ''),
                                  SizedBox(height: responsive.sectionSpacing),

                                  // 🔘 TOMBOL LANJUT
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text('Lanjut Isi SPPA'),
                                      onPressed: () {
                                        context.read<SimulasiParLocalCubit>().setFromSimulasi(
                                          siBuilding: record.siBuilding ?? 0,
                                          siContent: record.siContent ?? 0,
                                          siMachinery: record.siMachinery ?? 0,
                                          siStock: record.siStock ?? 0,
                                          siOther: record.siOther ?? 0,
                                          stockAdjustable: record.stockAdjustable ?? 0,
                                          ratePar: record.ratePar ?? 0,
                                          rateEqvet: record.rateEqvet ?? 0,
                                          rateRsmdcc: record.rateRsmdcc ?? 0,
                                          rateTsfwd: record.rateTsfwd ?? 0,
                                          rateOther: record.rateOther ?? 0,
                                          rateTotal: record.rateTotal ?? 0,
                                          premiEqvet: record.premiEqvet ?? 0,
                                          premiRsmdcc: record.premiRsmdcc ?? 0,
                                          premiTsfwd: record.premiTsfwd ?? 0,
                                          premiOther: record.premiOthers ?? 0,
                                          premiTotal: record.premiTotal ?? 0,
                                          wilayah: record.comboMWilayah ?? const ComboMWilayahModel(),
                                          zonaGempa: record.comboMKabZonaGempa ?? const ComboMKabZonaGempaModel(),
                                          konstruksi: record.comboRKonstruksiojk ?? const ComboRKonstruksiojkModel(),
                                          okupasi: record.comboROkupasi ?? const ComboROkupasiModel(),
                                        );
                                        // context.read<SimulasiParLocalCubit>().setFromSimulasi(
                                        //   siBuilding: (record.siBuilding ?? 0) * 1000000,
                                        //   siContent: (record.siContent ?? 0) * 1000000,
                                        //   siMachinery: (record.siMachinery ?? 0) * 1000000,
                                        //   siStock: (record.siStock ?? 0) * 1000000,
                                        //   siOther: (record.siOther ?? 0) * 1000000,
                                        //   stockAdjustable: record.stockAdjustable ?? 0,
                                        //
                                        //   ratePar: record.ratePar ?? 0,
                                        //   rateEqvet: record.rateEqvet ?? 0,
                                        //   rateRsmdcc: record.rateRsmdcc ?? 0,
                                        //   rateTsfwd: record.rateTsfwd ?? 0,
                                        //   rateOther: record.rateOther ?? 0,
                                        //   rateTotal: record.rateTotal ?? 0,
                                        //
                                        //   premiEqvet: record.premiEqvet ?? 0,
                                        //   premiRsmdcc: record.premiRsmdcc ?? 0,
                                        //   premiTsfwd: record.premiTsfwd ?? 0,
                                        //   premiOther: record.premiOthers ?? 0,
                                        //   premiTotal: record.premiTotal ?? 0,
                                        //
                                        //   wilayah: record.comboMWilayah ?? const ComboMWilayahModel(),
                                        //   zonaGempa: record.comboMKabZonaGempa ?? const ComboMKabZonaGempaModel(),
                                        //   konstruksi: record.comboRKonstruksiojk ?? const ComboRKonstruksiojkModel(),
                                        //   okupasi: record.comboROkupasi ?? const ComboROkupasiModel(),
                                        // );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const SppaPolisParMain(), // <-- halaman tujuan langsung
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  SizedBox(height: responsive.sectionSpacing),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(ResponsiveHelper responsive) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        height: responsive.headerHeight,
        color: const Color(0xFF91C050),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/frame_polis.svg',
                width: responsive.headerIconSize,
                height: responsive.headerIconSize,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: responsive.horizontalPadding,
                top: responsive.headerTextTop,
                right: responsive.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beli Polis',
                    style: TextStyle(
                      fontSize: responsive.headerTitleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  SizedBox(height: responsive.headerSubtitleSpacing),
                  Text(
                    'Sebelum lanjut, pastikan data kamu sudah lengkap, ya!',
                    style: TextStyle(
                      fontSize: responsive.headerSubtitleSize,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: _fontFamily,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ResponsiveHelper responsive) {
    return Row(
      children: [
        Container(
          width: 4,
          height: responsive.sectionHeaderSize + 4,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF8BC34A),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: responsive.sectionHeaderSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}

class ResponsiveHelper {
  final BoxConstraints constraints;

  ResponsiveHelper(this.constraints);

  bool get isMobile => constraints.maxWidth < 768;
  bool get isTablet => constraints.maxWidth >= 768 && constraints.maxWidth < 992;
  bool get isDesktop => constraints.maxWidth >= 992;

  double get horizontalPadding => constraints.maxWidth > 1200
      ? 48
      : isTablet
      ? 36
      : 24;

  double get maxWidth => constraints.maxWidth > 1200
      ? 1200
      : isTablet
      ? constraints.maxWidth * 0.95
      : constraints.maxWidth * 0.9;

  double get headerHeight => isMobile ? 130 : isTablet ? 150 : 160;
  double get headerTitleSize => isMobile ? 24 : isTablet ? 28 : 32;
  double get headerSubtitleSize => isMobile ? 13 : isTablet ? 14 : 15;
  double get headerTextTop => isMobile ? 36 : 45;
  double get headerSubtitleSpacing => isMobile ? 6 : 8;
  double get headerIconSize => isMobile ? 90 : 110;
  double get bottomPadding => isMobile ? 32 : 40;
  double get sectionSpacing => isMobile ? 24 : isTablet ? 28 : 32;
  double get sectionHeaderSize => isMobile ? 16 : isTablet ? 17 : 18;
}
