
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_klaim/mobile/widget/klaim1_inline_editor_page.dart';
import '../../../../common/constants.dart';

import '../../../widgets/apptheme/header_card.dart';
import '../../base/base_background_sidepage.dart';

class KlaimMainPage extends StatefulWidget {
  const KlaimMainPage({super.key});

  @override
  _KlaimMainPageState createState() => _KlaimMainPageState();
}

class _KlaimMainPageState extends State<KlaimMainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Klaim',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              HeaderCard(
                iconPath: "assets/icons/shield2.svg",
                title: "Klaim",
                subtitle:
                "Ajukan klaim Anda dengan mudah dan cepat sesuai ketentuan polis yang berlaku.",
              ),
              SizedBox(height: 12),
              Expanded(child: Klaim1InlineEditorPage()),
            ],
          ),
        ),
      ),
    );
  }

}
