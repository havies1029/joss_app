
import 'package:flutter/material.dart';
import 'package:joss_app/pages/register/mobile/client/register_form_client_remake.dart';

import '../../../../common/constants.dart';
import '../../../base/base_background_firstpage.dart';

class RegisterClient extends StatefulWidget {
  final String requestFrom;
  const RegisterClient({super.key, required this.requestFrom});

  @override
  RegisterClientState createState() => RegisterClientState();
}

class RegisterClientState extends State<RegisterClient>
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

  // Widget yang mengandung RegisterFormClient
  Widget _buildDesignRegisterFormClient() {
    return RegisterFormClientRemake(requestFrom: widget.requestFrom);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
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
                        _buildDesignRegisterFormClient(),
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
