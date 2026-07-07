import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/pages/login/mobile/forgot/forgot_password_page.dart';
import 'package:joss_app/pages/login/welcome_header.dart';
import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/login/emailverification_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../common/loading_indicator.dart';
import '../../../../helper/indo_phone_result.dart';

class LoginFormClient extends StatefulWidget {
  const LoginFormClient({super.key});

  @override
  State<LoginFormClient> createState() => _LoginFormClientState();
}

class _LoginFormClientState extends State<LoginFormClient>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberPassword = true;
  bool isSubmitting = false;
  bool _isInitialEmailApplied = false;
  int _submitAttempt = 0;

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

  void _applyInitialEmailFromState() {
    final emailState = context.read<EmailVerificationBloc>().state.email.trim();
    if (emailState.isEmpty) return;

    if (_usernameController.text.trim().isEmpty && !_isInitialEmailApplied) {
      _usernameController.text = emailState;
      _isInitialEmailApplied = true;
    }
  }

  void _clearEmailStateAndController() {
    _usernameController.clear();
    _isInitialEmailApplied = false;

    context.read<EmailVerificationBloc>().add(
          const FieldEmailVerificationChangedEvent(email: ''),
        );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );

    Future.microtask(() => context.read<LoginBloc>().add(LoginReset()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyInitialEmailFromState();
    });
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

  Widget _buildEmailField(double hPadding) {
    return appTextField(
      label: "Email atau No. Handphone",
      hint: "Masukkan email atau nomor HP kamu",
      controller: _usernameController,
      focusNode: _emailFocusNode,
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

          // ubah ke format 62
          _usernameController.text = phoneRes.phone62!;
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
      label: "Kata Sandi",
      hint: "Masukkan Kata Sandi",
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: sGrey,
          size: 22,
        ),
        onPressed: () =>
            setState(() => _isPasswordVisible = !_isPasswordVisible),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kPassNullError;
        }
        if (value.length < 8) {
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
      isLoading: isSubmitting,
      backgroundColor: isSubmitting ? secondaryBlackColor : primaryColor,
      onPressed: isSubmitting
          ? null
          : () async {
        if (!_formKey.currentState!.validate()) return;

        if (mounted) {
          setState(() {
            isSubmitting = true;
          });
        }

        _showGlobalLoading();

        _startSubmitTimeout();

        _animationController.forward(from: 0);
        onLoginButtonPressed();
      },
    );
  }

  void _startSubmitTimeout() {
    final attempt = ++_submitAttempt;

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted || attempt != _submitAttempt || !isSubmitting) return;

      _hideGlobalLoading();

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          "Terjadi kesalahan dalam pengiriman data, silahkan klik kembali.",
        ),
      );
    });
  }

  void onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        email: _usernameController.text,
        password: _passwordController.text,
        rememberMe: _rememberPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSubmitting = false;
                });
              }

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Username atau Password Anda salah!"),
              );
              return;
            }

            if (state is LoginPostAuthenticate) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSubmitting = false;
                });
              }
            }
          },
        ),
      ],
      child: Form(
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
                        SizedBox(height: hPadding),
                        WelcomeHeader(type: "login_client"),
                      ],
                    ),
                  ),
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
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildEmailField(0),
                                const SizedBox(height: 10),
                                _buildPasswordField(0),
                                const SizedBox(height: 10),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  checkboxBorderRadius,
                                                ),
                                              ),
                                              onChanged: (value) => setState(
                                                () => _rememberPassword =
                                                    value ?? false,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Simpan Sesi Login",
                                                style: bodyTextStyle(context),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: HoverableText(
                                        text: 'Lupa Kata Sandi',
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ForgotPasswordPage(
                                                initialEmail:
                                                    _usernameController.text
                                                        .trim(),
                                                onSubmit: (email) {
                                                  return Future.value(true);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        styleBuilder: (isHovering) =>
                                            inputTextStyle(
                                          context,
                                          color:
                                              isHovering ? pBlue : primaryColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildSignInButton(),
                                SizedBox(height: vPadding),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Belum Punya Akun? ",
                                      style: bodyTextStyle(context)
                                          .copyWith(color: hintGrey),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _clearEmailStateAndController();
                                        context
                                            .read<EmailVerificationBloc>()
                                            .add(
                                              ClearEmailVerificationEvent(),
                                            );
                                        context.read<AuthenticationBloc>().add(
                                              RequireLoginUser(),
                                            );
                                      },
                                      child: Text(
                                        "Masuk Sebagai Pengguna",
                                        style: bodyTextStyle(context)
                                            .copyWith(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
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
      ),
    );
  }
}
