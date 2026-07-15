import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/forgot_password_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/pages/login/mobile/client/new_login_client/new_login_client_page.dart';
import 'package:joss_app/pages/login/mobile/forgot/widget/otp_forgot_widget.dart';

class NewForgotPasswordPage extends StatefulWidget {
  final String? initialEmail;
  final VoidCallback? onBack;
  final Future<bool> Function(String email)? onSubmit;

  const NewForgotPasswordPage({
    super.key,
    this.initialEmail,
    this.onBack,
    this.onSubmit,
  });

  @override
  State<NewForgotPasswordPage> createState() => _NewForgotPasswordPageState();
}

class _NewForgotPasswordPageState extends State<NewForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool isSubmitting = false;
  bool _isDialogLoadingShown = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? "");
  }

  @override
  void dispose() {
    _emailController.dispose();
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

  void _handleBack() {
    final onBack = widget.onBack;
    if (onBack != null) {
      onBack();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => const NewLoginClient(),
      ),
    );
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _emailController.text.trim();

    final success = await (widget.onSubmit?.call(email) ?? Future.value(true));
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar("Gagal mengirim OTP, coba lagi."),
      );
      return;
    }

    final record = RequestOtpModel(
      sentTo: email,
      sentVia: "email",
      purpose: "forgot_password",
    );

    context.read<ForgotPasswordBloc>().add(
          ForgotPswdRequestPinEvent(record: record),
        );
  }

  Widget _buildEmailField() {
    return appTextField(
      label: "Email",
      hint: "Masukkan email kamu",
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final v = (value ?? "").trim();

        if (v.isEmpty) {
          return "Mohon isi email";
        }

        if (!EmailValidator.validate(v)) {
          return "Masukkan format email yang valid";
        }

        return null;
      },
      onTap: () {},
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return AppButton.primary(
          text: "Kirim",
          isLoading: isSubmitting,
          backgroundColor: isSubmitting ? secondaryBlackColor : primaryColor,
          onPressed: isSubmitting
              ? null
              : () async {
                  setState(() {
                    isSubmitting = true;
                  });

                  _showGlobalLoading();

                  await _submit();
                },
        );
      },
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
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (prev, curr) =>
              prev.requestOtpSuccess != curr.requestOtpSuccess ||
              prev.errorMessage != curr.errorMessage,
          listener: (context, state) {
            if (state.requestOtpSuccess) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSubmitting = false;
                });
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OtpForgotWidget(
                    sentTo:
                        state.record?.sentTo ?? _emailController.text.trim(),
                  ),
                ),
              );

              context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotPswdResetFlagsEvent());
              return;
            }

            if (state.errorMessage.isNotEmpty) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSubmitting = false;
                });
              }

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(state.errorMessage),
              );

              context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotPswdClearMessageEvent());
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: primaryBlackColor,
            body: SafeArea(
              child: BaseBackgroundFirstPage(
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
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: hPadding,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Lupa Kata Sandi?",
                                          style: headingStyle(context),
                                        ),
                                        Text(
                                          "Masukkan email terdaftar untuk mengatur ulang kata sandi.",
                                          style:
                                              bodyTextStyle(context).copyWith(
                                            color: hintGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                  decoration: const BoxDecoration(
                                    color: secondaryBlackColor,
                                    borderRadius: BorderRadius.only(
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
                                          _buildSubmitButton(),
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
          ),
        ),
      ),
    );
  }
}
