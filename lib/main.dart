import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1list_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/blocs/gen_cob_app/cobmanpol_bloc.dart';
import 'package:joss_app/blocs/gen_dn1/dn1cari_bloc.dart';
import 'package:joss_app/blocs/gen_endors/endors2cari_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanbanklist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/blocs/gen_trslog/trslogcari_bloc.dart';
import 'package:joss_app/blocs/local_prefs/simulasi_mv_local_cubit.dart';
import 'package:joss_app/blocs/local_prefs/simulasi_par_local_cubit.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparlist_bloc.dart';
import 'package:joss_app/pages/login/mobile/client/widget/otp_client_widget.dart';
import 'package:joss_app/pages/login/mobile/user/login_user_page.dart';
import 'package:joss_app/pages/login/mobile/user/widget/otp_user_widget.dart';
import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';
import 'package:joss_app/pages/startpage/mobile/startpage.dart';
import 'package:joss_app/repositories/calpar/calpar1crud_repository.dart';
import 'package:joss_app/repositories/calpar/calpar2form_repository.dart';
import 'package:joss_app/repositories/calpar/calpar3form_repository.dart';
import 'package:joss_app/repositories/calpar/calpar4form_repository.dart';
import 'package:joss_app/repositories/gen_calmv/calmv1crud_repository.dart';
import 'package:joss_app/repositories/gen_calmv/calmv2form_repository.dart';
import 'package:joss_app/repositories/gen_calmv/calmv3form_repository.dart';
import 'package:joss_app/repositories/gen_compro/reqcompro_repository.dart';
import 'package:joss_app/repositories/gen_endors/endors1crud_repository.dart';
import 'package:joss_app/repositories/gen_invite/invite_repository.dart';
import 'package:joss_app/repositories/gen_klaim/klaim1crud_repository.dart';
import 'package:joss_app/repositories/gen_klaim/klaim2crud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanbankcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralcmpcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralidvcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpajakcrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiccrud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv1crud_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv2form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv3form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv4form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv5form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv6form_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_download_fotoacc_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_download_fotomobil_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_download_stnk_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_acc_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_mobil_repository.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_stnk_repository.dart';
import 'package:joss_app/repositories/gen_sppamv/download_polis_repository.dart';
import 'package:joss_app/repositories/gen_sppamv/sppamvcrud_repository.dart';
import 'package:joss_app/repositories/gen_sppapar/sppaparcrud_repository.dart';
import 'package:joss_app/repositories/payment/invbayarvaform_repository.dart';
import 'package:joss_app/repositories/payment/pay1crud_repository.dart';
import 'package:joss_app/repositories/payment/paymentdn_repository.dart';
import 'package:joss_app/repositories/regpar/regpar1crud_repository.dart';
import 'package:joss_app/repositories/regpar/regpar2form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar3form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar4form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar5form_repository.dart';
import 'package:joss_app/repositories/regpar/regpar_download_fotoobject_repository.dart';
import 'package:joss_app/repositories/regpar/regpar_upload_fotoobject_repository.dart';
import 'package:joss_app/repositories/reguser/reguser_repository.dart';
import 'package:joss_app/repositories/simulmv/simulmvcrud_repository.dart';
import 'package:joss_app/repositories/simulpar/simulparcrud_repository.dart';
import 'package:mobile_chat_flutter/presentation/mobile_chat_screen.dart';

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

import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:joss_app/repositories/login/emailverification_repository.dart';
import 'package:joss_app/repositories/login/change_password_repository.dart';
import 'package:joss_app/repositories/profile/userfoto_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekan1crud_repository.dart';
import 'package:joss_app/repositories/gen_profile/mrekancontactcrud_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apis/payment/paymentdn_api.dart';
import 'blocs/asetothers/asetotherscari_bloc.dart';
import 'blocs/calpar/calpar1crud_bloc.dart';
import 'blocs/calpar/calpar1list_bloc.dart';
import 'blocs/calpar/calpar2form_bloc.dart';
import 'blocs/calpar/calpar3form_bloc.dart';
import 'blocs/calpar/calpar4form_bloc.dart';
import 'blocs/gallery/galleryeventcari_bloc.dart';

