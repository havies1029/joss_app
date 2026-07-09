import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import '../../../../blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/models/user/user_model.dart';
import '../../../../blocs/login/emailverification_bloc.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../helper/indo_phone_result.dart';
import '../../../../models/combobox/combomjnsclient_model.dart';
import '../../../../models/combobox/combomreferral_model.dart';
import '../../../../models/reguser/reguser_model.dart';
import '../../../../repositories/combobox/combomjnsclient_repository.dart';
import '../../../../repositories/combobox/combomreferral_repository.dart';
import '../../../../widgets/apptheme/dropdown2.dart';
import '../../../login/mobile/client/widget/otp_client_widget.dart';
import '../../../login/welcome_header.dart';
import '../../../../common/constants.dart';

class RegisterFormClientRemake extends StatefulWidget {
  final String requestFrom;
  const RegisterFormClientRemake({super.key, required this.requestFrom});

  @override
  State<RegisterFormClientRemake> createState() =>
      _RegisterFormClientRemakeState();
}

class _RegisterFormClientRemakeState extends State<RegisterFormClientRemake> {
  var lastLoginBy = "";
  final fieldNameController = TextEditingController();
  final fieldPasswordController = TextEditingController();
  final fieldTeleponController = TextEditingController();
  final fieldKonfirmasiPasswordController = TextEditingController();
  final fieldEmailController = TextEditingController();
  ComboMJnsclientModel? fieldComboJnsClient;
  ComboMReferralModel? fieldComboMReferral;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool isSubmitting = false;
  int _submitAttempt = 0;

  late EmailVerificationBloc emailVerificationBloc;
  late AuthenticationBloc authenticationBloc;

  late final RegUserModel? record;

  @override
  void initState() {
    super.initState();
    authenticationBloc = context.read<AuthenticationBloc>();
  }

  @override
  void dispose() {
    fieldNameController.dispose();
    fieldPasswordController.dispose();
    fieldTeleponController.dispose();
    fieldEmailController.dispose();
    fieldKonfirmasiPasswordController.dispose();
    super.dispose();
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

    if (lastLoginBy == 'hp') {
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
    }
    if (lastLoginBy == 'email') {
      final telp = fieldTeleponController.text.trim();
      if (telp.isEmpty) {
        setErr('form1.telepon', kStringNullError);
        ok = false;
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

  Widget _buildTeleponField() => appTextField(
        label: "No. HP",
        hint: "Masukkan nomor telepon",
        controller: fieldTeleponController,
        keyboardType: TextInputType.phone,
        prefix: Text(
          "+62 | ",
          style: inputTextStyle(context, color: primaryLightColor),
        ),
        errorText: err('form1.telepon'),
        validator: (_) => err('form1.telepon'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) {
            clearErr('form1.telepon');
          }
        },
      );

  Widget _buildEmailField() => appTextField(
        label: "Email",
        hint: "Masukkan alamat email",
        controller: fieldEmailController,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r"\s")),
        ],
        errorText: err('form1.email'),
        validator: (_) => err('form1.email'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) {
            clearErr('form1.email');
          }
        },
      );

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
          setState(() {
            fieldComboJnsClient = v;
            if (v != null) {
              clearErr('form1.jenisClient');
            }
          });
        },
        onSaveCallback: (value) => fieldComboJnsClient = value,
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

  void handleBack() {
    if (singlePopPages.contains(widget.requestFrom)) {
      Navigator.pop(context);
    } else {
      Navigator.of(context, rootNavigator: true).pop();

      authenticationBloc.add(
        LoggedIn(user: AppData.user),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var email = AppData.user.email ?? "";
    final isEmail = EmailValidator.validate(email.trim());
    lastLoginBy = isEmail ? "email" : "hp";

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        handleBack();
      },
      child: BlocConsumer<RegUserBloc, RegUserState>(
        listenWhen: (previous, current) {
          return previous.isSaved != current.isSaved ||
              previous.hasFailure != current.hasFailure ||
              previous.isOtpClient != current.isOtpClient ||
              previous.isRegisterSuccess != current.isRegisterSuccess;
        },
        listener: (context, state) {
          if (state.hasFailure && state.errors.isNotEmpty) {
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
              state.isRegisterSuccess &&
              singlePopPages.contains(widget.requestFrom) &&
              !state.isOtpClient) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PopupClientWidget(
                  sentTo: state.sentTo,
                  sentVia: state.sentVia,
                ),
              ),
            );
            if (mounted) {
              setState(() {
                isSubmitting = false;
              });
            }
          }
        },
        builder: (context, state) {
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
                                  _buildNameField(),
                                  SizedBox(height: vPadding),
                                  if (lastLoginBy == 'email') ...[
                                    _buildTeleponField(),
                                    SizedBox(height: vPadding),
                                  ] else if (lastLoginBy == 'hp') ...[
                                    _buildEmailField(),
                                    SizedBox(height: vPadding),
                                  ],
                                  _buildPasswordField(),
                                  SizedBox(height: vPadding),
                                  _PasswordRequirementRow(
                                      controller: fieldPasswordController),
                                  SizedBox(height: vPadding),
                                  _buildKonfirmasiPasswordField(),
                                  SizedBox(height: vPadding),
                                  buildFieldComboMJnsclient(),
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
                                            if (!validateForm1()) return;

                                            setState(() {
                                              isSubmitting = true;
                                            });
                                            _startSubmitTimeout();

                                            onSubmit();
                                          },
                                  ),
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
      ),
    );
  }

  void onSubmit() {
    final ok = validateForm1();
    if (!ok) return;

    User user = AppData.user;

    final bool fromEmail = lastLoginBy == 'email';

    final String email =
        fromEmail ? user.email ?? '' : fieldEmailController.text.trim();

    String telepon =
        fromEmail ? fieldTeleponController.text.trim() : user.email ?? '';

    if (lastLoginBy == 'email') {
      var phoneRes = IndoPhoneHelper.normalize(telepon);
      telepon = phoneRes.phone62 ?? '';
    }

    final record = RegUserModel(
      personalNama: fieldNameController.text.trim(),
      telepon: telepon,
      password: fieldPasswordController.text,
      jnsClientId: fieldComboJnsClient!.mjnsclientId,
      email: email,
      userNama: fieldNameController.text.trim(),
      sendOtpVia: fromEmail ? "hp" : "email",
      referral: fieldComboMReferral?.kodeUnik,
    );

    context.read<RegUserBloc>().add(ClearRequestFromEvent());

    context.read<RegUserBloc>().add(
          RegUserTambahEvent(
            record: record,
            requestFrom: widget.requestFrom,
            pinSentTo: fromEmail ? telepon : email,
            pinSentVia: fromEmail ? "hp" : "email",
          ),
        );
  }

  void _startSubmitTimeout() {
    final attempt = ++_submitAttempt;
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted || attempt != _submitAttempt || !isSubmitting) return;

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
