import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/reguser_otp/reguser_otp_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/international_phone_result.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/pages/login/mobile/client/new_login_client/new_login_client_page.dart';
import 'package:joss_app/pages/login/mobile/forgot/kata_sandi_baru_page.dart';
import 'package:joss_app/pages/login/welcome_header.dart';
import 'package:joss_app/pages/register/mobile/client/register_client_page.dart';
import 'package:joss_app/pages/register/mobile/client/widget/register_otp_popup_widget.dart';
import 'package:joss_app/pages/register/mobile/client/widget/register_phone_status_popup_widget.dart';
import 'package:joss_app/widgets/apptheme/phone_number_field.dart';

const _phoneGateEmptyError = 'No. Handphone belum valid';

class RegisterPhoneGatePage extends StatefulWidget {
  final String requestFrom;
  final String initialPhone;

  const RegisterPhoneGatePage({
    super.key,
    this.requestFrom = 'daftarclient_page',
    this.initialPhone = '',
  });

  @override
  State<RegisterPhoneGatePage> createState() => _RegisterPhoneGatePageState();
}

class _RegisterPhoneGatePageState extends State<RegisterPhoneGatePage> {
  final TextEditingController _phoneController = TextEditingController();
  final Map<String, String?> fieldErrors = {};

  int _countryCode = InternationalPhoneHelper.defaultCountryCode;
  String _pendingOpenOtpFor = '';
  String _lastHandledHpStatusKey = '';
  String _verifiedTarget = '';
  String _verifiedRequestId = '';
  String _verifiedRegistrationStatus = '';
  final Map<String, _VerifiedPhoneGateInfo> _verifiedPhoneCache = {};
  bool _isPhoneStatusPopupOpen = false;
  bool _isBottomActionLoading = false;

  @override
  void initState() {
    super.initState();
    final initialPhone = widget.initialPhone.trim();
    if (initialPhone.isNotEmpty) {
      _phoneController.text = InternationalPhoneHelper.toNationalInput(
        initialPhone,
        countryCode: _countryCode,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  InternationalPhoneResult _normalizePhone() {
    return InternationalPhoneHelper.normalize(
      _phoneController.text,
      countryCode: _countryCode,
      emptyMessage: _phoneGateEmptyError,
    );
  }

  String _phoneTarget() => _normalizePhone().phone ?? '';

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void _handleBack() {
    context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _sendHpOtp() {
    final phoneRes = _normalizePhone();

    if (!phoneRes.isValid) {
      setErr('form.telepon', phoneRes.error ?? 'Format tidak valid');
      return;
    }

    final target = phoneRes.phone ?? '';
    clearErr('form.telepon');
    _pendingOpenOtpFor = 'hp';
    _lastHandledHpStatusKey = '';
    context.read<RegUserOtpBloc>().add(
          RegUserOtpKirimEvent(
            target: target,
            requestFrom: 'hp',
          ),
        );
  }

  Future<void> _showRegisteredPopup(RegUserOtpState state) async {
    final target = state.hpStatusTarget;
    final requestId = state.hpStatusRequestId;
    if (target.isEmpty || requestId.isEmpty) return;

    bool shouldNavigate = false;
    _isPhoneStatusPopupOpen = true;
    await showRegisterPhoneStatusPopup(
      context,
      isRegistered: true,
      onPressed: () async {
        shouldNavigate = true;
        return true;
      },
    );

    _isPhoneStatusPopupOpen = false;
    if (!mounted || !shouldNavigate) return;

    _openResetPasswordForRegisteredPhone(state);
  }

  Future<void> _showNotRegisteredPopup(RegUserOtpState state) async {
    final target = state.hpStatusTarget;
    final requestId = state.hpStatusRequestId;
    if (target.isEmpty || requestId.isEmpty) return;

    bool shouldNavigate = false;
    _isPhoneStatusPopupOpen = true;
    await showRegisterPhoneStatusPopup(
      context,
      isRegistered: false,
      onPressed: () async {
        shouldNavigate = true;
        return true;
      },
    );

    _isPhoneStatusPopupOpen = false;
    if (!mounted || !shouldNavigate) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RegisterClient(
          requestFrom: widget.requestFrom,
          initialPhone: target,
          initialHpReqtokenId: requestId,
          initialHpVerified: true,
        ),
      ),
    );
  }

  void _openResetPasswordForRegisteredPhone(RegUserOtpState state) {
    final target = state.hpStatusTarget;
    final requestId = state.hpStatusRequestId;
    if (target.isEmpty || requestId.isEmpty) return;

    context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    _phoneController.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => KataSandiBaruPage(
          email: target,
          requestId: requestId,
          requestFrom: 'hp',
          useResetPasswordDomain: true,
        ),
      ),
    );
  }

