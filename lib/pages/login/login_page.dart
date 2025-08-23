import 'package:joss_app/widgets/mobiledesign_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/pages/login/login_form.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  const LoginPage({super.key, required this.userRepository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return MobileDesignWidget(
      child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              userRepository: widget.userRepository,
            );
          },
          child: const LoginForm(),
        ),
    );
  }
}
