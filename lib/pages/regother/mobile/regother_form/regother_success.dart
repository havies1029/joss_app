import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regother/regother1crud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';

import 'package:confetti/confetti.dart';

import '../../../management_polis/detail_management_page/detail_management_widget.dart';

class RegotherSucess extends StatefulWidget {
  final String display;
  final String? purpose;
  const RegotherSucess({super.key, required this.display, this.purpose});

  @override
  State<RegotherSucess> createState() => _RegotherSucessState();
}

class _RegotherSucessState extends State<RegotherSucess> {
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
                      width: 245,onPressed: () {
                        final cobOthers = context.read<Regother1CrudBloc>().state.selectedCOBId;

                        dynamic selectedItem;
                        selectedItem = context.read<Regother1CrudBloc>().state.selectedItem;

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
                              cobId: cobOthers,
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
            ],
          ),
        ),
      ),
    );
  }
}