  void _openLoginForRegisteredPhone(RegUserOtpState state) {
    final target = state.hpStatusTarget;
    if (target.isEmpty) return;

    context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    _phoneController.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => NewLoginClient(
          requestFrom: widget.requestFrom,
          initialUsername: target,
        ),
      ),
    );
  }

  void _handleHpStatus(BuildContext context, RegUserOtpState state) {
    if (!state.isHpVerified || state.isHpStatusChecking) return;
    if (state.hpRegistrationStatus.isEmpty) return;
    if (_isPhoneStatusPopupOpen) return;

    final target = _phoneTarget();
    if (target.isEmpty || target != state.hpStatusTarget) return;

    final key = '${state.hpStatusRequestId};${state.hpRegistrationStatus}';
    if (key == _lastHandledHpStatusKey) {
      return;
    }
    _lastHandledHpStatusKey = key;

    setState(() {
      _verifiedTarget = state.hpStatusTarget;
      _verifiedRequestId = state.hpStatusRequestId;
      _verifiedRegistrationStatus = state.hpRegistrationStatus;
      _pendingOpenOtpFor = '';
      _verifiedPhoneCache[state.hpStatusTarget] = _VerifiedPhoneGateInfo(
        requestId: state.hpStatusRequestId,
        registrationStatus: state.hpRegistrationStatus,
      );
    });

    if (state.hpRegistrationStatus ==
        RegUserHpRegistrationStatus.registeredLogin) {
      _openLoginForRegisteredPhone(state);
      return;
    }

    if (state.hpRegistrationStatus == RegUserHpRegistrationStatus.registered) {
      _showRegisteredPopup(state);
      return;
    }

    if (state.hpRegistrationStatus ==
        RegUserHpRegistrationStatus.registeredPic) {
      _showRegisteredPopup(state);
      return;
    }
    if (state.hpRegistrationStatus ==
        RegUserHpRegistrationStatus.notRegistered) {
      _showNotRegisteredPopup(state);
    }
  }

  bool _isVerifiedTarget(String target) {
    return target.isNotEmpty &&
        target == _verifiedTarget &&
        _verifiedRequestId.isNotEmpty &&
        _verifiedRegistrationStatus.isNotEmpty;
  }

  bool _restoreVerifiedPhone(String target) {
    final info = _verifiedPhoneCache[target];
    if (target.isEmpty || info == null) return false;

    _verifiedTarget = target;
    _verifiedRequestId = info.requestId;
    _verifiedRegistrationStatus = info.registrationStatus;
    _lastHandledHpStatusKey = '${info.requestId};${info.registrationStatus}';
    return true;
  }

  bool _isCurrentInputVerified() {
    return _isVerifiedTarget(_phoneTarget());
  }

  bool get _isVerifiedRegistered {
    return RegUserHpRegistrationStatus.isRegisteredStatus(
      _verifiedRegistrationStatus,
    );
  }

  bool get _isVerifiedRegisteredLogin {
    return _verifiedRegistrationStatus ==
        RegUserHpRegistrationStatus.registeredLogin;
  }

  Future<void> _handleVerifiedAction() async {
    final target = _verifiedTarget;
    final requestId = _verifiedRequestId;
    if (target.isEmpty || requestId.isEmpty) return;

    if (_isVerifiedRegisteredLogin) {
      context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
      _phoneController.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NewLoginClient(
            requestFrom: widget.requestFrom,
            initialUsername: target,
          ),
        ),
      );
      return;
    }

    if (_isVerifiedRegistered) {
      if (_isBottomActionLoading) return;
      setState(() => _isBottomActionLoading = true);
      if (!mounted) return;
      setState(() => _isBottomActionLoading = false);

      context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
      _phoneController.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => KataSandiBaruPage(
            email: target,
            requestId: requestId,
            requestFrom: 'hp',
            useResetPasswordDomain: true,
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RegisterClient(
          requestFrom: widget.requestFrom,
          initialPhone: target,
          initialHpReqtokenId: requestId,
          initialHpVerified: true,
        ),
      ),
    );
  }

  void _handleOtpStateChanged(BuildContext context, RegUserOtpState state) {
    _handleHpStatus(context, state);

    if (_pendingOpenOtpFor.isEmpty) return;
    if (state.activeRequestFrom != _pendingOpenOtpFor) return;

    if (state.isHpSending) return;

    if (state.hasFailure) {
      final message = state.hpError.isNotEmpty
          ? state.hpError
          : state.message.isNotEmpty
              ? state.message
              : 'Gagal mengirim OTP.';
      setErr('form.telepon', message);
      _pendingOpenOtpFor = '';
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(message));
      return;
    }

    if (state.hpRequestId.isEmpty) return;

    final target = state.activeTarget;
    _pendingOpenOtpFor = '';

    showRegisterOtpPopup(
      context,
      target: target,
      requestFrom: 'hp',
    );
  }

  Widget _buildPhoneField(RegUserOtpState otpState) {
    final isVerified = _isCurrentInputVerified();

    return AppPhoneNumberField(
      label: 'No. Hp',
      hint: 'Masukkan No. Hp',
      controller: _phoneController,
      countryCode: _countryCode,
      onCountryCodeChanged: (value) {
        setState(() {
          _countryCode = value;
          _lastHandledHpStatusKey = '';
        });
        clearErr('form.telepon');
        context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
      },
      errorText: isVerified ? null : err('form.telepon'),
      helperText: isVerified ? 'No telepon ini telah diverifikasi' : null,
      helperStyle: bodyTextStyle(context, fontSize: 12).copyWith(
        color: successGreen,
      ),
      borderColor: isVerified ? successGreen : null,
      focusedBorderColor: isVerified ? successGreen : null,
      suffixIcon: isVerified
          ? const Icon(
              Icons.check,
              color: successGreen,
              size: 22,
            )
          : null,
      validator: (_) => err('form.telepon'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) clearErr('form.telepon');
        final target = _phoneTarget();
        if (target != _verifiedTarget) {
          final restored = _restoreVerifiedPhone(target);
          if (!restored) {
            _verifiedTarget = '';
            _verifiedRequestId = '';
            _verifiedRegistrationStatus = '';
            _lastHandledHpStatusKey = '';
            context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
          }
        }
        setState(() {});
      },
    );
  }

  Widget _buildPhoneOtpRow(RegUserOtpState otpState) {
    final isVerified = _isCurrentInputVerified();

    Widget buildButton() {
      return AppButton.primary(
        text: 'Verifikasi',
        isLoading: otpState.isHpSending,
        backgroundColor:
            otpState.isHpSending ? secondaryBlackColor : primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        onPressed: otpState.isHpSending ? null : _sendHpOtp,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhoneField(otpState),
        if (!isVerified) ...[
          const SizedBox(height: 8),
          buildButton(),
        ],
      ],
    );
  }

  Widget _buildVerifiedActionButton() {
    if (!_isCurrentInputVerified()) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: vPadding),
      child: AppButton.primary(
        text: _isVerifiedRegisteredLogin
            ? 'Masuk'
            : _isVerifiedRegistered
                ? 'Atur Kata Sandi'
                : 'Lengkapi Data',
        isLoading: _isBottomActionLoading,
        backgroundColor:
            _isBottomActionLoading ? secondaryBlackColor : primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        onPressed: _isBottomActionLoading ? null : _handleVerifiedAction,
      ),
    );
  }

  Widget _buildLoginFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sudah Punya Akun? ",
          style: bodyTextStyle(context).copyWith(color: hintGrey),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => NewLoginClient(
                  requestFrom: widget.requestFrom,
                ),
              ),
            );
          },
          child: Text(
            "Masuk Sebagai Klien",
            style: bodyTextStyle(context).copyWith(color: primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: IosLeftEdgeSwipe(
          onSwipeBack: () async => _handleBack(),
          child: PopScope(
            canPop: Platform.isAndroid ? false : true,
            onPopInvokedWithResult: (didPop, result) async {
              if (Platform.isIOS) return;
              if (didPop) return;
              _handleBack();
            },
            child: BaseBackgroundFirstPage(
              child: BlocListener<RegUserOtpBloc, RegUserOtpState>(
                listener: _handleOtpStateChanged,
                child: BlocBuilder<RegUserOtpBloc, RegUserOtpState>(
                  builder: (context, otpState) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: headerSpacing),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: vPadding,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: TextButton.icon(
                                            onPressed: _handleBack,
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(0, 0),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            icon: Icon(
                                              Icons.arrow_back_ios_new,
                                              color: primaryColor,
                                              size: getResponsiveFont(
                                                  context, 18),
                                            ),
                                            label: Text(
                                              'Kembali',
                                              style: bodyTextStyle(context)
                                                  .copyWith(
                                                      color: primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: vPadding * 0.8),
                                      const WelcomeHeader(
                                        type: 'register_client',
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
                                      decoration: BoxDecoration(
                                        color: secondaryBlackColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Card(
                                        color: secondaryBlackColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              _buildPhoneOtpRow(otpState),
                                              _buildVerifiedActionButton(),
                                              SizedBox(height: vPadding * 1.2),
                                              _buildLoginFooter(context),
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
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VerifiedPhoneGateInfo {
  final String requestId;
  final String registrationStatus;

  const _VerifiedPhoneGateInfo({
    required this.requestId,
    required this.registrationStatus,
  });
}
