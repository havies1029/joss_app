import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/emailverification_bloc.dart';
import 'package:joss_app/blocs/login/login_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/helper/indo_phone_result.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/pages/login/mobile/forgot/new_forgot_page/new_forgot_password_page.dart';
import 'package:joss_app/pages/login/welcome_header.dart';
import 'package:joss_app/pages/register/mobile/client/register_phone_gate_page.dart';

class VerificationLoginFormClient extends StatefulWidget {
  final String requestFrom;
  final String initialUsername;

  const VerificationLoginFormClient({
    super.key,
    this.requestFrom = '',
    this.initialUsername = '',
  });

  @override
  State<VerificationLoginFormClient> createState() =>
      _VerificationLoginFormClientState();
}

class _VerificationLoginFormClientState
    extends State<VerificationLoginFormClient>
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
  final Map<String, String?> fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: defaultDuration,
    );

    context.read<LoginBloc>().add(LoginReset());

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
    final initialUsername = widget.initialUsername.trim();
    if (initialUsername.isNotEmpty && !_isInitialEmailApplied) {
      _usernameController.text = initialUsername;
      _passwordController.clear();
      _isInitialEmailApplied = true;
      return;
    }

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

  void _handleBack() {
    _clearEmailStateAndController();
    context.read<EmailVerificationBloc>().add(
          ClearEmailVerificationEvent(),
        );

    if (widget.requestFrom.isNotEmpty &&
        widget.requestFrom != 'daftarclient_page' &&
        Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

  bool validateLoginForm() {
    clearErrsByPrefix('form.');
    var ok = true;

    final input = _usernameController.text.trim();
    if (input.isEmpty) {
      setErr('form.username', "Mohon isi email atau nomor handphone");
      ok = false;
    } else if (!EmailValidator.validate(input)) {
      final phoneRes = IndoPhoneHelper.normalize(input);

      if (!phoneRes.isValid) {
        setErr(
          'form.username',
          phoneRes.error ?? "Masukkan format nomor HP yang valid",
        );
        ok = false;
      } else {
        _usernameController.text = phoneRes.phone62!;
      }
    }

    final password = _passwordController.text;
    if (password.isEmpty) {
      setErr('form.password', 'Mohon isi kode verifikasi');
      ok = false;
    } else if (password.length < 8) {
      setErr('form.password', 'Kode verifikasi minimal 8 karakter');
      ok = false;
    }

    return ok;
  }

  Widget _buildEmailField() {
    return appTextField(
      label: "Email atau No. Handphone",
      hint: "Masukkan email atau nomor HP kamu",
      controller: _usernameController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      errorText: err('form.username'),
      validator: (_) => err('form.username'),
      onChanged: (value) {
        final input = value.trim();
        if (input.isEmpty) return;

        if (EmailValidator.validate(input)) {
          clearErr('form.username');
          return;
        }

        final phoneRes = IndoPhoneHelper.normalize(input);
        if (phoneRes.isValid) {
          clearErr('form.username');
        }
      },
      onTap: () {
        _animationController.forward(from: 0);
      },
    );
  }

  Widget _buildPasswordField() {
    return appTextField(
      label: "Kode Verifikasi",
      hint: "Masukkan Kode Verifikasi",
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      errorText: err('form.password'),
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
        return err('form.password');
      },
      onChanged: (value) {
        if (value.length >= 8) {
          clearErr('form.password');
        }
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
              if (!validateLoginForm()) return;

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

  String _loginFailureMessage() {
    final input = _usernameController.text.trim();

    if (EmailValidator.validate(input)) {
      return "Email atau Kode Verifikasi Anda salah!";
    }

    return "No Handphone atau Kode Verifikasi Anda salah!";
  }

  void onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        email: _usernameController.text,
        password: _passwordController.text,
        rememberMe: _rememberPassword,
        requestFrom: widget.requestFrom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IosLeftEdgeSwipe(
      onSwipeBack: () async {
        _handleBack();
      },
      child: PopScope(
        canPop: Platform.isAndroid ? false : true,
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS) return;
          if (didPop) return;

          _handleBack();
        },
        child: MultiBlocListener(
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
                    errorSnackBar(_loginFailureMessage()),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: vPadding,
                        ),
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
                            SizedBox(height: vPadding * 0.6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: TextButton.icon(
                                  onPressed: _handleBack,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: primaryColor,
                                    size: getResponsiveFont(context, 18),
                                  ),
                                  label: Text(
                                    "Kembali",
                                    style: bodyTextStyle(context)
                                        .copyWith(color: primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: vPadding * 0.8),
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
                                    _buildEmailField(),
                                    const SizedBox(height: 10),
                                    _buildPasswordField(),
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
                                                  onChanged: (value) =>
                                                      setState(
                                                    () => _rememberPassword =
                                                        value ?? false,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "Simpan Sesi Login",
                                                    style:
                                                        bodyTextStyle(context),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                      NewForgotPasswordPage(
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
                                              color: isHovering
                                                  ? pBlue
                                                  : primaryColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Belum Punya Akun? ",
                                          style: bodyTextStyle(context)
                                              .copyWith(color: hintGrey),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    RegisterPhoneGatePage(
                                                  requestFrom:
                                                      widget.requestFrom.isEmpty
                                                          ? 'daftarclient_page'
                                                          : widget.requestFrom,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Daftar sebagai Klien",
                                            style: bodyTextStyle(context)
                                                .copyWith(color: primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
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
        ),
      ),
    );
  }
}
