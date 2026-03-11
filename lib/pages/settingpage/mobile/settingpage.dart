import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/gen_profile/mrekancontactcrud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../common/app_data.dart';
import '../../profile/mobile/profile/form_section/rekan_bank.dart';
import '../../profile/mobile/profile/form_section/rekan_contact.dart';
import '../../profile/mobile/profile/form_section/rekan_general_cmp.dart';
import '../../profile/mobile/profile/form_section/rekan_general_idv.dart';
import '../../profile/mobile/profile/form_section/rekan_pic.dart';
import '../widgets/kebijakan_privasi_page.dart';
import '../widgets/syarat_ketentuan_page.dart';
import '../widgets/ubah_password_popup.dart';

import '../../base/base_background_firstpage.dart';
import '../../../common/constants.dart';

const List<String> scopes = <String>['email'];
//fix all about settingpage
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool emailNotification = true;
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

      final mjnsclientId =
          context.read<RegUserBloc>().state.record?.jnsClientId;

      context.read<MRekanContactCrudBloc>()
          .add(MRekanContactCrudLihatEvent());

      /// load sesuai jenis client
      if (mjnsclientId == '10') {
        context.read<MRekanGeneralIdvCrudBloc>()
            .add(MRekanGeneralIdvCrudLihatEvent());
      } else {
        context.read<MRekanGeneralCmpCrudBloc>()
            .add(MRekanGeneralCmpCrudLihatEvent());
      }

    });
  }

  Widget _buildAvatar(
      Uint8List? bytes,
      String initials, {
        bool isLoading = false,
      }) {
    final hasPhoto = bytes != null && bytes.isNotEmpty;

    return CircleAvatar(
      radius: 23,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: isLoading
            ? const SizedBox(
          width: 46,
          height: 46,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: LoadingIndicator(),
            ),
          ),
        )
            : hasPhoto
            ? Image.memory(
          bytes!,
          fit: BoxFit.cover,
          width: 46,
          height: 46,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => _placeholderAvatar(),
        )
            : _placeholderAvatar(),
      ),
    );
  }

  Widget _placeholderAvatar() => SvgPicture.asset(
    'assets/icons/place_holder_2.svg',
    width: 46,
    height: 46,
    fit: BoxFit.cover,
  );

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(foto, _initialsFromName(nama)),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAMA
                  Text(
                    nama,
                    style: headingStyle(context, fontSize: 22),
                  ),

                  const SizedBox(height: 6),

                  /// SUBTITLE
                  if (subtitle != null && subtitle.trim().isNotEmpty)
                    Text(
                      subtitle,
                      style: bodyTextStyle(context).copyWith(
                        color: primaryLightColor,
                      ),
                    ),

                  const SizedBox(height: 8),

                  /// EMAIL
                  /// EMAIL
                  if (email != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/email.svg",
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            primaryLightColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8), // gap email
                        Expanded(
                          child: Text(
                            email,
                            style: bodyTextStyle(context, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 6),

                  /// TELEPON
                  if (telepon != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/telepon.svg",
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            primaryLightColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 9), // gap telepon
                        Expanded(
                          child: Text(
                            telepon.startsWith('+') ? telepon : '+$telepon',
                            style: bodyTextStyle(context, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(dialogContext, false),
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
                                borderRadius: BorderRadius.circular(cardBorderRadius),
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

  Future<void> handleLogout(BuildContext context) async {
    final shouldLogout = await showLogoutConfirmDialog(context);
    if (!context.mounted) return;

    if (shouldLogout == true) {
      context.read<AuthenticationBloc>().add(LoggedOut());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mjnsclientId =
    context.select((RegUserBloc b) => b.state.record?.jnsClientId);

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: BaseBackgroundFirstPage(
        child: SafeArea(
          child: MultiBlocListener(
            listeners: [

              /// CONTACT DATA
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

              /// INDIVIDUAL CLIENT
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

              /// COMPANY CLIENT
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
            ],

            child: Container(
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

                          final userType =
                          authState is AuthenticationAuthenticated
                              ? (authState.user.userType ?? '').toUpperCase()
                              : '';

                          if (userType == 'C') {

                            return BlocBuilder<
                                ProfileDownloadFotoBloc,
                                ProfileDownloadFotoState>(
                              buildWhen: (prev, curr) =>
                              curr is ProfileDownloadFotoLoaded ||
                                  curr is ProfileDownloadFotoLoading ||
                                  prev.runtimeType != curr.runtimeType,

                              builder: (context, fotoState) {

                                if (fotoState is ProfileDownloadFotoLoading) {
                                  return _buildProfileCard(
                                    context: context,
                                    nama: profileNama ?? AppData.user.nama ?? "",
                                    email: profileEmail ?? AppData.user.email,
                                    telepon: profileTelepon ?? AppData.user.hp,
                                    foto: null,
                                    subtitle: "Klien JPS",
                                  );
                                }

                                if (fotoState is ProfileDownloadFotoLoaded) {

                                  final foto = fotoState.imageBytes.isNotEmpty
                                      ? fotoState.imageBytes
                                      : null;

                                  return _buildProfileCard(
                                    context: context,
                                    nama: profileNama ?? AppData.user.nama ?? "",
                                    email: profileEmail ?? AppData.user.email,
                                    telepon: profileTelepon ?? AppData.user.hp,
                                    foto: foto,
                                    subtitle: "Klien JPS",
                                  );
                                }

                                return _buildProfileCard(
                                  context: context,
                                  nama: profileNama ?? AppData.user.nama ?? "",
                                  email: profileEmail ?? AppData.user.email,
                                  telepon: profileTelepon ?? AppData.user.hp,
                                  foto: null,
                                  subtitle: "Klien JPS",
                                );
                              },
                            );
                          }

                          else if (userType == 'U') {
                            return _buildProfileCard(
                              context: context,
                              nama: AppData.user.nama ?? "Pengguna Baru",
                              foto: null,
                            );
                          }

                          else {

                            final fallbackEmail =
                            authState is AuthenticationAuthenticated
                                ? (authState.user.email?.trim() ?? 'Guest User')
                                : 'Guest User';

                            return _buildProfileCard(
                              context: context,
                              nama: fallbackEmail,
                              foto: null,
                              subtitle: "Nasabah",
                            );
                          }
                        },
                      ),

                      const SizedBox(height: hPadding),

                      /// ================= AKUN =================
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

                                /// INFORMASI
                                _buildSectionTitle(context, 'Informasi'),

                                _buildCardContainer(
                                  children: [

                                    _buildMenuItem(
                                      svgAsset: 'assets/icons/informasi_klien.svg',
                                      title: 'Informasi Klien',
                                      onTap: () async {

                                        if (mjnsclientId == '10') {
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

                                        context.read<ProfileDownloadFotoBloc>()
                                            .add(LoadSecureImage());
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
                                            builder: (_) =>
                                            const MrekanPicMainPage(),
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

                      /// ================= SYARAT =================
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

                      /// ================= LAINNYA =================
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
                            onTap: () {
                              Navigator.pushNamed(context, 'chat');
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: vPadding),

                      /// ================= LOGOUT =================
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

                      const SizedBox(height: hPadding,),

                      _buildSectionTitle(context, 'v1.0.1'),

                      const SizedBox(height: 50),
                    ],
                  ),
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
