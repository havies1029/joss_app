import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/reguser/reguser_bloc.dart';
import 'dart:async';
import 'dart:math' as math; // buat sin shake

import '../../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../../blocs/login/emailverification_bloc.dart';
import '../../../../../common/constants.dart';
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

  // 📌 OTP
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

        // // 🔥 Auto redirect ke HomeTabWidget
        // Future.delayed(const Duration(seconds: 1), () {
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (_) => HomeTabWidget(userRepository: UserRepository()),
        //     ),
        //   );
        // });
      }
    });
  }


  void _resendOtp() {
    String otp = _otpControllers.map((c) => c.text).join();
    setState(() {
      _remainingTime = 59;
      _isResendAvailable = false;
    });
    _startTimer();

    // Kirim event ke BLoC untuk request OTP baru
    context.read<EmailVerificationBloc>().add(
      ValidasiPinEmailEvent(
          record: EmailVerificationModel(email: widget.email, pin: otp), requestAt: DateTime.now()
      ),
    );

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      successSnackBar(
        'Kode OTP telah dikirim ulang ke email',
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

  void  _verifyOtp() {
    String otp = _otpControllers.map((c) => c.text).join();

    // HapticFeedback.mediumImpact();
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (_) => const Center(
    //     child: CircularProgressIndicator(
    //       valueColor: AlwaysStoppedAnimation(primaryColor), // pakai constant
    //     ),
    //   ),
    // );

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    //Navigator.of(context).pop();
    //   context.read<RegUserProfileCubit>().setProfile(
    //     email: widget.email,
    //   );

    context.read<EmailVerificationBloc>().add(
      ValidasiPinEmailEvent(
        record: EmailVerificationModel(email: widget.email, pin: otp), requestAt: DateTime.now(),
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

    // adaptif: kalau layar kecil, jaraknya lebih kecil
    // final double topSpacing =
    // screenHeight < 700 ? screenHeight * 0.06 : screenHeight * 0.095;

    return BlocListener<EmailVerificationBloc, EmailVerificationState>(
      listener: (context, state) {
        if (state.verificationFailed) {
          _shakeOtpFields();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kode OTP salah, silakan coba lagi'),
              backgroundColor: Colors.red,
            ),
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
                                      context.read<AuthenticationBloc>().add(LoggedOut());
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
                              decoration: BoxDecoration(
                                gradient: cardBorderGradient,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: vPadding * 2, horizontal: hPadding * 1.5),
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
                                    // SizedBox(height: screenHeight * 0.04),
                                    // Icon
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
                                        Text("Kami sudah mengirim kode OTP ke hp/email", style: bodyTextStyle(context, fontSize: 20)),
                                        Text(
                                            widget.email, style: bodyTextStyle(context, fontSize: 20).copyWith(color: primaryColor)
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // ⏱ Timer / Resend
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: _isResendAvailable
                                          ? GestureDetector(
                                        onTap: _resendOtp,
                                        child: Text(
                                          'Kirim ulang kode',
                                          style: bodyTextStyle(context
                                          ).copyWith(color: primaryColor),
                                        ),
                                      )
                                          : Text(
                                        _formatTime(_remainingTime),
                                        style: bodyTextStyle(context
                                        ).copyWith(color: pRed),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // 🔢 OTP Fields
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

                                    const SizedBox(height: 18),
                                    Text(
                                      'Silakan masukkan kode di atas untuk melanjutkan.',
                                      style: bodyTextStyle(context).copyWith(color: hintGrey),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 18),

                                    AppButton.primary(
                                      text: "Lanjut",
                                      onPressed: () {
                                        String otp = _otpControllers.map((c) => c.text).join();
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

}