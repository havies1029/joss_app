import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';

import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import 'package:confetti/confetti.dart';

class PaymentSuccess extends StatefulWidget {
  final String display;
  final String description;
  final String displayButton;
  const PaymentSuccess({super.key, required this.display, required this.description, required this.displayButton});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
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

              // Confetti kanan–atas
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

              // Konten utama
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
                      "${widget.display}",
                      textAlign: TextAlign.center,
                      style: headingStyle(context),
                    ),
                    const SizedBox(height: hPadding),
                    Text(
                      "${widget.description}",
                      textAlign: TextAlign.center,
                      style: bodyTextStyle(context, fontSize: 20)
                          .copyWith(color: hintGrey),
                    ),
                    const SizedBox(height: vPadding),
                    AppButton.primary(
                      text: "${widget.displayButton}",
                      backgroundColor: formGrey,
                      borderside: BorderSide(color: sGrey),
                      width: 245,
                      onPressed: () {
                        context
                            .read<DnRekap2invBloc>()
                            .add(InitializeDnRekap2invEvent());
                        Navigator.popUntil(context, (route) => route.isFirst);
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
