import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
import 'package:joss_app/pages/qontak/mobile/chat_init_service.dart';
import 'package:joss_app/pages/qontak/mobile/customer_service_page.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../blocs/user_profile/user_profile_state.dart';
import '../../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../../blocs/reguser_profile/reguser_profile_state.dart';
import '../../../blocs/user_profile/user_profile_cubit.dart';
import '../../gen_cob_app/cobcari_main.dart';
import '../../gen_dn1/dn1cari_list.dart';
import '../../login/change_pswd_main.dart';
import '../../profile/mobile/profile/form_section/crud_pic/list_pic.dart';
import '../../profile/mobile/profile/form_section/rekan_bank.dart';
import '../../profile/mobile/profile/form_section/rekan_contact.dart';
import '../../profile/mobile/profile/form_section/rekan_general_cmp.dart';
import '../../profile/mobile/profile/form_section/rekan_general_idv.dart';
import '../../profile/mobile/profile/form_section/rekan_pic.dart';
import '../widgets/logout_popup.dart';
import '../widgets/ubah_password_popup.dart';

import '../../base/base_background_firstpage.dart';
import '../../../common/constants.dart';

const List<String> scopes = <String>['email'];

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool emailNotification = true;
  bool darkMode = true;

  Widget _buildAvatar(Uint8List? bytes, String initials) {
    if (bytes != null && bytes.isNotEmpty) {
      return CircleAvatar(radius: 23, backgroundImage: MemoryImage(bytes));
    }
    return CircleAvatar(
      radius: 23,
      backgroundColor: primaryColor,
      child: Text(initials, style: headingStyle(context, fontSize: 20)),
    );
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Widget _buildProfileCard({
    required BuildContext context,
    required String nama,
    String? email,
    String? telepon,
    Uint8List? foto,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.6),
            primaryColor.withOpacity(0.4),
            primaryColor.withOpacity(0.2),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 0.75, 0.9, 1.0],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(hPadding + 6),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius - 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(foto, _initialsFromName(nama)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: headingStyle(context, fontSize: 22)),
                  const SizedBox(height: 4),
                  if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: bodyTextStyle(context)),
                  ],
                  const SizedBox(height: 4),
                  if (email != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: primaryLightColor,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            email,
                            style: bodyTextStyle(
                              context,
                              fontSize: 16,
                            ).copyWith(color: hintGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (telepon != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: primaryLightColor,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            telepon,
                            style: bodyTextStyle(context, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mjnsclientId = context.select((RegUserBloc b) => b.state.record?.jnsClientId);
    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: const BorderRadius.only(
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
                    // ================== PROFILE SECTION ==================
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, authState) {
                        final userType = authState is AuthenticationAuthenticated
                            ? (authState.user.userType ?? '').toUpperCase()
                            : '';

                        if (userType == 'C') {
                          // 🔹 CLIENT
                          return BlocBuilder<MRekan1CrudBloc, MRekan1CrudState>(
                            buildWhen: (prev, curr) {
                              final prevRec = prev.record;
                              final currRec = curr.record;

                              return prevRec?.rekanNama != currRec?.rekanNama ||
                                  prevRec?.email != currRec?.email ||   // sesuaikan nama field
                                  prevRec?.telepon != currRec?.telepon;       // sesuaikan nama field
                            },
                            builder: (context, rekanState) {
                              final namaRaw = rekanState.record?.rekanNama?.trim();
                              final emailRaw = rekanState.record?.email?.trim(); // <-- ganti sesuai modelmu
                              final telpRaw  = rekanState.record?.telepon?.trim();  // <-- ganti sesuai modelmu

                              final nama = (namaRaw != null && namaRaw.isNotEmpty) ? namaRaw : 'Pengguna';
                              final email = (emailRaw != null && emailRaw.isNotEmpty) ? emailRaw : null;
                              final telepon = (telpRaw != null && telpRaw.isNotEmpty) ? telpRaw : null;

                              return BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
                                buildWhen: (prev, curr) =>
                                curr is ProfileDownloadFotoLoaded ||
                                    (prev is ProfileDownloadFotoLoaded && curr is! ProfileDownloadFotoLoaded),
                                builder: (context, fotoState) {
                                  final foto = (fotoState is ProfileDownloadFotoLoaded &&
                                      fotoState.imageBytes.isNotEmpty)
                                      ? fotoState.imageBytes
                                      : null;

                                  return _buildProfileCard(
                                    context: context,
                                    nama: nama,
                                    email: email,
                                    telepon: telepon,
                                    foto: foto,
                                    subtitle: "Klien JPS",
                                  );
                                },
                              );
                            },
                          );
                        }

                        else if (userType == 'U') {
                          final displayName = authState is AuthenticationAuthenticated
                              ? (authState.user.email?.trim().isNotEmpty ?? false)
                              ? authState.user.email!.trim()
                              : 'Pengguna Baru'
                              : 'Pengguna Baru';

                          return _buildProfileCard(
                            context: context,
                            nama: displayName,
                            foto: null,
                          );
                        }


                        else {
                          final fallbackEmail = authState is AuthenticationAuthenticated
                              ? (authState.user.email?.trim() ?? 'Guest User')
                              : 'Guest User';

                          debugPrint(
                              "⚙️ [ProfileCard] userType kosong/tidak dikenal → pakai auth email: $fallbackEmail");

                          return _buildProfileCard(
                            context: context,
                            nama: fallbackEmail,
                            foto: null,
                            subtitle: "Nasabah Biasa",
                          );
                        }

                        // return _buildProfileCard(
                        //   context: context,
                        //   nama: "Guest",
                        //   foto: null,
                        //   subtitle: "Nasabah biasa",
                        // );
                      },
                    ),

                    const SizedBox(height: hPadding),

                    // ================== AKUN SECTION ==================
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, authState) {
                        final userType =
                            authState is AuthenticationAuthenticated
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
                                    title: 'Ubah Password',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const UbahPasswordPage(),
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
                                    svgAsset:
                                        'assets/icons/informasi_klien.svg',
                                    title: 'Informasi Klien',
                                    onTap: () async {
                                      if (mjnsclientId == '10') {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const MRekanGeneralIdvCrudFormPage(),
                                          ),
                                        );
                                      } else {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const MRekanGeneralCmpCrudFormPage(),
                                          ),
                                        );
                                      }

                                      context.read<MRekan1CrudBloc>().add(
                                        MRekan1CrudLihatEvent(),
                                      );

                                      context.read<ProfileDownloadFotoBloc>().add(LoadSecureImage());
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
                                          builder:
                                              (_) =>
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
                                          builder:
                                              (_) =>
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
                                          builder: (_) => const MrekanPicMainPage(),
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

                    // ================== SYARAT & KETENTUAN ==================
                    _buildSectionTitle(context, 'Syarat dan Ketentuan'),
                     _buildCardContainer(
                      children: [
                        _buildMenuItem(
                          svgAsset: 'assets/icons/sk.svg',
                          title: 'Syarat dan Ketentuan',
                          onTap:
                              () => successSnackBar(
                                'Syarat dan Ketentuan diklik',
                              ),
                        ),
                        sDivider,
                        _buildMenuItem(
                          svgAsset: 'assets/icons/shield.svg',
                          title: 'Kebijakan dan Privasi',
                          onTap:
                              () => successSnackBar(
                                'Kebijakan dan Privasi diklik',
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: vPadding),

                    // ================== LAINNYA ==================
                    _buildSectionTitle(context, 'Lainnya'),
                    _buildCardContainer(
                      children: [
                        _buildSwitchItem(
                          svgAsset: 'assets/icons/notification.svg',
                          title: 'Email Notifikasi',
                          value: emailNotification,
                          onChanged: (value) {
                            setState(() => emailNotification = value);
                            successSnackBar(
                              'Email Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                            );
                          },
                        ),
                        sDivider,
                        _buildMenuItem(
                          svgAsset: 'assets/icons/bantuan.svg',
                          title: 'Bantuan',
                          onTap: () async {
                            // if (ChatInitService.I.isInitialized) {
                            //   Navigator.pushNamed(context, 'chat');
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Chat belum siap, coba lagi')),
                            //   );
                            // }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: vPadding),

                    // ================== LOGOUT ==================
                    _buildSectionTitle(context, 'Keluar'),
                    _buildCardContainer(
                      children: [
                        _buildMenuItem(
                          svgAsset: 'assets/icons/logout.svg',
                          title: 'Keluar',
                          titleColor: pDarkRed,
                          showForwardsvgAsset: false,
                          svgAssetColor: pRed,
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder:
                                  (context) => const LogoutConfirmationPopup(),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Helper kecil untuk section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey),
      ),
    );
  }

  // 🔹 Helper untuk card container
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
              colorFilter:
                  svgAssetColor != null
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
