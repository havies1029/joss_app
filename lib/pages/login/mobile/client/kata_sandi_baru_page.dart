import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/forgot_password_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/authentication/reset_password_model.dart';

class KataSandiBaruPage extends StatefulWidget {
  final String email;
  final String requestId; // optional kalau kamu pakai requestId dari API
  final Future<bool> Function({
    required String email,
    required String newPassword,
    String? requestId,
  })? onSubmit;

  const KataSandiBaruPage({
    super.key,
    required this.email,
    required this.requestId,
    this.onSubmit,
  });

  @override
  State<KataSandiBaruPage> createState() => _KataSandiBaruPageState();
}

class _KataSandiBaruPageState extends State<KataSandiBaruPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _showNew = false;
  bool _showConfirm = false;

  bool _hasStartedTypingNewPassword = false;
  bool _hasStartedTypingConfirmPassword = false;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _newPasswordController.addListener(() {
      if (_newPasswordController.text.isNotEmpty && !_hasStartedTypingNewPassword) {
        setState(() => _hasStartedTypingNewPassword = true);
      } else {
        setState(() {}); // biar indikator requirement update realtime
      }
    });

    _confirmPasswordController.addListener(() {
      if (_confirmPasswordController.text.isNotEmpty && !_hasStartedTypingConfirmPassword) {
        setState(() => _hasStartedTypingConfirmPassword = true);
      }
    });

    _newPasswordFocus.addListener(() {
      if (!_newPasswordFocus.hasFocus && _hasStartedTypingNewPassword) {
        _formKey.currentState?.validate();
      }
    });

    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus && _hasStartedTypingConfirmPassword) {
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // ======= password rules (sesuai gambar) =======
  bool _min8(String v) => v.length >= 8;
  bool _upper(String v) => v.contains(RegExp(r'[A-Z]'));
  bool _digit(String v) => v.contains(RegExp(r'\d'));
  bool _symbol(String v) =>
      v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+]'));

  bool _allRulesOk(String v) => _min8(v) && _upper(v) && _digit(v) && _symbol(v);

  String? _validateNewPassword(String? value) {
    if (!_hasStartedTypingNewPassword) return null;
    final v = (value ?? "").trim();

    if (v.isEmpty) return 'Password baru tidak boleh kosong';
    if (!_min8(v)) return 'Password minimal 8 karakter';
    if (!_upper(v)) return 'Password harus mengandung huruf besar';
    if (!_digit(v)) return 'Password harus mengandung angka';
    if (!_symbol(v)) return 'Password harus mengandung simbol';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_hasStartedTypingConfirmPassword) return null;
    final v = (value ?? "").trim();

    if (v.isEmpty) return 'Ulangi password baru';
    if (v != _newPasswordController.text.trim()) {
      return 'Password baru & konfirmasi tidak sama';
    }
    return null;
  }

  Future<void> _submit() async {
    setState(() {
      _hasStartedTypingNewPassword = true;
      _hasStartedTypingConfirmPassword = true;
    });

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final pwd = _newPasswordController.text.trim();
    if (!_allRulesOk(pwd)) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar("Password belum memenuhi syarat."),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await (widget.onSubmit?.call(
          email: widget.email,
          newPassword: pwd,
          requestId: widget.requestId,
        ) ??
        Future.value(true));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      final record = ResetPasswordModel(requestId: widget.requestId, newPassword: pwd); // sesuaikan ctor model kamu
      context.read<ForgotPasswordBloc>().add(
        ForgotPswdResetPasswordEvent(record: record),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar("Gagal membuat password, coba lagi."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pwd = _newPasswordController.text;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (prev, curr) =>
          prev.isSent != curr.isSent ||
          prev.resetPasswordSuccess != curr.resetPasswordSuccess,
      listener: (context, state) {
        // OTP VALID (sukses)
        if (state.isSent && state.resetPasswordSuccess) {
          Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
          return;
        }
        if (state.isSent && !state.resetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar("Gagal membuat password, coba lagi."),
          );
        }
      
      },
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        appBar: AppBar(
          backgroundColor: primaryBlackColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Buat Kata Sandi Baru",
            style: headingStyle(context, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: hPadding * 1.5,
              horizontal: hPadding * 1.5,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ===== Card =====
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: pGrey,
                      border: Border.all(color: sGrey),
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 12,
                      right: 16,
                      left: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email (readonly)
                        appTextField(
                          controller: TextEditingController(text: widget.email),
                          label: "Email",
                          enabled: false,
                        ),
                        const SizedBox(height: 12),
      
                        // Password baru
                        appTextField(
                          controller: _newPasswordController,
                          label: "Kata Sandi Baru",
                          obscureText: !_showNew,
                          focusNode: _newPasswordFocus,
                          validator: _validateNewPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showNew ? Icons.visibility_off : Icons.visibility,
                              color: hintGrey,
                            ),
                            onPressed: () => setState(() => _showNew = !_showNew),
                          ),
                        ),
      
                        // Requirement row
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: _PasswordRequirementRow(
                            password: pwd,
                          ),
                        ),
      
                        // Konfirmasi password
                        appTextField(
                          controller: _confirmPasswordController,
                          label: "Konfirmasi Kata Sandi",
                          obscureText: !_showConfirm,
                          focusNode: _confirmPasswordFocus,
                          validator: _validateConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirm ? Icons.visibility_off : Icons.visibility,
                              color: hintGrey,
                            ),
                            onPressed: () => setState(() => _showConfirm = !_showConfirm),
                          ),
                        ),
                        const SizedBox(height: 12),
      
                        // Info keamanan (mirip gambar)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock, color: hintGrey, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Jaga keamanan akunmu! Jangan gunakan kata sandi yang sama di banyak layanan.',
                                style: bodyTextStyle(context, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 20),
      
                  // Button kirim (orange)
                  AppButton.primary(
                    text: _isSubmitting ? "Memproses..." : "Kirim",
                    onPressed: _isSubmitting ? null : _submit,
                    width: double.infinity,
                    backgroundColor: const Color(0xFFF28A2E),
                    textStyle: headingStyle(context, fontSize: 16).copyWith(color: Colors.white),
                    isLoading: _isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======= PASSWORD REQUIREMENTS (sama konsep dengan gambar 2) =======
class _PasswordRequirementRow extends StatelessWidget {
  final String password;
  const _PasswordRequirementRow({required this.password});

  bool get _min8 => password.length >= 8;
  bool get _upper => password.contains(RegExp(r'[A-Z]'));
  bool get _digit => password.contains(RegExp(r'\d'));
  bool get _symbol =>
      password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+]'));

  @override
  Widget build(BuildContext context) {
    TextStyle style(bool active) => TextStyle(
          fontSize: 13.7,
          color: active ? primaryColor : hintGrey,
          fontWeight: FontWeight.w500,
        );

    Widget item(bool checked, String text) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              checked ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 15,
              color: checked ? primaryColor : hintGrey,
            ),
            const SizedBox(width: 4),
            Text(text, style: style(checked)),
          ],
        );

    return Wrap(
      spacing: 14,
      runSpacing: 8,
      children: [
        item(_min8, "Minimal 8 Karakter"),
        item(_upper, "Ada Huruf Besar"),
        item(_digit, "Ada Angka"),
        item(_symbol, "Ada Simbol"),
      ],
    );
  }
}