import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/emailverification_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/reguser/reguser_bloc.dart';
import '../models/login/emailverification_model.dart';
import '../models/reguser/reguser_model.dart';

class AuthInputRouter {
  static void handleInput(BuildContext context, String input) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    final phoneRegex = RegExp(r'^(?:\+62|62|0)[0-9]{9,13}$');

    if (emailRegex.hasMatch(input)) {
      // 📧 EMAIL FLOW
      context.read<EmailVerificationBloc>().add(
        EmailVerificationTambahEvent(
          record: EmailVerificationModel(
            email: input,
            requestFrom: 'email',
          ),
        ),
      );
    } else if (phoneRegex.hasMatch(input)) {
      context.read<EmailVerificationBloc>().add(
        EmailVerificationTambahEvent(
          record: EmailVerificationModel(
            email: input,
            requestFrom: 'hp',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format tidak valid, masukkan email atau nomor HP"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
