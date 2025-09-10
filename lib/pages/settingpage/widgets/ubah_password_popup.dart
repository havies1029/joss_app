import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/change_password_bloc.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';
import 'package:joss_app/common/constants.dart';

const Color fieldBgColor = Color(0xFF181818);
const Color borderColor = Color(0xFF484848);
const Color fieldTextColor = Colors.white;
const Color labelColor = Colors.white70;
const Color hintColor = Colors.white38;
const Color errorColor = Color(0xFFFF5A5A);
const Color activeColor = primaryColor; // #EF7A28

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({Key? key}) : super(key: key);

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  late ChangePasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChangePasswordBloc>();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _oldPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final oldPwd = _oldPasswordController.text.trim();
    final newPwd = _newPasswordController.text.trim();
    final confirmPwd = _confirmPasswordController.text.trim();

    bool hasError = false;

    if (oldPwd.isEmpty) {
      _oldPasswordError = 'Password lama tidak boleh kosong';
      hasError = true;
    }
    if (newPwd.isEmpty) {
      _newPasswordError = 'Password baru tidak boleh kosong';
      hasError = true;
    }
    if (confirmPwd.isEmpty) {
      _confirmPasswordError = 'Ulangi password baru';
      hasError = true;
    } else if (!hasError && newPwd != confirmPwd) {
      _confirmPasswordError = 'Password baru & konfirmasi tidak sama';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    final model = ChangePasswordModel(oldPassword: oldPwd, newPassword: newPwd);
    _bloc.add(UserChangePasswordEvent(pswd: model));
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
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryBlackColor,
          appBar: AppBar(
            backgroundColor: primaryBlackColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Ubah Kata Sandi",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Card Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: fieldBgColor,
                        border: Border.all(color: borderColor, width: 1.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            controller: _oldPasswordController,
                            label: "Kata Sandi Lama",
                            errorText: _oldPasswordError,
                            obscureText: !_showOld,
                            onToggle: () =>
                                setState(() => _showOld = !_showOld),
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _newPasswordController,
                            label: "Kata Sandi Baru",
                            errorText: _newPasswordError,
                            obscureText: !_showNew,
                            onToggle: () =>
                                setState(() => _showNew = !_showNew),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _PasswordRequirementRow(
                              password: _newPasswordController.text,
                            ),
                          ),

                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: "Ulangi Kata Sandi",
                            errorText: _confirmPasswordError,
                            obscureText: !_showConfirm,
                            onToggle: () =>
                                setState(() => _showConfirm = !_showConfirm),
                          ),
                          const SizedBox(height: 10),

                          // Security info
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lock,
                                    color: hintColor, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Jaga keamanan akunmu! Jangan gunakan kata sandi yang sama di banyak layanan.',
                                    style: TextStyle(
                                      color: hintColor,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // BUTTON SIMPAN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // BUTTON LUPA KATA SANDI
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF232323),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // TODO: Implement forgot password logic
                        },
                        child: const Text(
                          "Lupa Kata Sandi?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
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
      },
    );
  }
}

// ======= CUSTOM FIELD ========
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool obscureText;
  final VoidCallback? onToggle;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.errorText,
    this.obscureText = false,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: fieldTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: activeColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldBgColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        labelText: label,
        labelStyle: const TextStyle(
          color: labelColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: activeColor, width: 1.7),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: label,
        hintStyle: const TextStyle(color: hintColor, fontWeight: FontWeight.w400),
        suffixIcon: onToggle != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: hintColor,
            size: 22,
          ),
          onPressed: onToggle,
        )
            : null,
        errorText: errorText,
        errorStyle: const TextStyle(
          color: errorColor,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
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
  bool get _symbol => password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+]'));

  @override
  Widget build(BuildContext context) {
    TextStyle style(bool active) => TextStyle(
      fontSize: 13.7,
      color: active ? activeColor : hintColor,
      fontWeight: FontWeight.w500,
    );

    Widget item(bool checked, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          checked ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 15,
          color: checked ? activeColor : hintColor,
        ),
        SizedBox(width: 4),
        Text(text, style: style(checked)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 14,
        runSpacing: 8,
        children: [
          item(_min8, "Minimal 8 Karakter"),
          item(_upper, "Ada Huruf Besar"),
          item(_digit, "Ada Angka"),
          item(_symbol, "Ada Simbol"),
        ],
      ),
    );
  }
}
