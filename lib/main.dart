// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
// import 'package:joss_app/blocs/gen_calmv/calmv1list_bloc.dart';
// import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
// import 'package:joss_app/blocs/gen_cob_app/cobmanpol_bloc.dart';
// import 'package:joss_app/blocs/gen_dn1/dn1cari_bloc.dart';
// import 'package:joss_app/blocs/gen_endors/endors2cari_bloc.dart';
// import 'package:joss_app/blocs/gen_profile/mrekanbanklist_bloc.dart';
// import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
// import 'package:joss_app/blocs/gen_trslog/trslogcari_bloc.dart';
// import 'package:joss_app/blocs/local_prefs/simulasi_mv_local_cubit.dart';
// import 'package:joss_app/blocs/local_prefs/simulasi_par_local_cubit.dart';
// import 'package:joss_app/blocs/regendors/regendors1form_bloc.dart';
// import 'package:joss_app/blocs/regendors/regendorscari_bloc.dart';
// import 'package:joss_app/blocs/regreaktif/regreaktif1_bloc.dart';
// import 'package:joss_app/blocs/regrenewal/regrenewcari_bloc.dart';
// import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
// import 'package:joss_app/blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
// import 'package:joss_app/blocs/share_cubit/share_dnsppa_state_cubit.dart';
// import 'package:joss_app/blocs/simulpar/simulparlist_bloc.dart';
// import 'package:joss_app/blocs/user_profile/user_profile_state.dart';
// import 'package:joss_app/pages/base/base_background_sidepage.dart';
// import 'package:joss_app/pages/login/mobile/client/widget/otp_client_widget.dart';
// import 'package:joss_app/pages/login/mobile/user/login_user_page.dart';
// import 'package:joss_app/pages/login/mobile/user/widget/otp_user_widget.dart';
// import 'package:joss_app/pages/profile/mobile/profile/form_section/rekan_pajak.dart';
// import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';
// import 'package:joss_app/pages/register/mobile/client/register_client_page.dart';
// import 'package:joss_app/pages/startpage/mobile/startpage.dart';
// import 'package:joss_app/repositories/calpar/calpar1crud_repository.dart';
// import 'package:joss_app/repositories/calpar/calpar2form_repository.dart';
// import 'package:joss_app/repositories/calpar/calpar3form_repository.dart';
// import 'package:joss_app/repositories/calpar/calpar4form_repository.dart';
// import 'package:joss_app/repositories/gen_calmv/calmv1crud_repository.dart';
// import 'package:joss_app/repositories/gen_calmv/calmv2form_repository.dart';
// import 'package:joss_app/repositories/gen_calmv/calmv3form_repository.dart';
// import 'package:joss_app/repositories/gen_compro/reqcompro_repository.dart';
// import 'package:joss_app/repositories/gen_dn1/dn1cari_repository.dart';
// import 'package:joss_app/repositories/gen_endors/endors1crud_repository.dart';
// import 'package:joss_app/repositories/gen_invite/invite_repository.dart';
// import 'package:joss_app/repositories/gen_klaim/klaim1crud_repository.dart';
// import 'package:joss_app/repositories/gen_klaim/klaim2crud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekanbankcrud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekangeneralcmpcrud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekangeneralidvcrud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekanpajakcrud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekanpiccrud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv1crud_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv2form_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv3form_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv4form_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv5form_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv6form_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv7form_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv_download_fotoacc_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv_download_fotomobil_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv_download_stnk_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_acc_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_mobil_repository.dart';
// import 'package:joss_app/repositories/gen_regmv/regmv_upload_stnk_repository.dart';
// import 'package:joss_app/repositories/gen_sppamv/download_polis_repository.dart';
// import 'package:joss_app/repositories/gen_sppamv/sppamvcrud_repository.dart';
// import 'package:joss_app/repositories/gen_sppapar/sppaparcrud_repository.dart';
// import 'package:joss_app/repositories/payment/invbayarvaform_repository.dart';
// import 'package:joss_app/repositories/payment/pay1crud_repository.dart';
// import 'package:joss_app/repositories/payment/paymentdn_repository.dart';
// import 'package:joss_app/repositories/payment/paymentmethodcari_repository.dart';
// import 'package:joss_app/repositories/regendors/regendors1form_repository.dart';
// import 'package:joss_app/repositories/regklaim/picker_repository.dart';
// import 'package:joss_app/repositories/regklaim/regklaim1crud_repository.dart';
// import 'package:joss_app/repositories/regklaim/sppaheader_repository.dart';
// import 'package:joss_app/repositories/regklaim/upload_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar1crud_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar2form_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar3form_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar4form_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar5form_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar6form_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar_download_fotoobject_repository.dart';
// import 'package:joss_app/repositories/regpar/regpar_upload_fotoobject_repository.dart';
// import 'package:joss_app/repositories/regreaktif/regreaktif1_repository.dart';
// import 'package:joss_app/repositories/regrenewal/regrenew1form_repository.dart';
// import 'package:joss_app/repositories/reguser/reguser_repository.dart';
// import 'package:joss_app/repositories/simulmv/simulmvcrud_repository.dart';
// import 'package:joss_app/repositories/simulpar/simulparcrud_repository.dart';
// import 'package:joss_app/repositories/simulpar/simulparlist_repository.dart';
// import 'package:mobile_chat_flutter/presentation/mobile_chat_screen.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/common/loading_indicator.dart';
// import 'package:joss_app/pages/home/home_tab_widget.dart';
// import 'package:joss_app/pages/login/mobile/client/login_client_page.dart';
//
// import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
// import 'package:joss_app/blocs/login/login_bloc.dart';
// import 'package:joss_app/blocs/login/emailverification_bloc.dart';
// import 'package:joss_app/blocs/login/change_password_bloc.dart';
// import 'package:joss_app/blocs/networkconnection/network_bloc.dart';
// import 'package:joss_app/blocs/profile/profile_download_foto_bloc.dart';
// import 'package:joss_app/blocs/profile/profile_upload_foto_bloc.dart';
// import 'package:joss_app/blocs/gen_profile/mrekan1crud_bloc.dart';
// import 'package:joss_app/blocs/gen_profile/mrekan1list_bloc.dart';
// import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
// import 'package:joss_app/blocs/gen_profile/mrekancontactlist_bloc.dart';
// import 'package:joss_app/blocs/user_profile/user_profile_cubit.dart';
//
// import 'package:joss_app/repositories/user/user_repository.dart';
// import 'package:joss_app/repositories/login/emailverification_repository.dart';
// import 'package:joss_app/repositories/login/change_password_repository.dart';
// import 'package:joss_app/repositories/profile/userfoto_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekan1crud_repository.dart';
// import 'package:joss_app/repositories/gen_profile/mrekancontactcrud_repository.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'apis/payment/paymentdn_api.dart';
// import 'apis/payment/paymentmethodcari_api.dart';
// import 'blocs/asetothers/asetotherscari_bloc.dart';
// import 'blocs/asettracking/asettrackcari_bloc.dart';
// import 'blocs/calpar/calpar1crud_bloc.dart';
// import 'blocs/calpar/calpar1list_bloc.dart';
// import 'blocs/calpar/calpar2form_bloc.dart';
// import 'blocs/calpar/calpar3form_bloc.dart';
// import 'blocs/calpar/calpar4form_bloc.dart';
// import 'blocs/calpar/calpar_flow_bloc.dart';
// import 'blocs/gallery/galleryeventcari_bloc.dart';
//
// import 'blocs/gallery/gallerymembercari_bloc.dart';
// import 'blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
// import 'blocs/gen_aset_health/asethealthcari_bloc.dart';
// import 'blocs/gen_aset_hull/asethullcari_bloc.dart';
// import 'blocs/gen_aset_mv/asetmvcari_bloc.dart';
// import 'blocs/gen_aset_par/asetparcari_bloc.dart';
// import 'blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
// import 'blocs/gen_berita/berita1cari_bloc.dart';
// import 'blocs/gen_berita/berita2cari_bloc.dart';
// import 'blocs/gen_berita/berita3cari_bloc.dart';
// import 'blocs/gen_berita/beritakecilcari_bloc.dart';
// import 'blocs/gen_berita/beritalaincari_bloc.dart';
// import 'blocs/gen_calmv/calmv3form_bloc.dart';
// import 'blocs/gen_calmv/calmv_flow_bloc.dart';
// import 'blocs/gen_cob_app/cobcari_bloc.dart';
// import 'blocs/gen_compro/reqcompro_bloc.dart';
// import 'blocs/gen_endors/endors1crud_bloc.dart';
// import 'blocs/gen_endors/endors1list_bloc.dart';
// import 'blocs/gen_invite/invite_bloc.dart';
// import 'blocs/gen_klaim/klaim1crud_bloc.dart';
// import 'blocs/gen_klaim/klaim1list_bloc.dart';
// import 'blocs/gen_klaim/klaim2crud_bloc.dart';
// import 'blocs/gen_profile/rekanpiccobcari_bloc.dart';
// import 'blocs/gen_promo/promo1cari_bloc.dart';
// import 'blocs/gen_promo/promo2cari_bloc.dart';
// import 'blocs/gen_regmv/polis_tanggal_bloc.dart';
// import 'blocs/gen_regmv/regmv1crud_bloc.dart';
// import 'blocs/gen_regmv/regmv1list_bloc.dart';
// import 'blocs/gen_regmv/regmv2form_bloc.dart';
// import 'blocs/gen_regmv/regmv3form_bloc.dart';
// import 'blocs/gen_regmv/regmv4cari_bloc.dart';
// import 'blocs/gen_regmv/regmv4form_bloc.dart';
// import 'blocs/gen_regmv/regmv5cari_bloc.dart';
// import 'blocs/gen_regmv/regmv5form_bloc.dart';
// import 'blocs/gen_regmv/regmv6form_bloc.dart';
// import 'blocs/gen_regmv/regmv7cari_bloc.dart';
// import 'blocs/gen_regmv/regmv7form_bloc.dart';
// import 'blocs/gen_regmv/regmv_download_foto_acc_bloc.dart';
// import 'blocs/gen_regmv/regmv_download_foto_mobil_bloc.dart';
// import 'blocs/gen_regmv/regmv_download_foto_stnk_bloc.dart';
// import 'blocs/gen_regmv/regmv_flow_bloc.dart';
// import 'blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
// import 'blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
// import 'blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
// import 'blocs/gen_sppamv/sppa_download_polis_bloc.dart';
// import 'blocs/gen_sppamv/sppamvcrud_bloc.dart';
// import 'blocs/gen_sppamv/sppamvlist_bloc.dart';
// import 'blocs/gen_sppapar/sppaparcrud_bloc.dart';
// import 'blocs/gen_sppapar/sppaparlist_bloc.dart';
// import 'blocs/gen_status_aset/statusasetcari_bloc.dart';
// import 'blocs/klaim/klaim2list_bloc.dart';
// import 'blocs/gen_profile/mrekanbankcrud_bloc.dart';
// import 'blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
// import 'blocs/gen_profile/mrekanpajakcrud_bloc.dart';
// import 'blocs/gen_profile/mrekanpiccrud_bloc.dart';
// import 'blocs/gen_profile/mrekanpiclist_bloc.dart';
// import 'blocs/loading_flow/loading_flow_bloc.dart';
// import 'blocs/local_prefs/article_selection_cubit.dart';
// import 'blocs/payment/dnrekap2inv_bloc.dart';
// import 'blocs/payment/historybayar2cari_bloc.dart';
// import 'blocs/payment/historybayarcari_bloc.dart';
// import 'blocs/payment/invbayarvaform_bloc.dart';
// import 'blocs/payment/pay1crud_bloc.dart';
// import 'blocs/payment/pay1list_bloc.dart';
// import 'blocs/payment/pay2cari_bloc.dart';
// import 'blocs/payment/paymentmethodcari_bloc.dart';
// import 'blocs/regendors/regendors2cari_bloc.dart';
// import 'blocs/regklaim/attach_bloc.dart';
// import 'blocs/regklaim/cobklaimcari_bloc.dart';
// import 'blocs/regklaim/polissourcecari_bloc.dart';
// import 'blocs/regklaim/regklaim1crud_bloc.dart';
// import 'blocs/regklaim/sppaheader_bloc.dart';
// import 'blocs/regklaim/sppapoliscari_bloc.dart';
// import 'blocs/regother/regother3cari_bloc.dart';
// import 'blocs/regpar/regpar1crud_bloc.dart';
// import 'blocs/regpar/regpar1list_bloc.dart';
// import 'blocs/regpar/regpar2form_bloc.dart';
// import 'blocs/regpar/regpar3form_bloc.dart';
// import 'blocs/regpar/regpar4form_bloc.dart';
// import 'blocs/regpar/regpar5form_bloc.dart';
// import 'blocs/regpar/regpar6cari_bloc.dart';
// import 'blocs/regpar/regpar6form_bloc.dart';
// import 'blocs/regpar/regpar_download_foto_object_bloc.dart';
// import 'blocs/regpar/regpar_flow_bloc.dart';
// import 'blocs/regpar/regpar_upload_foto_object_bloc.dart';
// import 'blocs/regreaktif/regreaktif2cari_bloc.dart';
// import 'blocs/regreaktif/regreaktifcari_bloc.dart';
// import 'blocs/regrenewal/regrenew1form_bloc.dart';
// import 'blocs/regrenewal/regrenewal2cari_bloc.dart';
// import 'blocs/reguser_profile/reguser_profile_cubit.dart';
// import 'blocs/gen_review/reviewcari_bloc.dart';
// import 'blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
// import 'blocs/share_cubit/share_health_state_cubit.dart';
// import 'blocs/share_cubit/share_hull_state_cubit.dart';
// import 'blocs/share_cubit/share_mv_state_cubit.dart';
// import 'blocs/share_cubit/share_par_state_cubit.dart';
// import 'blocs/simulmv/simulmvcrud_bloc.dart';
// import 'blocs/simulpar/simulparcrud_bloc.dart';
// import 'blocs/hasil_simul_par_cubit/hasil_simul_par_cubit.dart';
// import 'blocs/share_cubit/share_ringkasan_state_cubit.dart';
// import 'package:joss_app/blocs/hasil_simul_mv_cubit/hasil_simul_mv_cubit.dart';
// import 'helper/app_prefs.dart';
// import 'models/reguser/reguser_model.dart';
// import 'blocs/regother/regother1crud_bloc.dart';
// import 'blocs/regother/regother1list_bloc.dart';
// import 'blocs/regother/regother2form_bloc.dart';
//
//
// import 'package:joss_app/repositories/regother/regother1crud_repository.dart';
// import 'package:joss_app/repositories/regother/regother2form_repository.dart';
//
// import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
// import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
// import 'package:joss_app/blocs/payment/dnsppamvcari_bloc.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   HydratedBloc.storage = await HydratedStorage.build(
//     storageDirectory:
//     kIsWeb
//         ? HydratedStorageDirectory.web
//         : HydratedStorageDirectory(
//       (await getApplicationDocumentsDirectory()).path,
//     ),
//   );
//
//   final userRepository = UserRepository();
//   final prefs = await SharedPreferences.getInstance();
//   final appPrefs = AppPrefs(prefs);
//   final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
//
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
//         ),
//         BlocProvider<SimulasiParLocalCubit>(
//           create: (_) => SimulasiParLocalCubit(appPrefs),
//         ),
//         BlocProvider<SimulasiMvLocalCubit>(
//           create: (_) => SimulasiMvLocalCubit(appPrefs),
//         ),
//         BlocProvider(
//           create: (ctx) => LoginBloc(
//             authenticationBloc: ctx.read<AuthenticationBloc>(),
//             userRepository: userRepository,
//             emailVerificationBloc: EmailVerificationBloc(repository: EmailVerificationRepository(), authenticationBloc: AuthenticationBloc(userRepository: userRepository)),
//           ),
//         ),
//         // BlocProvider(
//         //   create: (ctx) => EmailVerificationBloc(
//         //     repository: EmailVerificationRepository(),
//         //     authenticationBloc: ctx.read<AuthenticationBloc>(),
//         //   ),
//         // ),
//         BlocProvider(create: (_) => ChangePasswordBloc(repository: ChangePasswordRepository())),
//         BlocProvider(create: (_) => NetworkBloc()..add(NetworkObserve())),
//         BlocProvider(create: (_) => ProfileUploadFotoBloc()),
//         BlocProvider(create: (_) => ProfileDownloadFotoBloc(repository: UserFotoRepository())),
//         BlocProvider(create: (_) => MRekan1CrudBloc(repository: MRekan1CrudRepository())),
//         BlocProvider<EmailVerificationBloc>(
//             create: (context) =>
//                 EmailVerificationBloc(
//                     repository: EmailVerificationRepository(),
//                     authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
//         BlocProvider<RegUserBloc>(
//             create: (context) =>
//                 RegUserBloc(repository: RegUserRepository(), authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
//         BlocProvider(create: (_) => MRekan1ListBloc()),
//         BlocProvider(create: (_) => Calmv1ListBloc()),
//         BlocProvider(create: (_) => MRekanContactCrudBloc(repository: MRekanContactCrudRepository())),
//         BlocProvider(create: (_) => MRekanContactListBloc()),
//         BlocProvider(create: (_) => MRekanPajakCrudBloc(repository: MRekanPajakCrudRepository())),
//         BlocProvider(create: (_) => Calmv1CrudBloc(repository: Calmv1CrudRepository())),
//         BlocProvider(create: (_) => Calmv2FormBloc(repository: Calmv2FormRepository())),
//         BlocProvider(create: (_) => Calmv3FormBloc(repository: Calmv3FormRepository())),
//         BlocProvider(create: (_) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository())),
//         BlocProvider(create: (_) => MRekanGeneralIdvCrudBloc(repository: MRekanGeneralIdvCrudRepository())),
//         BlocProvider(create: (_) => MRekanGeneralCmpCrudBloc(repository: MRekanGeneralCmpCrudRepository())),
//         BlocProvider<MRekanPicListBloc>(
//           create: (context) => MRekanPicListBloc(repository: MRekanPicListRepository())..add(FetchMRekanPicListEvent()),
//         ),
//         BlocProvider<MRekanPicCrudBloc>(
//           create: (context) => MRekanPicCrudBloc(repository: MRekanPicCrudRepository()),
//         ),
//         BlocProvider<RekanPicCobCariBloc>(create: (context) => RekanPicCobCariBloc()),
//         BlocProvider<ReqComproBloc>(
//           create: (_) => ReqComproBloc(repository: ReqComproRepository()),
//         ),
//         // BlocProvider(create: (_) => UserProfileCubit()), // hydrated
//         BlocProvider(create: (_) => ShareRingkasanStateCubit()), // hydrated
//         BlocProvider(create: (_) => ShareParStateCubit()), // hydrated
//         BlocProvider(create: (_) => ShareMvStateCubit()), // hydrated
//         BlocProvider(create: (_) => ShareHealthStateCubit()), // hydrated
//         BlocProvider(create: (_) => ShareHullStateCubit()), // hydrated
//
//         BlocProvider(create: (_) => HasilSimulMvCubit()), // hydrated
//         BlocProvider(create: (_) => HasilSimulParCubit()), // hydrated
//
//         BlocProvider(create: (_) => Regother2FormBloc(repository: Regother2FormRepository())),
//         BlocProvider(create: (_) => Regother1CrudBloc(repository: Regother1CrudRepository())),
//         BlocProvider(create: (_) => Regother1ListBloc()),
//
//         BlocProvider(create: (context) => DnrekapcobCariBloc()),
//         BlocProvider(create: (context) => DnsppamvCariBloc()),
//         BlocProvider(create: (context) => PaymentMethodCariBloc(repository: PaymentDnRepository(api: PaymentDnAPI()))),
//         BlocProvider(create: (context) => DnRekap2invBloc()),
//         BlocProvider(create: (context) => InvbayarvaFormBloc(repository: InvbayarvaFormRepository())),
//         BlocProvider(create:  (context) => Pay1ListBloc()),
//         BlocProvider(create: (context) => Pay1CrudBloc(repository: Pay1CrudRepository())),
//         BlocProvider(create: (context) => Pay2CariBloc()),
//         BlocProvider(create: (_) => GalleryeventCariBloc()..add(RefreshGalleryeventCariEvent())),
//         BlocProvider(create: (_) => ReviewCariBloc()..add(RefreshReviewCariEvent())),
//         BlocProvider(create: (_) => GallerymemberCariBloc()..add(RefreshGallerymemberCariEvent())),
//
//         BlocProvider(create:  (context) => Endors1ListBloc()),
//         BlocProvider(create: (context) => Endors1CrudBloc(repository: Endors1CrudRepository())),
//         BlocProvider(create: (context) => RegendorsCariBloc()),
//         BlocProvider(create: (context) => Regendors1FormBloc(repository: Regendors1FormRepository())),
//         // BlocProvider(create: (_) => RegUserProfileCubit()),
//         BlocProvider(
//           create: (_) => Berita1CariBloc()..add(RefreshBerita1CariEvent(1)),
//         ),
//         BlocProvider(
//           create: (_) => BeritaKecilCariBloc()..add(RefreshBeritaKecilCariEvent(2)),
//         ),
//         BlocProvider(
//           create: (_) => BeritaLainCariBloc()..add(RefreshBeritaLainCariEvent(3)),
//         ),
//         BlocProvider(create: (_) => Berita2CariBloc()),
//         BlocProvider(create: (_) => Berita3CariBloc()),
//         BlocProvider<ArticleSelectionCubit>(
//           create: (_) => ArticleSelectionCubit(appPrefs),
//         ),
//         BlocProvider(create: (_) => TrslogCariBloc()),
//         BlocProvider<Klaim1ListBloc>(
//             create: (context) =>
//                 Klaim1ListBloc()),
//         BlocProvider<Klaim2ListBloc>(
//             create: (context) =>
//                 Klaim2ListBloc()),
//         BlocProvider<MRekanBankListBloc>(
//             create: (context) =>
//                 MRekanBankListBloc()),
//         BlocProvider<MRekanBankCrudBloc>(
//           create: (context) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository()),
//         ),
//         BlocProvider<Klaim1CrudBloc>(
//           create: (context) => Klaim1CrudBloc(repository: Klaim1CrudRepository()),
//         ),
//         BlocProvider<Klaim2CrudBloc>(
//           create: (context) => Klaim2CrudBloc(repository: Klaim2CrudRepository()),
//         ),
//         BlocProvider(create: (context) => StatusAsetCariBloc()),
//         BlocProvider<AsethullCariBloc>(create: (context) => AsethullCariBloc()),
//         BlocProvider<AsetRingkasanCariBloc>(create: (context) => AsetRingkasanCariBloc()),
//         BlocProvider<AsetParCariBloc>(
//             create: (context) => AsetParCariBloc()),
//         BlocProvider<AsetMvCariBloc>(
//             create: (context) => AsetMvCariBloc()),
//         BlocProvider<AsetHealthCariBloc>(
//             create: (context) => AsetHealthCariBloc()),
//         BlocProvider<AsetothersCariBloc>(
//             create: (context) => AsetothersCariBloc()),
//         BlocProvider<AsetDashboardCariBloc>(create: (context) => AsetDashboardCariBloc()),
//         BlocProvider(create: (context) => Promo1CariBloc()),
//         BlocProvider(create: (context) => Promo2CariBloc()),
//         BlocProvider(create:(context) => SppamvListBloc()),
//         BlocProvider(create: (context) => SppamvCrudBloc(repository: SppamvCrudRepository())),
//         BlocProvider(create: (context) => SppaparListBloc()),
//         BlocProvider(create: (context) => SppaparCrudBloc(repository: SppaparCrudRepository())),
//         BlocProvider(create: (context) => SimulparListBloc()),
//         BlocProvider<SimulmvCrudBloc>(
//             create: (context) =>
//                 SimulmvCrudBloc(repository: SimulmvCrudRepository())),
//         BlocProvider<SimulparCrudBloc>(
//             create: (context) =>
//                 SimulparCrudBloc(repository: SimulparCrudRepository())),
//         BlocProvider<CobCariBloc>(
//             create: (context) => CobCariBloc()),
//         BlocProvider<Dn1CariBloc>(create: (context) => Dn1CariBloc()),
//         BlocProvider(create: (context) => InviteBloc(repo: InviteRepository())),
//         BlocProvider(create: (context) => Endors1ListBloc()),
//         BlocProvider(create: (context) => Endors2CariBloc()),
//         BlocProvider(create:(context) => Regmv1ListBloc()),
//         BlocProvider(create:(context) => Regmv1CrudBloc(repository: Regmv1CrudRepository())),
//         BlocProvider(create:(context) => Regmv2FormBloc(repository: Regmv2FormRepository())),
//         BlocProvider(create:(context) => Regmv3FormBloc(repository: Regmv3FormRepository())),
//         BlocProvider(create:(context) => Regmv4FormBloc(repository: Regmv4FormRepository())),
//         BlocProvider(create:(context) => Regmv5FormBloc(repository: Regmv5FormRepository())),
//         BlocProvider(create:(context) => Regmv6FormBloc(repository: Regmv6FormRepository())),
//         BlocProvider(create:(context) => Regmv7FormBloc(repository: Regmv7FormRepository())),
//
//         BlocProvider(create: (context) => SppamvCrudBloc(repository: SppamvCrudRepository())),
//         BlocProvider(create: (_) => Calpar3FormBloc(repository: Calpar3FormRepository())),
//         BlocProvider(create: (_) => Calpar4FormBloc(repository: Calpar4FormRepository())),
//         BlocProvider(create: (_) => Calpar2FormBloc(repository: Calpar2FormRepository())),
//         BlocProvider(create: (_) => Calpar1CrudBloc(repository: Calpar1CrudRepository())),
//         BlocProvider(create: (_) => Calpar1ListBloc()),
//
//         BlocProvider(create: (context) => RegmvUploadStnkBloc(repository: RegmvUploadStnkRepository())),
//         BlocProvider(create: (context) => RegmvUploadFotoMobilBloc(repository: RegmvUploadFotoMobilRepository())),
//         BlocProvider(create: (context) => RegmvUploadFotoAccBloc(repository: RegmvUploadFotoAccRepository())),
//
//         BlocProvider(create: (context) => Regpar1ListBloc()),
//         BlocProvider(create: (context) => Regpar1CrudBloc(repository: Regpar1CrudRepository())),
//         BlocProvider(create: (context) => Regpar2FormBloc( repository: Regpar2FormRepository())),
//         BlocProvider(create: (context) => Regpar3FormBloc( repository: Regpar3FormRepository())),
//         BlocProvider(create: (context) => Regpar4FormBloc( repository: Regpar4FormRepository())),
//         BlocProvider(create: (context) => Regpar5FormBloc( repository: Regpar5FormRepository())),
//
//         BlocProvider(create: (context) => Regmv4CariBloc()),
//         BlocProvider(create: (context) => RegmvDownloadFotoStnkBloc(repository: RegmvDownloadStnkRepository())),
//         BlocProvider(create: (context) => Regmv5CariBloc()),
//         BlocProvider(create: (context) => RegmvDownloadFotoMobilBloc(repository: RegmvDownloadFotoMobilRepository())),
//         BlocProvider(create: (context) => Regmv7CariBloc()),
//         BlocProvider(create: (context) => RegmvDownloadFotoAccBloc(repository: RegmvDownloadFotoAccRepository())),
//
//         BlocProvider(create: (context) => RegparUploadFotoObjectBloc(repository: RegparUploadFotoObjectRepository())),
//         BlocProvider(create: (context) => RegparDownloadFotoObjectBloc(repository: RegparDownloadFotoObjectRepository())),
//         BlocProvider(create: (context) => Regpar6CariBloc()),
//         BlocProvider(create: (context) => Regpar6FormBloc(repository: Regpar6FormRepository())),
//         BlocProvider(create: (context) => CobManPolBloc()),
//         BlocProvider(create:  (context) => SppaDownloadPolisBloc(repository: DownloadPolisRepository())),
//         BlocProvider<CalmvFlowBloc>(
//           create: (context) => CalmvFlowBloc(
//             calmv1CrudBloc: context.read<Calmv1CrudBloc>(),
//             calmv2FormBloc: context.read<Calmv2FormBloc>(),
//             calmv3FormBloc: context.read<Calmv3FormBloc>(),
//           ),
//         ),
//         BlocProvider<CalparFlowBloc>(
//           create: (context) => CalparFlowBloc(
//             calpar1CrudBloc: context.read<Calpar1CrudBloc>(),
//             calpar2FormBloc: context.read<Calpar2FormBloc>(),
//             calpar3FormBloc: context.read<Calpar3FormBloc>(),
//             calpar4FormBloc: context.read<Calpar4FormBloc>(),
//           ),
//         ),
//         BlocProvider<RegmvFlowBloc>(
//           create: (context) => RegmvFlowBloc(
//             regmv1CrudBloc: context.read<Regmv1CrudBloc>(),
//             regmv2FormBloc: context.read<Regmv2FormBloc>(),
//             regmv3FormBloc: context.read<Regmv3FormBloc>(),
//             regmv6FormBloc: context.read<Regmv6FormBloc>(),
//           ),
//         ),
//         BlocProvider<RegparFlowBloc>(
//           create: (context) => RegparFlowBloc(
//             regpar1CrudBloc: context.read<Regpar1CrudBloc>(),
//             regpar2FormBloc: context.read<Regpar2FormBloc>(),
//             regpar3FormBloc: context.read<Regpar3FormBloc>(),
//             regpar4FormBloc: context.read<Regpar4FormBloc>(),
//             regpar5FormBloc: context.read<Regpar5FormBloc>(),
//           ),
//         ),
//
//         BlocProvider(
//         create: (_) => PolisTanggalBloc()),
//         BlocProvider(create: (context) => RegendorsCariBloc()),
//         BlocProvider(create: (context) => Regendors1FormBloc(repository: Regendors1FormRepository())),
//         BlocProvider(create: (context) => RegrenewCariBloc()),
//         BlocProvider(create: (context) => Regrenew1FormBloc(repository: Regrenew1FormRepository())),
//         BlocProvider(create:  (context) => RegreaktifCariBloc()),
//         BlocProvider(create: (context) => Regreaktif1Bloc(repository: Regreaktif1Repository())),
//         BlocProvider(create: (context) => AsettrackCariBloc()),
//         BlocProvider(create: (context) =>Regendors2CariBloc()),
//         BlocProvider(create:  (context) => Regrenewal2CariBloc()),
//         BlocProvider(create:  (context) => Regreaktif2CariBloc()),
//         BlocProvider(create: (context) => HistorybayarCariBloc()),
//         BlocProvider(create:  (context) => Historybayar2CariBloc()),
//         BlocProvider<LoadingFlowBloc>(
//           create: (context) => LoadingFlowBloc(
//             cobManPolBloc: context.read<CobManPolBloc>(),
//             statusAsetCariBloc: context.read<StatusAsetCariBloc>(),
//             asetRingkasanCariBloc: context.read<AsetRingkasanCariBloc>(),
//             asetParCariBloc: context.read<AsetParCariBloc>(),
//             asetMvCariBloc: context.read<AsetMvCariBloc>(),
//             asethullCariBloc: context.read<AsethullCariBloc>(),
//             asetHealthCariBloc: context.read<AsetHealthCariBloc>(),
//             asetothersCariBloc: context.read<AsetothersCariBloc>(),
//           ),
//         ),
//         BlocProvider(create:  (context) => Regklaim1CrudBloc(repository: Regklaim1CrudRepository())),
//         BlocProvider(create:  (context) => CobklaimcariBloc()),
//         BlocProvider(create:  (context) => SppapoliscariBloc()),
//         BlocProvider(create:  (context) => PolissourcecariBloc()),
//         BlocProvider(create: (context) => Regother3cariBloc()),
//         BlocProvider(create: (context) => SppaHeaderBloc(repository: SppaHeaderRepository())),
//         BlocProvider(create: (context) => AttachBloc(pickerRepo: PickerRepositoryImpl(), uploadRepo: UploadRepositoryImpl(Dio()))),
//       ],
//       child: MultiBlocListener(
//         listeners: [
//           // Debug listener untuk Rekan
//           BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
//             listenWhen: (prev, curr) =>
//             curr.isLoaded && prev.record?.mrekan1Id != curr.record?.mrekan1Id,
//             listener: (context, state) {
//               final nama = state.record?.rekanNama?.trim();
//               final mrekan1Id = state.record?.mrekan1Id;
//               final mjnsclientId = state.record?.mjnsclientId; // 👈 ambil di sini
//
//               // if (nama != null && nama.isNotEmpty) {
//               //   context.read<UserProfileCubit>().setProfile(
//               //     mrekan1Id : mrekan1Id,
//               //     nama: nama,
//               //     mjnsclientId: mjnsclientId, // 👈 simpan juga
//               //   );
//               // }
//
//               if (mrekan1Id != null && mrekan1Id.isNotEmpty) {
//                 context.read<MRekanContactCrudBloc>().add(
//                   MRekanContactCrudLihatEvent(),
//                 );
//               }
//             },
//           ),
//
//           BlocListener<EmailVerificationBloc, EmailVerificationState>(
//             listenWhen: (prev, curr) =>
//             prev.record != curr.record && curr.record != null && !curr.hasFailure,
//             listener: (context, state) {
//               final record = state.record!;
//               // if (record.email.isNotEmpty) {
//               //   context.read<RegUserProfileCubit>().setProfile(
//               //     email: record.email,
//               //     reguserId: record.requestId,
//               //   );
//               // }
//             },
//           ),
//
//
//           BlocListener<MRekanContactCrudBloc, MRekanContactCrudState>(
//             listenWhen: (prev, curr) =>
//             curr.isLoaded && prev.record != curr.record,
//             listener: (context, state) {
//               final email = state.record?.email?.trim() ?? '';
//               final telepon = state.record?.telp?.trim() ?? '';
//
//               // if (email.isNotEmpty || telepon.isNotEmpty) {
//               //   context.read<UserProfileCubit>().setProfile(
//               //     email: email,
//               //     telepon: telepon,
//               //   );
//               // }
//             },
//           ),
//
//           // 🌐 Network status listener
//           BlocListener<NetworkBloc, NetworkState>(
//             listener: (context, state) {
//               final messenger = ScaffoldMessenger.of(context);
//               messenger.clearSnackBars();
//
//               if (state is NetworkFailure) {
//                 messenger.showSnackBar(
//                   errorSnackBar("You're not Connected to Internet", icon: Icons.signal_wifi_off),
//                 );
//               } else if (state is NetworkSuccess) {
//                 messenger.showSnackBar(
//                   successSnackBar("You're Connected to Internet", icon: Icons.wifi),
//                 );
//               }
//             },
//           ),
//
//           // 🔑 Authentication listener
//           BlocListener<AuthenticationBloc, AuthenticationState>(
//             listenWhen: (_, curr) => curr is AuthenticationAuthenticated,
//             listener: (context, state) {
//               final s = state as AuthenticationAuthenticated;
//               if (s.user.userType == 'C') {
//                 context.read<MRekan1CrudBloc>().add(MRekan1CrudLihatEvent());
//                 debugPrint('[Auth→Rekan] Trigger MRekan1CrudLihatEvent()');
//               }
//
//               // trigger foto profil sekali
//               final fotoState = context.read<ProfileDownloadFotoBloc>().state;
//               if (fotoState is! ProfileDownloadFotoLoading &&
//                   fotoState is! ProfileDownloadFotoLoaded) {
//                 context.read<ProfileDownloadFotoBloc>().add(LoadSecureImage());
//                 debugPrint('[Foto] LoadSecureImage() dipanggil');
//               }
//             },
//           ),
//
//           // 🖼 Foto profil listener
//           BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
//             listenWhen: (_, c) => c is ProfileDownloadFotoLoaded,
//             listener: (context, state) {
//               final bytes = (state as ProfileDownloadFotoLoaded).imageBytes;
//               // if (bytes.isNotEmpty) {
//               //   context.read<UserProfileCubit>().setProfile(fotoBytes: bytes);
//               //   debugPrint('[Foto] bytes=${bytes.length} -> set ke UserProfileCubit');
//               // } else {
//               //   debugPrint('[Foto] bytes kosong, skip setProfile()');
//               // }
//             },
//           ),
//         ],
//         child: _App(
//           userRepository: userRepository,
//           seenOnboarding: seenOnboarding,
//         ),
//       ),
//     ),
//   );
// }
// class _App extends StatefulWidget {
//   final UserRepository userRepository;
//   final bool seenOnboarding;
//
//   const _App({
//     super.key,
//     required this.userRepository,
//     required this.seenOnboarding,
//   });
//
//   @override
//   State<_App> createState() => _AppState();
// }
//
// class _AppState extends State<_App> {
//   late bool _showOnboarding;
//   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _showOnboarding = !widget.seenOnboarding;
//   }
//
//   void _onOnboardingCompleted() {
//     setState(() {
//       _showOnboarding = false;
//     });
//   }
//
//   // 🔹 Helper untuk buka popup biar gak nulis ulang
//   Future<void> _showPopup(Widget page) async {
//     await _navigatorKey.currentState?.push(
//       MaterialPageRoute(builder: (_) => page),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         // OTP via HP
//         BlocListener<AuthenticationBloc, AuthenticationState>(
//           listenWhen: (_, curr) =>
//           curr is AuthenticationRequirePinHPVerification,
//           listener: (_, state) {
//             if (state is AuthenticationRequirePinHPVerification) {
//               _showPopup(
//                 PopupClientWidget(phoneNumber: state.hpno),
//               );
//             }
//           },
//         ),
//
//         // OTP via Email
//         BlocListener<AuthenticationBloc, AuthenticationState>(
//           listenWhen: (_, curr) =>
//           curr is AuthenticationRequirePinEmailVerification,
//           listener: (_, state) {
//             if (state is AuthenticationRequirePinEmailVerification) {
//               _showPopup(
//                 PopupUserWidget(email: state.email),
//               );
//             }
//           },
//         ),
//       ],
//       child: MaterialApp(
//         navigatorKey: _navigatorKey, // 🔥 Fix error Navigator
//         debugShowCheckedModeBanner: false,
//         title: 'JPS Insurance',
//         theme: FlexThemeData.light(
//           scheme: FlexScheme.mandyRed,
//           fontFamily: 'Delm-Regular',
//         ),
//         darkTheme: FlexThemeData.dark(
//           scheme: FlexScheme.mandyRed,
//           fontFamily: 'Delm-Regular',
//           colorScheme: const ColorScheme.dark(
//             primary: primaryBlackColor,
//             secondary: primaryLightColor,
//           ),
//         ),
//
//         themeMode: ThemeMode.light,
//         onGenerateRoute: (settings) {
//           switch (settings.name) {
//             case 'chat':
//               return MaterialPageRoute(
//                 builder: (_) => const MobileChatScreen(), // dari SDK Mekari
//               );
//             default:
//               return null;
//           }
//         },
//         home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//           builder: (context, state) {
//             if (state is AuthenticationAuthenticated) {
//               // 🔹 1. Bersihkan semua route sebelumnya
//               while (_navigatorKey.currentState?.canPop() ?? false) {
//                 _navigatorKey.currentState?.pop();
//               }
//
//               final user = state.user;
//               final homeWidget = HomeTabWidget(userRepository: widget.userRepository);
//
//               // 🔹 2. Cegah double inisialisasi chat
//               if (ChatInitService.I.isInitialized) {
//                 debugPrint("⚠️ [ChatInitService] Sudah diinisialisasi, skip ulang init.");
//                 return homeWidget;
//               }
//
//               // 🔹 3. Handle Client ('C')
//               if ((user.userType ?? '').toUpperCase() == 'C') {
//                 // context.read<UserProfileCubit>().setProfile(
//                 //   mrekan1Id: user.id?.toString(),
//                 //   nama: user.nama,
//                 //   email: user.email,
//                 //   telepon: user.hp,
//                 // );
//
//                 return BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
//                   listenWhen: (prev, curr) =>
//                   prev.record?.mrekan1Id != curr.record?.mrekan1Id &&
//                       curr.record?.mrekan1Id != null &&
//                       curr.record!.mrekan1Id!.trim().isNotEmpty,
//                   listener: (context, state) async {
//                     if (ChatInitService.I.isInitialized) return;
//
//                     try {
//                       final userId = state.record!.mrekan1Id!.trim();
//
//                       // ambil nama paling relevan
//                       final displayName =
//                       (state.record?.rekanNama?.trim().isNotEmpty ?? false)
//                           ? state.record!.rekanNama!.trim()
//                           : "Guest";
//
//                       final result = await ChatInitService.I.ensureInit(
//                         userId: userId,
//                         displayName: displayName,
//                       );
//
//                       // if (context.mounted) {
//                       //   ScaffoldMessenger.of(context).showSnackBar(
//                       //     SnackBar(
//                       //       content: Text(result.success
//                       //           ? "✅ Chat siap: ${result.displayName}"
//                       //           : "❌ Gagal inisialisasi chat: ${result.error}"),
//                       //       backgroundColor: result.success ? Colors.green : Colors.red,
//                       //     ),
//                       //   );
//                       // }
//                     } catch (e, s) {
//                       debugPrint("🔥 [ChatInit Error C] $e\n$s");
//                       if (context.mounted) {
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   SnackBar(
//                         //     content: Text("❌ Error inisialisasi chat: $e"),
//                         //     backgroundColor: Colors.red,
//                         //   ),
//                         // );
//                       }
//                     }
//                   },
//                   child: homeWidget,
//                 );
//               }
//
//               // 🔹 4. Handle User Biasa ('U')
//               else if ((user.userType ?? '').toUpperCase() == 'U') {
//                 WidgetsBinding.instance.addPostFrameCallback((_) async {
//                   if (ChatInitService.I.isInitialized) return;
//
//                   try {
//                     final guestId = "guest-${DateTime.now().millisecondsSinceEpoch}";
//                     final email = user.email?.trim() ?? guestId;
//
//                     final result = await ChatInitService.I.ensureInit(
//                       userId: email,
//                       displayName: email,
//                     );
//
//                     if (context.mounted) {
//                       // ScaffoldMessenger.of(context).showSnackBar(
//                       //   SnackBar(
//                       //     content: Text(result.success
//                       //         ? "✅ Chat siap: ${result.displayName}"
//                       //         : "❌ Gagal inisialisasi chat: ${result.error}"),
//                       //     backgroundColor: result.success ? Colors.green : Colors.red,
//                       //   ),
//                       // );
//                     }
//
//                     debugPrint(result.success
//                         ? "✅ [ChatInitService] Initialized untuk $email"
//                         : "⚠️ [ChatInitService] Gagal init: ${result.error}");
//                   } catch (e, s) {
//                     debugPrint("🔥 [ChatInit Error U] $e\n$s");
//                   }
//                 });
//               }
//
//               // 🔹 5. Handle userType kosong / tidak dikenali
//               else {
//                 WidgetsBinding.instance.addPostFrameCallback((_) async {
//                   if (ChatInitService.I.isInitialized) return;
//
//                   try {
//                     final guestId = "guest-${DateTime.now().millisecondsSinceEpoch}";
//                     final email = user.email?.trim() ?? guestId;
//
//                     final result = await ChatInitService.I.ensureInit(
//                       userId: email,
//                       displayName: email,
//                     );
//
//                     if (context.mounted) {
//                       // ScaffoldMessenger.of(context).showSnackBar(
//                       //   SnackBar(
//                       //     content: Text(result.success
//                       //         ? "✅ Chat siap (default): ${result.displayName}"
//                       //         : "❌ Gagal inisialisasi chat: ${result.error}"),
//                       //     backgroundColor: result.success ? Colors.green : Colors.red,
//                       //   ),
//                       // );
//                     }
//
//                     debugPrint(result.success
//                         ? "✅ [ChatInitService] Initialized default untuk $email"
//                         : "⚠️ [ChatInitService] Gagal init default: ${result.error}");
//                   } catch (e, s) {
//                     debugPrint("🔥 [ChatInit Error UNKNOWN] $e\n$s");
//                   }
//                 });
//               }
//
//               // 🔹 6. Default fallback
//               return homeWidget;
//             }
//
//             // if (state is AuthenticationAuthenticated) {
//             //   final user = state.user;
//             //
//             //   // ✅ No ChatInitService, no Mekari, no MRekan1CrudBloc
//             //   return HomeTabWidget(
//             //     userRepository: widget.userRepository,
//             //     // kalau butuh passing user, tambahkan param di HomeTabWidget
//             //     // user: user,
//             //   );
//             // }
//
//             if (state is AuthenticationUnauthenticated) {
//               // context.read<UserProfileCubit>().clearProfile();
//               context.read<LoginBloc>().add(LoginReset());
//
//               // ChatInitService.I.dispose();
//               return const LoginUser();
//             }
//
//             if (state is AuthenticationRequireLoginClient) {
//               return const LoginClient();
//             }
//             //
//             // if (state is AuthenticationRequireRegisterClient) {
//             //   debugPrint('[MAIN] show RegisterClient from=${state.requiredFrom}');
//             //   return RegisterClient(requestFrom: state.requiredFrom,);
//             // }
//
//             if (state is AuthenticationForgotPassword) {
//               // return const ForgotPasswordPage();
//             }
//
//             // if (state is AuthenticationPhonePinVerified) {
//             //   context.read<AuthenticationBloc>().add(LoggedOut());
//             //   WidgetsBinding.instance.addPostFrameCallback((_) {
//             //     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
//             //       MaterialPageRoute(builder: (_) => const LoginClient()),
//             //           (route) => false,
//             //     );
//             //   });
//             //
//             //   // Langsung tampilkan halaman login biar smooth
//             //   return const LoginClient();
//             // }
//
//             if (state is AuthenticationPhonePinVerified) {
//
//               String requestFrom = context.read<RegUserBloc>().state.requestFrom;
//               if (requestFrom == "calmv_page " || requestFrom == "calpar_page") {
//                 debugPrint("Log out user");
//                 // force login user
//                 BlocProvider.of<AuthenticationBloc>(context).add(
//                   LoggedOut(),
//                 );
//               }else{
//                 while (_navigatorKey.currentState?.canPop() ?? false) {
//                   _navigatorKey.currentState?.pop();
//                 }
//                 context.read<AuthenticationBloc>().add(LoggedOut());
//               }
//
//               return const LoadingIndicator();
//             }
//
//             // if (state is AuthenticationPhonePinVerified) {
//             //   final userRepo = widget.userRepository;
//             //   context.read<AuthenticationBloc>().add(LoggedOut());
//             //   // 🚀 login ulang (future supaya ga blocking)
//             //   Future.microtask(() async {
//             //     final token = await userRepo.getToken();
//             //     final user = await userRepo.getUserByToken(token);
//             //     context.read<AuthenticationBloc>().add(LoggedIn(user: user));
//             //   });
//             //
//             //   // tampilkan indikator sementara
//             //   return const LoadingIndicator();
//             // }
//             // default → loading
//             return const LoadingIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:joss_app/repositories/klaimlacak/klaimnilaicrud_repository.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvbengkelcrud_repository.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvklaimcrud_repository.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvpoliscrud_repository.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvstatuscrud_repository.dart';
import 'package:joss_app/repositories/perbaruiklaimpar/klaimparklaimcrud_repository.dart';
import 'package:joss_app/repositories/regpar/regpar1crud_repository.dart';
import 'package:joss_app/repositories/regpar/regpar2form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar3form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar4form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar5form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar6form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar_download_fotoobject_repository.dart';
import 'package:joss_app/repositories/regpar/regpar_upload_fotoobject_repository.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/helper/app_prefs.dart';
import 'package:joss_app/pages/home/home_tab_widget.dart';
import 'package:joss_app/pages/login/mobile/client/login_client_page.dart';
import 'package:joss_app/pages/login/mobile/client/widget/otp_client_widget.dart';
import 'package:joss_app/pages/login/mobile/user/login_user_page.dart';
import 'package:joss_app/pages/login/mobile/user/widget/otp_user_widget.dart';
import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';

// APIs
import 'apis/payment/paymentdn_api.dart';

// Repositories
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:joss_app/repositories/login/emailverification_repository.dart';
import 'package:joss_app/repositories/login/change_password_repository.dart';
import 'package:joss_app/repositories/profile/userfoto_repository.dart';

import 'package:joss_app/repositories/gen_profile/mrekan1crud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekancontactcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpajakcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanbankcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralidvcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralcmpcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiccrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';

import 'package:joss_app/repositories/gen_calmv/calmv1crud_repository.dart';
import 'package:joss_app/repositories/gen_calmv/calmv2form_repository.dart';
import 'package:joss_app/repositories/gen_calmv/calmv3form_repository.dart';

import 'package:joss_app/repositories/calpar/calpar1crud_repository.dart';
import 'package:joss_app/repositories/calpar/calpar2form_repository.dart';
import 'package:joss_app/repositories/calpar/calpar3form_repository.dart';
import 'package:joss_app/repositories/calpar/calpar4form_repository.dart';

import 'package:joss_app/repositories/gen_endors/endors1crud_repository.dart';
import 'package:joss_app/repositories/regendors/regendors1form_repository.dart';

import 'package:joss_app/repositories/gen_klaim/klaim1crud_repository.dart';
import 'package:joss_app/repositories/gen_klaim/klaim2crud_repository.dart';

import 'package:joss_app/repositories/gen_regmv/regmv1crud_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv2form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv3form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv4form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv5form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv6form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv7form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_stnk_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_mobil_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_acc_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_download_stnk_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_download_fotomobil_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_download_fotoacc_repository.dart';

import 'package:joss_app/repositories/gen_sppamv/download_polis_repository.dart';
import 'package:joss_app/repositories/gen_sppamv/sppamvcrud_repository.dart';
import 'package:joss_app/repositories/gen_sppapar/sppaparcrud_repository.dart';

import 'package:joss_app/repositories/payment/paymentdn_repository.dart';
import 'package:joss_app/repositories/payment/paymentmethodcari_repository.dart';
import 'package:joss_app/repositories/payment/invbayarvaform_repository.dart';
import 'package:joss_app/repositories/payment/pay1crud_repository.dart';

import 'package:joss_app/repositories/reguser/reguser_repository.dart';
import 'package:joss_app/repositories/regother/regother1crud_repository.dart';
import 'package:joss_app/repositories/regother/regother2form_repository.dart';

import 'package:joss_app/repositories/regklaim/picker_repository.dart';
import 'package:joss_app/repositories/regklaim/upload_repository.dart';
import 'package:joss_app/repositories/regklaim/regklaim1crud_repository.dart';
import 'package:joss_app/repositories/regklaim/sppaheader_repository.dart';

import 'package:joss_app/repositories/regrenewal/regrenew1form_repository.dart';
import 'package:joss_app/repositories/regreaktif/regreaktif1_repository.dart';

import 'package:joss_app/repositories/simulmv/simulmvcrud_repository.dart';
import 'package:joss_app/repositories/simulpar/simulparcrud_repository.dart';
import 'package:joss_app/repositories/simulpar/simulparlist_repository.dart';

import 'package:joss_app/repositories/gen_compro/reqcompro_repository.dart';
import 'package:joss_app/repositories/gen_invite/invite_repository.dart';

// Blocs / Cubits
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/blocs/login/emailverification_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/blocs/networkconnection/network_bloc.dart';
import 'package:joss_app/blocs/profile/profile_download_foto_bloc.dart';
import 'package:joss_app/blocs/profile/profile_upload_foto_bloc.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';

import 'package:joss_app/blocs/local_prefs/simulasi_par_local_cubit.dart';
import 'package:joss_app/blocs/local_prefs/simulasi_mv_local_cubit.dart';
import 'blocs/gen_calmv/calmvaccordion_bloc.dart';
import 'blocs/gen_dn1/dn1cari_bloc.dart';
import 'blocs/gen_promo/promo1cari_bloc.dart';
import 'blocs/gen_promo/promo2cari_bloc.dart';
import 'blocs/gen_trslog/trslogcari_bloc.dart';
import 'blocs/klaimlacak/klaimnilaicrud_bloc.dart';
import 'blocs/klaimlacak/klaimprogresscari_bloc.dart';
import 'blocs/klaimrasio/klaimrasiocobcari_bloc.dart';
import 'blocs/klaimrinci/groupcobcari_bloc.dart';
import 'blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'blocs/klaimringkas/klaimringkascari_bloc.dart';
import 'blocs/klaimringkas/mstatusringkascari_bloc.dart';
import 'blocs/local_prefs/article_selection_cubit.dart';

import 'package:joss_app/blocs/gen_profile/mrekan1crud_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1list_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactlist_bloc.dart';
import 'blocs/gen_profile/mrekanpajakcrud_bloc.dart';
import 'blocs/gen_profile/mrekanbankcrud_bloc.dart';
import 'blocs/gen_profile/mrekanbanklist_bloc.dart';
import 'blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import 'blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'blocs/gen_profile/rekanpiccobcari_bloc.dart';

import 'blocs/gen_calmv/calmv1crud_bloc.dart';
import 'blocs/gen_calmv/calmv1list_bloc.dart';
import 'blocs/gen_calmv/calmv2form_bloc.dart';
import 'blocs/gen_calmv/calmv3form_bloc.dart';
import 'blocs/gen_calmv/calmv_flow_bloc.dart';

import 'blocs/calpar/calpar1crud_bloc.dart';
import 'blocs/calpar/calpar1list_bloc.dart';
import 'blocs/calpar/calpar2form_bloc.dart';
import 'blocs/calpar/calpar3form_bloc.dart';
import 'blocs/calpar/calpar4form_bloc.dart';
import 'blocs/calpar/calpar_flow_bloc.dart';

import 'blocs/gen_cob_app/cobmanpol_bloc.dart';
import 'blocs/gen_cob_app/cobcari_bloc.dart';

import 'blocs/gen_compro/reqcompro_bloc.dart';
import 'blocs/gen_invite/invite_bloc.dart';

import 'blocs/gen_endors/endors1crud_bloc.dart';
import 'blocs/gen_endors/endors1list_bloc.dart';
import 'blocs/gen_endors/endors2cari_bloc.dart';
import 'blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'blocs/perbaruiklaimmv/klaimmvaccordion_bloc.dart';
import 'blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'blocs/perbaruiklaimmv/klaimmvstatuscari_bloc.dart';
import 'blocs/perbaruiklaimmv/klaimmvstatuscrud_bloc.dart';
import 'blocs/perbaruiklaimpar/klaimparaccordion_bloc.dart';
import 'blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'blocs/regendors/regendorscari_bloc.dart';
import 'blocs/regendors/regendors1form_bloc.dart';
import 'blocs/regendors/regendors2cari_bloc.dart';

import 'blocs/gen_klaim/klaim1crud_bloc.dart';
import 'blocs/gen_klaim/klaim1list_bloc.dart';
import 'blocs/gen_klaim/klaim2crud_bloc.dart';
import 'blocs/klaim/klaim2list_bloc.dart';

import 'blocs/gen_regmv/polis_tanggal_bloc.dart';
import 'blocs/gen_regmv/regmv1crud_bloc.dart';
import 'blocs/gen_regmv/regmv1list_bloc.dart';
import 'blocs/gen_regmv/regmv2form_bloc.dart';
import 'blocs/gen_regmv/regmv3form_bloc.dart';
import 'blocs/gen_regmv/regmv4cari_bloc.dart';
import 'blocs/gen_regmv/regmv4form_bloc.dart';
import 'blocs/gen_regmv/regmv5cari_bloc.dart';
import 'blocs/gen_regmv/regmv5form_bloc.dart';
import 'blocs/gen_regmv/regmv6form_bloc.dart';
import 'blocs/gen_regmv/regmv7cari_bloc.dart';
import 'blocs/gen_regmv/regmv7form_bloc.dart';
import 'blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import 'blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
import 'blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import 'blocs/gen_regmv/regmv_download_foto_acc_bloc.dart';
import 'blocs/gen_regmv/regmv_download_foto_mobil_bloc.dart';
import 'blocs/gen_regmv/regmv_download_foto_stnk_bloc.dart';
import 'blocs/gen_regmv/regmv_flow_bloc.dart';

import 'blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import 'blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'blocs/gen_sppamv/sppamvlist_bloc.dart';
import 'blocs/gen_sppapar/sppaparcrud_bloc.dart';
import 'blocs/gen_sppapar/sppaparlist_bloc.dart';

import 'blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import 'blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'blocs/gen_aset_hull/asethullcari_bloc.dart';
import 'blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'blocs/gen_aset_par/asetparcari_bloc.dart';
import 'blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'blocs/asetothers/asetotherscari_bloc.dart';
import 'blocs/asettracking/asettrackcari_bloc.dart';
import 'blocs/share_cubit/share_ringkasan_state_cubit.dart';
import 'blocs/share_cubit/share_par_state_cubit.dart';
import 'blocs/share_cubit/share_mv_state_cubit.dart';
import 'blocs/share_cubit/share_health_state_cubit.dart';
import 'blocs/share_cubit/share_hull_state_cubit.dart';

import 'blocs/hasil_simul_mv_cubit/hasil_simul_mv_cubit.dart';
import 'blocs/hasil_simul_par_cubit/hasil_simul_par_cubit.dart';

import 'blocs/simulmv/simulmvcrud_bloc.dart';
import 'blocs/simulpar/simulparcrud_bloc.dart';
import 'blocs/simulpar/simulparlist_bloc.dart';

import 'blocs/gallery/galleryeventcari_bloc.dart';
import 'blocs/gallery/gallerymembercari_bloc.dart';
import 'blocs/gen_review/reviewcari_bloc.dart';

import 'blocs/gen_berita/berita1cari_bloc.dart';
import 'blocs/gen_berita/berita2cari_bloc.dart';
import 'blocs/gen_berita/berita3cari_bloc.dart';
import 'blocs/gen_berita/beritakecilcari_bloc.dart';
import 'blocs/gen_berita/beritalaincari_bloc.dart';

import 'blocs/payment/dnrekapcobcari_bloc.dart';
import 'blocs/payment/dnrekap2inv_bloc.dart';
import 'blocs/payment/dnsppacari_bloc.dart';
import 'blocs/payment/dnsppamvcari_bloc.dart';
import 'blocs/payment/historybayarcari_bloc.dart';
import 'blocs/payment/historybayar2cari_bloc.dart';
import 'blocs/payment/invbayarvaform_bloc.dart';
import 'blocs/payment/pay1crud_bloc.dart';
import 'blocs/payment/pay1list_bloc.dart';
import 'blocs/payment/pay2cari_bloc.dart';
import 'blocs/payment/paymentmethodcari_bloc.dart';

import 'blocs/regother/regother1crud_bloc.dart';
import 'blocs/regother/regother1list_bloc.dart';
import 'blocs/regother/regother2form_bloc.dart';
import 'blocs/regother/regother3cari_bloc.dart';

import 'blocs/regklaim/attach_bloc.dart';
import 'blocs/regklaim/cobklaimcari_bloc.dart';
import 'blocs/regklaim/polissourcecari_bloc.dart';
import 'blocs/regklaim/regklaim1crud_bloc.dart';
import 'blocs/regklaim/sppaheader_bloc.dart';
import 'blocs/regklaim/sppapoliscari_bloc.dart';

import 'blocs/regpar/regpar1crud_bloc.dart';
import 'blocs/regpar/regpar1list_bloc.dart';
import 'blocs/regpar/regpar2form_bloc.dart';
import 'blocs/regpar/regpar3form_bloc.dart';
import 'blocs/regpar/regpar4form_bloc.dart';
import 'blocs/regpar/regpar5form_bloc.dart';
import 'blocs/regpar/regpar6cari_bloc.dart';
import 'blocs/regpar/regpar6form_bloc.dart';
import 'blocs/regpar/regpar_download_foto_object_bloc.dart';
import 'blocs/regpar/regpar_upload_foto_object_bloc.dart';
import 'blocs/regpar/regpar_flow_bloc.dart';

import 'blocs/regrenewal/regrenewcari_bloc.dart';
import 'blocs/regrenewal/regrenew1form_bloc.dart';
import 'blocs/regrenewal/regrenewal2cari_bloc.dart';

import 'blocs/regreaktif/regreaktif1_bloc.dart';
import 'blocs/regreaktif/regreaktifcari_bloc.dart';
import 'blocs/regreaktif/regreaktif2cari_bloc.dart';

import 'blocs/loading_flow/loading_flow_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
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
          create: (_) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
        ),

        BlocProvider<SimulasiParLocalCubit>(
          create: (_) => SimulasiParLocalCubit(appPrefs),
        ),
        BlocProvider<SimulasiMvLocalCubit>(
          create: (_) => SimulasiMvLocalCubit(appPrefs),
        ),

        // NOTE: EmailVerificationBloc disediakan satu kali, dipakai oleh LoginBloc & UI lain
        BlocProvider<EmailVerificationBloc>(
          create: (context) => EmailVerificationBloc(
            repository: EmailVerificationRepository(),
            authenticationBloc: context.read<AuthenticationBloc>(),
          ),
        ),

        BlocProvider(
          create: (ctx) => LoginBloc(
            authenticationBloc: ctx.read<AuthenticationBloc>(),
            userRepository: userRepository,
            emailVerificationBloc: ctx.read<EmailVerificationBloc>(),
          ),
        ),

        BlocProvider(
          create: (_) => ChangePasswordBloc(repository: ChangePasswordRepository()),
        ),
        BlocProvider(
          create: (_) => NetworkBloc()..add(NetworkObserve()),
        ),
        BlocProvider(
          create: (_) => ProfileUploadFotoBloc(),
        ),
        BlocProvider(
          create: (_) => ProfileDownloadFotoBloc(repository: UserFotoRepository()),
        ),

        // Profile / Rekan
        BlocProvider(create: (_) => MRekan1CrudBloc(repository: MRekan1CrudRepository())),
        BlocProvider(create: (_) => MRekan1ListBloc()),
        BlocProvider(create: (_) => MRekanContactCrudBloc(repository: MRekanContactCrudRepository())),
        BlocProvider(create: (_) => MRekanContactListBloc()),
        BlocProvider(create: (_) => MRekanPajakCrudBloc(repository: MRekanPajakCrudRepository())),
        BlocProvider(create: (_) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository())),
        BlocProvider(create: (_) => MRekanBankListBloc()),
        BlocProvider(create: (_) => MRekanGeneralIdvCrudBloc(repository: MRekanGeneralIdvCrudRepository())),
        BlocProvider(create: (_) => MRekanGeneralCmpCrudBloc(repository: MRekanGeneralCmpCrudRepository())),
        BlocProvider<MRekanPicListBloc>(
          create: (context) => MRekanPicListBloc(repository: MRekanPicListRepository())
            ..add(FetchMRekanPicListEvent()),
        ),
        BlocProvider<MRekanPicCrudBloc>(
          create: (context) => MRekanPicCrudBloc(repository: MRekanPicCrudRepository()),
        ),
        BlocProvider(create: (_) => RekanPicCobCariBloc()),

        // ReqCompro / Invite
        BlocProvider(create: (_) => ReqComproBloc(repository: ReqComproRepository())),
        BlocProvider(create: (_) => InviteBloc(repo: InviteRepository())),

        // Hydrated (share state)
        BlocProvider(create: (_) => ShareRingkasanStateCubit()),
        BlocProvider(create: (_) => ShareParStateCubit()),
        BlocProvider(create: (_) => ShareMvStateCubit()),
        BlocProvider(create: (_) => ShareHealthStateCubit()),
        BlocProvider(create: (_) => ShareHullStateCubit()),
        BlocProvider(create: (_) => HasilSimulMvCubit()),
        BlocProvider(create: (_) => HasilSimulParCubit()),

        // RegOther
        BlocProvider(create: (_) => Regother2FormBloc(repository: Regother2FormRepository())),
        BlocProvider(create: (_) => Regother1CrudBloc(repository: Regother1CrudRepository())),
        BlocProvider(create: (_) => Regother1ListBloc()),
        BlocProvider(create: (_) => Regother3cariBloc()),

        // Payment
        BlocProvider(create: (_) => DnrekapcobCariBloc()),
        BlocProvider(create: (_) => DnsppaCariBloc()),
        BlocProvider(create: (_) => DnsppamvCariBloc()),
        BlocProvider(create: (_) => PaymentMethodCariBloc(repository: PaymentDnRepository(api: PaymentDnAPI()))),
        BlocProvider(create: (_) => DnRekap2invBloc()),
        BlocProvider(create: (_) => InvbayarvaFormBloc(repository: InvbayarvaFormRepository())),
        BlocProvider(create: (_) => Pay1ListBloc()),
        BlocProvider(create: (_) => Pay1CrudBloc(repository: Pay1CrudRepository())),
        BlocProvider(create: (_) => Pay2CariBloc()),
        BlocProvider(create: (_) => HistorybayarCariBloc()),
        BlocProvider(create: (_) => Historybayar2CariBloc()),

        // Gallery / Review
        BlocProvider(create: (_) => GalleryeventCariBloc()..add(RefreshGalleryeventCariEvent())),
        BlocProvider(create: (_) => ReviewCariBloc()..add(RefreshReviewCariEvent())),
        BlocProvider(create: (_) => GallerymemberCariBloc()..add(RefreshGallerymemberCariEvent())),

        // Endors
        BlocProvider(create: (_) => Endors1ListBloc()),
        BlocProvider(create: (_) => Endors1CrudBloc(repository: Endors1CrudRepository())),
        BlocProvider(create: (_) => Endors2CariBloc()),
        BlocProvider(create: (_) => RegendorsCariBloc()),
        BlocProvider(create: (_) => Regendors1FormBloc(repository: Regendors1FormRepository())),
        BlocProvider(create: (_) => Regendors2CariBloc()),

        // News
        BlocProvider(create: (_) => Berita1CariBloc()..add(RefreshBerita1CariEvent(1))),
        BlocProvider(create: (_) => BeritaKecilCariBloc()..add(RefreshBeritaKecilCariEvent(2))),
        BlocProvider(create: (_) => BeritaLainCariBloc()..add(RefreshBeritaLainCariEvent(3))),
        BlocProvider(create: (_) => Berita2CariBloc()),
        BlocProvider(create: (_) => Berita3CariBloc()),
        BlocProvider<ArticleSelectionCubit>(create: (_) => ArticleSelectionCubit(appPrefs)),

        // Trslog
        BlocProvider(create: (_) => TrslogCariBloc()),

        //Klaimq
        BlocProvider(create: (context) => KlaimmvklaimcrudBloc(repository: KlaimmvklaimcrudRepository())),
        BlocProvider(create: (context) => KlaimmvpoliscrudBloc(repository: KlaimmvpoliscrudRepository())),
        // BlocProvider(create: (context) => KlaimmvdoccrudBloc(repository: KlaimmvdoccrudRepository())),
        BlocProvider(create: (context) => KlaimmvbengkelcrudBloc(repository: KlaimmvbengkelcrudRepository())),
        BlocProvider(create: (context) => KlaimmvstatuscrudBloc(repository: KlaimmvstatuscrudRepository())),
        BlocProvider(create: (context) => KlaimmvaccordionBloc()),
        BlocProvider(create: (context) => Klaim5cariBloc()),
        BlocProvider(create: (context) => KlaimmvstatuscariBloc()),

        BlocProvider(create: (context) => KlaimprogresscariBloc()),
        BlocProvider(create: (context) => KlaimnilaicrudBloc(repository: KlaimnilaicrudRepository())),
        BlocProvider(create: (context) => KlaimparklaimcrudBloc(repository: KlaimparklaimcrudRepository())),
        // BlocProvider(create: (context) => Klaim5parListBloc()),
        // BlocProvider(create: (context) => Klaim5parCrudBloc(repository: Klaim5parCrudRepository())),
        BlocProvider(create: (context) => KlaimparaccordionBloc()),

        // Aset
        BlocProvider(create: (_) => StatusAsetCariBloc()),
        BlocProvider(create: (_) => AsethullCariBloc()),
        BlocProvider(create: (_) => AsetRingkasanCariBloc()),
        BlocProvider(create: (_) => AsetParCariBloc()),
        BlocProvider(create: (_) => AsetMvCariBloc()),
        BlocProvider(create: (_) => AsetHealthCariBloc()),
        BlocProvider(create: (_) => AsetothersCariBloc()),
        BlocProvider(create: (_) => AsetDashboardCariBloc()),
        BlocProvider(create: (_) => AsettrackCariBloc()),

        // Promo
        BlocProvider(create: (_) => Promo1CariBloc()),
        BlocProvider(create: (_) => Promo2CariBloc()),

        // SPPA MV / PAR
        BlocProvider(create: (_) => SppamvListBloc()),
        BlocProvider(create: (_) => SppamvCrudBloc(repository: SppamvCrudRepository())),
        BlocProvider(create: (_) => SppaparListBloc()),
        BlocProvider(create: (_) => SppaparCrudBloc(repository: SppaparCrudRepository())),
        BlocProvider(create: (_) => SppapoliscariBloc()),
        BlocProvider(create: (_) => PolissourcecariBloc()),
        BlocProvider(create: (_) => SppaHeaderBloc(repository: SppaHeaderRepository())),
        BlocProvider(create: (_) => SppaDownloadPolisBloc(repository: DownloadPolisRepository())),

        // Simul
        BlocProvider(create: (_) => SimulparListBloc()),
        BlocProvider(create: (_) => SimulmvCrudBloc(repository: SimulmvCrudRepository())),
        BlocProvider(create: (_) => SimulparCrudBloc(repository: SimulparCrudRepository())),

        // COB
        BlocProvider(create: (_) => CobCariBloc()),
        BlocProvider(create: (_) => CobManPolBloc()),

        // DN1
        BlocProvider(create: (_) => Dn1CariBloc()),

        // CALMV
        BlocProvider(create: (_) => CalmvAccordionBloc()),
        BlocProvider(create: (_) => Calmv1ListBloc()),
        BlocProvider(create: (_) => Calmv1CrudBloc(repository: Calmv1CrudRepository())),
        BlocProvider(create: (_) => Calmv2FormBloc(repository: Calmv2FormRepository())),
        BlocProvider(create: (_) => Calmv3FormBloc(repository: Calmv3FormRepository())),
        BlocProvider<CalmvFlowBloc>(
          create: (context) => CalmvFlowBloc(
            calmv1CrudBloc: context.read<Calmv1CrudBloc>(),
            calmv2FormBloc: context.read<Calmv2FormBloc>(),
            calmv3FormBloc: context.read<Calmv3FormBloc>(),
          ),
        ),

        // CALPAR
        BlocProvider(create: (_) => Calpar1CrudBloc(repository: Calpar1CrudRepository())),
        BlocProvider(create: (_) => Calpar1ListBloc()),
        BlocProvider(create: (_) => Calpar2FormBloc(repository: Calpar2FormRepository())),
        BlocProvider(create: (_) => Calpar3FormBloc(repository: Calpar3FormRepository())),
        BlocProvider(create: (_) => Calpar4FormBloc(repository: Calpar4FormRepository())),
        BlocProvider<CalparFlowBloc>(
          create: (context) => CalparFlowBloc(
            calpar1CrudBloc: context.read<Calpar1CrudBloc>(),
            calpar2FormBloc: context.read<Calpar2FormBloc>(),
            calpar3FormBloc: context.read<Calpar3FormBloc>(),
            calpar4FormBloc: context.read<Calpar4FormBloc>(),
          ),
        ),

        // REGMV
        BlocProvider(create: (_) => Regmv1ListBloc()),
        BlocProvider(create: (_) => Regmv1CrudBloc(repository: Regmv1CrudRepository())),
        BlocProvider(create: (_) => Regmv2FormBloc(repository: Regmv2FormRepository())),
        BlocProvider(create: (_) => Regmv3FormBloc(repository: Regmv3FormRepository())),
        BlocProvider(create: (_) => Regmv4FormBloc(repository: Regmv4FormRepository())),
        BlocProvider(create: (_) => Regmv5FormBloc(repository: Regmv5FormRepository())),
        BlocProvider(create: (_) => Regmv6FormBloc(repository: Regmv6FormRepository())),
        BlocProvider(create: (_) => Regmv7FormBloc(repository: Regmv7FormRepository())),
        BlocProvider(create: (_) => Regmv4CariBloc()),
        BlocProvider(create: (_) => Regmv5CariBloc()),
        BlocProvider(create: (_) => Regmv7CariBloc()),
        BlocProvider(create: (_) => RegmvUploadStnkBloc(repository: RegmvUploadStnkRepository())),
        BlocProvider(create: (_) => RegmvUploadFotoMobilBloc(repository: RegmvUploadFotoMobilRepository())),
        BlocProvider(create: (_) => RegmvUploadFotoAccBloc(repository: RegmvUploadFotoAccRepository())),
        BlocProvider(create: (_) => RegmvDownloadFotoStnkBloc(repository: RegmvDownloadStnkRepository())),
        BlocProvider(create: (_) => RegmvDownloadFotoMobilBloc(repository: RegmvDownloadFotoMobilRepository())),
        BlocProvider(create: (_) => RegmvDownloadFotoAccBloc(repository: RegmvDownloadFotoAccRepository())),
        BlocProvider<RegmvFlowBloc>(
          create: (context) => RegmvFlowBloc(
            regmv1CrudBloc: context.read<Regmv1CrudBloc>(),
            regmv2FormBloc: context.read<Regmv2FormBloc>(),
            regmv3FormBloc: context.read<Regmv3FormBloc>(),
            regmv6FormBloc: context.read<Regmv6FormBloc>(),
          ),
        ),

        // REGPAR
        BlocProvider(create: (_) => Regpar1ListBloc()),
        BlocProvider(create: (_) => Regpar1CrudBloc(repository: Regpar1CrudRepository())),
        BlocProvider(create: (_) => Regpar2FormBloc(repository: Regpar2FormRepository())),
        BlocProvider(create: (_) => Regpar3FormBloc(repository: Regpar3FormRepository())),
        BlocProvider(create: (_) => Regpar4FormBloc(repository: Regpar4FormRepository())),
        BlocProvider(create: (_) => Regpar5FormBloc(repository: Regpar5FormRepository())),
        BlocProvider(create: (_) => Regpar6CariBloc()),
        BlocProvider(create: (_) => Regpar6FormBloc(repository: Regpar6FormRepository())),
        BlocProvider(create: (_) => RegparUploadFotoObjectBloc(repository: RegparUploadFotoObjectRepository())),
        BlocProvider(create: (_) => RegparDownloadFotoObjectBloc(repository: RegparDownloadFotoObjectRepository())),
        BlocProvider<RegparFlowBloc>(
          create: (context) => RegparFlowBloc(
            regpar1CrudBloc: context.read<Regpar1CrudBloc>(),
            regpar2FormBloc: context.read<Regpar2FormBloc>(),
            regpar3FormBloc: context.read<Regpar3FormBloc>(),
            regpar4FormBloc: context.read<Regpar4FormBloc>(),
            regpar5FormBloc: context.read<Regpar5FormBloc>(),
          ),
        ),

        // PolisTanggal
        BlocProvider(create: (_) => PolisTanggalBloc()),

        // Regrenew / Regreaktif
        BlocProvider(create: (_) => RegrenewCariBloc()),
        BlocProvider(create: (_) => Regrenew1FormBloc(repository: Regrenew1FormRepository())),
        BlocProvider(create: (_) => Regrenewal2CariBloc()),
        BlocProvider(create: (_) => RegreaktifCariBloc()),
        BlocProvider(create: (_) => Regreaktif1Bloc(repository: Regreaktif1Repository())),
        BlocProvider(create: (_) => Regreaktif2CariBloc()),

        // RegUser
        BlocProvider(
          create: (context) => RegUserBloc(
            repository: RegUserRepository(),
            authenticationBloc: context.read<AuthenticationBloc>(),
          ),
        ),

        // LoadingFlow
        BlocProvider<LoadingFlowBloc>(
          create: (context) => LoadingFlowBloc(
            cobManPolBloc: context.read<CobManPolBloc>(),
            statusAsetCariBloc: context.read<StatusAsetCariBloc>(),
            asetRingkasanCariBloc: context.read<AsetRingkasanCariBloc>(),
            asetParCariBloc: context.read<AsetParCariBloc>(),
            asetMvCariBloc: context.read<AsetMvCariBloc>(),
            asethullCariBloc: context.read<AsethullCariBloc>(),
            asetHealthCariBloc: context.read<AsetHealthCariBloc>(),
            asetothersCariBloc: context.read<AsetothersCariBloc>(),
          ),
        ),

        // Reg Klaim
        BlocProvider(create: (_) => Regklaim1CrudBloc(repository: Regklaim1CrudRepository())),
        BlocProvider(create: (_) => CobklaimcariBloc()),
        BlocProvider(create: (context) => KlaimrasiocobCariBloc()),
        BlocProvider(create: (context) => KlaimringkasCariBloc()),
        BlocProvider(create: (context) => MstatusringkasCariBloc()),
        BlocProvider(create: (context) => MstatusrinciCariBloc()),
        BlocProvider(create: (context) => GroupcobCariBloc()),
        // BlocProvider(
        //   create: (_) => AttachBloc(
        //     pickerRepo: PickerRepositoryImpl(),
        //     uploadRepo: UploadRepositoryImpl(Dio()),
        //   ),
        // ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
            listenWhen: (prev, curr) =>
            curr.isLoaded && prev.record?.mrekan1Id != curr.record?.mrekan1Id,
            listener: (context, state) {
              final mrekan1Id = state.record?.mrekan1Id;
              if (mrekan1Id != null && mrekan1Id.isNotEmpty) {
                context.read<MRekanContactCrudBloc>().add(MRekanContactCrudLihatEvent());
              }
            },
          ),
          BlocListener<EmailVerificationBloc, EmailVerificationState>(
            listenWhen: (prev, curr) =>
            prev.record != curr.record && curr.record != null && !curr.hasFailure,
            listener: (context, state) {
              // no-op (sesuai kode kamu)
            },
          ),
          BlocListener<MRekanContactCrudBloc, MRekanContactCrudState>(
            listenWhen: (prev, curr) => curr.isLoaded && prev.record != curr.record,
            listener: (context, state) {
              // no-op (sesuai kode kamu)
            },
          ),
          BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();

              if (state is NetworkFailure) {
                messenger.showSnackBar(
                  errorSnackBar(
                    "You're not Connected to Internet",
                    icon: Icons.signal_wifi_off,
                  ),
                );
              } else if (state is NetworkSuccess) {
                messenger.showSnackBar(
                  successSnackBar(
                    "You're Connected to Internet",
                    icon: Icons.wifi,
                  ),
                );
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listenWhen: (_, curr) => curr is AuthenticationAuthenticated,
            listener: (context, state) {
              final s = state as AuthenticationAuthenticated;

              if (s.user.userType == 'C') {
                context.read<MRekan1CrudBloc>().add(MRekan1CrudLihatEvent());
                debugPrint('[Auth→Rekan] Trigger MRekan1CrudLihatEvent()');
              }

              final fotoState = context.read<ProfileDownloadFotoBloc>().state;
              if (fotoState is! ProfileDownloadFotoLoading &&
                  fotoState is! ProfileDownloadFotoLoaded) {
                context.read<ProfileDownloadFotoBloc>().add(LoadSecureImage());
                debugPrint('[Foto] LoadSecureImage() dipanggil');
              }
            },
          ),
          BlocListener<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
            listenWhen: (_, c) => c is ProfileDownloadFotoLoaded,
            listener: (context, state) {
              // no-op (sesuai kode kamu)
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

  Future<void> _showPopup(Widget page) async {
    await _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) => curr is AuthenticationRequirePinHPVerification,
          listener: (_, state) {
            if (state is AuthenticationRequirePinHPVerification) {
              _showPopup(PopupClientWidget(phoneNumber: state.hpno));
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) => curr is AuthenticationRequirePinEmailVerification,
          listener: (_, state) {
            if (state is AuthenticationRequirePinEmailVerification) {
              _showPopup(PopupUserWidget(email: state.email));
            }
          },
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
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
        themeMode: ThemeMode.light,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'chat':
              return MaterialPageRoute(builder: (_) => const MobileChatScreen());
            default:
              return null;
          }
        },
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              while (_navigatorKey.currentState?.canPop() ?? false) {
                _navigatorKey.currentState?.pop();
              }

              final user = state.user;
              final homeWidget =
              HomeTabWidget(userRepository: widget.userRepository);

              if (ChatInitService.I.isInitialized) {
                debugPrint("⚠️ [ChatInitService] Sudah diinisialisasi, skip ulang init.");
                return homeWidget;
              }

              if ((user.userType ?? '').toUpperCase() == 'C') {
                return BlocListener<MRekan1CrudBloc, MRekan1CrudState>(
                  listenWhen: (prev, curr) =>
                  prev.record?.mrekan1Id != curr.record?.mrekan1Id &&
                      curr.record?.mrekan1Id != null &&
                      curr.record!.mrekan1Id!.trim().isNotEmpty,
                  listener: (context, state) async {
                    if (ChatInitService.I.isInitialized) return;

                    try {
                      final userId = state.record!.mrekan1Id!.trim();
                      final displayName =
                      (state.record?.rekanNama?.trim().isNotEmpty ?? false)
                          ? state.record!.rekanNama!.trim()
                          : "Guest";

                      await ChatInitService.I.ensureInit(
                        userId: userId,
                        displayName: displayName,
                      );
                    } catch (e, s) {
                      debugPrint("🔥 [ChatInit Error C] $e\n$s");
                    }
                  },
                  child: homeWidget,
                );
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (ChatInitService.I.isInitialized) return;
                  try {
                    final guestId =
                        "guest-${DateTime.now().millisecondsSinceEpoch}";
                    final email = user.email?.trim() ?? guestId;

                    final result = await ChatInitService.I.ensureInit(
                      userId: email,
                      displayName: email,
                    );

                    debugPrint(result.success
                        ? "✅ [ChatInitService] Initialized untuk $email"
                        : "⚠️ [ChatInitService] Gagal init: ${result.error}");
                  } catch (e, s) {
                    debugPrint("🔥 [ChatInit Error] $e\n$s");
                  }
                });
              }

              return homeWidget;
            }

            if (state is AuthenticationUnauthenticated) {
              context.read<LoginBloc>().add(LoginReset()); // balikin kondisi state bloc ke konidsi semula
              return const LoginUser();
            }

            if (state is AuthenticationRequireLoginClient) {
              return const LoginClient();
            }

            if (state is AuthenticationPhonePinVerified) {
              final requestFrom = context.read<RegUserBloc>().state.requestFrom;

              if (requestFrom == "calmv_page " || requestFrom == "calpar_page") {
                debugPrint("Log out user");
                context.read<AuthenticationBloc>().add(LoggedOut());
              } else {
                while (_navigatorKey.currentState?.canPop() ?? false) {
                  _navigatorKey.currentState?.pop();
                }
                context.read<AuthenticationBloc>().add(LoggedOut());
              }

              return const LoadingIndicator();
            }

            return const LoadingIndicator();
          },
        ),
      ),
    );
  }
}
