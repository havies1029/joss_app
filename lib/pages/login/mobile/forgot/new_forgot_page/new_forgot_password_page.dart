import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/forgot_password_reset_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/helper/indo_phone_result.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/models/login/forgot_password_reset_model.dart';
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
  ScaffoldMessengerState? _scaffoldMessenger;
  NavigatorState? _navigator;
  NavigatorState? _rootNavigator;
  ForgotPasswordResetBloc? _forgotPasswordResetBloc;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
    _navigator = Navigator.of(context);
    _rootNavigator = Navigator.of(context, rootNavigator: true);
    _forgotPasswordResetBloc = context.read<ForgotPasswordResetBloc>();
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

    _rootNavigator?.pop();
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

  String? _normalizedPhoneTarget() {
    final phoneRes = IndoPhoneHelper.normalize(
      _emailController.text.trim(),
      emptyMessage: 'Mohon isi nomor HP',
    );

    return phoneRes.phone62;
  }

  Future<void> _submit() async {
    final target = _normalizedPhoneTarget();
    if (target == null) {
      _hideGlobalLoading();

      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
      return;
    }

    bool success = true;
    try {
      success = await (widget.onSubmit?.call(target) ?? Future.value(true));
    } catch (_) {
      success = false;
    }

    if (!mounted) return;

    if (!success) {
      final messenger = _scaffoldMessenger;

      _hideGlobalLoading();

      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }

      messenger?.showSnackBar(
        errorSnackBar("Gagal mengirim OTP, coba lagi."),
      );
      return;
    }

    final record = ForgotPasswordOtpSendModel(
      target: target,
      requestFrom: 'hp',
    );

    context.read<ForgotPasswordResetBloc>().add(
          ForgotPasswordResetSendOtpEvent(record: record),
        );
  }

  Widget _buildPhoneField() {
    return appTextField(
      label: "No. Handphone",
      hint: "Masukkan nomor HP kamu",
      controller: _emailController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        final phoneRes = IndoPhoneHelper.normalize(
          (value ?? "").trim(),
          emptyMessage: 'Mohon isi nomor HP',
        );

        if (!phoneRes.isValid) {
          return phoneRes.error ?? "Masukkan nomor HP yang valid";
        }

        return null;
      },
      onTap: () {},
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ForgotPasswordResetBloc, ForgotPasswordResetState>(
      buildWhen: (prev, curr) => prev.isSending != curr.isSending,
      builder: (context, state) {
        return AppButton.primary(
          text: "Verifikasi",
          isLoading: isSubmitting,
          backgroundColor: isSubmitting ? secondaryBlackColor : primaryColor,
          onPressed: isSubmitting
              ? null
              : () async {
                  final ok = _formKey.currentState?.validate() ?? false;
                  if (!ok) return;

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
        child: BlocListener<ForgotPasswordResetBloc, ForgotPasswordResetState>(
          listenWhen: (prev, curr) =>
              prev.sendOtpSuccess != curr.sendOtpSuccess ||
              prev.errorMessage != curr.errorMessage,
          listener: (context, state) {
            final messenger = _scaffoldMessenger;
            final navigator = _navigator;
            final forgotPasswordResetBloc = _forgotPasswordResetBloc;

            if (state.sendOtpSuccess) {
              final sentTo = state.target.isNotEmpty
                  ? state.target
                  : (_normalizedPhoneTarget() ?? _emailController.text.trim());

              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSubmitting = false;
                });
              }

              navigator?.push(
                MaterialPageRoute(
                  builder: (_) => OtpForgotWidget(
                    sentTo: sentTo,
                    requestFrom: 'hp',
                    useResetPasswordDomain: true,
                  ),
                ),
              );

              forgotPasswordResetBloc?.add(
                const ForgotPasswordResetFlagsEvent(),
              );
              return;
            }

            if (state.errorMessage.isNotEmpty) {
              final errorMessage = state.errorMessage;

              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  isSubmitting = false;
                });
              }

              messenger?.hideCurrentSnackBar();
              messenger?.showSnackBar(errorSnackBar(errorMessage));

              forgotPasswordResetBloc?.add(
                const ForgotPasswordResetClearMessageEvent(),
              );
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
                                          "Masukkan nomor HP terdaftar untuk mengatur ulang kata sandi.",
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
                                          _buildPhoneField(),
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
