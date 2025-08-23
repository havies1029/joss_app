
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';

import '../../blocs/networkconnection/network_bloc.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/header_section.dart';
import 'package:joss_app/widgets/button_shape.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      duration: const Duration(milliseconds: 500),
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

  // Desain input field untuk Email
  Widget _buildEmailField(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        controller: _usernameController,
        focusNode: _emailFocusNode,
        decoration: const InputDecoration(
          prefixIcon:
          Icon(Icons.email_outlined, color: MyColors.secondaryGrey),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          hintText: "Email",
          hintStyle: TextStyle(color: MyColors.secondaryGrey),
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.secondaryGrey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.black, width: 2),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
        value == null || value.isEmpty ? 'Username tidak boleh kosong' : null,
        onTap: () {
          _animationController.forward(from: 0);
        },
      ).animate(
        controller: _animationController,
        effects: [
          ShimmerEffect(
            color: MyColors.primaryYellow.withOpacity(0.2),
            duration: const Duration(milliseconds: 500),
          ),
          const FadeEffect(
            begin: 0.8,
            end: 1,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  // Desain input field untuk Password
  Widget _buildPasswordField(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon:
          const Icon(Icons.lock_outline, color: MyColors.secondaryGrey),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: MyColors.secondaryGrey,
            ),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          hintText: "Password",
          hintStyle: const TextStyle(color: MyColors.secondaryGrey),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.secondaryGrey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.black, width: 2),
          ),
        ),
        validator: (value) => value == null || value.isEmpty
            ? 'Password tidak boleh kosong'
            : null,
        onTap: () {
          _animationController.forward(from: 0);
        },
      ).animate(
        controller: _animationController,
        effects: [
          ShimmerEffect(
            color: MyColors.primaryYellow.withOpacity(0.2),
            duration: const Duration(milliseconds: 500),
          ),
          const FadeEffect(
            begin: 0.8,
            end: 1,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  // Desain tombol Sign In dengan validasi dan animasi
  Widget _buildSignInButton(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _animationController.forward(from: 0);
              onLoginButtonPressed();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryYellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
          child: const Text(
            "Sign In",
            style: TextStyle(fontSize: 14, color: MyColors.black),
          ),
        ).animate(
          effects: [
            ScaleEffect(
              begin: const Offset(1, 1),
              end: const Offset(0.95, 0.95),
              duration: Duration(milliseconds: 100),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk memicu event login
  void onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
      email: _usernameController.text,
      password: _passwordController.text,
      rememberMe: _rememberPassword
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Kita tentukan nilai padding dan spacing secara manual sesuai kebutuhan
    const double horizontalPadding = 20.0;
    const double headerSpacing = 30.0;
    const double fieldSpacing = 20.0;

    return MultiBlocListener(
      listeners: [
        BlocListener<NetworkBloc, NetworkState>(listener: (context, state) {
          if (state is NetworkFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.signal_wifi_off, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "You're not Connected to Internet",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
              elevation: 3,
              duration: const Duration(seconds: 3),
            ));
          } else if (state is NetworkSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.wifi, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "You're Connected to Internet",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
              elevation: 3,
              duration: const Duration(seconds: 3),
            ));
          }
        }),


        BlocListener<LoginBloc, LoginState>(listener: (context, state) {
         
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.error_outline, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "Username atau Password Anda salah!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
              elevation: 3,
              duration: const Duration(seconds: 3),
            ));
          }
        }),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return ((state is LoginInitial) || (state is LoginFailure))
              ? SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 70),
                      // Tampilkan HeaderSection
                      const HeaderSection(),
                      const SizedBox(height: 10),
                      // Tambahkan teks "Login" di atas kalimat Terms and Privacy
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: MyColors.black,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // RichText untuk menampilkan kalimat Terms and Privacy Policy
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: "By signing in you are agreeing to\n",
                          style: TextStyle(
                              fontSize: 15,
                              color: MyColors.secondaryGrey),
                          children: [
                            TextSpan(
                              text: "our Terms and Privacy Policy",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: MyColors.secondaryBlue),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: headerSpacing),
                      _buildEmailField(horizontalPadding),
                      const SizedBox(height: fieldSpacing),
                      _buildPasswordField(horizontalPadding),
                      const SizedBox(height: fieldSpacing),
                      // Ubah Row agar tidak overflow (dengan Expanded/Flexible)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding),
                        child: Row(
                          children: [
                            // Bagian Remember Password bisa meluas sesuai sisa space
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
                                      activeColor:
                                      MyColors.primaryYellow,
                                      checkColor: MyColors.black,
                                      onChanged: (value) =>
                                          setState(() =>
                                          _rememberPassword =
                                              value ?? false),
                                    ),
                                    // Agar teks tidak meluber, bungkus dengan Flexible
                                    Flexible(
                                      child: Text(
                                        "Remember password",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: MyColors.black,
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
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MyColors.secondaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: fieldSpacing),
                      _buildSignInButton(horizontalPadding),
                    ],
                  ),
                ),
              ),
            ),
          ) : const Center(child: CircularProgressIndicator());
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
      duration: const Duration(milliseconds: 500),
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
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: MyColors.white,
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
            if (!isKeyboardOpen)
              MediaQuery.removeViewInsets(
                context: context,
                removeBottom: true,
                child: const BottomShape(),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

