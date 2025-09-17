
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../base/base_background_firstpage.dart';
import 'login_form_client.dart';

class LoginClient extends StatefulWidget {
  const LoginClient({super.key});

  @override
  _LoginClientState createState() => _LoginClientState();
}

class _LoginClientState extends State<LoginClient>
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

  // Widget yang mengandung LoginFormClient
  Widget _buildDesignLoginFormClient() {
    return const LoginFormClient();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight * 0.03;
    final headerSpacing = screenHeight * 0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor, // ⬅️ kasih warna dasar hitam
      body: SafeArea(
        child: BaseBackgroundFirstPage(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(

                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: headerSpacing),
                        _buildDesignLoginFormClient(),
                      ],
                    ),
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
