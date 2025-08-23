import 'package:joss_app/pages/login/change_pswd_form.dart';
import 'package:flutter/material.dart';

class ChangePswdMainPage extends StatelessWidget {
  const ChangePswdMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    //debugPrint("Masuk ke Login Page");

    return const Scaffold(
      body: ChangePswdForm(),
    );
  }
}
