import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/helper/ios_left_edge_swipe.dart';
import 'package:joss_app/pages/login/mobile/client/new_login_client/new_login_client_page.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../blocs/reguser_otp/reguser_otp_bloc.dart';
import '../../../../helper/indo_phone_result.dart';
import '../../../../helper/phone_number_result.dart';
import '../../../../models/combobox/combomjnsclient_model.dart';
import '../../../../models/combobox/combomreferral_model.dart';
import '../../../../models/reguser/reguser_model.dart';
import '../../../../repositories/combobox/combomjnsclient_repository.dart';
import '../../../../repositories/combobox/combomreferral_repository.dart';
import '../../../../widgets/apptheme/dropdown2.dart';
import '../../../login/welcome_header.dart';
import '../../../../common/constants.dart';
import 'widget/register_otp_popup_widget.dart';

class RegisterFormClientRemake extends StatefulWidget {
  final String requestFrom;
  const RegisterFormClientRemake({super.key, required this.requestFrom});

  @override
  State<RegisterFormClientRemake> createState() =>
      _RegisterFormClientRemakeState();
}

class _RegisterFormClientRemakeState extends State<RegisterFormClientRemake> {
  final fieldNameController = TextEditingController();
  final fieldPasswordController = TextEditingController();
  final fieldTeleponController = TextEditingController();
  final fieldKonfirmasiPasswordController = TextEditingController();
  final fieldEmailController = TextEditingController();
  final fieldCompanyNamaController = TextEditingController();
  ComboMJnsclientModel? fieldComboJnsClient;
  ComboMReferralModel? fieldComboMReferral;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool isSubmitting = false;
  int _submitAttempt = 0;
  String _pendingOpenOtpFor = '';
  bool _isDialogLoadingShown = false;
  final Map<String, String> _verifiedEmailRequestIds = {};
  final Map<String, String> _verifiedHpRequestIds = {};

