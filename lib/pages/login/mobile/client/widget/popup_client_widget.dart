import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:math' as math; // buat sin shake

import '../../../../../blocs/login/emailverification_bloc.dart';
import '../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/login/emailverification_model.dart';
import '../../../../../models/reguser/reguser_model.dart';
import '../../../../../repositories/user/user_repository.dart';
import '../../../../base/base_background_firstpage.dart';
import '../../../../home/home_tab_widget.dart';

class PopupClientWidget extends StatefulWidget {
  final String phoneNumber;

  const PopupClientWidget({
    super.key,
    required this.phoneNumber,
  });

  @override
  _PopupClientWidgetState createState() => _PopupClientWidgetState();
}

class _PopupClientWidgetState extends State<PopupClientWidget>
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

        // 🔥 Auto redirect ke HomeTabWidget
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

    context.read<RegUserBloc>().add(
      ValidasiPinHPEvent(
          record: record!
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

  void _verifyOtp() {
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

    RegUserModel? record = context.read<RegUserBloc>().state.record;
    record?.kodePin = otp;

    context.read<RegUserBloc>().add(
      ValidasiPinHPEvent(
          record: record!
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

    for (var c in _otpControllers) c.dispose();
    for (var n in _focusNodes) n.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // adaptif: kalau layar kecil, jaraknya lebih kecil
    final double topSpacing =
    screenHeight < 700 ? screenHeight * 0.06 : screenHeight * 0.095;

    return Scaffold(
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundFirstPage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
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
                          SizedBox(height: topSpacing),

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

                                // 🔒 Icon
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
                                        text: widget.phoneNumber,
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
    );
  }

  Widget _buildOtpField(int i) {
    return Container(
      width: 45,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNodes[i].hasFocus ? primaryColor : Colors.grey[700]!,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _otpControllers[i],
        focusNode: _focusNodes[i],
        textAlign: TextAlign.center,
        style: const TextStyle(
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