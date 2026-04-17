import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';

import '../../../../../../blocs/dashboard/sumdash_bloc.dart';
import '../../../../../../blocs/notiflog/logtrscaritopx_bloc.dart';
import '../../../../../../blocs/payment/dnrekap2inv_bloc.dart';
import 'package:confetti/confetti.dart';

import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';


class PerbaruiSuccessPage extends StatefulWidget {
  final String display;
  final String description;
  final String displayButton;
  final VoidCallback? onButtonPressed;

  const PerbaruiSuccessPage({
    super.key,
    required this.display,
    required this.description,
    required this.displayButton,
    this.onButtonPressed
  });

  @override
  State<PerbaruiSuccessPage> createState() => _PerbaruiSuccessPageState();
}

class _PerbaruiSuccessPageState extends State<PerbaruiSuccessPage> {
  late ConfettiController _controllerLeft;
  late ConfettiController _controllerRight;

  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _controllerLeft = ConfettiController(duration: const Duration(seconds: 1));
    _controllerRight = ConfettiController(duration: const Duration(seconds: 1));

    _controllerLeft.play();
    _controllerRight.play();

    _redirectTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _goToMain();
    });
  }

  void _goToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const KlaimMainPage()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _controllerLeft.dispose();
    _controllerRight.dispose();
    super.dispose();
  }
  void _defaultButtonAction() {
    context.read<DnRekap2invBloc>().add(InitializeDnRekap2invEvent());
    // Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const KlaimMainPage()),
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.onButtonPressed ?? _defaultButtonAction;
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
                child: IgnorePointer(
                  ignoring: true,
                  child: ConfettiWidget(
                    confettiController: _controllerLeft,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.03,
                    numberOfParticles: 32,
                    shouldLoop: false,
                  ),
                ),
              ),

              Align(
                alignment: const Alignment(1, -1),
                child: IgnorePointer(
                  ignoring: true,
                  child: ConfettiWidget(
                    confettiController: _controllerRight,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.03,
                    numberOfParticles: 32,
                    shouldLoop: false,
                  ),
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
                        widget.description,
                        textAlign: TextAlign.center,
                        style: bodyTextStyle(context, fontSize: 20)
                            .copyWith(color: hintGrey),
                      ),
                      const SizedBox(height: vPadding),
                      AppButton.primary(
                        text: widget.displayButton,
                        backgroundColor: formGrey,
                        borderside: BorderSide(color: sGrey),
                        width: 245,
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<SumdashBloc>().add(SumdashLihatEvent());
                          context.read<LogtrscaritopxBloc>().add(RefreshLogtrscaritopxEvent());
                          // onPressed.call();
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
