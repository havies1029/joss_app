import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomShape extends StatelessWidget {
  const BottomShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        'assets/images/shape-bottom.svg',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
