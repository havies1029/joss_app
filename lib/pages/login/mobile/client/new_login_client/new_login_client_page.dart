import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/pages/login/mobile/client/new_login_client/new_login_form_client.dart';

class NewLoginClient extends StatelessWidget {
  final String requestFrom;
  final String initialUsername;

  const NewLoginClient({
    super.key,
    this.requestFrom = '',
    this.initialUsername = '',
  });

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
                        NewLoginFormClient(
                          requestFrom: requestFrom,
                          initialUsername: initialUsername,
                        ),
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
