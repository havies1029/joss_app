import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math' as math;

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

    // biar border fokus ke-refresh halus tanpa setState jittery
    for (final n in _focusNodes) {
      n.addListener(() {
        if (mounted) setState(() {});
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNodes[0].requestFocus();
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

  // ===== Helper label/value (tanpa sentuh bloc) =====
  bool _looksLikeEmail(String input) => input.contains('@');

  bool _looksLikePhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 9; // cukup aman buat hp lokal
  }

  String _buildOtpLabel(String input) {
    if (_looksLikeEmail(input)) return 'email';
    if (_looksLikePhone(input)) return 'No. HP';
    return 'hp/email';
  }

  String _buildOtpValue(String input) {
    if (_looksLikePhone(input)) {
      final digits = input.replaceAll(RegExp(r'\D'), '');
      // kalau sudah 62xxxxx, tampilkan +62 xxxxx
      if (digits.startsWith('62')) return '+62 ${digits.substring(2)}';
      // kalau 0xxxx -> tampilkan apa adanya
      return input;
    }
    return input;
  }

  void _resetOtpAndFocusFirst() {
    for (final c in _otpControllers) {
      c.clear();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
    setState(() {});
  }

  void _startAnimations() async {
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
      if (!mounted) return;
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _isResendAvailable = true);
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    // bloc tetap sama: jangan diubah
    final otp = _otpControllers.map((c) => c.text).join();

    setState(() {
      _remainingTime = 59;
      _isResendAvailable = false;
    });
    _startTimer();

    context.read<EmailVerificationBloc>().add(
      ValidasiPinEmailEvent(
        record: EmailVerificationModel(email: widget.email, pin: otp),
        requestAt: DateTime.now(),
      ),
    );

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      successSnackBar('Kode OTP telah dikirim ulang ke email'),
    );
  }

  void _onOtpChanged(String value, int index) {
    // PASTE handling: user paste 123456
    if (value.length > 1) {
      final chars = value.replaceAll(RegExp(r'\D'), '').split('');
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = i < chars.length ? chars[i] : '';
      }
      final last = math.min(chars.length, 6) - 1;
      if (last >= 0) {
        _focusNodes[last].requestFocus();
      } else {
        _focusNodes[0].requestFocus();
      }

      // auto verify kalau penuh
      if (_otpControllers.every((c) => c.text.isNotEmpty)) _verifyOtp();
      setState(() {}); // paste only
      return;
    }

    // Normal typing
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }

    if (_otpControllers.every((c) => c.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  void _verifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua kode OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // bloc tetap sama: jangan diubah
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
          _resetOtpAndFocusFirst();
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
                                  horizontal: 15, vertical: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      for (final c in _otpControllers) {
                                        c.clear();
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
                                      style: bodyTextStyle(context)
                                          .copyWith(color: primaryLightColor),
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
                                    SvgPicture.asset("assets/icons/otp_icon.svg"),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Verifikasi OTP',
                                      style: headingStyle(context, fontSize: 25),
                                    ),
                                    const SizedBox(height: 6),

                                    Column(
                                      children: [
                                        Text(
                                          "Kami sudah mengirim kode OTP ke ${_buildOtpLabel(widget.email)}",
                                          style: bodyTextStyle(context, fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          _buildOtpValue(widget.email),
                                          style: bodyTextStyle(context, fontSize: 20)
                                              .copyWith(color: primaryColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: _isResendAvailable
                                          ? GestureDetector(
                                        onTap: _resendOtp,
                                        child: Text(
                                          'Kirim ulang kode',
                                          style: bodyTextStyle(context)
                                              .copyWith(color: primaryColor),
                                        ),
                                      )
                                          : Text(
                                        _formatTime(_remainingTime),
                                        style: bodyTextStyle(context)
                                            .copyWith(color: pRed),
                                      ),
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
                                      style: bodyTextStyle(context)
                                          .copyWith(color: hintGrey),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 18),

                                    AppButton.primary(
                                      text: "Lanjut",
                                      onPressed: () {
                                        final otp =
                                        _otpControllers.map((c) => c.text).join();
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
    final hasFocus = _focusNodes[i].hasFocus;

    return Focus(
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        final isBackspace = event.logicalKey == LogicalKeyboardKey.backspace;
        if (!isBackspace) return KeyEventResult.ignored;

        // 1) kalau field ada isi: clear field ini, stay
        if (_otpControllers[i].text.isNotEmpty) {
          _otpControllers[i].clear();
          return KeyEventResult.handled;
        }

        // 2) kalau kosong: pindah kiri + clear kiri
        if (i > 0) {
          _otpControllers[i - 1].clear();
          _focusNodes[i - 1].requestFocus();
          return KeyEventResult.handled;
        }

        return KeyEventResult.handled;
      },
      child: AnimatedContainer(
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
          textInputAction: i == 5 ? TextInputAction.done : TextInputAction.next,
          maxLength: 1,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => _onOtpChanged(v, i),
          onTap: () {
            HapticFeedback.selectionClick();
            _scaleController.reset();
            _scaleController.forward();
          },
        ),
      ),
    );
  }
}