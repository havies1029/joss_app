  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:joss_app/common/constants.dart';
  import 'package:joss_app/pages/base/base_background_firstpage.dart';

  import '../../../../blocs/asetothers/asetotherscari_bloc.dart';
  import '../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
  import '../../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
  import '../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
  import '../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
  import '../../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
  import 'package:confetti/confetti.dart';

  import '../../detail_management_page/detail_management_widget.dart';

  class PolisSuccess extends StatefulWidget {
    final String display;
    final String? purpose;
    const PolisSuccess({super.key, required this.display, this.purpose});

    @override
    State<PolisSuccess> createState() => _PolisSuccessState();
  }

  class _PolisSuccessState extends State<PolisSuccess> {
    late ConfettiController _controllerLeft;
    late ConfettiController _controllerRight;

    @override
    void initState() {
      super.initState();
      _controllerLeft = ConfettiController(duration: const Duration(seconds: 1));
      _controllerRight = ConfettiController(duration: const Duration(seconds: 1));
      _controllerLeft.play();
      _controllerRight.play();
    }

    @override
    void dispose() {
      _controllerLeft.dispose();
      _controllerRight.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: primaryBlackColor,
        body: BaseBackgroundFirstPage(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Confetti kiri–atas
                Align(
                  alignment: const Alignment(-1, -1),
                  child: ConfettiWidget(
                    confettiController: _controllerLeft,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.03,
                    numberOfParticles: 32,
                    shouldLoop: false,
                  ),
                ),

                Align(
                  alignment: const Alignment(1, -1),
                  child: ConfettiWidget(
                    confettiController: _controllerRight,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.03,
                    numberOfParticles: 32,
                    shouldLoop: false,
                  ),
                ),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/logo_berhasil.svg",
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: vPadding),
                        Text(
                          widget.display,
                          textAlign: TextAlign.center,
                          style: headingStyle(context),
                        ),
                        const SizedBox(height: hPadding),
                        Text(
                          "Tim internal sedang meninjau permintaan Anda",
                          textAlign: TextAlign.center,
                          style: bodyTextStyle(context, fontSize: 20)
                              .copyWith(color: hintGrey),
                        ),
                        const SizedBox(height: vPadding),
                        AppButton.primary(
                          text: "Lihat Detail",
                          backgroundColor: formGrey,
                          borderside: BorderSide(color: sGrey),
                          width: 245,
                          onPressed: () {
                            final cobId = context.read<CobManPolBloc>().state.selectedCOBId;
                            // final cobOthers = context.read<Regother1CrudBloc>().state.selectedCOBId;

                            dynamic selectedItem;
                            switch (cobId) {
                              case "10002":
                                selectedItem = context.read<AsetParCariBloc>().state.selectedItem;
                                break;
                              case "10003":
                                selectedItem = context.read<AsetMvCariBloc>().state.selectedItem;
                                break;
                              case "10004":
                                selectedItem = context.read<AsethullCariBloc>().state.selectedItem;
                                break;
                              case "10005":
                                selectedItem = context.read<AsetHealthCariBloc>().state.selectedItem;
                                break;
                              default:
                                selectedItem = context.read<AsetothersCariBloc>().state.selectedItem;
                            }

                            if (selectedItem == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Data polis tidak ditemukan")),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailManagementPolisPage(
                                  data: selectedItem,
                                  cobId: cobId,
                                  statusId: "",
                                  jenisProses: widget.purpose,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
