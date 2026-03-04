import 'package:flutter/material.dart';
import 'constants.dart';
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(color: primaryColor,),
  );
}


/*
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:joss_app/common/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 36,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      alignment: Alignment.center,
      child: SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/icons/infinity_loader_orange.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
*/