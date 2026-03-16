import 'package:flutter/material.dart';
import 'constants.dart';
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(color: primaryColor,),
  );
}