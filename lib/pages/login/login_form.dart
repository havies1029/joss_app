import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';

import '../../blocs/networkconnection/network_bloc.dart';
import '../../common/constants.dart';
import 'package:joss_app/widgets/header_section.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
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
  bool _rememberPassword = false; // Variabel untuk checkbox Remember Password

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

  Widget _buildPasswordField(double hPadding) {
    return appTextField(
      label: "Password",
      hint: "Masukkan password",
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible, // Gunakan state dari parent
      padding: EdgeInsets.symmetric(horizontal: hPadding),
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
    return appButtons.primary(
      text: "Masuk",
      width: double.infinity,
      height: buttonHeight,
      isLoading: false,
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
        BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is NetworkFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                  "You're not Connected to Internet",
                  icon: Icons.signal_wifi_off,
                ),
              );
            } else if (state is NetworkSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                successSnackBar(
                  "You're Connected to Internet",
                  icon: Icons.wifi,
                ),
              );
            }
          },
        ),

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
              ? SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(hPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 70),
                          // Tampilkan HeaderSection
                          const HeaderSection(),
                          const SizedBox(height: 10),
                          // Tambahkan teks "Login" di atas kalimat Terms and Privacy
                          Text("Login", style: headingStyle(context)),
                          SizedBox(height: headerSpacing),
                          // RichText untuk menampilkan kalimat Terms and Privacy Policy
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "By signing in you are agreeing to\n",
                              style: customInputStyle(
                                context,
                                color: primaryLightColor,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: HoverableText(
                                    text: "Our Terms and Privacy Policy",
                                    onTap: () {
                                    },
                                    styleBuilder: (isHovering) => customInputStyle(
                                      context,
                                      color: isHovering ? primaryColor : pBlue
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: headerSpacing),
                          _buildEmailField(hPadding),
                          SizedBox(height: fieldSpacing),
                          _buildPasswordField(hPadding),
                          SizedBox(height: fieldSpacing),
                          // Ubah Row agar tidak overflow (dengan Expanded/Flexible)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: hPadding),
                            child: Row(
                              children: [
                                // Bagian Remember Password bisa meluas sesuai sisa space
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
                                          onChanged:
                                              (value) => setState(
                                                () =>
                                                    _rememberPassword =
                                                        value ?? false,
                                              ),
                                        ),
                                        // Agar teks tidak meluber, bungkus dengan Flexible
                                        Flexible(
                                          child: Text(
                                            "Ingat Kata Sandi",
                                            style: customInputStyle(
                                              context,
                                              color: primaryLightColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Tombol Forgot Password tetap di ujung kanan
                                TextButton(
                                  onPressed: () {
                                    // Implementasi fungsi forgot password dapat dilakukan di sini
                                  },
                                  child: HoverableText(
                                    text: 'Lupa Kata Sandi',
                                    onTap: () {},
                                    styleBuilder:
                                        (isHovering) => customInputStyle(
                                          context,
                                          color:
                                              isHovering
                                                  ? pBlue
                                                  : primaryColor
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          _buildSignInButton(),

                          // SizedBox(height: fieldSpacing),
                          // pIsMobile
                          //     ? appButtons.iconLeft(
                          //   text: 'Daftar Menggunakan Gmail',
                          //   icon: 'assets/icons/google-icon.svg',
                          //   onPressed: () => _handleGmailRegisterForMobile(context),
                          // )
                          //     : const CachedGoogleSigninButton(),
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Widget yang mengandung LoginForm
  Widget _buildDesignLoginForm() {
    return const LoginForm();
  }

  @override
  Widget build(BuildContext context) {
    // Nilai responsif berdasarkan ukuran layar
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight * 0.03;
    final headerSpacing = screenHeight * 0.025;
    // Deteksi apakah keyboard terbuka
    // final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: verticalPadding,
                  bottom: verticalPadding,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: headerSpacing),
                      _buildDesignLoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
