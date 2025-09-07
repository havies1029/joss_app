import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/login/mobile/client/widget/popup_client_widget.dart';
import 'package:joss_app/pages/login/mobile/user/login_user_page.dart';
import 'package:joss_app/pages/login/mobile/user/widget/popup_user_widget.dart';
import 'package:joss_app/pages/profilepage/mobile/profile/form_section/rekan_pajak.dart';
import 'package:joss_app/pages/register/mobile/client/register_client_page.dart';
import 'package:joss_app/repositories/gen_profile/mrekanbankcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralcmpcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralidvcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpajakcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiccrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';
import 'package:joss_app/repositories/reguser/reguser_repository.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/pages/home/home_tab_widget.dart';
import 'package:joss_app/pages/login/mobile/client/login_client_page.dart';

import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/blocs/login/emailverification_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/blocs/networkconnection/network_bloc.dart';
import 'package:joss_app/blocs/profile/profile_download_foto_bloc.dart';
import 'package:joss_app/blocs/profile/profile_upload_foto_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1crud_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1list_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactlist_bloc.dart';
import 'package:joss_app/blocs/user_profile/user_profile_cubit.dart';

import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:joss_app/repositories/login/emailverification_repository.dart';
import 'package:joss_app/repositories/login/change_password_repository.dart';
import 'package:joss_app/repositories/profile/userfoto_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekan1crud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekancontactcrud_repository.dart';

import 'blocs/gallery/galleryeventcari_bloc.dart';

import 'blocs/gen_profile/mrekanbankcrud_bloc.dart';
import 'blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import 'blocs/gen_profile/mrekanpajakcrud_bloc.dart';
import 'blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'blocs/reguser_profile/reguser_profile_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path,
            ),
  );

  final userRepository = UserRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
        ),
        BlocProvider(
          create: (ctx) => LoginBloc(
            authenticationBloc: ctx.read<AuthenticationBloc>(),
            userRepository: userRepository,
          ),
        ),
        // BlocProvider(
        //   create: (ctx) => EmailVerificationBloc(
        //     repository: EmailVerificationRepository(),
        //     authenticationBloc: ctx.read<AuthenticationBloc>(),
        //   ),
        // ),
        BlocProvider(create: (_) => ChangePasswordBloc(repository: ChangePasswordRepository())),
        BlocProvider(create: (_) => NetworkBloc()..add(NetworkObserve())),
        BlocProvider(create: (_) => ProfileUploadFotoBloc()),
        BlocProvider(create: (_) => ProfileDownloadFotoBloc(repository: UserFotoRepository())),
        BlocProvider(create: (_) => MRekan1CrudBloc(repository: MRekan1CrudRepository())),
        BlocProvider<EmailVerificationBloc>(
            create: (context) =>
                EmailVerificationBloc(
                    repository: EmailVerificationRepository(),
                    authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
        BlocProvider<RegUserBloc>(
            create: (context) =>
                RegUserBloc(repository: RegUserRepository(), authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
        BlocProvider(create: (_) => MRekan1ListBloc()),
        BlocProvider(create: (_) => MRekanContactCrudBloc(repository: MRekanContactCrudRepository())),
        BlocProvider(create: (_) => MRekanContactListBloc()),
        BlocProvider(create: (_) => MRekanPajakCrudBloc(repository: MRekanPajakCrudRepository())),
        BlocProvider(create: (_) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository())),
        BlocProvider(create: (_) => MRekanGeneralIdvCrudBloc(repository: MRekanGeneralIdvCrudRepository())),
        BlocProvider(create: (_) => MRekanGeneralCmpCrudBloc(repository: MRekanGeneralCmpCrudRepository())),
        BlocProvider<MRekanPicListBloc>(
          create: (context) => MRekanPicListBloc(repository: MRekanPicListRepository())..add(FetchMRekanPicListEvent()),
        ),
        BlocProvider<MRekanPicCrudBloc>(
          create: (context) => MRekanPicCrudBloc(repository: MRekanPicCrudRepository()),
        ),
        BlocProvider(create: (_) => UserProfileCubit()), // hydrated
        BlocProvider(create: (_) => RegUserProfileCubit()),
        BlocProvider(create: (_) => GalleryeventCariBloc()..add(RefreshGalleryeventCariEvent())),
      ],
      child: MultiBlocListener(
        listeners: [
          // Debug listener untuk Rekan
          BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
            listenWhen: (prev, curr) =>
            curr.isLoaded && prev.record?.mrekan1Id != curr.record?.mrekan1Id,
            listener: (context, state) {
              final nama = state.record?.rekanNama?.trim();
              final mrekan1Id = state.record?.mrekan1Id;
              final mjnsclientId = state.record?.mjnsclientId; // 👈 ambil di sini

              if (nama != null && nama.isNotEmpty) {
                context.read<UserProfileCubit>().setProfile(
                  nama: nama,
                  mjnsclientId: mjnsclientId, // 👈 simpan juga
                );
              }

              if (mrekan1Id != null && mrekan1Id.isNotEmpty) {
                context.read<MRekanContactCrudBloc>().add(
                  MRekanContactCrudLihatEvent(),
                );
              }
            },
          ),

          BlocListener<EmailVerificationBloc, EmailVerificationState>(
            listenWhen: (prev, curr) =>
            prev.record != curr.record && curr.record != null && !curr.hasFailure,
            listener: (context, state) {
              final record = state.record!;
              if (record.email.isNotEmpty) {
                context.read<RegUserProfileCubit>().setProfile(
                  email: record.email,
                );
              }
            },
          ),


          BlocListener<MRekanContactCrudBloc, MRekanContactCrudState>(
            listenWhen: (prev, curr) =>
            curr.isLoaded && prev.record != curr.record,
            listener: (context, state) {
              final email = state.record?.email?.trim() ?? '';
              final telepon = state.record?.telp?.trim() ?? '';

              if (email.isNotEmpty || telepon.isNotEmpty) {
                context.read<UserProfileCubit>().setProfile(
                  email: email,
                  telepon: telepon,
                );
              }
            },
          ),

          // 🌐 Network status listener
          BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();

              if (state is NetworkFailure) {
                messenger.showSnackBar(
                  errorSnackBar("You're not Connected to Internet", icon: Icons.signal_wifi_off),
                );
              } else if (state is NetworkSuccess) {
                messenger.showSnackBar(
                  successSnackBar("You're Connected to Internet", icon: Icons.wifi),
                );
              }
            },
          ),

          // 🔑 Authentication listener
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listenWhen: (_, curr) => curr is AuthenticationAuthenticated,
            listener: (context, state) {
              final s = state as AuthenticationAuthenticated;
              if (s.user.custType == 'C') {
                context.read<MRekan1CrudBloc>().add(MRekan1CrudLihatEvent());
                debugPrint('[Auth→Rekan] Trigger MRekan1CrudLihatEvent()');
              }

              // trigger foto profil sekali
              final fotoState = context.read<ProfileDownloadFotoBloc>().state;
              if (fotoState is! ProfileDownloadFotoLoading &&
                  fotoState is! ProfileDownloadFotoLoaded) {
                context.read<ProfileDownloadFotoBloc>().add(LoadSecureImage());
                debugPrint('[Foto] LoadSecureImage() dipanggil');
              }
            },
          ),

          // 🖼️ Foto profil listener
          BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
            listenWhen: (_, c) => c is ProfileDownloadFotoLoaded,
            listener: (context, state) {
              final bytes = (state as ProfileDownloadFotoLoaded).imageBytes;
              if (bytes.isNotEmpty) {
                context.read<UserProfileCubit>().setProfile(fotoBytes: bytes);
                debugPrint('[Foto] bytes=${bytes.length} -> set ke UserProfileCubit');
              } else {
                debugPrint('[Foto] bytes kosong, skip setProfile()');
              }
            },
          ),
        ],
        child: _App(userRepository: userRepository),
      ),
    ),
  );
}

