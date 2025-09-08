import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/pages/login/welcome_header_login.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../blocs/login/emailverification_bloc.dart';
import '../../../../blocs/networkconnection/network_bloc.dart';
import '../../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../common/app_data.dart';
import '../../../../common/constants.dart';

import '../../../../models/login/emailverification_model.dart';
import '../../../../widgets/google/google_signin_button_stub.dart';
import '../../../base/base_background_firstpage.dart';
import '../client/login_client_page.dart';

const List<String> scopes = <String>[
  'email',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
  clientId: kIsWeb ? '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com' : null,
  serverClientId: kIsWeb ? null : '217496566954-tiqmna993j1a943i9d86chpas0ipktle.apps.googleusercontent.com',
);

class CachedGoogleSigninButton extends StatelessWidget {
  const CachedGoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    // debugPrint('✅ Rendered CachedGoogleSigninButton sekali');
    return googleSigninButton();
  }
}

class LoginFormUser extends StatefulWidget {
  const LoginFormUser({super.key});

  @override
  State<LoginFormUser> createState() => _LoginFormUserState();
}

class _LoginFormUserState extends State<LoginFormUser>
    with SingleTickerProviderStateMixin {
  late final Widget _cachedGoogleButton;
  // Controller untuk input field
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  // GlobalKey untuk validasi form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Untuk animasi
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  bool _isHoveringGmail = false;
  bool _rememberPassword = false; // Variabel untuk checkbox Remember Password

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      if (account != null && context.mounted) {
        context.read<EmailVerificationBloc>().add(
          EmailVerificationTambahEvent(
            record: EmailVerificationModel(
              email: account.email,
              requestFrom: 'google',
            ),
          ),
        );
      }
    });
    // _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  // Ganti method _buildEmailField dan _buildPasswordField dengan:

  Widget _buildEmailField(double hPadding) {
    return appTextField(
      label: "Email",
      hint: "Masukkan email",
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kEmailNullError;
        }
        if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }

  Widget _buildSignInButton() {
    return AppButton.primary(
      text: "Masuk",
      width: double.infinity,
      height: buttonHeight,
      isLoading: false,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _animationController.forward(from: 0);
          onRegisterButtonPressed();
        }
      },
    );
  }