import 'blocs/gallery/gallerymembercari_bloc.dart';
import 'blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import 'blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'blocs/gen_aset_hull/asethullcari_bloc.dart';
import 'blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'blocs/gen_aset_par/asetparcari_bloc.dart';
import 'blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'blocs/gen_berita/berita1cari_bloc.dart';
import 'blocs/gen_berita/berita2cari_bloc.dart';
import 'blocs/gen_berita/berita3cari_bloc.dart';
import 'blocs/gen_berita/beritakecilcari_bloc.dart';
import 'blocs/gen_berita/beritalaincari_bloc.dart';
import 'blocs/gen_calmv/calmv3form_bloc.dart';
import 'blocs/gen_cob_app/cobcari_bloc.dart';
import 'blocs/gen_compro/reqcompro_bloc.dart';
import 'blocs/gen_endors/endors1crud_bloc.dart';
import 'blocs/gen_endors/endors1list_bloc.dart';
import 'blocs/gen_invite/invite_bloc.dart';
import 'blocs/gen_klaim/klaim1crud_bloc.dart';
import 'blocs/gen_klaim/klaim1list_bloc.dart';
import 'blocs/gen_klaim/klaim2crud_bloc.dart';
import 'blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'blocs/gen_promo/promo1cari_bloc.dart';
import 'blocs/gen_promo/promo2cari_bloc.dart';
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
import 'blocs/gen_regmv/regmv_download_foto_acc_bloc.dart';
import 'blocs/gen_regmv/regmv_download_foto_mobil_bloc.dart';
import 'blocs/gen_regmv/regmv_download_foto_stnk_bloc.dart';
import 'blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import 'blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
import 'blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import 'blocs/gen_sppamv/sppa_download_polis_bloc.dart';
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
import 'blocs/payment/dnrekap2inv_bloc.dart';
import 'blocs/payment/invbayarvaform_bloc.dart';
import 'blocs/payment/pay1crud_bloc.dart';
import 'blocs/payment/pay1list_bloc.dart';
import 'blocs/payment/pay2cari_bloc.dart';
import 'blocs/payment/paymentmethodcari_bloc.dart';
import 'blocs/regpar/regpar1crud_bloc.dart';
import 'blocs/regpar/regpar1list_bloc.dart';
import 'blocs/regpar/regpar2form_bloc.dart';
import 'blocs/regpar/regpar3form_bloc.dart';
import 'blocs/regpar/regpar4form_bloc.dart';
import 'blocs/regpar/regpar5form_bloc.dart';
import 'blocs/regpar/regpar6cari_bloc.dart';
import 'blocs/regpar/regpar_download_foto_object_bloc.dart';
import 'blocs/regpar/regpar_upload_foto_object_bloc.dart';
import 'blocs/gen_review/reviewcari_bloc.dart';
import 'blocs/simulmv/simulmvcrud_bloc.dart';
import 'blocs/simulpar/simulparcrud_bloc.dart';
import 'blocs/hasil_simul_par_cubit/hasil_simul_par_cubit.dart';
import 'package:joss_app/blocs/hasil_simul_mv_cubit/hasil_simul_mv_cubit.dart';
import 'helper/app_prefs.dart';
import 'blocs/regother/regother1crud_bloc.dart';
import 'blocs/regother/regother1list_bloc.dart';
import 'blocs/regother/regother2form_bloc.dart';


import 'package:joss_app/repositories/regother/regother1crud_repository.dart';
import 'package:joss_app/repositories/regother/regother2form_repository.dart';

