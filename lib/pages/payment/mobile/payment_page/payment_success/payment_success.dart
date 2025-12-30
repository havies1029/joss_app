import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';

import '../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import 'package:confetti/confetti.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  late ConfettiController _controllerLeft;
  late ConfettiController _controllerRight;


  @override
  void initState() {
    super.initState();
    _controllerLeft  = ConfettiController(duration: const Duration(seconds: 1));
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
      backgroundColor: primaryBlackColor, // 🟢 Hitam solid sebagai base layer
      body: BaseBackgroundFirstPage(
        child: Scaffold(
          backgroundColor: Colors
              .transparent, // 🟢 biar transparan ke layer BaseBackground
          body: Stack(
            children: [
              /// Confetti kiri–atas
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

              /// Confetti kanan–atas
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

              /// Konten utama
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/logo_berhasil.svg",
                      width: 56 * 3,
                      height: 56 * 3,
                    ),
                    const SizedBox(height: vPadding),
                    Text(
                      "Pembayaran Berhasil!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 30),
                        color: primaryLightColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: hPadding),
                    Text(
                      "Polis Anda kini aktif.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: hintGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: vPadding),
                    AppButton.primary(
                      text: "Kembali",
                      backgroundColor: formGrey,
                      borderside: BorderSide(color: sGrey, width: 1),
                      width: 60 * 3,
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