import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/login/forgot_password_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/pages/login/mobile/client/widget/otp_forgot_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? initialEmail;
  final VoidCallback? onBack;
  final Future<bool> Function(String email)? onSubmit;

  const ForgotPasswordPage({
    super.key,
    this.initialEmail,
    this.onBack,
    this.onSubmit,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _emailController.text.trim();

    final success = await (widget.onSubmit?.call(email) ?? Future.value(true));
    if (!mounted) return;

    if (success) {

      final record = ForgotPasswordModel(email: email); 
      context.read<ForgotPasswordBloc>().add(
        ForgotPswdRequestPinEvent(record: record),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar("Gagal mengirim OTP, coba lagi."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (prev, curr) =>
          prev.isSent != curr.isSent ||
          prev.verificationEmailSuccess != curr.verificationEmailSuccess,
      listener: (context, state) {
        // OTP VALID (sukses)
        if (state.isSent && state.verificationEmailSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpForgotWidget(sentTo: state.record?.email ?? ""), // <-- buka OTP di sini
            ),
          );
          return;
        }
      
      },
      child: Scaffold(
        backgroundColor: primaryBlackColor,
        body: BaseBackgroundFirstPage(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
      
                    // ====== Logo (sesuai request) ======
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
      
                    const SizedBox(height: 12),
      
                    // ====== Kembali ======
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.chevron_left, color: primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              "Kembali",
                              style: bodyTextStyle(context).copyWith(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
      
                    const SizedBox(height: 8),
      
                    // ====== Title & desc ======
                    Text(
                      "Lupa Kata Sandi?",
                      style: headingStyle(context, fontSize: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Masukkan email terdaftar untuk mengatur ulang kata sandi.",
                      style: bodyTextStyle(context, fontSize: 16).copyWith(color: hintGrey),
                    ),
      
                    const SizedBox(height: 18),
      
                    Container(
                      decoration: BoxDecoration(
                        gradient: cardBorderGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: secondaryBlackColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              appTextField(
                                label: "Email",
                                hint: "Masukkan email kamu",
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  final v = (value ?? "").trim();
                                  if (v.isEmpty) return "Mohon isi email";
                                  if (!emailValidatorRegExp.hasMatch(v)) {
                                    return "Masukkan format email yang valid";
                                  }
                                  return null;
                                },
                                onTap: () {},
                              ),
                              const SizedBox(height: 14),
      
                              // Tombol orange (mirip screenshot)
                              AppButton.primary(
                                text: "Kirim",
                                onPressed: _submit,
                                width: double.infinity,
                                backgroundColor: const Color(0xFFF28A2E),
                                textStyle: headingStyle(context, fontSize: 16)
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
      
                    // spacer bawah biar ga mepet home indicator
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}