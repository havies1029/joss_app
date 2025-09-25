import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanbanklist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/blocs/gen_trslog/trslogcari_bloc.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/login/mobile/client/widget/popup_client_widget.dart';
import 'package:joss_app/pages/login/mobile/user/login_user_page.dart';
import 'package:joss_app/pages/login/mobile/user/widget/popup_user_widget.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/rekan_pajak.dart';
import 'package:joss_app/pages/register/mobile/client/register_client_page.dart';
import 'package:joss_app/pages/startpage/mobile/startpage.dart';
import 'package:joss_app/repositories/gen_klaim/klaim1crud_repository.dart';
import 'package:joss_app/repositories/gen_klaim/klaim2crud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanbankcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralcmpcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralidvcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpajakcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiccrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';
import 'package:joss_app/repositories/gen_sppamv/sppamvcrud_repository.dart';
import 'package:joss_app/repositories/gen_sppapar/sppaparcrud_repository.dart';
import 'package:joss_app/repositories/reguser/reguser_repository.dart';
import 'package:joss_app/repositories/simulmv/simulmvcrud_repository.dart';
import 'package:joss_app/repositories/simulpar/simulparcrud_repository.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_screen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/gallery/galleryeventcari_bloc.dart';

import 'blocs/gallery/gallerymembercari_bloc.dart';
import 'blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import 'blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'blocs/gen_aset_par/asetparcari_bloc.dart';
import 'blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'blocs/gen_berita/berita1cari_bloc.dart';
import 'blocs/gen_berita/berita2cari_bloc.dart';
import 'blocs/gen_berita/berita3cari_bloc.dart';
import 'blocs/gen_berita/beritakecilcari_bloc.dart';
import 'blocs/gen_berita/beritalaincari_bloc.dart';
import 'blocs/gen_klaim/klaim1crud_bloc.dart';
import 'blocs/gen_klaim/klaim1list_bloc.dart';
import 'blocs/gen_klaim/klaim2crud_bloc.dart';
import 'blocs/gen_promo/promo1cari_bloc.dart';
import 'blocs/gen_promo/promo2cari_bloc.dart';
import 'blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'blocs/gen_sppamv/sppamvlist_bloc.dart';
import 'blocs/gen_sppapar/sppaparcrud_bloc.dart';
import 'blocs/gen_sppapar/sppaparlist_bloc.dart';
import 'blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'blocs/klaim/klaim2list_bloc.dart';
import 'blocs/gen_profile/mrekanbankcrud_bloc.dart';
import 'blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import 'blocs/gen_profile/mrekanpajakcrud_bloc.dart';
import 'blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'blocs/local_prefs/article_selection_cubit.dart';
import 'blocs/reguser_profile/reguser_profile_cubit.dart';
import 'blocs/gen_review/reviewcari_bloc.dart';
import 'blocs/simulmv/simulmvcrud_bloc.dart';
import 'blocs/simulpar/simulparcrud_bloc.dart';
import 'helper/app_prefs.dart';

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
  final prefs = await SharedPreferences.getInstance();
  final appPrefs = AppPrefs(prefs);
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

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
        BlocProvider(create: (_) => GalleryeventCariBloc()..add(RefreshGalleryeventCariEvent())),
        BlocProvider(create: (_) => ReviewCariBloc()..add(RefreshReviewCariEvent())),
        BlocProvider(create: (_) => GallerymemberCariBloc()..add(RefreshGallerymemberCariEvent())),
        BlocProvider(create: (_) => RegUserProfileCubit()),
        BlocProvider(create: (_) => GalleryeventCariBloc()..add(RefreshGalleryeventCariEvent())),
        BlocProvider(
          create: (_) => Berita1CariBloc()..add(RefreshBerita1CariEvent(1)),
        ),
        BlocProvider(
          create: (_) => BeritaKecilCariBloc()..add(RefreshBeritaKecilCariEvent(2)),
        ),
        BlocProvider(
          create: (_) => BeritaLainCariBloc()..add(RefreshBeritaLainCariEvent(3)),
        ),
        BlocProvider(create: (_) => Berita2CariBloc()),
        BlocProvider(create: (_) => Berita3CariBloc()),
        BlocProvider<ArticleSelectionCubit>(
          create: (_) => ArticleSelectionCubit(appPrefs),
        ),
        BlocProvider(create: (_) => TrslogCariBloc()),
        BlocProvider<Klaim1ListBloc>(
            create: (context) =>
                Klaim1ListBloc()),
        BlocProvider<Klaim2ListBloc>(
            create: (context) =>
                Klaim2ListBloc()),
        BlocProvider<MRekanBankListBloc>(
            create: (context) =>
                MRekanBankListBloc()),
        BlocProvider<MRekanBankCrudBloc>(
          create: (context) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository()),
        ),
        BlocProvider<Klaim1CrudBloc>(
          create: (context) => Klaim1CrudBloc(repository: Klaim1CrudRepository()),
        ),
        BlocProvider<Klaim2CrudBloc>(
          create: (context) => Klaim2CrudBloc(repository: Klaim2CrudRepository()),
        ),
        BlocProvider(create: (context) => StatusAsetCariBloc()),
        BlocProvider<AsetRingkasanCariBloc>(create: (context) => AsetRingkasanCariBloc()),
        BlocProvider<AsetParCariBloc>(
            create: (context) => AsetParCariBloc()),
        BlocProvider<AsetMvCariBloc>(
            create: (context) => AsetMvCariBloc()),
        BlocProvider<AsetHealthCariBloc>(
            create: (context) => AsetHealthCariBloc()),
        BlocProvider<AsetDashboardCariBloc>(create: (context) => AsetDashboardCariBloc()),
        BlocProvider(create: (context) => Promo1CariBloc()),
        BlocProvider(create: (context) => Promo2CariBloc()),
        BlocProvider(create:(context) => SppamvListBloc()),
        BlocProvider(create: (context) => SppamvCrudBloc(repository: SppamvCrudRepository())),
        BlocProvider(create: (context) => SppaparListBloc()),
        BlocProvider(create: (context) => SppaparCrudBloc(repository: SppaparCrudRepository())),
        BlocProvider<SimulmvCrudBloc>(
            create: (context) =>
                SimulmvCrudBloc(repository: SimulmvCrudRepository())),
        BlocProvider<SimulparCrudBloc>(
            create: (context) =>
                SimulparCrudBloc(repository: SimulparCrudRepository())),
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
                  mrekan1Id : mrekan1Id,
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

          // 🖼 Foto profil listener
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
        child: _App(
          userRepository: userRepository,
          seenOnboarding: seenOnboarding,
        ),
      ),
    ),
  );
}
class _App extends StatefulWidget {
  final UserRepository userRepository;
  final bool seenOnboarding;

