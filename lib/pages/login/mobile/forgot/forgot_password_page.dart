import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/forgot_password_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/pages/login/mobile/forgot/widget/otp_forgot_widget.dart';

import '../../../../common/loading_indicator.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? initialEmail;
  final VoidCallback? onBack;
  final Future<bool> Function(String email)? onSubmit;

  const ForgotPasswordPage({
    super.key,
    this.initialEmail,
    this.onBack,
    this.onSubmit,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool isSubmitting = false;

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
    _emailController = TextEditingController(text: widget.initialEmail ?? "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
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
                sentTo: state.record?.sentTo ?? _emailController.text.trim(),
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
        backgroundColor: secondaryBlackColor,
        body: BaseBackgroundFirstPage(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
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
                                SizedBox(height: hPadding),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: widget.onBack ??
                                      () => Navigator.of(context).maybePop(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.chevron_left,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Kembali",
                                        style: bodyTextStyle(context).copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                        style: bodyTextStyle(context).copyWith(
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: hPadding * 1.5,
                                      vertical: vPadding,
                                    ),
                                    child: Column(
                                      children: [
                                        appTextField(
                                          label: "Email",
                                          hint: "Masukkan email kamu",
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
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
                                        ),
                                        const SizedBox(height: 10),
                                        BlocBuilder<ForgotPasswordBloc,
                                            ForgotPasswordState>(
                                          buildWhen: (prev, curr) =>
                                              prev.isLoading != curr.isLoading,
                                          builder: (context, state) {
                                            return AppButton.primary(
                                              text: "Kirim",
                                              isLoading: isSubmitting,
                                              backgroundColor: isSubmitting
                                                  ? secondaryBlackColor
                                                  : primaryColor,
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
                                        ),
                                        const SizedBox(height: 10),
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
    );
  }
}
