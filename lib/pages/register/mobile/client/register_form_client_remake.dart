import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/login/emailverification_bloc.dart';
import '../../../../blocs/login/login_bloc.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../models/combobox/combomjnsclient_model.dart';
import '../../../../models/reguser/reguser_model.dart';
import '../../../../repositories/combobox/combomjnsclient_repository.dart';
import '../../../login/welcome_header.dart';
import '../../../../common/constants.dart';


class RegisterFormClientRemake extends StatefulWidget {
  final String requestFrom;
  const RegisterFormClientRemake({super.key, required this.requestFrom});

  @override
  State<RegisterFormClientRemake> createState() => _RegisterFormClientRemakeState();
}


class _RegisterFormClientRemakeState extends State<RegisterFormClientRemake>
{

  final fieldNameController = TextEditingController();
  final fieldPasswordController = TextEditingController();
  final fieldTeleponController = TextEditingController();
  final fieldKonfirmasiPasswordController = TextEditingController();
  final fieldEmailController = TextEditingController();
  ComboMJnsclientModel? fieldComboJnsClient;

  bool _obscurePassword = true;

  late EmailVerificationBloc emailVerificationBloc;
  late final RegUserModel? record;
  String requestFrom = '';

  @override
  void initState() {
    super.initState();
    emailVerificationBloc = context.read<EmailVerificationBloc>();
    requestFrom = emailVerificationBloc.state.record!.requestFrom!;
  }

  @override
  void dispose(){
    fieldNameController.dispose();
    fieldPasswordController.dispose();
    fieldTeleponController.dispose();
    fieldEmailController.dispose();
    fieldKonfirmasiPasswordController.dispose();
    super.dispose();
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

    final telp = fieldTeleponController.text.trim();
    if (telp.isEmpty) {
      setErr('form1.telepon', kStringNullError);
      ok = false;
    } else {
      if (!RegExp(r'^\d+$').hasMatch(telp)) {
        setErr('form1.telepon', "Format tidak valid");
        ok = false;
      }
    }

    final pass = fieldPasswordController.text;
    if (pass.trim().isEmpty) {
      setErr('form1.password', kStringNullError);
      ok = false;
    }

    final konf = fieldKonfirmasiPasswordController.text;
    if (konf.trim().isEmpty) {
      setErr('form1.konfirmasiPassword', kStringNullError);
      ok = false;
    } else {
      if (pass.trim().isNotEmpty && pass != konf) {
        setErr('form1.konfirmasiPassword', "Konfirmasi password tidak sama");
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
    label: "Password",
    hint: "Masukkan password",
    controller: fieldPasswordController,
    keyboardType: TextInputType.visiblePassword,
    obscureText: _obscurePassword,
    errorText: err('form1.password'),
    validator: (_) => err('form1.password'),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword
            ? Icons.visibility_off
            : Icons.visibility,
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
      if (v.trim().isNotEmpty) {
        clearErr('form1.password');
      }
    },
  );

  Widget _buildKonfirmasiPasswordField() => appTextField(
    label: "Konfirmasi Password",
    hint: "Masukkan konfirmasi password",
    controller: fieldKonfirmasiPasswordController,
    keyboardType: TextInputType.visiblePassword,
    obscureText: _obscurePassword,
    errorText: err('form1.konfirmasiPassword'),
    validator: (_) => err('form1.konfirmasiPassword'),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword
            ? Icons.visibility_off
            : Icons.visibility,
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
      if (v.trim().isNotEmpty) {
        clearErr('form1.konfirmasiPassword');
      }
    },
  );

  Widget _buildTeleponField() => appTextField(
    label: "Nomor Telepon",
    hint: "Masukkan nomor telepon",
    controller: fieldTeleponController,
    keyboardType: TextInputType.phone,
    prefix: Text(
      "62 | ",
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

  Widget buildFieldComboMJnsclient() => ReusableComboBox<ComboMJnsclientModel>(
    hintText: "Jenis Client",
    initItem: fieldComboJnsClient,
    dataLoader: () => ComboMJnsclientRepository().getComboMJnsclient(),
    displayText: (i) => i.jenisNama,
    compareItems: (a, b) => a.mjnsclientId == b.mjnsclientId,
    validatorCallback: (_) => err('form1.jenisClient'),
    errorText: err('form1.jenisClient'),
    onChangedCallback: (v) {
      fieldComboJnsClient = v;
      if (v != null) clearErr('form1.jenisClient');
    },
    onSaveCallback: (value) => fieldComboJnsClient = value,
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegUserBloc, RegUserState>(
      listener: (context, state) {
        // gagal dari API
        if (state.hasFailure && state.errors.isNotEmpty) {
          final msg = state.errors.first;
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(msg));
          return;
        }

        // sukses
        if (state.isSaved) {
          final email = state.record!.email;
          final password = state.record!.password;

          context.read<LoginBloc>().add(
            LoginButtonPressed(
              email: email,
              password: password,
              rememberMe: true,
            ),
          );



          // kalau mau langsung balik halaman:
          // Navigator.of(context, rootNavigator: true).pop();
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
                  // ===== Header Section (DESAIN) =====
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: vPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/logo_jps_no_background.png',
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
                              onPressed: () => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: primaryColor,
                                size: getResponsiveFont(context, 18),
                              ),
                              label: Text(
                                "Kembali",
                                style: bodyTextStyle(context).copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: vPadding * 0.8),
                        WelcomeHeader(type: "register_client"),
                      ],
                    ),
                  ),

                  // ===== Card Section (DESAIN) =====
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

                                if (requestFrom == 'email') ...[
                                  _buildTeleponField(),
                                  SizedBox(height: vPadding),
                                ] else if (requestFrom == 'hp') ...[
                                  _buildEmailField(),
                                  SizedBox(height: vPadding),
                                ],

                                _buildPasswordField(),
                                SizedBox(height: vPadding),

                                _buildKonfirmasiPasswordField(),
                                SizedBox(height: vPadding),

                                buildFieldComboMJnsclient(),
                                SizedBox(height: vPadding),

                                AppButton.primary(
                                  text: "Submit",
                                  onPressed: onSubmit,
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
    );
  }

  void onSubmit() {
    final ok = validateForm1();
    if (!ok) return;

    final evState = context.read<EmailVerificationBloc>().state;

    final bool fromEmail = widget.requestFrom == 'email';
    final bool fromHp = widget.requestFrom == 'hp';

    final String email = fromEmail
        ? evState.email
        : fieldEmailController.text.trim();

    final String teleponRaw = fromEmail
        ? fieldTeleponController.text.trim()
        : evState.telepon;

    final String teleponNormalized = _normalizePhone62(teleponRaw);

    final record = RegUserModel(
      personalNama: fieldNameController.text.trim(),
      telepon: teleponNormalized,
      password: fieldPasswordController.text,
      jnsClientId: fieldComboJnsClient!.mjnsclientId,
      email: email,
      userNama: fieldNameController.text.trim(),
    );

    context.read<RegUserBloc>().add(
      RegUserTambahEvent(
        record: record,
        requestFrom: widget.requestFrom,
      ),
    );
  }

  String _normalizePhone62(String input) {
    var t = input.trim();

    t = t.replaceAll(RegExp(r'[\s\-]'), '');

    if (t.startsWith('+62')) t = t.substring(1);

    if (t.startsWith('0')) t = '62${t.substring(1)}';

    if (t.startsWith('62')) return t;

    return '62$t';
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