  const _App({
    super.key,
    required this.userRepository,
    required this.seenOnboarding,
  });

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  late bool _showOnboarding;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _showOnboarding = !widget.seenOnboarding;
  }

  void _onOnboardingCompleted() {
    setState(() {
      _showOnboarding = false;
    });
  }

  // 🔹 Helper untuk buka popup biar gak nulis ulang
  Future<void> _showPopup(Widget page) async {
    await _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // OTP via HP
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) =>
          curr is AuthenticationRequirePinHPVerification,
          listener: (_, state) {
            if (state is AuthenticationRequirePinHPVerification) {
              _showPopup(
                PopupClientWidget(phoneNumber: state.hpno),
              );
            }
          },
        ),

        // OTP via Email
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) =>
          curr is AuthenticationRequirePinEmailVerification,
          listener: (_, state) {
            if (state is AuthenticationRequirePinEmailVerification) {
              _showPopup(
                PopupUserWidget(email: state.email),
              );
            }
          },
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey, // 🔥 Fix error Navigator
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
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'chat':
              return MaterialPageRoute(
                builder: (_) => const MobileChatScreen(), // dari SDK Mekari
              );
            default:
              return null;
          }
        },
        home: _showOnboarding
            ? StartScreen(onCompleted: _onOnboardingCompleted)
            : BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              // ✅ Tutup semua popup lama
              while (_navigatorKey.currentState?.canPop() ?? false) {
                _navigatorKey.currentState?.pop();
              }

              final user = state.user;

              if (user.custType == 'C') {
                context.read<UserProfileCubit>().setProfile(
                  nama: user.nama,
                  email: user.email,
                  telepon: user.hp,
                );
              } else if (user.custType == 'U') {
                context.read<RegUserProfileCubit>().setProfile(
                  email: user.email,
                );
              }

              return HomeTabWidget(
                userRepository: widget.userRepository,
              );
            }


            if (state is AuthenticationGoogleUserAuthenticated) {
              while (_navigatorKey.currentState?.canPop() ?? false) {
                _navigatorKey.currentState?.pop();
              }

              return HomeTabWidget(
                userRepository: widget.userRepository,
              );
            }


            if (state is AuthenticationUnauthenticated) {
              context.read<UserProfileCubit>().clearProfile();
              context.read<RegUserProfileCubit>().clearProfile();
              context.read<LoginBloc>().add(LoginReset());
              return const LoginUser();
            }

            if (state is AuthenticationRequireLoginClient) {
              return const LoginClient();
            }

            if (state is AuthenticationRequireRegisterClient) {
              return const RegisterClient();
            }

            if (state is AuthenticationForgotPassword) {
              // return const ForgotPasswordPage();
            }

            // if (state is AuthenticationPhonePinVerified) {
            //   context.read<AuthenticationBloc>().add(LoggedOut());
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            //       MaterialPageRoute(builder: (_) => const LoginClient()),
            //           (route) => false,
            //     );
            //   });
            //
            //   // Langsung tampilkan halaman login biar smooth
            //   return const LoginClient();
            // }

            if (state is AuthenticationPhonePinVerified) {

              while (_navigatorKey.currentState?.canPop() ?? false) {
                _navigatorKey.currentState?.pop();
              }
              // 🚀 OTP sukses → langsung logout biar state balik ke Unauthenticated
              context.read<AuthenticationBloc>().add(LoggedOut());
              return const LoadingIndicator();
            }

            // if (state is AuthenticationPhonePinVerified) {
            //   final userRepo = widget.userRepository;
            //   context.read<AuthenticationBloc>().add(LoggedOut());
            //   // 🚀 login ulang (future supaya ga blocking)
            //   Future.microtask(() async {
            //     final token = await userRepo.getToken();
            //     final user = await userRepo.getUserByToken(token);
            //     context.read<AuthenticationBloc>().add(LoggedIn(user: user));
            //   });
            //
            //   // tampilkan indikator sementara
            //   return const LoadingIndicator();
            // }
            // default → loading
            return const LoadingIndicator();
          },
        ),
      ),
    );
  }
}