import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/blocs/login/emailverification_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/blocs/networkconnection/network_bloc.dart';
import 'package:joss_app/blocs/profile/profile_download_foto_bloc.dart';
import 'package:joss_app/blocs/profile/profile_upload_foto_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1crud_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1list_bloc.dart';
import 'package:joss_app/blocs/user_profile/user_profile_cubit.dart';

import 'package:joss_app/repositories/login/emailverification_repository.dart';
import 'package:joss_app/repositories/login/change_password_repository.dart';
import 'package:joss_app/repositories/profile/userfoto_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekan1crud_repository.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/pages/login/login_form.dart';
import 'package:joss_app/pages/home/home_tab_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );

  final userRepository = UserRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc(userRepository: userRepository)..add(AppStarted())),
        BlocProvider(create: (ctx) => LoginBloc(
          authenticationBloc: ctx.read<AuthenticationBloc>(),
          userRepository: userRepository,
        )),
        BlocProvider(create: (ctx) => EmailVerificationBloc(
          repository: EmailVerificationRepository(),
          authenticationBloc: ctx.read<AuthenticationBloc>(),
        )),
        BlocProvider(create: (_) => ChangePasswordBloc(repository: ChangePasswordRepository())),
        BlocProvider(create: (_) => NetworkBloc()..add(NetworkObserve())),
        BlocProvider(create: (_) => ProfileUploadFotoBloc()),
        BlocProvider(create: (_) => ProfileDownloadFotoBloc(repository: UserFotoRepository())),
        BlocProvider(create: (_) => MRekan1CrudBloc(repository: MRekan1CrudRepository())),
        BlocProvider(create: (_) => MRekan1ListBloc()),
        // ⬇️ simpan profil di sini (persist dengan hydrated)
        BlocProvider(create: (_) => UserProfileCubit()),
      ],
      child: const _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JPS Insurance',
      theme: FlexThemeData.light(
        scheme: FlexScheme.mandyRed,
        fontFamily: 'Delm-Regular',
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.mandyRed,
        fontFamily: 'Delm-Regular',
        primary: primaryBlackColor,
        secondary: primaryLightColor,
      ),
      themeMode: ThemeMode.dark,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return HomeTabWidget(userRepository: UserRepository());
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage();
          }
          return const LoadingIndicator();
        },
      ),
    );
  }
}