import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
import 'package:joss_app/blocs/payment/dnsppamvcari_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory:
  //   kIsWeb
  //       ? HydratedStorageDirectory.web
  //       : HydratedStorageDirectory(
  //     (await getApplicationDocumentsDirectory()).path,
  //   ),
  // );

  final userRepository = UserRepository();
  final prefs = await SharedPreferences.getInstance();
  final appPrefs = AppPrefs(prefs);
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),),
        BlocProvider<SimulasiParLocalCubit>(create: (_) => SimulasiParLocalCubit(appPrefs),),
        BlocProvider<SimulasiMvLocalCubit>(create: (_) => SimulasiMvLocalCubit(appPrefs),),
        BlocProvider(create: (context) => LoginBloc(authenticationBloc: context.read<AuthenticationBloc>(),userRepository: userRepository,),),
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
        BlocProvider<EmailVerificationBloc>(create: (context) =>EmailVerificationBloc(repository: EmailVerificationRepository(),authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
        BlocProvider<RegUserBloc>(create: (context) => RegUserBloc(repository: RegUserRepository(), authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
        BlocProvider(create: (_) => MRekan1ListBloc()),
        BlocProvider(create: (_) => Calmv1ListBloc()),
        BlocProvider(create: (_) => MRekanContactCrudBloc(repository: MRekanContactCrudRepository())),
        BlocProvider(create: (_) => MRekanContactListBloc()),
        BlocProvider(create: (_) => MRekanPajakCrudBloc(repository: MRekanPajakCrudRepository())),
        BlocProvider(create: (_) => Calmv1CrudBloc(repository: Calmv1CrudRepository())),
        BlocProvider(create: (_) => Calmv2FormBloc(repository: Calmv2FormRepository())),
        BlocProvider(create: (_) => Calmv3FormBloc(repository: Calmv3FormRepository())),
        BlocProvider(create: (_) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository())),
        BlocProvider(create: (_) => MRekanGeneralIdvCrudBloc(repository: MRekanGeneralIdvCrudRepository())),
        BlocProvider(create: (_) => MRekanGeneralCmpCrudBloc(repository: MRekanGeneralCmpCrudRepository())),
        BlocProvider<MRekanPicListBloc>(create: (context) => MRekanPicListBloc(repository: MRekanPicListRepository())..add(FetchMRekanPicListEvent()),),
        BlocProvider<MRekanPicCrudBloc>(create: (context) => MRekanPicCrudBloc(repository: MRekanPicCrudRepository()),),
        BlocProvider<RekanPicCobCariBloc>(create: (context) => RekanPicCobCariBloc()),
        BlocProvider<ReqComproBloc>(create: (_) => ReqComproBloc(repository: ReqComproRepository()),),

        BlocProvider(create: (_) => HasilSimulMvCubit()), // hydrated
        BlocProvider(create: (_) => HasilSimulParCubit()), // hydrated

        BlocProvider(create: (_) => Regother2FormBloc(repository: Regother2FormRepository())),
        BlocProvider(create: (_) => Regother1CrudBloc(repository: Regother1CrudRepository())),
        BlocProvider(create: (_) => Regother1ListBloc()),

        BlocProvider(create: (context) => DnrekapcobCariBloc()),
        BlocProvider(create: (context) => DnsppaCariBloc()),
        BlocProvider(create: (context) => DnsppamvCariBloc()),
        BlocProvider(create: (context) => PaymentMethodCariBloc(repository: PaymentDnRepository(api: PaymentDnAPI()))),
        BlocProvider(create: (context) => DnRekap2invBloc()),
        BlocProvider(create: (context) => InvbayarvaFormBloc(repository: InvbayarvaFormRepository())),
        BlocProvider(create:  (context) => Pay1ListBloc()),
        BlocProvider(create: (context) => Pay1CrudBloc(repository: Pay1CrudRepository())),
        BlocProvider(create: (context) => Pay2CariBloc()),
        BlocProvider(create: (_) => GalleryeventCariBloc()..add(RefreshGalleryeventCariEvent())),
        BlocProvider(create: (_) => ReviewCariBloc()..add(RefreshReviewCariEvent())),
        BlocProvider(create: (_) => GallerymemberCariBloc()..add(RefreshGallerymemberCariEvent())),
        BlocProvider(create: (_) => Berita1CariBloc()..add(RefreshBerita1CariEvent(1)),),
        BlocProvider(create: (_) => BeritaKecilCariBloc()..add(RefreshBeritaKecilCariEvent(2)),),
        BlocProvider(create: (_) => BeritaLainCariBloc()..add(RefreshBeritaLainCariEvent(3)),),
        BlocProvider(create: (_) => Berita2CariBloc()),
        BlocProvider(create: (_) => Berita3CariBloc()),
        BlocProvider<ArticleSelectionCubit>(create: (_) => ArticleSelectionCubit(appPrefs),),
        BlocProvider(create: (_) => TrslogCariBloc()),
        BlocProvider<Klaim1ListBloc>(create: (context) => Klaim1ListBloc()),
        BlocProvider<Klaim2ListBloc>(create: (context) => Klaim2ListBloc()),
        BlocProvider<MRekanBankListBloc>(create: (context) => MRekanBankListBloc()),
        BlocProvider<MRekanBankCrudBloc>(create: (context) => MRekanBankCrudBloc(repository: MRekanBankCrudRepository()),),
        BlocProvider<Klaim1CrudBloc>(create: (context) => Klaim1CrudBloc(repository: Klaim1CrudRepository()),),
        BlocProvider<Klaim2CrudBloc>(create: (context) => Klaim2CrudBloc(repository: Klaim2CrudRepository()),),
        BlocProvider(create: (context) => StatusAsetCariBloc()),
        BlocProvider<AsethullCariBloc>(create: (context) => AsethullCariBloc()),
        BlocProvider<AsetRingkasanCariBloc>(create: (context) => AsetRingkasanCariBloc()),
        BlocProvider<AsetParCariBloc>(create: (context) => AsetParCariBloc()),
        BlocProvider<AsetMvCariBloc>(create: (context) => AsetMvCariBloc()),
        BlocProvider<AsetHealthCariBloc>(create: (context) => AsetHealthCariBloc()),
        BlocProvider<AsetothersCariBloc>(create: (context) => AsetothersCariBloc()),
        BlocProvider<AsetDashboardCariBloc>(create: (context) => AsetDashboardCariBloc()),
        BlocProvider(create: (context) => Promo1CariBloc()),
        BlocProvider(create: (context) => Promo2CariBloc()),
        BlocProvider(create:(context) => SppamvListBloc()),
        BlocProvider(create: (context) => SppaparListBloc()),
        BlocProvider(create: (context) => SppaparCrudBloc(repository: SppaparCrudRepository())),
        BlocProvider(create: (context) => SimulparListBloc()),
        BlocProvider<SimulmvCrudBloc>(create: (context) => SimulmvCrudBloc(repository: SimulmvCrudRepository())),
        BlocProvider<SimulparCrudBloc>(create: (context) => SimulparCrudBloc(repository: SimulparCrudRepository())),
        BlocProvider<CobCariBloc>(create: (context) => CobCariBloc()),
        BlocProvider<Dn1CariBloc>(create: (context) => Dn1CariBloc()),
        BlocProvider(create: (context) => InviteBloc(repo: InviteRepository())),
        BlocProvider(create: (context) => Endors1CrudBloc(repository: Endors1CrudRepository())),
        BlocProvider(create: (context) => Endors1ListBloc()),
        BlocProvider(create: (context) => Endors2CariBloc()),
        BlocProvider(create:(context) => Regmv1ListBloc()),
        BlocProvider(create:(context) => Regmv1CrudBloc(repository: Regmv1CrudRepository())),
        BlocProvider(create:(context) => Regmv2FormBloc(repository: Regmv2FormRepository())),
        BlocProvider(create:(context) => Regmv3FormBloc(repository: Regmv3FormRepository())),
        BlocProvider(create:(context) => Regmv4FormBloc(repository: Regmv4FormRepository())),
        BlocProvider(create:(context) => Regmv5FormBloc(repository: Regmv5FormRepository())),
        BlocProvider(create:(context) => Regmv6FormBloc(repository: Regmv6FormRepository())),

        BlocProvider(create: (context) => SppamvCrudBloc(repository: SppamvCrudRepository())),
        BlocProvider(create: (_) => Calpar3FormBloc(repository: Calpar3FormRepository())),
        BlocProvider(create: (_) => Calpar4FormBloc(repository: Calpar4FormRepository())),
        BlocProvider(create: (_) => Calpar2FormBloc(repository: Calpar2FormRepository())),
        BlocProvider(create: (_) => Calpar1CrudBloc(repository: Calpar1CrudRepository())),
        BlocProvider(create: (_) => Calpar1ListBloc()),

        BlocProvider(create: (context) => RegmvUploadStnkBloc(repository: RegmvUploadStnkRepository())),
        BlocProvider(create: (context) => RegmvUploadFotoMobilBloc(repository: RegmvUploadFotoMobilRepository())),
        BlocProvider(create: (context) => RegmvUploadFotoAccBloc(repository: RegmvUploadFotoAccRepository())),

        BlocProvider(create: (context) => Regpar1ListBloc()),
        BlocProvider(create: (context) => Regpar1CrudBloc(repository: Regpar1CrudRepository())),
        BlocProvider(create: (context) => Regpar2FormBloc( repository: Regpar2FormRepository())),
        BlocProvider(create: (context) => Regpar3FormBloc( repository: Regpar3FormRepository())),
        BlocProvider(create: (context) => Regpar4FormBloc( repository: Regpar4FormRepository())),
        BlocProvider(create: (context) => Regpar5FormBloc( repository: Regpar5FormRepository())),

        BlocProvider(create: (context) => Regmv4CariBloc()),
        BlocProvider(create: (context) => RegmvDownloadFotoStnkBloc(repository: RegmvDownloadStnkRepository())),
        BlocProvider(create: (context) => Regmv5CariBloc()),
        BlocProvider(create: (context) => RegmvDownloadFotoMobilBloc(repository: RegmvDownloadFotoMobilRepository())),
        BlocProvider(create: (context) => Regmv7CariBloc()),
        BlocProvider(create: (context) => RegmvDownloadFotoAccBloc(repository: RegmvDownloadFotoAccRepository())),

        BlocProvider(create: (context) => RegparUploadFotoObjectBloc(repository: RegparUploadFotoObjectRepository())),
        BlocProvider(create: (context) => RegparDownloadFotoObjectBloc(repository: RegparDownloadFotoObjectRepository())),
        BlocProvider(create: (context) => Regpar6CariBloc()),
        BlocProvider(create: (context) => CobManPolBloc()),

        BlocProvider(create:  (context) => SppaDownloadPolisBloc(repository: DownloadPolisRepository())),
     ],
      child: MultiBlocListener(
        listeners: [
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

          BlocListener<AuthenticationBloc, AuthenticationState>(
            listenWhen: (_, curr) => curr is AuthenticationAuthenticated,
            listener: (context, state) {
              final s = state as AuthenticationAuthenticated;
              if (s.user.userType == 'C') {
                context.read<MRekan1CrudBloc>().add(MRekan1CrudLihatEvent());
              }

              final fotoState = context.read<ProfileDownloadFotoBloc>().state;
              if (fotoState is! ProfileDownloadFotoLoading &&
                  fotoState is! ProfileDownloadFotoLoaded) {
                context.read<ProfileDownloadFotoBloc>().add(LoadSecureImage());
                // debugPrint('[Foto] LoadSecureImage() dipanggil');
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
  bool _pendingGoToLoginUser = false;
  int _unauthSeenCount = 0;
  int _pushLoginCount = 0;
  @override
  void initState() {
    super.initState();
    _showOnboarding = !widget.seenOnboarding;
  }

  void _onOnboardingCompleted() {
    setState(() {
      _showOnboarding = false;
    });

    if (_pendingGoToLoginUser) {
      _pendingGoToLoginUser = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final nav = _navigatorKey.currentState;
        if (nav == null) return;

        nav.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginUser()),
              (route) => false,
        );
      });
    }
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

        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) => curr is AuthenticationRequireLoginClient,
          listener: (_, state) {
            if (state is AuthenticationRequireLoginClient) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final nav = _navigatorKey.currentState;
                if (nav == null) return;

                nav.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginClient(),
                  ),
                      (route) => false,
                );
              });
            }
          },
        ),

        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) => curr is AuthenticationUnauthenticated,
          listener: (_, state) {
            if (state is AuthenticationUnauthenticated) {
              // Kalau onboarding belum selesai: tahan dulu
              if (_showOnboarding) {
                _pendingGoToLoginUser = true;
                return;
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                final nav = _navigatorKey.currentState;
                if (nav == null) return;

                nav.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginUser()),
                      (route) => false,
                );
              });
            }
          },
        ),

        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (_, curr) => curr is AuthenticationAuthenticated,
          listener: (_, state) {
            if (state is AuthenticationAuthenticated) {
              // Kalau onboarding masih aktif, jangan pop apa-apa dulu
              if (_showOnboarding) return;
              debugPrint(state.authenticatedFrom);
              if (state.authenticatedFrom == 'login_user' ||
                  state.authenticatedFrom == 'login_client' ||
                  state.authenticatedFrom == 'email_verification') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final nav = _navigatorKey.currentState;
                  if (nav == null) return;

                  nav.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => HomeTabWidget(userRepository: widget.userRepository),
                    ),
                        (route) => false,
                  );
                });
              }
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

        themeMode: ThemeMode.dark,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'chat':
              return MaterialPageRoute(
                builder: (_) => const MobileChatScreen(),
              );
            default:
              return null;
          }
        },

        home: _showOnboarding
            ? StartScreen(onCompleted: _onOnboardingCompleted)
            : HomeTabWidget(
          userRepository: widget.userRepository,),
      ),
    );
  }
}


