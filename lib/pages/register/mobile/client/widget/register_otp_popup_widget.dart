import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/reguser_otp/reguser_otp_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:pinput/pinput.dart';

Future<T?> showRegisterOtpPopup<T>(
  BuildContext context, {
  required String target,
  required String requestFrom,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<RegUserOtpBloc>(),
        child: RegisterOtpPopupWidget(
          target: target,
          requestFrom: requestFrom,
        ),
      );
    },
  );
}

class RegisterOtpPopupWidget extends StatefulWidget {
  final String target;
  final String requestFrom;

  const RegisterOtpPopupWidget({
    super.key,
    required this.target,
    required this.requestFrom,
  });

  @override
  State<RegisterOtpPopupWidget> createState() => _RegisterOtpPopupWidgetState();
}

class _RegisterOtpPopupWidgetState extends State<RegisterOtpPopupWidget>
    with TickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  Timer? _timer;
  int _remainingTime = 59;
  bool _isResendAvailable = false;
  bool _otpError = false;
  bool _hasClosedAfterVerified = false;
  String _inlineMessage = '';
  bool _inlineMessageIsError = false;

  bool get _isEmail => widget.requestFrom.trim().toLowerCase() == 'email';

  String get _normalizedRequestFrom =>
      _isEmail ? 'email' : widget.requestFrom.trim().toLowerCase();

  String get _targetLabel => _isEmail ? 'email' : 'No. HP';

  String get _targetValue {
    if (_isEmail) return widget.target;
    final target = widget.target.trim();
    if (target.startsWith('62') && target.length > 2) {
      return '+62 ${target.substring(2)}';
    }
    return target;
  }

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _pinFocusNode.requestFocus();
    });

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = 59;
      _isResendAvailable = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
        return;
      }

      setState(() => _isResendAvailable = true);
      timer.cancel();
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _shakeOtpFields() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  String _currentRequestId(RegUserOtpState state) {
    return _isEmail ? state.emailRequestId : state.hpRequestId;
  }

  void _resendOtp() {
    _pinController.clear();
    setState(() {
      _otpError = false;
      _inlineMessage = '';
      _inlineMessageIsError = false;
    });
    _startTimer();
    FocusScope.of(context).unfocus();
    Future.microtask(() => _pinFocusNode.requestFocus());

    context.read<RegUserOtpBloc>().add(
          RegUserOtpKirimEvent(
            target: widget.target,
            requestFrom: _normalizedRequestFrom,
          ),
        );
  }

  void _validateOtp(RegUserOtpState state) {
    final pin = _pinController.text;

    if (pin.length != 6) {
      _shakeOtpFields();
      setState(() {
        _otpError = true;
        _inlineMessage = 'Mohon isi semua kode OTP';
        _inlineMessageIsError = true;
      });
      _pinFocusNode.requestFocus();
      return;
    }

    final requestId = _currentRequestId(state);
    if (requestId.isEmpty) {
      _shakeOtpFields();
      setState(() {
        _otpError = true;
        _inlineMessage = 'Kode OTP belum tersedia. Kirim ulang OTP.';
        _inlineMessageIsError = true;
      });
      return;
    }
    context.read<RegUserOtpBloc>().add(
          RegUserOtpValidasiEvent(
            requestId: requestId,
            target: widget.target,
            requestFrom: _normalizedRequestFrom,
            pin: pin,
          ),
        );
  }

  PinTheme _pinTheme(BuildContext context, Color borderColor) {
    return PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: getResponsiveFont(context, 24),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(checkboxBorderRadius),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final basePinTheme = _pinTheme(context, sGrey);
    final focusedPinTheme = _pinTheme(context, primaryColor);
    final errorPinTheme = _pinTheme(context, pRed);

    return BlocConsumer<RegUserOtpBloc, RegUserOtpState>(
      listenWhen: (previous, current) {
        final wasVerified =
            _isEmail ? previous.isEmailVerified : previous.isHpVerified;
        final isVerified =
            _isEmail ? current.isEmailVerified : current.isHpVerified;
        final currentRequestFrom = current.activeRequestFrom;
        return previous.hasFailure != current.hasFailure ||
            previous.message != current.message ||
            (currentRequestFrom == _normalizedRequestFrom &&
                wasVerified != isVerified);
      },
      listener: (context, state) {
        final isCurrentFlow = state.activeRequestFrom == _normalizedRequestFrom;
        final isVerified =
            _isEmail ? state.isEmailVerified : state.isHpVerified;

        if (isCurrentFlow &&
            isVerified &&
            !state.hasFailure &&
            !_hasClosedAfterVerified) {
          _hasClosedAfterVerified = true;
          Navigator.of(context).pop();
          return;
        }

        if (isCurrentFlow &&
            !state.hasFailure &&
            state.message == 'OTP berhasil dikirim.') {
          setState(() {
            _inlineMessage = 'Kode OTP telah dikirim ulang';
            _inlineMessageIsError = false;
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   successSnackBar('Kode OTP telah dikirim ulang'),
          // );

          return;
        }

        if (isCurrentFlow && state.hasFailure) {
          _pinController.clear();
          _pinFocusNode.requestFocus();
          _shakeOtpFields();
          setState(() {
            _otpError = true;
            _inlineMessage = state.message.isNotEmpty
                ? state.message
                : 'Verifikasi OTP gagal';
            _inlineMessageIsError = true;
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   errorSnackBar(
          //     state.message.isNotEmpty
          //         ? state.message
          //         : 'Verifikasi OTP gagal',
          //   ),
          // );
        }
      },
      builder: (context, state) {
        final isSending = _isEmail ? state.isEmailSending : state.isHpSending;
        final isValidating =
            _isEmail ? state.isEmailValidating : state.isHpValidating;
        final isBusy = isSending || isValidating;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: hPadding * 1.5,
            vertical: hPadding * 1.5,
          ),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding * 1.25,
                vertical: vPadding * 1.5,
              ),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius * 1.5),
                border: Border.all(color: sGrey),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/otp_icon.svg',
                      height: 82,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Verifikasi OTP',
                      style: headingStyle(context, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Kami sudah mengirim kode OTP ke $_targetLabel',
                      style: bodyTextStyle(context, fontSize: 14).copyWith(
                        color: hintGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _targetValue,
                      style: bodyTextStyle(context, fontSize: 14).copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
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
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: primaryColor,
                          selectionColor: primaryColor.withOpacity(0.25),
                          selectionHandleColor: primaryColor,
                        ),
                        child: Pinput(
                          length: 6,
                          controller: _pinController,
                          focusNode: _pinFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          autofillHints: const <String>[],
                          defaultPinTheme: basePinTheme,
                          focusedPinTheme: focusedPinTheme,
                          errorPinTheme: errorPinTheme,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          onTap: HapticFeedback.selectionClick,
                          onChanged: (_) {
                            if (_otpError) {
                              setState(() {
                                _otpError = false;
                                _inlineMessage = '';
                                _inlineMessageIsError = false;
                              });
                            }
                          },
                          onCompleted: (_) {
                            if (!isBusy) _validateOtp(state);
                          },
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _inlineMessage.isEmpty
                          ? const SizedBox(height: 8)
                          : Padding(
                              key: ValueKey(_inlineMessage),
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _inlineMessage,
                                style: bodyTextStyle(context, fontSize: 13)
                                    .copyWith(
                                  color: _inlineMessageIsError
                                      ? pRed
                                      : successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    AppButton.primary(
                      text: 'Lanjut',
                      isLoading: isValidating,
                      backgroundColor:
                          isValidating ? secondaryBlackColor : primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onPressed: isBusy ? null : () => _validateOtp(state),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Belum menerima kode OTP?',
                      style: bodyTextStyle(context, fontSize: 13).copyWith(
                        color: hintGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isResendAvailable
                          ? GestureDetector(
                              key: const ValueKey('resend'),
                              behavior: HitTestBehavior.opaque,
                              onTap: isBusy ? null : _resendOtp,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                child: Text(
                                  'Kirim Ulang OTP',
                                  style: bodyTextStyle(context, fontSize: 14)
                                      .copyWith(
                                    color: isBusy ? hintGrey : primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              _formatTime(_remainingTime),
                              key: const ValueKey('timer'),
                              style: bodyTextStyle(context, fontSize: 14)
                                  .copyWith(color: pRed),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
