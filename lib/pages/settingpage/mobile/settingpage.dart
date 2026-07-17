import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/gen_profile/mrekancontactcrud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../blocs/notifevent/notif_email_setting_bloc.dart';
import '../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../common/app_data.dart';
import '../../profile/mobile/profile/form_section/rekan_bank.dart';
import '../../profile/mobile/profile/form_section/rekan_contact.dart';
import '../../profile/mobile/profile/form_section/rekan_general_cmp.dart';
import '../../profile/mobile/profile/form_section/rekan_general_idv.dart';
import '../../profile/mobile/profile/form_section/rekan_pic_widget.dart';
import '../widgets/kebijakan_privasi_page.dart';
import '../widgets/settings_profile_card_widget.dart';
import '../widgets/syarat_ketentuan_page.dart';
import '../widgets/ubah_password_popup.dart';
import '../../base/base_background_firstpage.dart';
import '../../../common/constants.dart';
import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';

const List<String> scopes = <String>['email'];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = true;

  late MRekanContactCrudBloc contactBloc;
  late MRekanGeneralCmpCrudBloc cmpBloc;
  late MRekanGeneralIdvCrudBloc idvBloc;

  String? profileNama;
  String? profileEmail;
  String? profileTelepon;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mjenisClient =
          context.read<MRekan1CrudBloc>().state.record?.mjnsclientId ?? '';

      context.read<MRekanContactCrudBloc>().add(MRekanContactCrudLihatEvent());

      final authState = context.read<AuthenticationBloc>().state;
      final userType = authState is AuthenticationAuthenticated
          ? authState.user.userType.trim()
          : '';

      if (userType.isNotEmpty) {
        context
            .read<NotifEmailSettingBloc>()
            .add(NotifEmailSettingLihatEvent());
      }

      if (mjenisClient == '10') {
        context
            .read<MRekanGeneralIdvCrudBloc>()
            .add(MRekanGeneralIdvCrudLihatEvent());
      } else {
        context
            .read<MRekanGeneralCmpCrudBloc>()
            .add(MRekanGeneralCmpCrudLihatEvent());
      }
    });
  }

  Future<bool?> showLogoutConfirmDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Keluar Sekarang?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kamu bisa login lagi kapan pun kok.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sGrey,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pSlowRed,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: Text(
                              "Iya, Keluar",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  String _resolveUserType(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is! AuthenticationAuthenticated) {
      return "";
    }
    return authState.user.userType.trim();
  }

  Future<void> handleLogout(BuildContext context) async {
    final shouldLogout = await showLogoutConfirmDialog(context);
    if (!context.mounted) return;

    if (shouldLogout == true) {
      if (_resolveUserType(context).isEmpty) {
        await SystemNavigator.pop();
        return;
      }

      context.read<AuthenticationBloc>().add(LoggedOut());
      context.read<ProfileDownloadFotoBloc>().add(ClearSecureImage());
      ChatInitService.I.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mjenisClient = context.select(
      (MRekan1CrudBloc b) => b.state.record?.mjnsclientId ?? '',
    );

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: MultiBlocListener(
            listeners: _buildListeners(),
            child: _buildContent(context, mjenisClient),
          ),
        ),
      ),
    );
  }

  List<BlocListener> _buildListeners() {
    return [
      BlocListener<MRekanContactCrudBloc, MRekanContactCrudState>(
        listener: (context, state) {
          final rec = state.record;
          if (rec != null) {
            setState(() {
              profileEmail =
                  rec.email.trim().isNotEmpty ? rec.email : AppData.user.email;

              profileTelepon =
                  rec.telp.trim().isNotEmpty ? rec.telp : AppData.user.hp;
            });
          }
        },
      ),
      BlocListener<MRekanGeneralIdvCrudBloc, MRekanGeneralIdvCrudState>(
        listener: (context, state) {
          final rec = state.record;
          if (rec != null) {
            setState(() {
              profileNama = rec.rekanNama.trim().isNotEmpty
                  ? rec.rekanNama
                  : AppData.user.nama;
            });
          }
        },
      ),
      BlocListener<MRekanGeneralCmpCrudBloc, MRekanGeneralCmpCrudState>(
        listener: (context, state) {
          final rec = state.record;
          if (rec != null) {
            setState(() {
              profileNama = (rec.rekanNama?.trim().isNotEmpty ?? false)
                  ? rec.rekanNama
                  : AppData.user.nama;
            });
          }
        },
      ),
    ];
  }

  Widget _buildContent(BuildContext context, String mjenisClient) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        color: secondaryBlackColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
                  final userType = authState is AuthenticationAuthenticated
                      ? authState.user.userType.toUpperCase()
                      : '';

                  if (userType == 'C') {
                    return SettingsProfileCardWidget(
                      nama: profileNama ?? AppData.user.nama ?? "",
                      email: profileEmail ?? AppData.user.email,
                      telepon: profileTelepon ?? AppData.user.hp,
                      subtitle: "Klien Proteksi Plus",
                    );
                  } else {
                    return const SettingsProfileCardWidget(
                      nama: "Pengguna Baru",
                    );
                  }
                },
              ),
              const SizedBox(height: hPadding),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
                  final userType = authState is AuthenticationAuthenticated
                      ? authState.user.userType
                      : '';

                  if (userType == 'C') {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Akun'),
                        _buildCardContainer(
                          children: [
                            _buildMenuItem(
                              svgAsset: 'assets/icons/ubah_pass.svg',
                              title: 'Ubah Kata Sandi',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UbahPasswordPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: vPadding),
                        _buildSectionTitle(context, 'Informasi'),
                        _buildCardContainer(
                          children: [
                            _buildMenuItem(
                              svgAsset: 'assets/icons/informasi_klien.svg',
                              title: 'Informasi Klien',
                              onTap: () async {
                                if (mjenisClient == '10') {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MRekanGeneralIdvCrudFormPage(),
                                    ),
                                  );
                                } else {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MRekanGeneralCmpCrudFormPage(),
                                    ),
                                  );
                                }
                              },
                            ),
                            sDivider,
                            _buildMenuItem(
                              svgAsset: 'assets/icons/location.svg',
                              title: 'Kontak & Alamat',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const MRekanContactCrudFormPage(),
                                  ),
                                );
                              },
                            ),
                            sDivider,
                            _buildMenuItem(
                              svgAsset: 'assets/icons/bank.svg',
                              title: 'Rekening Bank',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const MRekanBankCrudFormPage(
                                      viewMode: 'tambah',
                                      recordId: '',
                                    ),
                                  ),
                                );
                              },
                            ),
                            sDivider,
                            _buildMenuItem(
                              svgAsset: 'assets/icons/group.svg',
                              title: 'Akses & Anggota',
                              svgAssetColor: primaryLightColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RekanPicWidgetPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: vPadding),
              _buildSectionTitle(context, 'Syarat dan Ketentuan'),
              _buildCardContainer(
                children: [
                  _buildMenuItem(
                    svgAsset: 'assets/icons/sk.svg',
                    title: 'Syarat dan Ketentuan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SyaratKetentuanPage(),
                        ),
                      );
                    },
                  ),
                  sDivider,
                  _buildMenuItem(
                    svgAsset: 'assets/icons/shield.svg',
                    title: 'Kebijakan dan Privasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KebijakanPrivasiPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: vPadding),
              _buildSectionTitle(context, 'Lainnya'),
              _buildCardContainer(
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, authState) {
                      final userType = authState is AuthenticationAuthenticated
                          ? authState.user.userType.trim()
                          : '';

                      if (userType.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return BlocConsumer<NotifEmailSettingBloc,
                          NotifEmailSettingState>(
                        listenWhen: (prev, curr) =>
                            prev.isSaved != curr.isSaved ||
                            prev.hasFailure != curr.hasFailure,
                        listener: (context, state) {
                          if (state.isSaved && state.message.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              successSnackBar(state.message),
                            );
                          }

                          if (state.hasFailure && state.message.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(state.message),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              _buildSwitchItem(
                                svgAsset: 'assets/icons/notification.svg',
                                title: 'Email Notifikasi',
                                value: state.isNotifEmail,
                                onChanged: state.isSaving
                                    ? (_) {}
                                    : (value) {
                                        context
                                            .read<NotifEmailSettingBloc>()
                                            .add(
                                              NotifEmailSettingUbahEvent(
                                                value,
                                              ),
                                            );
                                      },
                              ),
                              sDivider,
                            ],
                          );
                        },
                      );
                    },
                  ),
                  _buildMenuItem(
                    svgAsset: 'assets/icons/bantuan.svg',
                    title: 'Bantuan',
                    onTap: () {
                      Navigator.pushNamed(context, 'chat');
                    },
                  ),
                ],
              ),
              const SizedBox(height: vPadding),
              _buildSectionTitle(context, 'Keluar'),
              _buildCardContainer(
                children: [
                  _buildMenuItem(
                    svgAsset: 'assets/icons/logout.svg',
                    title: 'Keluar',
                    titleColor: pDarkRed,
                    showForwardsvgAsset: false,
                    svgAssetColor: pRed,
                    onTap: () async {
                      await handleLogout(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: hPadding),
              _buildSectionTitle(context, 'v1.0.1'),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey),
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required String svgAsset,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? svgAssetColor,
    bool showForwardsvgAsset = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: vPadding,
          vertical: hPadding,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 20,
              height: 20,
              colorFilter: svgAssetColor != null
                  ? ColorFilter.mode(svgAssetColor, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: bodyTextStyle(context).copyWith(color: titleColor),
              ),
            ),
            if (showForwardsvgAsset)
              Icon(Icons.arrow_forward_ios, color: primaryLightColor, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String svgAsset,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    double switchScale = 0.75,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: vPadding),
      child: Row(
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(primaryLightColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: bodyTextStyle(context))),
          Transform.scale(
            scale: switchScale,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: primaryLightColor,
              activeTrackColor: pBlue,
              inactiveThumbColor: primaryLightColor,
              inactiveTrackColor: pGrey,
            ),
          ),
        ],
      ),
    );
  }
}