// Fungsi untuk memicu event register email
  void onRegisterButtonPressed() {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    String? error;
    if (email.isEmpty) {
      error = 'Email tidak boleh kosong';
    } else if (!emailRegex.hasMatch(email)) {
      error = 'Format email tidak valid';
    }

    if (error != null) {
      setState(() => _emailError = error);
      return;
    }

    // ✅ Clear error
    setState(() => _emailError = null);

    // ✅ Trigger ke EmailVerificationBloc (untuk proses verifikasi / register)
    final record = EmailVerificationModel(
      email: email,
      requestFrom: 'email',
    );

    context.read<EmailVerificationBloc>().add(
      EmailVerificationTambahEvent(record: record),
    );
  }


  // void _handleGmailRegisterForMobile(BuildContext context) async {
  //   try {
  //     GoogleSignInAccount? user;
  //
  //     if (kIsWeb) {
  //       user = await _googleSignIn.signIn();
  //     } else {
  //       user = await _googleSignIn.signInSilently();
  //       user ??= await _googleSignIn.signIn();
  //     }
  //
  //     // debugPrint('[GMAIL] Google Sign-In result: ${user?.email}');
  //
  //     if (user != null && context.mounted) {
  //       // 🔒 Simpan email & display name ke AuthLocalCubit
  //       final authLocalCubit = context.read<AuthLocalCubit>();
  //       authLocalCubit.setLastLoginEmail(user.email);
  //       authLocalCubit.setGoogleDisplayName(user.displayName);
  //
  //       // ⛳ Kirim ke EmailVerificationBloc
  //       context.read<EmailVerificationBloc>().add(
  //         EmailVerificationTambahEvent(
  //           record: EmailVerificationModel(
  //             email: user.email,
  //             requestFrom: 'google',
  //           ),
  //         ),
  //       );
  //     }
  //
  //   } catch (e) {
  //     debugPrint('[GMAIL] ERROR: $e');
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Login Google gagal: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Username atau Password Anda salah!"),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return ((state is LoginInitial) || (state is LoginFailure))
              ? Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Header Section
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/logo_jps_no_background.png',
                              height: isDesktop(context)
                                  ? 56
                                  : isTablet(context)
                                  ? 48
                                  : 42,
                              width: isDesktop(context)
                                  ? 180
                                  : isTablet(context)
                                  ? 140
                                  : 120,
                            ),
                            WelcomeHeaderLogin(),
                          ],
                        ),
                      ),

                      // Card Section yang akan mengambil sisa ruang
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border(
                              top: BorderSide(
                                color: primaryColor,
                                width: 4.0,
                              ),
                            ),
                          ),
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildEmailField(0),
                                  SizedBox(height: fieldSpacing),
                                  // Row dengan checkbox dan forgot password
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _rememberPassword = !_rememberPassword;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: _rememberPassword,
                                                activeColor: primaryColor,
                                                checkColor: primaryLightColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                    checkboxBorderRadius,
                                                  ),
                                                ),
                                                onChanged: (value) => setState(
                                                      () => _rememberPassword = value ?? false,
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  "Ingat Login",
                                                  style: bodyTextStyle(
                                                    context,
                                                  ),
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: fieldSpacing),
                                  _buildSignInButton(),
                                  SizedBox(height: fieldSpacing),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white24,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "atau",
                                          style: TextStyle(
                                            fontSize: getResponsiveFont(context, 18),
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white24,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: fieldSpacing),
                                  // Tombol Google
                                  AppData.kIsWeb
                                      ? const CachedGoogleSigninButton()
                                      : _buildIconButton(
                                    text: 'Daftar Menggunakan Gmail',
                                    iconPath: 'assets/icons/google-icon.svg',
                                    isHovering: _isHoveringGmail,
                                    onHover: (hovering) =>
                                        setState(() => _isHoveringGmail = hovering),
                                    onPressed: () => _handleGmailRegisterForMobile(context),
                                  ),

                                  // Sisa ruang akan diisi oleh Card background
                                  Spacer(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Belum Punya Akun? ",
                                        style: TextStyle(
                                          fontSize: getResponsiveFont(context, 18),
                                          color: Colors.white70, // warna teks abu
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginClient()));
                                        },
                                        child: Text(
                                          "Masuk Sebagai Klien",
                                          style: TextStyle(
                                            fontSize: getResponsiveFont(context, 18),
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor, // warna brand dari constants
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // 🔽 Divider spacing
                                  SizedBox(height: fieldSpacing),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _handleGmailRegisterForMobile(BuildContext context) async {
    try {
      GoogleSignInAccount? user;

      if (kIsWeb) {
        user = await _googleSignIn.signIn();
      } else {
        user = await _googleSignIn.signInSilently();
        user ??= await _googleSignIn.signIn();
      }

      // debugPrint('[GMAIL] Google Sign-In result: ${user?.email}');

      if (user != null && context.mounted) {
        // 🔒 Simpan email & display name ke AuthLocalCubi

        // ⛳ Kirim ke EmailVerificationBloc
        context.read<EmailVerificationBloc>().add(
          EmailVerificationTambahEvent(
            record: EmailVerificationModel(
              email: user.email,
              requestFrom: 'google',
            ),
          ),
        );
      }

    } catch (e) {
      debugPrint('[GMAIL] ERROR: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Google gagal: $e')),
        );
      }
    }
  }

  Widget _buildIconButton({
    required String text,
    required String iconPath,
    required bool isHovering,
    required Function(bool) onHover,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: isHovering ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isHovering ? Colors.grey.shade400 : Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: isHovering
                ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath, width: 24, height: 24),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Color(0xFF91C050),
                      fontSize: getResponsiveFont(context, 15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


