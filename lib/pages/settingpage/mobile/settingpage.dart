import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import '../../login/mobile/user/widget/popup_user_widget.dart';


const List<String> scopes = <String>[
  'email',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
  clientId: kIsWeb ? '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com' : null,
  serverClientId: kIsWeb ? null : '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com',
);

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
      return CircleAvatar(radius: 30, backgroundImage: MemoryImage(bytes));
    }
    return CircleAvatar(
      radius: 30,
      backgroundColor: primaryColor,
      child: Text(initials, style: TextStyle(color: Colors.white, fontSize: getResponsiveFont(context, 20), fontWeight: FontWeight.w700)),
    );
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first[0] : '';
    final last  = parts.length > 1 ? parts.last[0]  : '';
    return (first + last).toUpperCase();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        margin: const EdgeInsets.all(hPadding),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    try {
      // Kalau ada animasi overlay
      // await _animationController.reverse();
      // await _overlayController.reverse();
    } catch (_) {}

    if (!context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _googleSignIn.signOut(); // Logout Google
      } catch (e) {
        debugPrint("Google SignOut error: $e");
      }

      // Trigger logout ke AuthenticationBloc
      context.read<AuthenticationBloc>().add(
        LoggedOut(),
      );
    });

    // Tutup popup atau navigasi balik
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: BaseBackgroundFirstPage(
        backgroundAsset: "assets/images/background_gradient.png",
        fadeHeight: 300,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(hPadding),
            child: Column(
              children: [
                // ================== PROFILE SECTION ==================
                BlocBuilder<UserProfileCubit, UserProfileState>(
                  buildWhen: (prev, curr) {
                    final nameChanged  = prev.nama    != curr.nama;
                    final emailChanged = prev.email   != curr.email;
                    final telpChanged  = prev.telepon != curr.telepon;

                    // bandingkan perubahan bytes (tanpa deep-compare)
                    final bytesChanged =
                        (prev.fotoBytes == null && curr.fotoBytes != null) ||
                            (prev.fotoBytes != null && curr.fotoBytes == null) ||
                            (prev.fotoBytes != null &&
                                curr.fotoBytes != null &&
                                prev.fotoBytes!.lengthInBytes != curr.fotoBytes!.lengthInBytes);

                    return nameChanged || emailChanged || telpChanged || bytesChanged;
                  },
                  builder: (context, state) {
                    final nama = (state.nama?.trim().isNotEmpty ?? false)
                        ? state.nama!.trim()
                        : 'Pengguna';
                    final email = (state.email?.trim().isNotEmpty ?? false)
                        ? state.email!.trim()
                        : null;
                    final telepon = (state.telepon?.trim().isNotEmpty ?? false)
                        ? state.telepon!.trim()
                        : null;
                    final foto = (state.fotoBytes != null && state.fotoBytes!.isNotEmpty)
                        ? state.fotoBytes
                        : null;

                    return Container(
                      padding: const EdgeInsets.all(1), // Padding untuk border
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.0), // Pudar ke transparent
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(hPaddingForCard),
                        decoration: BoxDecoration(
                          color: pGrey,
                          borderRadius: BorderRadius.circular(cardBorderRadius - 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAvatar(foto, _initialsFromName(nama)),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nama
                                  Text(
                                    nama,
                                    style: TextStyle(
                                      color: primaryLightColor,
                                      fontSize: getResponsiveFont(context, 22),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Role/subtitle (opsional)
                                  Text(
                                    'Nasabah Biasa',
                                    style: TextStyle(color: primaryLightColor, fontSize: getResponsiveFont(context, 18)),
                                  ),

                                  const SizedBox(height: 4),

                                  // Email (jika ada)
                                  if (email != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.email, color: primaryLightColor, size: 16),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            email,
                                            style: TextStyle(color: primaryLightColor, fontSize: getResponsiveFont(context, 16)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                  // Telepon (jika ada)
                                  if (telepon != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, color: primaryLightColor, size: 16),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            telepon,
                                            style: TextStyle(color: primaryLightColor, fontSize: getResponsiveFont(context, 16)),
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
                  },
                ),
                // ================== END PROFILE SECTION ==================

                const SizedBox(height: vPadding),

                // Menu Items
                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(
                      color: sGrey,   // pakai warna abu-abu dari constant
                      width: 1.0,     // ketebalan border
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Kelola Profil',
                        onTap: () => _showSnackBar('Kelola Profil diklik'),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        onTap: () {

                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: vPadding),

                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(
                      color: sGrey,   // pakai warna abu-abu dari constant
                      width: 1.0,     // ketebalan border
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.local_shipping_outlined,
                        title: 'Syarat dan Ketentuan',
                        onTap: () => _showSnackBar('Syarat dan Ketentuan diklik'),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.favorite_border,
                        title: 'Kebijakan dan Privasi',
                        onTap: () => _showSnackBar('Kebijakan dan Privasi diklik'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: vPadding),

                // Toggle Settings
                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(
                      color: sGrey,   // pakai warna abu-abu dari constant
                      width: 1.0,     // ketebalan border
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSwitchItem(
                        title: 'Email Notifikasi',
                        value: emailNotification,
                        onChanged: (value) {
                          setState(() => emailNotification = value);
                          _showSnackBar('Email Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}');
                        },
                      ),
                      // _buildDivider(),
                      _buildSwitchItem(
                        title: 'Mode Gelap',
                        value: darkMode,
                        onChanged: (value) {
                          setState(() => darkMode = value);
                          _showSnackBar('Mode Gelap ${value ? 'diaktifkan' : 'dinonaktifkan'}');
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: vPadding),

                // Logout Button
                Container(
                  decoration: BoxDecoration(
                    color: pGrey,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    border: Border.all(
                      color: sGrey,   // pakai warna abu-abu dari constant
                      width: 1.0,     // ketebalan border
                    ),
                  ),
                  child: _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    titleColor: pDarkRed,
                    iconColor: pRed,
                    onTap: () => _confirmLogout(context),
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
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(hPaddingForCard),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryLightColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(cardBorderRadius),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: primaryLightColor,
                fontSize:  getResponsiveFont(context, 18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryLightColor,
            activeTrackColor: pBlue,
            inactiveThumbColor: primaryLightColor,
            inactiveTrackColor: pGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: sGrey,
      height: 1,
      thickness: 1,
      indent: hPaddingForCard,
      endIndent: hPaddingForCard,
    );
  }
}