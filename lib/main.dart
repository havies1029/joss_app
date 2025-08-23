import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/blocs/login/emailverification_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/blocs/networkconnection/network_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/pages/home/home_tab_widget.dart';
import 'package:joss_app/pages/login/login_form.dart';
import 'package:joss_app/repositories/login/change_password_repository.dart';
import 'package:joss_app/repositories/login/emailverification_repository.dart';
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {

  final userRepository = UserRepository();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted());
    },
    child: App(
      userRepository: userRepository,
      key: null,
    ),
  ));
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  const App({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                userRepository: userRepository,
              )
        ),
        BlocProvider<EmailVerificationBloc>(
          create: (context) =>
              EmailVerificationBloc(
                repository: EmailVerificationRepository(), 
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
        BlocProvider<ChangePasswordBloc>(
          create: (context) =>
              ChangePasswordBloc(repository: ChangePasswordRepository())),               
        BlocProvider<NetworkBloc>(
          create: (context) => NetworkBloc()..add(NetworkObserve())), 

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JPS Insurance',
        theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
        // The Mandy red, dark theme.
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
        // Use dark or light theme based on system setting.
        themeMode: ThemeMode.light,


        routes: const {},
        
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {

            if (state is AuthenticationAuthenticated) {
              debugPrint("AuthenticationAuthenticated #20");

              return HomeTabWidget(
                userRepository: userRepository);
            }

            if (state is AuthenticationUnauthenticated) {
              debugPrint("AuthenticationUnauthenticated #30");
              return LoginPage();
            }

            return const LoadingIndicator();
           
          },
        ),
        
      ),
    );
  }
}
