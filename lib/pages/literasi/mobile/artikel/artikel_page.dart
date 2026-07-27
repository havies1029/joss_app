import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'artikel_list_page.dart';

class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      child: ArtikelListPage(),
    );
  }
}