class _App extends StatelessWidget {
  final UserRepository userRepository;
  const _App({super.key, required this.userRepository});

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
        colorScheme: const ColorScheme.dark(
          primary: primaryBlackColor,
          secondary: primaryLightColor,
        ),
      ),
      themeMode: ThemeMode.dark,
      // home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      //   builder: (context, state) {
      //     if (state is AuthenticationAuthenticated) {
      //       return HomeTabWidget(userRepository: userRepository);
      //     }
      //     if (state is AuthenticationUnauthenticated) {
      //       return const LoginClient();
      //     }
      //     return const LoadingIndicator();
      //   },
      // ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // ✅ Tutup semua popup
            while (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            final user = state.user; // ambil user dari state

            if (user.custType == 'C') {
              // 🔹 Client → simpan ke UserProfileCubit
              context.read<UserProfileCubit>().setProfile(
                nama: user.nama,
                email: user.email,
                telepon: user.hp,
                // kalau ada foto profil di user, tinggal masukkan juga
              );
            } else if (user.custType == 'U') {
              // 🔹 User baru → simpan ke RegUserProfileCubit
              context.read<RegUserProfileCubit>().setProfile(
                email: user.email,
                // tambahin field lain kalau ada di RegUserProfileCubit
              );
            }

            context.read<RegUserProfileCubit>().setProfile(
              email: user.email,
              // tambahin field lain kalau ada di RegUserProfileCubit
            );


            // ✅ Setelah data Cubit keisi → load HomeTabWidget
            return HomeTabWidget(userRepository: userRepository);
          }

          if (state is AuthenticationUnauthenticated) {
            context.read<UserProfileCubit>().clearProfile();
            context.read<RegUserProfileCubit>().clearProfile();
            return const LoginUser();
          }
          if (state is AuthenticationRequireLoginClient) {
            return const LoginClient(); // atau bikin LoginClientPage khusus
          }
          if (state is AuthenticationRequireRegisterClient) {
            return const RegisterClient();
          }
          if (state is AuthenticationForgotPassword) {
            // return const ForgotPasswordPage();
          }
          if (state is AuthenticationRequirePinHPVerification) {
            // context.read<AuthenticationBloc>().add(LoggedOut());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => PopupClientWidget(phoneNumber: state.hpno),
                ),
              );
            });

            // return HomeTabWidget(userRepository: userRepository);
          }
          if (state is AuthenticationRequirePinEmailVerification) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => PopupUserWidget(email: state.email),
                ),
              );
            });
            // return PopupUserWidget(email: state.email);
          }
          if (state is AuthenticationPhonePinVerified) {
            // contoh: paksa logout lalu balik ke login
            context.read<AuthenticationBloc>().add(LoggedOut());
            return const LoginClient();
          }

          if (state is AuthenticationRequirePinHPVerification) {
            while (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          }

          // default → loading
          return const LoadingIndicator();
        },
      ),
    );
  }
}