  late final RegUserModel? record;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    });
  }

  @override
  void dispose() {
    fieldNameController.dispose();
    fieldPasswordController.dispose();
    fieldTeleponController.dispose();
    fieldEmailController.dispose();
    fieldKonfirmasiPasswordController.dispose();
    fieldCompanyNamaController.dispose();
    super.dispose();
  }

  void _showGlobalLoading() {
    if (!mounted || _isDialogLoadingShown) return;

    _isDialogLoadingShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }

  void _hideGlobalLoading() {
    if (!mounted || !_isDialogLoadingShown) return;

    _isDialogLoadingShown = false;

    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  String? _validatePasswordRules(String pass) {
    final p = pass.trim();

    if (p.isEmpty) return kStringNullError;
    if (p.length < 8) return 'Kata Sandi minimal 8 karakter';
    if (!RegExp(r'[A-Z]').hasMatch(p)) return 'Tambahkan minimal 1 huruf besar';
    if (!RegExp(r'\d').hasMatch(p)) return 'Tambahkan minimal 1 angka';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+]').hasMatch(p)) {
      return 'Tambahkan minimal 1 simbol';
    }
    return null;
  }

  bool validateForm1() {
    clearErrsByPrefix('form1.');
    bool ok = true;

    final namaLengkap = fieldNameController.text.trim();
    if (namaLengkap.isEmpty) {
      setErr('form1.nama', kStringNullError);
      ok = false;
    }

    if (fieldComboJnsClient == null) {
      setErr('form1.jenisClient', kStringNullError);
      ok = false;
    }

    final isCompanyClient = fieldComboJnsClient?.mjnsclientId == '20';
    final companyNama = fieldCompanyNamaController.text.trim();
    if (isCompanyClient && companyNama.isEmpty) {
      setErr('form1.companyNama', kStringNullError);
      ok = false;
    }

    final email = fieldEmailController.text.trim();
    if (email.isEmpty) {
      setErr('form1.email', kStringNullError);
      ok = false;
    } else {
      if (!EmailValidator.validate(email)) {
        setErr('form1.email', "Format tidak valid");
        ok = false;
      }
    }

    final telp = fieldTeleponController.text.trim();
    if (telp.isEmpty) {
      setErr('form1.telepon', kStringNullError);
      ok = false;
    } else {
      if (isCompanyClient) {
        final phoneRes = PhoneNumberHelper.normalize(telp);
        if (!phoneRes.isValid) {
          setErr('form1.telepon', phoneRes.error ?? "Format tidak valid");
          ok = false;
        }
      } else {
        final phoneRes = IndoPhoneHelper.normalize(telp);
        if (!phoneRes.isValid) {
          setErr('form1.telepon', phoneRes.error ?? "Format tidak valid");
          ok = false;
        }
      }
    }

    final pass = fieldPasswordController.text;
    final passErr = _validatePasswordRules(pass);
    if (passErr != null) {
      setErr('form1.password', passErr);
      ok = false;
    }

    final konf = fieldKonfirmasiPasswordController.text;
    if (konf.trim().isEmpty) {
      setErr('form1.konfirmasiPassword', kStringNullError);
      ok = false;
    } else {
      if (pass.trim().isNotEmpty && pass != konf) {
        setErr('form1.konfirmasiPassword', "Konfirmasi Kata sandi tidak sama");
        ok = false;
      }
    }

    return ok;
  }

  Widget _buildNameField() => appTextField(
        label: "Nama Lengkap",
        controller: fieldNameController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z ,.]")),
        ],
        errorText: err('form1.nama'),
        validator: (_) => err('form1.nama'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('form1.nama');
        },
      );

  Widget _buildPasswordField() => appTextField(
        label: "Kata Sandi",
        hint: "Masukkan Kata Sandi",
        controller: fieldPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscurePassword,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        errorText: err('form1.password'),
        validator: (_) => err('form1.password'),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: sGrey,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        onChanged: (v) {
          clearErr('form1.password');
        },
      );

  Widget _buildKonfirmasiPasswordField() => appTextField(
        label: "Konfirmasi Kata Sandi",
        hint: "Masukkan konfirmasi Kata Sandi",
        controller: fieldKonfirmasiPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureConfirm,
        errorText: err('form1.konfirmasiPassword'),
        validator: (_) => err('form1.konfirmasiPassword'),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirm ? Icons.visibility_off : Icons.visibility,
            color: sGrey,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirm = !_obscureConfirm;
            });
          },
        ),
        onChanged: (v) {
          if (v.trim().isNotEmpty) {
            clearErr('form1.konfirmasiPassword');
          }
        },
      );

  String _emailOtpTarget(String value) {
    final email = value.trim();
    return EmailValidator.validate(email) ? email.toLowerCase() : '';
  }

  String _hpOtpTarget(String value) {
    final isCompanyClient = fieldComboJnsClient?.mjnsclientId == '20';

    if (isCompanyClient) {
      final phoneRes = PhoneNumberHelper.normalize(value);
      return phoneRes.phone ?? '';
    }

    final phoneRes = IndoPhoneHelper.normalize(value);
    return phoneRes.phone62 ?? '';
  }

  bool _isEmailVerifiedForCurrent(RegUserOtpState otpState) {
    final target = _emailOtpTarget(fieldEmailController.text);
    if (target.isEmpty) return false;
    if (_verifiedEmailRequestIds.containsKey(target)) return true;

    return otpState.isEmailVerified &&
        otpState.activeRequestFrom == 'email' &&
        otpState.activeTarget == target;
  }

  bool _isHpVerifiedForCurrent(RegUserOtpState otpState) {
    final target = _hpOtpTarget(fieldTeleponController.text);
    if (target.isEmpty) return false;
    if (_verifiedHpRequestIds.containsKey(target)) return true;

    return otpState.isHpVerified &&
        otpState.activeRequestFrom == 'hp' &&
        otpState.activeTarget == target;
  }

  String _emailRequestIdForCurrent(RegUserOtpState otpState) {
    final target = _emailOtpTarget(fieldEmailController.text);
    if (target.isEmpty) return '';
    return _verifiedEmailRequestIds[target] ??
        (otpState.isEmailVerified &&
                otpState.activeRequestFrom == 'email' &&
                otpState.activeTarget == target
            ? otpState.emailRequestId
            : '');
  }

  String _hpRequestIdForCurrent(RegUserOtpState otpState) {
    final target = _hpOtpTarget(fieldTeleponController.text);
    if (target.isEmpty) return '';
    return _verifiedHpRequestIds[target] ??
        (otpState.isHpVerified &&
                otpState.activeRequestFrom == 'hp' &&
                otpState.activeTarget == target
            ? otpState.hpRequestId
            : '');
  }

  Widget _buildTeleponField(RegUserOtpState otpState) {
    final isVerified = _isHpVerifiedForCurrent(otpState);
    final isCompanyClient = fieldComboJnsClient?.mjnsclientId == '20';

    return appTextField(
      label: isCompanyClient ? "No. Telp Perusahaan" : "No. HP",
      hint:
          isCompanyClient ? "Masukkan No. Telp Perusahaan" : "Masukkan No. HP",
      controller: fieldTeleponController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          final cleaned = PhoneNumberHelper.clean(newValue.text);
          if (cleaned == newValue.text) return newValue;

          final cursor = newValue.selection.baseOffset < 0
              ? newValue.text.length
              : newValue.selection.baseOffset.clamp(0, newValue.text.length);
          final cleanedBeforeCursor = PhoneNumberHelper.clean(
            newValue.text.substring(0, cursor),
          );

          return TextEditingValue(
            text: cleaned,
            selection: TextSelection.collapsed(
              offset: cleanedBeforeCursor.length,
            ),
          );
        }),
      ],
      prefix: isCompanyClient
          ? null
          : Text(
              "+62 | ",
              style: inputTextStyle(context, color: primaryLightColor),
            ),
      errorText: isVerified ? null : err('form1.telepon'),
      helperText: isVerified ? 'No telepon ini telah diverifikasi' : null,
      helperStyle: bodyTextStyle(context, fontSize: 12).copyWith(
        color: successGreen,
      ),
      borderColor: isVerified ? successGreen : null,
      focusedBorderColor: isVerified ? successGreen : null,
      validator: (_) => err('form1.telepon'),
      onChanged: (v) {
        if (v.trim().isNotEmpty) {
          clearErr('form1.telepon');
        }
        final target = _hpOtpTarget(v);
        final isVerifiedAfterChange =
            target.isNotEmpty && _verifiedHpRequestIds.containsKey(target);
        if (!isVerifiedAfterChange) {
          context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
        }
        setState(() {});
      },
    );
  }

  Widget _buildEmailField(RegUserOtpState otpState) {
    final isVerified = _isEmailVerifiedForCurrent(otpState);

    return appTextField(
      label: "Email",
      hint: "Masukkan alamat email",
      controller: fieldEmailController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"\s")),
      ],
      errorText: isVerified ? null : err('form1.email'),
      helperText: isVerified ? 'Email ini telah diverifikasi' : null,
      helperStyle: bodyTextStyle(context, fontSize: 12).copyWith(
        color: successGreen,
      ),
      borderColor: isVerified ? successGreen : null,
      focusedBorderColor: isVerified ? successGreen : null,
      validator: (_) => err('form1.email'),
      onChanged: (v) {
        final email = v.trim();

        if (email.isEmpty) {
          setErr('form1.email', kStringNullError);
        } else if (!EmailValidator.validate(email)) {
          setErr('form1.email', 'Format tidak valid');
        } else {
          clearErr('form1.email');
        }
        final target = _emailOtpTarget(v);
        final isVerifiedAfterChange =
            target.isNotEmpty && _verifiedEmailRequestIds.containsKey(target);
        if (!isVerifiedAfterChange) {
          context.read<RegUserOtpBloc>().add(const RegUserOtpResetEmailEvent());
        }
        setState(() {});
      },
    );
  }

  Widget _buildEmailOtpRow(RegUserOtpState otpState) {
    if (_isEmailVerifiedForCurrent(otpState)) {
      return _buildEmailField(otpState);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: _buildEmailField(otpState),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: AppButton.primary(
            text: 'Kirim OTP',
            isLoading: otpState.isEmailSending,
            backgroundColor:
                otpState.isEmailSending ? secondaryBlackColor : primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            onPressed: otpState.isEmailSending ? null : _sendEmailOtp,
          ),
        ),
      ],
    );
  }

  Widget _buildTeleponOtpRow(RegUserOtpState otpState) {
    if (_isHpVerifiedForCurrent(otpState)) {
      return _buildTeleponField(otpState);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: _buildTeleponField(otpState),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: AppButton.primary(
            text: 'Kirim OTP',
            isLoading: otpState.isHpSending,
            backgroundColor:
                otpState.isHpSending ? secondaryBlackColor : primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            onPressed: otpState.isHpSending ? null : _sendHpOtp,
          ),
        ),
      ],
    );
  }

  Widget buildFieldComboMJnsclient() =>
      ReusableComboBoxV2<ComboMJnsclientModel>(
        hintText: "Jenis Klien",
        initItem: fieldComboJnsClient,
        loader: (q) => ComboMJnsclientRepository().getComboMJnsclient(),
        clientSideSearch: true,
        displayText: (i) => i.jenisNama,
        compareItems: (a, b) => a.mjnsclientId == b.mjnsclientId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.jenisClient'),
        onChangedCallback: (v) {
          final wasCompanyClient = fieldComboJnsClient?.mjnsclientId == '20';
          final isCompanyClient = v?.mjnsclientId == '20';

          setState(() {
            fieldComboJnsClient = v;
            if (v?.mjnsclientId != '20') {
              fieldCompanyNamaController.clear();
              fieldErrors.remove('form1.companyNama');
            }
            if (v != null) {
              clearErr('form1.jenisClient');
            }
          });

          if (wasCompanyClient != isCompanyClient) {
            context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
          }
        },
        onSaveCallback: (value) => fieldComboJnsClient = value,
      );

  Widget _buildCompanyNamaField() => appTextField(
        label: "Nama Perusahaan",
        hint: "Masukkan nama perusahaan",
        controller: fieldCompanyNamaController,
        keyboardType: TextInputType.text,
        errorText: err('form1.companyNama'),
        validator: (_) => err('form1.companyNama'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) {
            clearErr('form1.companyNama');
          }
        },
      );

  Widget _buildReferralField() => ReusableComboBoxV2<ComboMReferralModel>(
        hintText: "Kode Referral (Opsional)",
        initItem: fieldComboMReferral,
        loader: (q) => ComboMReferralRepository().getComboMReferral(
          q.searchText,
        ),
        // displayText: (item) => "${item.kodeUnik} - ${item.namaMarketing}",
        //displayText: (item) => item.namaMarketing,
        displayText: (item) => item.kodeUnik,
        compareItems: (a, b) => a.mreferralId == b.mreferralId,
        showClearButton: true,
        errorText: err('form1.referral'),
        onChangedCallback: (value) {
          setState(() {
            fieldComboMReferral = value;
            if (value != null) {
              clearErr('form1.referral');
            }
          });
        },
        onSaveCallback: (value) => fieldComboMReferral = value,
      );

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

  void handleBack() {
    if (widget.requestFrom == 'daftarclient_page') {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return IosLeftEdgeSwipe(
      onSwipeBack: () async {
        handleBack();
      },
      child: PopScope(
        canPop: Platform.isAndroid ? false : true,
        onPopInvokedWithResult: (didPop, result) async {
          if (Platform.isIOS) return;
          if (didPop) return;

          handleBack();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<RegUserOtpBloc, RegUserOtpState>(
              listener: _handleOtpStateChanged,
            ),
          ],
          child: BlocConsumer<RegUserBloc, RegUserState>(
            listenWhen: (previous, current) {
              return previous.isSaved != current.isSaved ||
                  previous.hasFailure != current.hasFailure ||
                  previous.isOtpClient != current.isOtpClient ||
                  previous.isRegisterSuccess != current.isRegisterSuccess;
            },
            listener: (context, state) {
              if (state.hasFailure && state.errors.isNotEmpty) {
                _hideGlobalLoading();

                if (mounted) {
                  setState(() {
                    isSubmitting = false;
                  });
                }

                final msg = state.errors.first;
                ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(msg));
                return;
              }

              if (!state.hasFailure &&
                  state.isSaved &&
                  state.isRegisterSuccess) {
                _showGlobalLoading();
                context
                    .read<RegUserOtpBloc>()
                    .add(const RegUserOtpClearEvent());
              }
            },
            builder: (context, state) {
              return BlocBuilder<RegUserOtpBloc, RegUserOtpState>(
                builder: (context, otpState) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: vPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
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
                                      padding: const EdgeInsets.only(left: 4),
                                      child: TextButton.icon(
                                        onPressed: handleBack,
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        icon: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: primaryColor,
                                          size: getResponsiveFont(context, 18),
                                        ),
                                        label: Text(
                                          "Kembali",
                                          style: bodyTextStyle(context)
                                              .copyWith(color: primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: vPadding * 0.8),
                                  WelcomeHeader(type: "register_client"),
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          buildFieldComboMJnsclient(),
                                          SizedBox(height: vPadding),
                                          if (fieldComboJnsClient
                                                  ?.mjnsclientId ==
                                              '20') ...[
                                            _buildCompanyNamaField(),
                                            SizedBox(height: vPadding),
                                          ],
                                          _buildNameField(),
                                          SizedBox(height: vPadding),
                                          _buildEmailOtpRow(otpState),
                                          SizedBox(height: vPadding),
                                          _buildTeleponOtpRow(otpState),
                                          SizedBox(height: vPadding),
                                          _buildPasswordField(),
                                          SizedBox(height: vPadding),
                                          _PasswordRequirementRow(
                                              controller:
                                                  fieldPasswordController),
                                          SizedBox(height: vPadding),
                                          _buildKonfirmasiPasswordField(),
                                          SizedBox(height: vPadding),
                                          _buildReferralField(),
                                          SizedBox(height: vPadding),
                                          AppButton.primary(
                                            text: "Simpan",
                                            isLoading: isSubmitting,
                                            backgroundColor: isSubmitting
                                                ? secondaryBlackColor
                                                : primaryColor,
                                            onPressed: isSubmitting
                                                ? null
                                                : () async {
                                                    if (!validateForm1()) {
                                                      return;
                                                    }
                                                    if (!_validateOtpBeforeSubmit(
                                                      context
                                                          .read<
                                                              RegUserOtpBloc>()
                                                          .state,
                                                    )) {
                                                      return;
                                                    }

                                                    setState(() {
                                                      isSubmitting = true;
                                                    });
                                                    _startSubmitTimeout();

                                                    onSubmit();
                                                  },
                                          ),
                                          SizedBox(height: vPadding),
                                          _buildLoginFooter(context),
                                          const Spacer(),
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    final ok = validateForm1();
    if (!ok) return;

    final String email = fieldEmailController.text.trim();
    final isCompanyClient = fieldComboJnsClient?.mjnsclientId == '20';
    final String telepon = isCompanyClient
        ? (PhoneNumberHelper.normalize(fieldTeleponController.text).phone ?? '')
        : (IndoPhoneHelper.normalize(fieldTeleponController.text).phone62 ??
            '');

    final record = RegUserModel(
      personalNama: fieldNameController.text.trim(),
      telepon: telepon,
      password: fieldPasswordController.text,
      jnsClientId: fieldComboJnsClient!.mjnsclientId,
      email: email,
      userNama: fieldNameController.text.trim(),
      sendOtpVia: '',
      referral: fieldComboMReferral?.kodeUnik,
      companyNama: fieldComboJnsClient?.mjnsclientId == '20'
          ? fieldCompanyNamaController.text.trim()
          : null,
      emailReqtokenId: _emailRequestIdForCurrent(
        context.read<RegUserOtpBloc>().state,
      ),
      hpReqtokenId: _hpRequestIdForCurrent(
        context.read<RegUserOtpBloc>().state,
      ),
    );

    context.read<RegUserBloc>().add(ClearRequestFromEvent());

    context.read<RegUserBloc>().add(
          RegUserTambahEvent(
            record: record,
            requestFrom: widget.requestFrom,
          ),
        );
  }

  void _sendEmailOtp() {
    final email = fieldEmailController.text.trim();

    if (email.isEmpty) {
      setErr('form1.email', kStringNullError);
      return;
    }

    if (!EmailValidator.validate(email)) {
      setErr('form1.email', 'Format tidak valid');
      return;
    }

    clearErr('form1.email');
    _pendingOpenOtpFor = 'email';
    context.read<RegUserOtpBloc>().add(
          RegUserOtpKirimEvent(
            target: email,
            requestFrom: 'email',
          ),
        );
  }

  void _sendHpOtp() {
    final isCompanyClient = fieldComboJnsClient?.mjnsclientId == '20';
    final String target;

    if (isCompanyClient) {
      final phoneRes = PhoneNumberHelper.normalize(fieldTeleponController.text);

      if (!phoneRes.isValid) {
        setErr('form1.telepon', phoneRes.error ?? 'Format tidak valid');
        return;
      }

      target = phoneRes.phone ?? '';
    } else {
      final phoneRes = IndoPhoneHelper.normalize(fieldTeleponController.text);

      if (!phoneRes.isValid) {
        setErr('form1.telepon', phoneRes.error ?? 'Format tidak valid');
        return;
      }

      target = phoneRes.phone62 ?? '';
    }

    clearErr('form1.telepon');
    _pendingOpenOtpFor = 'hp';
    context.read<RegUserOtpBloc>().add(
          RegUserOtpKirimEvent(
            target: target,
            requestFrom: 'hp',
          ),
        );
  }

  void _handleOtpStateChanged(BuildContext context, RegUserOtpState state) {
    if (state.isEmailVerified &&
        state.activeRequestFrom == 'email' &&
        state.activeTarget.isNotEmpty &&
        state.emailRequestId.isNotEmpty) {
      _verifiedEmailRequestIds[state.activeTarget.toLowerCase()] =
          state.emailRequestId;
    }

    if (state.isHpVerified &&
        state.activeRequestFrom == 'hp' &&
        state.activeTarget.isNotEmpty &&
        state.hpRequestId.isNotEmpty) {
      _verifiedHpRequestIds[state.activeTarget] = state.hpRequestId;
    }

    if (_pendingOpenOtpFor.isEmpty) return;
    if (state.activeRequestFrom != _pendingOpenOtpFor) return;

    final isEmail = _pendingOpenOtpFor == 'email';
    final isSending = isEmail ? state.isEmailSending : state.isHpSending;
    if (isSending) return;

    if (state.hasFailure) {
      final message = isEmail ? state.emailError : state.hpError;
      setErr(
        isEmail ? 'form1.email' : 'form1.telepon',
        message.isNotEmpty ? message : 'Gagal mengirim OTP.',
      );
      _pendingOpenOtpFor = '';
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(message.isNotEmpty ? message : 'Gagal mengirim OTP.'),
      );
      return;
    }

    final requestId = isEmail ? state.emailRequestId : state.hpRequestId;
    if (requestId.isEmpty) return;

    final target = state.activeTarget;
    final requestFrom = _pendingOpenOtpFor;
    _pendingOpenOtpFor = '';

    showRegisterOtpPopup(
      context,
      target: target,
      requestFrom: requestFrom,
    );
  }

  bool _validateOtpBeforeSubmit(RegUserOtpState otpState) {
    var ok = true;

    if (!_isEmailVerifiedForCurrent(otpState)) {
      setErr('form1.email', 'Email belum diverifikasi');
      ok = false;
    }

    if (!_isHpVerifiedForCurrent(otpState)) {
      setErr('form1.telepon', 'No. HP belum diverifikasi');
      ok = false;
    }

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar('Verifikasi email dan nomor HP terlebih dahulu.'),
      );
    }

    return ok;
  }

  void _startSubmitTimeout() {
    final attempt = ++_submitAttempt;
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted || attempt != _submitAttempt || !isSubmitting) return;

      _hideGlobalLoading();

      setState(() {
        isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          "Terjadi kesalahan dalam pengiriman data, silahkan klik kembali.",
        ),
      );
    });
  }

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }
}

class _PasswordRequirementRow extends StatelessWidget {
  final TextEditingController controller;
  const _PasswordRequirementRow({required this.controller});

  bool _min8(String p) => p.length >= 8;
  bool _upper(String p) => p.contains(RegExp(r'[A-Z]'));
  bool _digit(String p) => p.contains(RegExp(r'\d'));
  bool _symbol(String p) =>
      p.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+]'));

  @override
  Widget build(BuildContext context) {
    TextStyle style(bool active) => TextStyle(
          fontSize: 13.7,
          color: active ? primaryColor : hintGrey,
          fontWeight: FontWeight.w500,
        );
    Widget item(bool checked, String text) => IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                checked
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 15,
                color: checked ? primaryColor : hintGrey,
              ),
              const SizedBox(width: 4),
              Text(text, style: style(checked)),
            ],
          ),
        );
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final p = value.text;
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              item(_min8(p), "Minimal 8 Karakter"),
              item(_upper(p), "Ada Huruf Besar"),
              item(_digit(p), "Ada Angka"),
              item(_symbol(p), "Ada Simbol"),
            ],
          ),
        );
      },
    );
  }
}
