import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpic_contact_change_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_profile/mrekanpic_contact_change_model.dart';
import 'package:pinput/pinput.dart';

Future<bool?> showMRekanPicContactChangeOtpPopup(
  BuildContext context, {
  required MRekanPicContactChangeBloc bloc,
  required String mrekanpicId,
  required int changeTypeId,
  required int verifyViaId,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: MRekanPicContactChangeOtpPopupWidget(
        mrekanpicId: mrekanpicId,
        changeTypeId: changeTypeId,
        verifyViaId: verifyViaId,
      ),
    ),
  );
}

class MRekanPicContactChangeOtpPopupWidget extends StatefulWidget {
  final String mrekanpicId;
  final int changeTypeId;
  final int verifyViaId;

  const MRekanPicContactChangeOtpPopupWidget({
    super.key,
    required this.mrekanpicId,
    required this.changeTypeId,
    required this.verifyViaId,
  });

  @override
  State<MRekanPicContactChangeOtpPopupWidget> createState() =>
      _MRekanPicContactChangeOtpPopupWidgetState();
}

class _MRekanPicContactChangeOtpPopupWidgetState
    extends State<MRekanPicContactChangeOtpPopupWidget>
    with SingleTickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  Timer? _timer;
  int _remainingTime = 59;
  bool _isResendAvailable = false;
  bool _otpError = false;
  bool _closedAfterVerified = false;
  String _activeRequestId = '';
  String _inlineMessage = '';
  bool _inlineMessageIsError = false;

  bool get _verifyViaEmail =>
      widget.verifyViaId == MRekanPicContactVerifyVia.email;

  String get _targetLabel => _verifyViaEmail ? 'email lama' : 'No. HP lama';

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
      if (!mounted) return;
      _sendOtp(clearState: true);
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _sendOtp({bool clearState = false}) {
    final bloc = context.read<MRekanPicContactChangeBloc>();
    if (clearState) {
      bloc.add(const MRekanPicContactChangeClearRequested());
    }
    bloc.add(
      MRekanPicContactChangeSendRequested(
        mrekanpicId: widget.mrekanpicId,
        changeTypeId: widget.changeTypeId,
        verifyViaId: widget.verifyViaId,
      ),
    );
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

  void _resendOtp() {
    _pinController.clear();
    setState(() {
      _otpError = false;
      _inlineMessage = '';
      _inlineMessageIsError = false;
      _activeRequestId = '';
    });
    _sendOtp();
  }

  void _validateOtp(MRekanPicContactChangeState state) {
    final pin = _pinController.text.trim();
    if (pin.length != 6) {
      _showPinError('Mohon isi semua kode OTP.');
      return;
    }
    if (state.changeRequestId.trim().isEmpty) {
      _showPinError('Kode OTP belum tersedia. Silakan kirim ulang.');
      return;
    }

    context.read<MRekanPicContactChangeBloc>().add(
          MRekanPicContactChangeValidateRequested(
            changeRequestId: state.changeRequestId,
            pin: pin,
          ),
        );
  }

  void _showPinError(String message) {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
    _pinController.clear();
    _pinFocusNode.requestFocus();
    setState(() {
      _otpError = true;
      _inlineMessage = message;
      _inlineMessageIsError = true;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
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
        border: Border.all(color: borderColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final basePinTheme = _pinTheme(context, sGrey);
    final focusedPinTheme = _pinTheme(context, primaryColor);
    final errorPinTheme = _pinTheme(context, pRed);

    return BlocConsumer<MRekanPicContactChangeBloc,
        MRekanPicContactChangeState>(
      listenWhen: (previous, current) =>
          previous.phase != current.phase ||
          previous.message != current.message ||
          previous.changeRequestId != current.changeRequestId ||
          previous.hasFailure != current.hasFailure,
      listener: (context, state) {
        if (state.phase == MRekanPicContactChangePhase.verified &&
            !_closedAfterVerified) {
          _closedAfterVerified = true;
          Navigator.of(context).pop(true);
          return;
        }

        if (state.phase == MRekanPicContactChangePhase.otpSent &&
            !state.hasFailure &&
            state.changeRequestId.isNotEmpty &&
            state.changeRequestId != _activeRequestId) {
          _activeRequestId = state.changeRequestId;
          _pinController.clear();
          _startTimer();
          setState(() {
            _otpError = false;
            _inlineMessage = 'Kode OTP berhasil dikirim.';
            _inlineMessageIsError = false;
          });
          _pinFocusNode.requestFocus();
          return;
        }

        if (state.hasFailure) {
          final message = state.message.trim().isNotEmpty
              ? state.message
              : 'Proses OTP gagal. Silakan coba kembali.';
          if (state.phase == MRekanPicContactChangePhase.expired ||
              state.phase == MRekanPicContactChangePhase.failure) {
            _timer?.cancel();
            setState(() => _isResendAvailable = true);
          }
          _showPinError(message);
        }
      },
      builder: (context, state) {
        final isSending = state.phase == MRekanPicContactChangePhase.sending;
        final isValidating =
            state.phase == MRekanPicContactChangePhase.validating;
        final isBusy = isSending || isValidating;
        final maskedTarget = state.maskedTarget.trim();

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: hPadding * 1.5,
            vertical: hPadding * 1.5,
          ),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius * 1.5),
                border: Border.all(color: sGrey),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.25,
                      vertical: vPadding * 1.5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32),
                        SvgPicture.asset('assets/icons/otp_icon.svg',
                            height: 82),
                        const SizedBox(height: 14),
                        Text(
                          'Verifikasi OTP',
                          style: headingStyle(context, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          isSending
                              ? 'Mengirim kode OTP ke $_targetLabel...'
                              : 'Masukkan kode OTP yang dikirim ke $_targetLabel',
                          style: bodyTextStyle(context, fontSize: 15).copyWith(
                            color: hintGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (maskedTarget.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            maskedTarget,
                            style:
                                bodyTextStyle(context, fontSize: 16).copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 22),
                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(
                              math.sin(_shakeAnimation.value) * 8,
                              0,
                            ),
                            child: child,
                          ),
                          child: Pinput(
                            length: 6,
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            enabled: !isBusy && state.isOtpSent,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          text: isSending ? 'Mengirim...' : 'Lanjut',
                          isLoading: isBusy,
                          backgroundColor:
                              isBusy ? secondaryBlackColor : primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: isBusy || !state.isOtpSent
                              ? null
                              : () => _validateOtp(state),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Belum menerima kode OTP?',
                          style: bodyTextStyle(context, fontSize: 15).copyWith(
                            color: hintGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_isResendAvailable)
                          TextButton(
                            onPressed: isBusy ? null : _resendOtp,
                            child: const Text('Kirim Ulang OTP'),
                          )
                        else
                          Text(
                            _formatTime(_remainingTime),
                            style:
                                bodyTextStyle(context, fontSize: 14).copyWith(
                              color: pRed,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      tooltip: 'Tutup',
                      onPressed: isBusy ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
