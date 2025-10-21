import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/pages/login/mobile/user/login_user_page.dart';
import 'package:joss_app/pages/login/welcome_header.dart';
import '../../../../common/constants.dart';

class LoginFormClient extends StatefulWidget {
  const LoginFormClient({super.key});

  @override
  State<LoginFormClient> createState() => _LoginFormClientState();
}

class _LoginFormClientState extends State<LoginFormClient>
    with SingleTickerProviderStateMixin {
  // Controller untuk input field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // GlobalKey untuk validasi form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Untuk animasi
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberPassword = true; // Variabel untuk checkbox Remember Password

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );
    Future.microtask(() => context.read<LoginBloc>().add(LoginReset()));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Ganti method _buildEmailField dan _buildPasswordField dengan:

  Widget _buildEmailField(double hPadding) {
    return appTextField(
      label: "Email",
      hint: "Masukkan email",
      controller: _usernameController,
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

  Widget _buildPasswordField(double hPadding) {
    return appTextField(
      label: "Password",
      hint: "Masukkan password",
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: sGrey,
          size: 22,
        ),
        onPressed:
            () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kPassNullError;
        }
        if (value.length < 6) {
          return kShortPassError;
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
          onLoginButtonPressed();
        }
      },
    );
  }

  // Fungsi untuk memicu event login
  void onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        email: _usernameController.text,
        password: _passwordController.text,
        rememberMe: _rememberPassword,
      ),
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
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: vPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              gaplessPlayback: true,
                              height:
                              isDesktop(context)
                                  ? 56
                                  : isTablet(context)
                                  ? 48
                                  : 42,
                              width:
                              isDesktop(context)
                                  ? 180
                                  : isTablet(context)
                                  ? 140
                                  : 120,
                            ),
                            SizedBox(height: hPadding,),
                            WelcomeHeader(type: "login_client"),
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
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    _buildEmailField(0),
                                    SizedBox(height: 10),
                                    _buildPasswordField(0),
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
                                                  value: _rememberPassword,
                                                  activeColor: primaryColor,
                                                  checkColor: primaryLightColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                      checkboxBorderRadius,
                                                    ),
                                                  ),
                                                  onChanged:
                                                      (value) => setState(
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
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Implementasi fungsi forgot password
                                          },
                                          child: HoverableText(
                                            text: 'Lupa Kata Sandi',
                                            onTap: () {},
                                            styleBuilder:
                                                (isHovering) =>
                                                inputTextStyle(
                                                  context,
                                                  color:
                                                  isHovering
                                                      ? pBlue
                                                      : primaryColor,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    _buildSignInButton(),

                                    SizedBox(height: vPadding,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Belum Punya Akun? ",
                                          style: bodyTextStyle(context).copyWith(color: hintGrey),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) => const LoginUser()),
                                            ).then((_) {
                                              Navigator.pop(context); // auto kembali ke halaman sebelumnya
                                            });
                                          },
                                          child: Text(
                                            "Masuk Sebagai Pengguna",
                                            style: bodyTextStyle(context).copyWith(color: primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20),
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
}