import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../common/constants.dart';
import '../../base/base_background_firstpage.dart';
import '../widgets/logout_popup.dart';
import 'package:joss_app/pages/settingpage/widgets/ubah_password_popup.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: hPadding * 2.5,
              vertical: vPadding,
            ),
            child: Column(
              children: [
                BlocBuilder<UserProfileCubit, UserProfileState>(
                  buildWhen: (prev, curr) {
                    final nameChanged = prev.nama != curr.nama;
                    final emailChanged = prev.email != curr.email;
                    final telpChanged = prev.telepon != curr.telepon;

                    // bandingkan perubahan bytes (tanpa deep-compare)
                    final bytesChanged =
                        (prev.fotoBytes == null && curr.fotoBytes != null) ||
                        (prev.fotoBytes != null && curr.fotoBytes == null) ||
                        (prev.fotoBytes != null &&
                            curr.fotoBytes != null &&
                            prev.fotoBytes!.lengthInBytes !=
                                curr.fotoBytes!.lengthInBytes);

                    return nameChanged ||
                        emailChanged ||
                        telpChanged ||
                        bytesChanged;
                  },
                  builder: (context, state) {
                    final nama =
                        (state.nama?.trim().isNotEmpty ?? false)
                            ? state.nama!.trim()
                            : 'Pengguna';
                    final email =
                        (state.email?.trim().isNotEmpty ?? false)
                            ? state.email!.trim()
                            : null;
                    final telepon =
                        (state.telepon?.trim().isNotEmpty ?? false)
                            ? state.telepon!.trim()
                            : null;
                    final foto =
                        (state.fotoBytes != null && state.fotoBytes!.isNotEmpty)
                            ? state.fotoBytes
                            : null;

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
                          borderRadius: BorderRadius.circular(
                            cardBorderRadius - 1.5,
                          ),
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
                                  Text(
                                    nama,
                                    style: headingStyle(context, fontSize: 22),
                                  ),
                                  const SizedBox(height: 4),

                                  // Role/subtitle (opsional)
                                  Text(
                                    'Nasabah Biasa',
                                    style: bodyTextStyle(context),
                                  ),

                                  const SizedBox(height: 4),

                                  // Email (jika ada)
                                  if (email != null)
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
                                            ),
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
                                        const Icon(
                                          Icons.phone,
                                          color: primaryLightColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            telepon,
                                            style: bodyTextStyle(
                                              context,
                                              fontSize: 16,
                                            ),
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
                    border: Border.all(color: sGrey),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Kelola Profil',
                        onTap: () => successSnackBar('Kelola Profil diklik'),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        onTap: () {
                          UbahPassword.show(context);
                          if (pIsMobile) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UbahPasswordPage(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => const UbahPassword(),
                            );
                          }
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
                    border: Border.all(color: sGrey),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.local_shipping_outlined,
                        title: 'Syarat dan Ketentuan',
                        onTap:
                            () =>
                                successSnackBar('Syarat dan Ketentuan diklik'),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.favorite_border,
                        title: 'Kebijakan dan Privasi',
                        onTap:
                            () =>
                                successSnackBar('Kebijakan dan Privasi diklik'),
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
                      // _buildDivider(),
                      _buildSwitchItem(
                        title: 'Mode Gelap',
                        value: darkMode,
                        onChanged: (value) {
                          setState(() => darkMode = value);
                          successSnackBar(
                            'Mode Gelap ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                          );
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
                    border: Border.all(color: sGrey),
                  ),
                  child: _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    titleColor: pDarkRed,
                    iconColor: pRed,
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
        padding: const EdgeInsets.symmetric(
          horizontal: vPadding,
          vertical: hPadding,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: bodyTextStyle(context).copyWith(color: titleColor),
              ),
            ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: vPadding,
        vertical: hPadding,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: bodyTextStyle(context))),
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
