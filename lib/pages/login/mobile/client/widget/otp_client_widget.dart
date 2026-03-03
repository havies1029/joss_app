import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../../blocs/login/emailverification_bloc.dart';
import '../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/login/emailverification_model.dart';
import '../../../../../models/reguser/reguser_model.dart';
import '../../../../base/base_background_firstpage.dart';

class PopupClientWidget extends StatefulWidget {
  final String sentTo;
  final String sentVia;

  const PopupClientWidget({
    super.key,
    required this.sentTo,
    required this.sentVia,
  });

  @override
  PopupClientWidgetState createState() => PopupClientWidgetState();
}

class PopupClientWidgetState extends State<PopupClientWidget>
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
    final otp = _otpControllers.map((c) => c.text).join();

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

    RegUserModel? record = context.read<RegUserBloc>().state.record;
    record?.kodePin = otp;

    final emailVerificationRecord =
        context.read<EmailVerificationBloc>().state.record;

    context.read<EmailVerificationBloc>().add(
      ResendOtpEvent(
        record: EmailVerificationModel(
          email: widget.sentTo,
          requestId: emailVerificationRecord?.requestId ?? '',
          requestFrom: "email",
        ),
      ),
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
    final otp = _otpControllers.map((c) => c.text).join();

    // ✅ validasi kamu tetap
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    RegUserModel? record = context.read<RegUserBloc>().state.record;
    record?.kodePin = otp;

    context.read<RegUserBloc>().add(
      ValidasiPinHPEvent(
        record: record!,
        sentTo: widget.sentTo,
        sentVia: widget.sentVia,
      ),
    );

    Navigator.of(context, rootNavigator: true).pop();
  }

  void _shakeOtpFields() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    _timer?.cancel();

    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ ikut DNA patokan: secondaryBlackColor
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
                                    for (final controller in _otpControllers) {
                                      controller.clear();
                                    }
                                    _timer?.cancel();
                                    Navigator.of(context, rootNavigator: false)
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

                          // ✅ Card DNA patokan (gradient border)
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
                                  // ✅ icon SVG seperti patokan
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
                                        "Kami sudah mengirim kode OTP ke ${widget.sentVia}",
                                        style: bodyTextStyle(
                                          context,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        widget.sentTo,
                                        style: bodyTextStyle(
                                          context,
                                          fontSize: 20,
                                        ).copyWith(color: primaryColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // ⏱ Timer / resend (UI ikut DNA patokan)
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: _isResendAvailable
                                        ? GestureDetector(
                                      onTap: _resendOtp,
                                      child: Text(
                                        'Kirim ulang kode',
                                        style: bodyTextStyle(context)
                                            .copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    )
                                        : Text(
                                      _formatTime(_remainingTime),
                                      style: bodyTextStyle(context)
                                          .copyWith(color: pRed),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // 🔢 OTP fields + shake (UI ikut DNA patokan)
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
                                          6,
                                              (i) => _buildOtpField(i),
                                        ),
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

                                  // ✅ Button ikut DNA patokan: AppButton.primary
                                  AppButton.primary(
                                    text: "Lanjut",
                                    onPressed: () {
                                      final otp = _otpControllers
                                          .map((c) => c.text)
                                          .join();
                                      if (otp.length == 6) {
                                        _verifyOtp();
                                      } else {
                                        _shakeOtpFields();
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
    );
  }

  Widget _buildOtpField(int i) {
    final hasFocus = _focusNodes[i].hasFocus;

    // ✅ UI ikut DNA patokan: AnimatedContainer + border width 2
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(checkboxBorderRadius),
        border: Border.all(
          color: hasFocus ? primaryColor : sGrey,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _otpControllers[i],
        focusNode: _focusNodes[i],
        textAlign: TextAlign.center,
        cursorColor: primaryColor,
        cursorWidth: 2,
        cursorHeight: 24,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) => _onOtpChanged(v, i),

        // ✅ tetap pertahankan behavior kamu (scale reset/forward) biar "sebisa mungkin" nggak berubah
        onTap: () {
          _scaleController.reset();
          _scaleController.forward();
        },
      ),
    );
  }
}