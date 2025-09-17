import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/reguser_profile/reguser_profile_cubit.dart';
import '../../../blocs/reguser_profile/reguser_profile_state.dart';
import '../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../blocs/user_profile/user_profile_state.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import '../../profilepage/mobile/profile/form_section/pic_form/rekan_pic.dart';
import '../../test_bank/mrekanbanklist_main.dart';
import '../widgets/logout_popup.dart';
import '../../profilepage/mobile/profile/form_section/rekan_bank.dart';
import '../../profilepage/mobile/profile/form_section/rekan_contact.dart';
import '../../profilepage/mobile/profile/form_section/rekan_general_cmp.dart';
import '../../profilepage/mobile/profile/form_section/rekan_general_idv.dart';
import '../widgets/ubah_password_popup.dart';

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
    required String subtitle,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(foto, _initialsFromName(nama)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: headingStyle(context, fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: bodyTextStyle(context)),
                  const SizedBox(height: 4),
                  if (email != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.email, color: primaryLightColor, size: 16),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            email,
                            style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey),
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
                        const Icon(Icons.phone, color: primaryLightColor, size: 16),
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
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: hPadding * 1.5
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================== PROFILE SECTION ==================
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authState) {
                    final custType = authState is AuthenticationAuthenticated
                        ? authState.user.custType
                        : '';

                    if (custType == 'C') {
                      // 🔹 Client → ambil dari UserProfileCubit
                      return BlocBuilder<UserProfileCubit, UserProfileState>(
                        buildWhen: (prev, curr) {
                          final nameChanged = prev.nama != curr.nama;
                          final emailChanged = prev.email != curr.email;
                          final telpChanged = prev.telepon != curr.telepon;
                          final bytesChanged =
                              (prev.fotoBytes == null && curr.fotoBytes != null) ||
                                  (prev.fotoBytes != null && curr.fotoBytes == null) ||
                                  (prev.fotoBytes != null &&
                                      curr.fotoBytes != null &&
                                      prev.fotoBytes!.lengthInBytes !=
                                          curr.fotoBytes!.lengthInBytes);

                          return nameChanged || emailChanged || telpChanged || bytesChanged;
                        },
                        builder: (context, state) {
                          final nama = (state.nama?.trim().isNotEmpty ?? false)
                              ? state.nama!.trim()
                              : 'Pengguna';
                          final email =
                          (state.email?.trim().isNotEmpty ?? false) ? state.email!.trim() : null;
                          final telepon = (state.telepon?.trim().isNotEmpty ?? false)
                              ? state.telepon!.trim()
                              : null;
                          final foto = (state.fotoBytes != null && state.fotoBytes!.isNotEmpty)
                              ? state.fotoBytes
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
                    } else if (custType == 'U') {
                      // 🔹 User baru → ambil dari RegUserProfileCubit
                      return BlocBuilder<RegUserProfileCubit, RegUserProfileState>(
                        buildWhen: (prev, curr) =>
                        prev.email != curr.email,
                        builder: (context, state) {
                          final nama = (state.email.trim().isNotEmpty)
                              ? state.email.trim()
                              : 'Pengguna Baru';
                          // final email =
                          // (state.email.trim().isNotEmpty) ? state.email.trim() : null;

                          return _buildProfileCard(
                            context: context,
                            nama: nama,
                            foto: null, // RegUserProfileCubit belum simpan foto
                            subtitle: "Nasabah Biasa",
                          );
                        },
                      );
                    }

                    return _buildProfileCard(
                      context: context,
                      nama: "Guest",
                      foto: null,
                      subtitle: "Nasabah biasa",
                    );
                  },
                ),

                const SizedBox(height: vPadding),

                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authState) {
                    final custType = authState is AuthenticationAuthenticated
                        ? authState.user.custType
                        : '';

                    if (custType == 'C') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Akun',
                            style: bodyTextStyle(
                              context,
                              fontSize: 16,
                            ).copyWith(color: hintGrey),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: pGrey,
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              border: Border.all(color: sGrey),
                            ),
                            child: Column(
                              children: [
                                _buildMenuItem(
                                  svgAsset: 'assets/icons/ubah_pass.svg',
                                  title: 'Ubah Password',
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
                          ),
                          const SizedBox(height: vPadding),
                          Text(
                            'Informasi',
                            style: bodyTextStyle(
                              context,
                              fontSize: 16,
                            ).copyWith(color: hintGrey),
                          ),

                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: pGrey,
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              border: Border.all(color: sGrey),
                            ),
                            child: Column(
                              children: [
                                _buildMenuItem(
                                  svgAsset: 'assets/icons/informasi_klien.svg',
                                  title: 'Informasi Klien',
                                  onTap: () {
                                    final mjnsclientId =
                                        context.read<UserProfileCubit>().state.mjnsclientId;

                                    if (mjnsclientId == '10') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const MRekanGeneralIdvCrudFormPage(),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
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
                                        builder: (context) =>
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
                                        builder: (context) => const MRekanBankCrudFormPage(
                                          viewMode: 'tambah',
                                          recordId: '',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                sDivider,
                                _buildMenuItem(
                                  svgAsset: 'assets/icons/pic.svg',
                                  title: 'Informasi PIC',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MRekanPicInlineEditorList(
                                          // viewMode: 'tambah',
                                          // recordId: '',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: vPadding),
                        ],
                      );
                    }

                    // Kalau bukan custType C → return widget kosong
                    return const SizedBox.shrink();
                  },
                ),

                Text('Syarat dan Ketentuan', style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey)),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(color: sGrey),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        svgAsset: 'assets/icons/sk.svg',
                        title: 'Syarat dan Ketentuan',
                        onTap:
                            () =>
                            successSnackBar('Syarat dan Ketentuan diklik'),
                      ),
                      // _buildMenuItem(
                      //   svgAsset: 'assets/icons/pic.svg',
                      //   title: 'Informasi PIC',
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const KlaimMainPage(
                      //           // viewMode: 'tambah',
                      //           // recordId: '',
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      sDivider,
                      _buildMenuItem(
                        svgAsset:'assets/icons/shield.svg',
                        title: 'Kebijaan dan Privasi',
                        onTap:
                            () =>
                            successSnackBar('Kebijakan dan Privasi diklik'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: vPadding),

                Text('Lainnnya', style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey)),
                const SizedBox(height: 6),
                // Toggle Settings
                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(color: sGrey),
                  ),
                  child: Column(
                    children: [
                      _buildSwitchItem(
                        title: 'Email Notifikasi',
                        value: emailNotification,
                        onChanged: (value) {
                          setState(() => emailNotification = value);
                          successSnackBar(
                            'Email Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: vPadding),

                Text('Keluar', style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey)),
                const SizedBox(height: 6),
                // Logout Button
                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(color: sGrey),
                  ),
                  child: _buildMenuItem(
                    svgAsset: 'assets/icons/logout.svg',
                    title: 'Keluar',
                    titleColor: pDarkRed,
                    showForwardsvgAsset: false,
                    svgAssetColor: pRed,
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => const LogoutConfirmationPopup(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
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
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    double switchScale = 0.75,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: vPadding
      ),
      child: Row(
        children: [
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
