import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';
import 'package:joss_app/common/constants.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  bool _hasStartedTypingNewPassword = false;
  bool _hasStartedTypingConfirmPassword = false;

  late ChangePasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChangePasswordBloc>();

    // Listen to new password changes
    _newPasswordController.addListener(() {
      if (_newPasswordController.text.isNotEmpty) {
        setState(() {
          _hasStartedTypingNewPassword = true;
        });
      }
    });

    // Listen to confirm password changes
    _confirmPasswordController.addListener(() {
      if (_confirmPasswordController.text.isNotEmpty) {
        setState(() {
          _hasStartedTypingConfirmPassword = true;
        });
      }
    });

    // Validate when focus changes from new password field
    _newPasswordFocus.addListener(() {
      if (!_newPasswordFocus.hasFocus && _hasStartedTypingNewPassword) {
        _formKey.currentState?.validate();
      }
    });

    // Validate when focus changes from confirm password field
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus && _hasStartedTypingConfirmPassword) {
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password lama tidak boleh kosong';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (!_hasStartedTypingNewPassword) return null;

    if (value == null || value.trim().isEmpty) {
      return 'Password baru tidak boleh kosong';
    }

    // Optional: Add more password strength validation here
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_hasStartedTypingConfirmPassword) return null;

    if (value == null || value.trim().isEmpty) {
      return 'Ulangi password baru';
    }

    if (value != _newPasswordController.text) {
      return 'Password baru & konfirmasi tidak sama';
    }

    return null;
  }

  void _submit() {
    // Trigger validation for all fields
    setState(() {
      _hasStartedTypingNewPassword = true;
      _hasStartedTypingConfirmPassword = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final oldPwd = _oldPasswordController.text.trim();
      final newPwd = _newPasswordController.text.trim();

      final model = ChangePasswordModel(
        oldPassword: oldPwd,
        newPassword: newPwd,
      );
      _bloc.add(UserChangePasswordEvent(pswd: model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.hasFailure
                    ? "Password lama salah."
                    : "Password berhasil diubah.",
              ),
              backgroundColor: state.hasFailure ? Colors.red : primaryColor,
            ),
          );
          if (!state.hasFailure) Navigator.of(context).pop();

          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          // Reset validation states
          setState(() {
            _hasStartedTypingNewPassword = false;
            _hasStartedTypingConfirmPassword = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: secondaryBlackColor,
          appBar: AppBar(
            backgroundColor: primaryBlackColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              "Ubah Kata Sandi",
              style: headingStyle(context, fontSize: 20),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: hPadding * 1.5,
                  horizontal: hPadding * 1.5,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Card Section
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
                            // Old Password Field
                            appTextField(
                              controller: _oldPasswordController,
                              label: "Kata Sandi Lama",
                              obscureText: !_showOld,
                              validator: _validateOldPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showOld
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: hintGrey,
                                ),
                                onPressed:
                                    () => setState(() => _showOld = !_showOld),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // New Password Field
                            appTextField(
                              controller: _newPasswordController,
                              label: "Kata Sandi Baru",
                              obscureText: !_showNew,
                              focusNode: _newPasswordFocus,
                              validator: _validateNewPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showNew
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: hintGrey,
                                ),
                                onPressed:
                                    () => setState(() => _showNew = !_showNew),
                              ),
                            ),

                            // Password Requirements
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: _PasswordRequirementRow(
                                password: _newPasswordController.text,
                              ),
                            ),

                            // Confirm Password Field
                            appTextField(
                              controller: _confirmPasswordController,
                              label: "Ulangi Kata Sandi",
                              obscureText: !_showConfirm,
                              focusNode: _confirmPasswordFocus,
                              validator: _validateConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: hintGrey,
                                ),
                                onPressed:
                                    () => setState(
                                      () => _showConfirm = !_showConfirm,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Security info
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: hPadding,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    color: hintGrey,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Jaga keamanan akunmu! Jangan gunakan kata sandi yang sama di banyak layanan.',
                                      style: bodyTextStyle(
                                        context,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // BUTTON SIMPAN
                      AppButton.primary(
                        text: "Simpan Perubahan",
                        onPressed: _submit,
                        width: double.infinity,
                        isLoading: false,
                      ),

                      const SizedBox(height: 10),
                     
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ======= PASSWORD REQUIREMENTS =======
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
        SizedBox(width: 4),
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
