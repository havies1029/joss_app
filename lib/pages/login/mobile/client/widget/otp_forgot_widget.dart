import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/emailverification_bloc.dart';
import 'package:joss_app/blocs/login/forgot_password_bloc.dart';
import 'package:joss_app/models/login/emailverification_model.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/pages/login/mobile/client/kata_sandi_baru_page.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../../../common/constants.dart';
import '../../../../base/base_background_firstpage.dart';

class OtpForgotWidget extends StatefulWidget {
  final String sentTo;

  const OtpForgotWidget({
    super.key,
    required this.sentTo,
  });

  @override
  OtpForgotWidgetState createState() => OtpForgotWidgetState();
}

class OtpForgotWidgetState extends State<OtpForgotWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  final List<TextEditingController> _otpControllers = [];
  final List<FocusNode> _focusNodes = [];

  // ⏱ Timer
  Timer? _timer;
  int _remainingTime = 59;
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; i++) {
      _otpControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _isResendAvailable = true);
        timer.cancel();
      }
    });
  }


  void _resendOtp() {

    setState(() {
      _remainingTime = 59;
      _isResendAvailable = false;
    });
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

    ForgotPasswordModel? record = context.read<ForgotPasswordBloc>().state.record;
    context.read<EmailVerificationBloc>().add(
      ResendOtpEvent(record: EmailVerificationModel(email: widget.sentTo, requestId: record?.requestId ?? '')),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_otpControllers.every((c) => c.text.isNotEmpty)) {
      _verifyOtp();
    }
  }
  void _verifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ForgotPasswordModel? record = context.read<ForgotPasswordBloc>().state.record;
    record?.pin = otp;

    // Kirim event validasi OTP ke ForgotPasswordBloc
    if (record == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan, silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<ForgotPasswordBloc>().add(
      ForgotPswdValidasiPinEmailEvent(
          record: record,
          requestAt: DateTime.now() 
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

    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [

        /// LISTENER VALIDASI OTP
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (prev, curr) =>
              prev.isSent != curr.isSent ||
              prev.verificationPinSuccess != curr.verificationPinSuccess,
          listener: (context, state) {
            if (state.isSent && state.verificationPinSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => KataSandiBaruPage(
                    email: widget.sentTo,
                    requestId: state.record?.requestId ?? '',
                  ),
                ),
              );
              return;
            }

            if (state.isSent && !state.verificationPinSuccess) {
              _shakeOtpFields();
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(state.errorMessage.isNotEmpty ? state.errorMessage : "Kode OTP salah. Silakan coba lagi."),
              );
            }
          },
        ),

        /// 🔥 LISTENER RESEND OTP
        BlocListener<EmailVerificationBloc, EmailVerificationState>(
          listenWhen: (prev, curr) =>
              prev.isResendOtpSuccess != curr.isResendOtpSuccess ||
              prev.hasFailure != curr.hasFailure,
          listener: (context, state) {
            if (state.isResendOtpSuccess) {
              _handleResendSuccess();
            }

            if (state.hasFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar("Gagal mengirim ulang OTP."),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: primaryBlackColor,
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
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child:
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      for (var controller in _otpControllers) {
                                        controller.clear();
                                      }
                                      _timer?.cancel();
                                      Navigator.of(context, rootNavigator: false).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: primaryLightColor,
                                      size: getResponsiveFont(context, 18),
                                    ),
                                    label: Text(
                                        "Kembali",
                                        style: bodyTextStyle(context).copyWith(color: primaryLightColor)
                                    ),
                                  ),
                                ),
                              ),
                            ),
      
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: primaryBlackColor,
                                borderRadius: BorderRadius.circular(20),
                                border: const Border(
                                  top: BorderSide(
                                    color: primaryColor,
                                    width: 4.0,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.04),
      
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.lock_outline,
                                          size: 40, color: Colors.white),
                                    ),
                                  ),
      
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Verifikasi OTP',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
      
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text:
                                            'Kami sudah mengirim kode OTP ke\n'),
                                        TextSpan(
                                          text: widget.sentTo,
                                          style: const TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
      
                                  const SizedBox(height: 40),
      
                                  // 🔢 OTP Fields with shake (pakai sin)
                                  AnimatedBuilder(
                                    animation: _shakeAnimation,
                                    builder: (_, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          math.sin(_shakeAnimation.value) * 8,
                                          0,
                                        ),
                                        child: child,
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                          6, (i) => _buildOtpField(i)),
                                    ),
                                  ),
      
                                  const SizedBox(height: 24),
      
                                  // ⏱ Timer / Resend
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: _isResendAvailable
                                        ? GestureDetector(
                                      onTap: _resendOtp,
                                      child: const Text(
                                        'Kirim ulang kode',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                        : Text(
                                      _formatTime(_remainingTime),
                                      style: const TextStyle(
                                        color: pRed, // pakai constant
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
      
      
                                  const SizedBox(height: 32),
                                  const Text(
                                    'Silakan masukkan kode di atas untuk melanjutkan.',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white60),
                                    textAlign: TextAlign.center,
                                  ),
      
                                  const SizedBox(height: 40),
      
                                  // 🚀 Continue button
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          String otp = _otpControllers
                                              .map((c) => c.text)
                                              .join();
                                          if (otp.length == 6) {
                                            _verifyOtp();
                                          } else {
                                            _shakeOtpFields();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(16)),
                                        ),
                                        child: const Text(
                                          'Lanjut',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

  Widget _buildOtpField(int i) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(checkboxBorderRadius),
        border: Border.all(
          color: _focusNodes[i].hasFocus ? primaryColor : sGrey,
        ),
      ),
      child: TextField(
        controller: _otpControllers[i],
        focusNode: _focusNodes[i],
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) => _onOtpChanged(v, i),
        onTap: () {
          _scaleController.reset();
          _scaleController.forward();
        },
      ),
    );
  }

  void _handleResendSuccess() {
    // 🔥 Kosongkan OTP
    for (var controller in _otpControllers) {
      controller.clear();
    }

    // Fokus ke field pertama
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }

    // Reset timer
    setState(() {
      _remainingTime = 59;
      _isResendAvailable = false;
    });

    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      successSnackBar("Kode OTP berhasil dikirim ulang."),
    );
  }

}