import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math' as math; // buat sin shake
import 'package:pinput/pinput.dart';

import '../../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../../blocs/login/emailverification_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/indo_phone_result.dart';
import '../../../../../models/login/emailverification_model.dart';
import '../../../../base/base_background_firstpage.dart';

class PopupUserWidget extends StatefulWidget {
  final String email;

  const PopupUserWidget({
    super.key,
    required this.email,
  });

  @override
  _PopupUserWidgetState createState() => _PopupUserWidgetState();
}

class _PopupUserWidgetState extends State<PopupUserWidget>
    with TickerProviderStateMixin {
  // 🎬 Animations
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  // 📌 OTP (Pinput)
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _otpError = false;

  // ⏱ Timer
  Timer? _timer;
  int _remainingTime = 59;
  bool _isResendAvailable = false;
  bool _isVerifyingOtp = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _startAnimations();
    _startTimer();
  }

  bool _isEmail(String input) => EmailValidator.validate(input);

  bool _isPhone(String input) => IndoPhoneHelper.normalize(input).isValid;

  String _buildRequestFrom(String input) {
    if (_isEmail(input)) return "email";
    if (_isPhone(input)) return "hp";
    return "unknown";
  }

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

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _isResendAvailable = true);
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    //micky 2026-03-05
    // cegah onCompleted kepanggil dari value lama / autofill
    _pinController.clear();
    setState(() {
      _otpError = false;
      _remainingTime = 59;
      _isResendAvailable = false;
    });
    FocusScope.of(context).unfocus();
    Future.microtask(() => _pinFocusNode.requestFocus());
    _startTimer();

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Kode OTP telah dikirim ulang'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final emailVerificationRecord =
        context.read<EmailVerificationBloc>().state.record;

    context.read<EmailVerificationBloc>().add(
      ResendOtpEvent(
        record: EmailVerificationModel(
          email: widget.email,
          requestId: emailVerificationRecord?.requestId ?? '',
          requestFrom: _buildRequestFrom(widget.email),
        ),
      ),
    );
  }

  void _verifyOtpFromPin(String otp) {
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<EmailVerificationBloc>().add(
      ValidasiPinEmailEvent(
        record: EmailVerificationModel(email: widget.email, pin: otp),
        requestAt: DateTime.now(),
      ),
    );
  }

  void _shakeOtpFields() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
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
    final screenHeight = MediaQuery.of(context).size.height;

    // === PIN THEMES (DESAIN TETAP) ===
    final basePinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(checkboxBorderRadius),
        border: Border.all(
          color: _pinFocusNode.hasFocus ? primaryColor : sGrey,
          width: 2,
        ),
      ),
    );

    final focusedPinTheme = basePinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor, width: 2),
    );

    final errorPinTheme = basePinTheme.copyDecorationWith(
      border: Border.all(color: pRed, width: 2),
    );

    return BlocListener<EmailVerificationBloc, EmailVerificationState>(
      listenWhen: (previous, current) =>
      previous.isLoaded != current.isLoaded ||
          previous.verificationFailed != current.verificationFailed,
      listener: (context, state) {
        if (!state.isLoaded) return;

        if (mounted) {
          setState(() {
            _isVerifyingOtp = false;
          });
        }

        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();

        if (state.verificationFailed) {
          _shakeOtpFields();

          setState(() => _otpError = true);

          _pinController.clear();
          _pinFocusNode.requestFocus();

          messenger.showSnackBar(
            errorSnackBar(
              state.errors.isNotEmpty
                  ? state.errors.first
                  : 'Verifikasi OTP gagal',
            ),
          );
        } else {
          messenger.showSnackBar(
            successSnackBar('Verifikasi OTP berhasil'),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          _pinController.clear();
          _timer?.cancel();

          Navigator.of(context, rootNavigator: false).pop();

          context.read<AuthenticationBloc>().add(LoggedOut());
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
                                    horizontal: 15, vertical: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: TextButton.icon(
                                      onPressed: () {
                                        _pinController.clear();
                                        _timer?.cancel();
                                        Navigator.of(context,
                                            rootNavigator: false)
                                            .pop();
                                        context
                                            .read<AuthenticationBloc>()
                                            .add(LoggedOut());
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
                                        size:
                                        getResponsiveFont(context, 18),
                                      ),
                                      label: Text(
                                        "Kembali",
                                        style: bodyTextStyle(context)
                                            .copyWith(
                                            color: primaryLightColor),
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
                                  decoration: const BoxDecoration(
                                    color: secondaryBlackColor,
                                    borderRadius: BorderRadius.only(
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
                                        style: headingStyle(context,
                                            fontSize: 25),
                                      ),
                                      const SizedBox(height: 6),
                                      Column(
                                        children: [
                                          Text(
                                            "Kami sudah mengirim kode OTP ke ${_buildOtpLabel(widget.email)}",
                                            style: bodyTextStyle(context,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            _buildOtpValue(widget.email),
                                            style: bodyTextStyle(context,
                                                fontSize: 20)
                                                .copyWith(
                                                color: primaryColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                            milliseconds: 300),
                                        child: _isResendAvailable
                                            ? GestureDetector(
                                          onTap: _resendOtp,
                                          child: Text(
                                            'Kirim ulang kode',
                                            style: bodyTextStyle(
                                                context)
                                                .copyWith(
                                                color:
                                                primaryColor),
                                          ),
                                        )
                                            : Text(
                                          _formatTime(
                                              _remainingTime),
                                          style: bodyTextStyle(
                                              context)
                                              .copyWith(
                                              color: pRed),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      AnimatedBuilder(
                                        animation: _shakeAnimation,
                                        builder: (_, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              math.sin(_shakeAnimation
                                                  .value) *
                                                  8,
                                              0,
                                            ),
                                            child: child,
                                          );
                                        },
                                        child: TextSelectionTheme(
                                          data: TextSelectionThemeData(
                                            cursorColor: primaryColor,
                                            selectionColor: primaryColor
                                                .withOpacity(0.25),
                                            selectionHandleColor:
                                            primaryColor,
                                          ),
                                          child: Pinput(
                                            length: 6,
                                            controller: _pinController,
                                            focusNode: _pinFocusNode,
                                            keyboardType:
                                            TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            autofillHints:
                                            const <String>[],

                                            defaultPinTheme: basePinTheme,
                                            focusedPinTheme:
                                            focusedPinTheme,
                                            errorPinTheme:
                                            errorPinTheme,
                                            forceErrorState: _otpError,

                                            showCursor: true,
                                            cursor: Align(
                                              alignment:
                                              Alignment.center,
                                              child: Container(
                                                width: 2,
                                                height: 24,
                                                color: primaryColor,
                                              ),
                                            ),

                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,

                                            onTap: () =>
                                                HapticFeedback
                                                    .selectionClick(),

                                            onChanged: (v) {
                                              if (_otpError) {
                                                setState(() =>
                                                _otpError =
                                                false);
                                              }
                                            },

                                            onCompleted: (pin) {
                                              if (_isVerifyingOtp) return;

                                              if (_otpError) {
                                                setState(() => _otpError = false);
                                              }

                                              setState(() {
                                                _isVerifyingOtp = true;
                                              });

                                              _verifyOtpFromPin(pin);
                                            },
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 18),
                                      Text(
                                        'Silakan masukkan kode di atas untuk melanjutkan.',
                                        style: bodyTextStyle(context)
                                            .copyWith(color: hintGrey),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 18),

                                      AppButton.primary(
                                        text: "Lanjut",
                                        isLoading: _isVerifyingOtp,
                                        backgroundColor:
                                        _isVerifyingOtp ? secondaryBlackColor : primaryColor,
                                        onPressed: _isVerifyingOtp
                                            ? null
                                            : () {
                                          final otp = _pinController.text;

                                          if (otp.length == 6) {
                                            setState(() {
                                              _isVerifyingOtp = true;
                                            });

                                            _verifyOtpFromPin(otp);
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
      ),
    );
  }
}