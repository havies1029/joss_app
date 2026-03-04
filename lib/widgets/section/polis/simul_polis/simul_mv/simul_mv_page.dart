import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/section/polis/real_polis/sppa_mv/sppa_mv_page.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_mv/simul_form/simul_casco.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_mv/simul_form/simul_opsi.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_mv/simul_form/simul_premi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../blocs/local_prefs/simulasi_mv_local_cubit.dart';
import '../../../../../models/combobox/combommvgrupojk_model.dart';
import '../../../../../models/combobox/combommvjnscover_model.dart';
import '../../../../../models/combobox/combomwilayah_model.dart';

class SimulMvPage extends StatefulWidget {
  const SimulMvPage({super.key});

  @override
  State<SimulMvPage> createState() => _SimulMvPageState();
}

class _SimulMvPageState extends State<SimulMvPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _showPremiSection = false;

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kendaraan",
      child: LayoutBuilder(
        builder: (context, constraints) {
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
                      _buildProgressBar(), const SizedBox(height: 15),
                      // CASCO
                      Text("Data Kendaraan", style: bodyTextStyle(context)),
                      const SizedBox(height: 10),
                      SimulmvFormCascoPage(viewMode: "tambah", recordId: ""),
                      const SizedBox(height: vPadding),
                      // OPSI
                      Text(
                        "Perlindungan Tambahan",
                        style: bodyTextStyle(context),
                      ),
                      const SizedBox(height: 10),
                      SimulmvFormOpsiPage(viewMode: "tambah", recordId: ""),
                      const SizedBox(height: vPadding),
                      // HITUNG PREMI
                      AppButton.primary(
                        text: "Hitung Premi",
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar("Terjadi kesalahan, coba lagi!"),
                            );
                            return;
                          }
                          context.read<SimulmvCrudBloc>().add(
                            HitungPremiEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: vPadding),

                      // Tampilkan section "Premi" hanya setelah perhitungan selesai
                      BlocBuilder<SimulmvCrudBloc, SimulmvCrudState>(
                        buildWhen:
                            (p, c) =>
                                p.isCalculated != c.isCalculated ||
                                p.isLoaded != c.isLoaded ||
                                p.errors != c.errors,
                        builder: (context, state) {
                          final showPremi =
                              state.isCalculated || state.isLoaded;
                          if (!showPremi) return const SizedBox.shrink();

                          final record = state.record;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hasil Simulasi perhitungan premi",
                                style: bodyTextStyle(context),
                              ),
                              const SizedBox(height: 10),
                              SimulmvFormPremiPage(
                                viewMode: "tambah",
                                recordId: "",
                              ),
                              const SizedBox(height: vPadding),

                              // TOMBOL LANJUT SPPA
                              Align(
                                alignment: Alignment.centerLeft,
                                child: AppButton.primary(
                                  text: "Beli Polis Kendaraan",
                                  onPressed: () {
                                    if (record == null) return;

                                    context
                                        .read<SimulasiMvLocalCubit>()
                                        .setFromSimulasi(
                                          mvgrupOjk:
                                              record.comboMMvgrupOjk ??
                                              const ComboMMvgrupOjkModel(),
                                          mvjnscover:
                                              record.comboMMvjnscover ??
                                              const ComboMMvjnscoverModel(),
                                          wilayah:
                                              record.comboMWilayah ??
                                              const ComboMWilayahModel(),
                                          thnBuat: record.thnBuat ?? 0,
                                          harga: record.harga?.round() ?? 0,
                                          lamaCoverBulan:
                                              record.coverBulan ?? 0,
                                          isFlood: record.isFlood ?? false,
                                          isEq: record.isEq ?? false,
                                          isSrcc: record.isSrcc ?? false,
                                          isTerrorism:
                                              record.isTerrorism ?? false,
                                          pad: record.pad?.round() ?? 0,
                                          pap: record.pap?.round() ?? 0,
                                          pll: record.pll?.round() ?? 0,
                                          tpl: record.tpl?.round() ?? 0,
                                          aw: record.aw?.round() ?? 0,
                                        );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SppaMvPage(),
                                      ),
                                    );
                                  },
                                ),
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
          SvgPicture.asset("assets/icons/kendaraan.svg", width: 40, height: 40),
          const SizedBox(width: 10),

          // Teks Header
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Beli Polis', style: bodyTextStyle(context, fontSize: 20)),
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
