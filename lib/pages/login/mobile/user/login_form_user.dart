import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/pages/login/welcome_header.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../blocs/login/emailverification_bloc.dart';
import '../../../../blocs/networkconnection/network_bloc.dart';
import '../../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../common/app_data.dart';
import '../../../../common/constants.dart';

import '../../../../models/login/emailverification_model.dart';
import 'package:joss_app/widgets/google/google_signin_button_stub.dart'
  if (dart.library.js_interop) 'package:joss_app/widgets/google/google_signin_button_web.dart';
import '../../../base/base_background_firstpage.dart';
import '../client/login_client_page.dart';

const List<String> scopes = <String>[
  'email',
];

class CachedGoogleSigninButton extends StatelessWidget {
  const CachedGoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
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
  bool _rememberPassword = true; // Variabel untuk checkbox Remember Password

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );
    googleSignIn.onCurrentUserChanged
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
    // googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildEmailField() {
    return appTextField(
      label: "Email",
      hint: "Masukkan email",
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
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
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    // ✅ Trigger ke EmailVerificationBloc
    final record = EmailVerificationModel(
      email: email,
      requestFrom: 'email',
    );

    context.read<EmailVerificationBloc>().add(
      EmailVerificationTambahEvent(record: record),
    );
  }

  Widget footerLoginText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sudah Punya Akun? ",
          style: bodyTextStyle(context).copyWith(color: hintGrey),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginClient()),
            );
          },
          child: Text(
            "Masuk Sebagai Klien",
            style: bodyTextStyle(context).copyWith(color: primaryColor),
          ),
        ),
      ],
    );
  }


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
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: vPadding),
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
                            WelcomeHeader(type: "login_user"),
                          ],
                        ),
                      ),

                      // Card Section
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: cardBorderGradient,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: secondaryBlackColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5, vertical : vPadding),
                                child: Column(
                                  children: [
                                    _buildEmailField(),
                                    SizedBox(height: 10),
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
                                                    "Simpan Sesi Login",
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
                                    SizedBox(height: 10),
                                    _buildSignInButton(),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: kDivider(color: hintGrey)
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
                                            child: kDivider(color: hintGrey)
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Tombol Google
                                    kIsWeb
                                        ? const CachedGoogleSigninButton()
                                        : AppButton.iconLeft(
                                      text: 'Masuk Dengan bebek',
                                      icon: SvgPicture.asset(
                                        'assets/icons/google-icon.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      onPressed: () => _handleGmailRegisterForMobile(context),
                                      backgroundColor: pGrey,
                                    ),

                                    SizedBox(height: vPadding,),
                                    footerLoginText(context),

                                    SizedBox(height: 10),
                                  ],
                                ),
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
        user = await googleSignIn.signIn();
      } else {
        user = await googleSignIn.signInSilently();
        user ??= await googleSignIn.signIn();
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
}