import 'dart:async';
import 'dart:math' as math;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/login/forgot_password_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/indo_phone_result.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/pages/login/mobile/client/kata_sandi_baru_page.dart';
import 'package:pinput/pinput.dart';

import '../../../../base/base_background_firstpage.dart';

class OtpForgotWidget extends StatefulWidget {
  final String sentTo;

  const OtpForgotWidget({
    super.key,
    required this.sentTo,
  });

  @override
  State<OtpForgotWidget> createState() => _OtpForgotWidgetState();
}

class _OtpForgotWidgetState extends State<OtpForgotWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  bool _otpError = false;

  Timer? _timer;
  int _remainingTime = 59;
  bool _isResendAvailable = false;
  bool _isVerifyingOtp = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pinFocusNode.requestFocus();
    });

    _pinFocusNode.addListener(() {
      if (mounted) setState(() {});
    });

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
    _startTimer();
  }

  bool _isEmail(String input) => EmailValidator.validate(input);
  bool _isPhone(String input) => IndoPhoneHelper.normalize(input).isValid;

  String _formatPhoneVisual(String phone62) {
    if (!phone62.startsWith('62')) return phone62;
    return '+62 ${phone62.substring(2)}';
  }

  String _buildOtpLabel(String input) {
    if (_isEmail(input)) return 'email';
    if (_isPhone(input)) return 'No. HP';
    return 'hp/email';
  }

  String _buildOtpValue(String input) {
    if (_isEmail(input)) return input;

    final phoneRes = IndoPhoneHelper.normalize(input);
    if (phoneRes.isValid) {
      return _formatPhoneVisual(phoneRes.phone62!);
    }
    return input;
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _slideController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _scaleController.forward();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _isResendAvailable = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isResendAvailable = true;
        });
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _resetOtpAndFocusFirst() {
    _pinController.clear();
    setState(() {
      _otpError = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pinFocusNode.requestFocus();
    });
  }

  void _shakeOtpFields() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  void _resendOtp() {
    final forgotPasswordBloc = context.read<ForgotPasswordBloc>();
    final existingRecord = forgotPasswordBloc.state.record;

    final record = existingRecord ??
        RequestOtpModel(
          sentTo: widget.sentTo,
          sentVia: _isEmail(widget.sentTo) ? "email" : "hp",
          purpose: "forgot_password",
        );

    forgotPasswordBloc.add(ForgotPswdResendOtpEvent(record: record));
  }

  void _verifyOtp({String? otpOverride}) {
    if (_isVerifyingOtp) return;

    final otp = (otpOverride ?? _pinController.text).trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final record = context.read<ForgotPasswordBloc>().state.record;
    if (record == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan, silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isVerifyingOtp = true;
      _otpError = false;
    });

    record.kodePin = otp;

    context.read<ForgotPasswordBloc>().add(
      ForgotPswdValidasiPinEmailEvent(
        record: record,
        requestAt: DateTime.now(),
      ),
    );
  }

  void _handleResendSuccess() {
    _resetOtpAndFocusFirst();

    setState(() {
      _remainingTime = 59;
      _isResendAvailable = false;
    });

    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      successSnackBar("Kode OTP berhasil dikirim ulang."),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (prev, curr) =>
          prev.verificationPinSuccess != curr.verificationPinSuccess ||
          prev.verificationPinFailed != curr.verificationPinFailed ||
          prev.resendOtpSuccess != curr.resendOtpSuccess ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.verificationPinSuccess ||
            state.verificationPinFailed ||
            state.errorMessage.isNotEmpty) {
          if (mounted) {
            setState(() {
              _isVerifyingOtp = false;
            });
          }
        }

        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();

        if (state.verificationPinSuccess) {
          messenger.showSnackBar(
            successSnackBar("Verifikasi OTP berhasil"),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => KataSandiBaruPage(
                email: widget.sentTo,
                requestId: state.record?.requestOtpId ?? '',
              ),
            ),
          );
          return;
        }

        if (state.verificationPinFailed) {
          _shakeOtpFields();
          setState(() {
            _otpError = true;
          });

          messenger.showSnackBar(
            errorSnackBar(
              state.errorMessage.isNotEmpty
                  ? state.errorMessage
                  : "Kode OTP salah / sudah kadaluarsa.",
            ),
          );

          _resetOtpAndFocusFirst();

          context.read<ForgotPasswordBloc>().add(
            const ForgotPswdResetFlagsEvent(),
          );
          context.read<ForgotPasswordBloc>().add(
            const ForgotPswdClearMessageEvent(),
          );
          return;
        }

        if (state.resendOtpSuccess) {
          _handleResendSuccess();

          context.read<ForgotPasswordBloc>().add(
            const ForgotPswdResetFlagsEvent(),
          );
          context.read<ForgotPasswordBloc>().add(
            const ForgotPswdClearMessageEvent(),
          );
          return;
        }

        if (state.errorMessage.isNotEmpty &&
            !state.verificationPinFailed &&
            !state.verificationPinSuccess &&
            !state.resendOtpSuccess) {
          messenger.showSnackBar(
            errorSnackBar(state.errorMessage),
          );

          context.read<ForgotPasswordBloc>().add(
            const ForgotPswdClearMessageEvent(),
          );
        }
      },
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        body: SafeArea(
          child: BaseBackgroundFirstPage(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      _resetOtpAndFocusFirst();
                                      _timer?.cancel();
                                      Navigator.of(
                                        context,
                                        rootNavigator: false,
                                      ).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: primaryLightColor,
                                      size: getResponsiveFont(context, 18),
                                    ),
                                    label: Text(
                                      "Kembali",
                                      style: bodyTextStyle(context).copyWith(
                                        color: primaryLightColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: cardBorderGradient,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: vPadding * 2,
                                  horizontal: hPadding * 1.5,
                                ),
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: secondaryBlackColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/otp_icon.svg",
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Verifikasi OTP',
                                      style: headingStyle(context, fontSize: 25),
                                    ),
                                    const SizedBox(height: 6),
                                    Column(
                                      children: [
                                        Text(
                                          "Kami sudah mengirim kode OTP ke ${_buildOtpLabel(widget.sentTo)}",
                                          style: bodyTextStyle(
                                            context,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          _buildOtpValue(widget.sentTo),
                                          style: bodyTextStyle(
                                            context,
                                            fontSize: 20,
                                          ).copyWith(color: primaryColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    BlocBuilder<ForgotPasswordBloc,
                                        ForgotPasswordState>(
                                      buildWhen: (prev, curr) =>
                                          prev.isLoading != curr.isLoading,
                                      builder: (context, state) {
                                        return AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: _isResendAvailable
                                              ? GestureDetector(
                                                  onTap: state.isLoading
                                                      ? null
                                                      : _resendOtp,
                                                  child: Text(
                                                    state.isLoading
                                                        ? 'Mengirim ulang...'
                                                        : 'Kirim ulang kode',
                                                    style: bodyTextStyle(context)
                                                        .copyWith(
                                                      color: state.isLoading
                                                          ? hintGrey
                                                          : primaryColor,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  _formatTime(_remainingTime),
                                                  style: bodyTextStyle(context)
                                                      .copyWith(color: pRed),
                                                ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextSelectionTheme(
                                      data: TextSelectionThemeData(
                                        cursorColor: primaryColor,
                                        selectionColor:
                                            primaryColor.withOpacity(0.25),
                                        selectionHandleColor: primaryColor,
                                      ),
                                      child: AnimatedBuilder(
                                        animation: _shakeAnimation,
                                        builder: (_, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              math.sin(_shakeAnimation.value) *
                                                  8,
                                              0,
                                            ),
                                            child: child,
                                          );
                                        },
                                        child: Pinput(
                                          length: 6,
                                          controller: _pinController,
                                          focusNode: _pinFocusNode,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          autofillHints: const <String>[],

                                          defaultPinTheme: PinTheme(
                                            width: 48,
                                            height: 48,
                                            textStyle: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                              color: pGrey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                checkboxBorderRadius,
                                              ),
                                              border: Border.all(
                                                color: _pinFocusNode.hasFocus
                                                    ? primaryColor
                                                    : sGrey,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          focusedPinTheme: PinTheme(
                                            width: 48,
                                            height: 48,
                                            textStyle: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                              color: pGrey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                checkboxBorderRadius,
                                              ),
                                              border: Border.all(
                                                color: primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          errorPinTheme: PinTheme(
                                            width: 48,
                                            height: 48,
                                            textStyle: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                              color: pGrey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                checkboxBorderRadius,
                                              ),
                                              border: Border.all(
                                                color: pRed,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          forceErrorState: _otpError,
                                          showCursor: true,
                                          cursor: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 2,
                                              height: 24,
                                              color: primaryColor,
                                            ),
                                          ),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          onTap: () =>
                                              HapticFeedback.selectionClick(),
                                          onChanged: (v) {
                                            if (_otpError) {
                                              setState(() {
                                                _otpError = false;
                                              });
                                            }
                                          },
                                          onCompleted: (pin) {
                                            _verifyOtp(otpOverride: pin);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      'Silakan masukkan kode di atas untuk melanjutkan.',
                                      style: bodyTextStyle(context).copyWith(
                                        color: hintGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 18),
                                    AppButton.primary(
                                      text: "Lanjut",
                                      isLoading: _isVerifyingOtp,
                                      backgroundColor: _isVerifyingOtp ? secondaryBlackColor : primaryColor,
                                      onPressed: _isVerifyingOtp
                                          ? null
                                          : () {
                                        final otp = _pinController.text.trim();

                                        if (otp.length == 6) {
                                          _verifyOtp();
                                        } else {
                                          _shakeOtpFields();
                                          setState(() {
                                            _otpError = true;
                                          });
                                          _pinFocusNode.requestFocus();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}