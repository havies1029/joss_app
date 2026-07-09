import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/pages/login/welcome_header.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/login/emailverification_bloc.dart';
import '../../../../common/constants.dart';

import '../../../../helper/auth_input_router.dart';
import '../../../../helper/indo_phone_result.dart';
import '../../../../models/login/emailverification_model.dart';

class LoginFormUser extends StatefulWidget {
  const LoginFormUser({super.key});

  @override
  State<LoginFormUser> createState() => _LoginFormUserState();
}

class _LoginFormUserState extends State<LoginFormUser>
    with SingleTickerProviderStateMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  final TextEditingController _emailOrPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  bool _rememberPassword = true;
  bool isSigningIn = false;
  bool isGoogleSigningIn = false;
  int _signInAttempt = 0;

  bool get _isBlockingSignIn => isSigningIn || isGoogleSigningIn;

  bool _isDialogLoadingShown = false;

  void _showGlobalLoading() {
    if (!mounted || _isDialogLoadingShown) return;

    _isDialogLoadingShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }

  void _hideGlobalLoading() {
    if (!mounted || !_isDialogLoadingShown) return;

    _isDialogLoadingShown = false;

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _animationController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildEmailOrPhoneField() {
    return appTextField(
      label: "Email atau No. Handphone",
      hint: "Masukkan email atau nomor HP kamu",
      controller: _emailOrPhoneController,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      validator: (value) {
        final input = (value ?? '').trim();
        if (input.isEmpty) {
          return "Mohon isi email atau nomor handphone";
        }

        final isEmail = EmailValidator.validate(input);

        if (!isEmail) {
          final phoneRes = IndoPhoneHelper.normalize(input);
          if (!phoneRes.isValid) {
            return phoneRes.error ?? "Masukkan format nomor HP yang valid";
          }
        }

        return null;
      },
    );
  }

  Widget _buildSignInButton() {
    return AppButton.primary(
      text: "Masuk",
      isLoading: isSigningIn,
      backgroundColor: isSigningIn ? secondaryBlackColor : primaryColor,
      onPressed: isSigningIn
          ? null
          : () async {
        if (!_formKey.currentState!.validate()) return;

        setState(() {
          isSigningIn = true;
        });

        _showGlobalLoading();

        _startSignInTimeout();

        _animationController.forward(from: 0);

        onRegisterButtonPressed(context);
      },
    );
  }

  void _startSignInTimeout() {
    final attempt = ++_signInAttempt;

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted || attempt != _signInAttempt || !isSigningIn) return;

      _hideGlobalLoading();

      setState(() {
        isSigningIn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          "Terjadi kesalahan dalam pengiriman data, silahkan klik kembali.",
        ),
      );
    });
  }

  void onRegisterButtonPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final input = _emailOrPhoneController.text.trim();

    context.read<EmailVerificationBloc>().add(
          FieldEmailVerificationChangedEvent(email: input),
        );

    AuthInputRouter.handleInput(context, input);
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
            final authBloc = context.read<AuthenticationBloc>();

            authBloc.add(
              RequireLoginClient(requiredFrom: "login_user", errorMsg: ""),
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
                errorSnackBar("Nama Pengguna atau Kata Sandi Anda salah!"),
              );
            }
          },
        ),
        BlocListener<EmailVerificationBloc, EmailVerificationState>(
          listenWhen: (previous, current) =>
              previous.hasFailure != current.hasFailure ||
              previous.errors != current.errors ||
              previous.successMessage != current.successMessage ||
              previous.isLoaded != current.isLoaded,
          listener: (context, state) {
            if (state.isLoaded && !state.hasFailure) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSigningIn = false;
                  isGoogleSigningIn = false;
                });
              }
            }

            if (state.successMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                successSnackBar(state.successMessage),
              );
              return;
            }

            if (state.hasFailure) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSigningIn = false;
                  isGoogleSigningIn = false;
                });
              }

              final errorText =
                  state.errors.where((e) => e.trim().isNotEmpty).join("\n");

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                  errorText.isNotEmpty
                      ? errorText
                      : "Terjadi kesalahan saat verifikasi email/telepon.",
                ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: vPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    gaplessPlayback: true,
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
                                  SizedBox(
                                    height: hPadding,
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
                                    color: secondaryBlackColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: hPadding * 1.5,
                                          vertical: vPadding),
                                      child: Column(
                                        children: [
                                          _buildEmailOrPhoneField(),
                                          SizedBox(height: 10),
                                          // Row dengan checkbox dan forgot password
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _rememberPassword =
                                                          !_rememberPassword;
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value:
                                                            _rememberPassword,
                                                        activeColor:
                                                            primaryColor,
                                                        checkColor:
                                                            primaryLightColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            checkboxBorderRadius,
                                                          ),
                                                        ),
                                                        onChanged: (value) =>
                                                            setState(
                                                          () =>
                                                              _rememberPassword =
                                                                  value ??
                                                                      false,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "Simpan Sesi Login",
                                                          style: bodyTextStyle(
                                                            context,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                          // SizedBox(height: 10),
                                          // Row(
                                          //   children: [
                                          //     Expanded(
                                          //         child: kDivider(
                                          //             color: hintGrey)),
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //               horizontal: 8.0),
                                          //       child: Text(
                                          //         "atau",
                                          //         style: TextStyle(
                                          //           fontSize: getResponsiveFont(
                                          //               context, 18),
                                          //           color: Colors.white70,
                                          //           fontWeight: FontWeight.w500,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Expanded(
                                          //         child: kDivider(
                                          //             color: hintGrey)),
                                          //   ],
                                          // ),
                                          // SizedBox(height: 10),
                                          //
                                          // AppButton.iconLeft(
                                          //   text: 'Masuk Dengan Google',
                                          //   icon: SvgPicture.asset(
                                          //     'assets/icons/google-icon.svg',
                                          //     width: 20,
                                          //     height: 20,
                                          //   ),
                                          //   backgroundColor: isGoogleSigningIn
                                          //       ? secondaryBlackColor
                                          //       : pGrey,
                                          //   onPressed: isGoogleSigningIn
                                          //       ? null
                                          //       : () async {
                                          //     setState(() {
                                          //       isGoogleSigningIn = true;
                                          //     });
                                          //
                                          //     _showGlobalLoading();
                                          //
                                          //     await _handleGmailRegisterForMobile(context);
                                          //   },
                                          // ),

                                          SizedBox(
                                            height: vPadding,
                                          ),
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
              : const Center(child: LoadingIndicator());
        },
      ),
    );
  }

  Future<void> _handleGmailRegisterForMobile(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _hideGlobalLoading();

        if (mounted) {
          setState(() {
            isGoogleSigningIn = false;
          });
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCred.user;
      if (user == null) {
        throw Exception('Firebase user is null setelah signInWithCredential');
      }

      // 5) Kirim ke BLoC / flow kamu (contoh kamu: EmailVerificationBloc)
      if (!context.mounted) return;

      final googleEmail = user.email ?? googleUser.email;

      context.read<EmailVerificationBloc>().add(
            FieldEmailVerificationChangedEvent(email: googleEmail),
          );

      context.read<EmailVerificationBloc>().add(
            EmailVerificationTambahEvent(
              record: EmailVerificationModel(
                email: googleEmail,
                requestFrom: 'google',
              ),
            ),
          );
    } catch (e) {
      _hideGlobalLoading();

      if (mounted) {
        setState(() {
          isGoogleSigningIn = false;
        });
      }

      debugPrint('[GMAIL] ERROR: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Google gagal: $e')),
      );
    }
  }
}