/*
home: _showOnboarding
            ? StartScreen(onCompleted: _onOnboardingCompleted)
            : BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              while (_navigatorKey.currentState?.canPop() ?? false) {
                _navigatorKey.currentState?.pop();
              }

              final user = state.user;
              final homeWidget = HomeTabWidget(userRepository: widget.userRepository);

              if (ChatInitService.I.isInitialized) {
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

                      // ambil nama paling relevan
                      final displayName =
                      (state.record?.rekanNama?.trim().isNotEmpty ?? false)
                          ? state.record!.rekanNama!.trim()
                          : "Guest";

                      final result = await ChatInitService.I.ensureInit(
                        userId: userId,
                        displayName: displayName,
                      );
                    } catch (e, s) {
                      debugPrint("🔥 [ChatInit Error C] $e\n$s");
                    }
                  },
                  child: homeWidget,
                );
              }

              else if ((user.userType ?? '').toUpperCase() == 'U') {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (ChatInitService.I.isInitialized) return;

                  try {
                    final guestId = "guest-${DateTime.now().millisecondsSinceEpoch}";
                    final email = user.email?.trim() ?? guestId;

                    final result = await ChatInitService.I.ensureInit(
                      userId: email,
                      displayName: email,
                    );

                  } catch (e, s) {
                    debugPrint("🔥 [ChatInit Error U] $e\n$s");
                  }
                });
              }

              else {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (ChatInitService.I.isInitialized) return;

                  try {
                    final guestId = "guest-${DateTime.now().millisecondsSinceEpoch}";
                    final email = user.email?.trim() ?? guestId;

                    final result = await ChatInitService.I.ensureInit(
                      userId: email,
                      displayName: email,
                    );
                  } catch (e, s) {
                    debugPrint("🔥 [ChatInit Error UNKNOWN] $e\n$s");
                  }
                });
              }

              // 🔹 6. Default fallback
              return homeWidget;
            }

            if (state is AuthenticationUnauthenticated) {
              // context.read<UserProfileCubit>().clearProfile();
              context.read<LoginBloc>().add(LoginReset());

              ChatInitService.I.dispose();
              return const LoginUser();
            }

            if (state is AuthenticationRequireLoginClient) {
              return const LoginClient();
            }
            //
            // if (state is AuthenticationRequireRegisterClient) {
            //   debugPrint('[MAIN] show RegisterClient from=${state.requiredFrom}');
            //   return RegisterClient(requestFrom: state.requiredFrom,);
            // }

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

              String requestFrom = context.read<RegUserBloc>().state.requestFrom;
              if (requestFrom == "calmv_page " || requestFrom == "calpar_page") {
                debugPrint("Log out user");
                // force login user
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedOut(),
                );
              }else{
                while (_navigatorKey.currentState?.canPop() ?? false) {
                  _navigatorKey.currentState?.pop();
                }
                context.read<AuthenticationBloc>().add(LoggedOut());
              }

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

*/