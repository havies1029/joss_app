import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/emailverification_bloc.dart';
import '../models/login/emailverification_model.dart';
import 'package:email_validator/email_validator.dart';

import 'indo_phone_result.dart';

class AuthInputRouter {
  static void handleInput(BuildContext context, String inputRaw) {
    final input = inputRaw.trim();

    // 1) Email: pakai library
    final isEmail = EmailValidator.validate(input);

    if (isEmail) {
      context.read<EmailVerificationBloc>().add(
        EmailVerificationTambahEvent(
          record: EmailVerificationModel(
            email: input,
            requestFrom: 'email',
          ),
        ),
      );
      return;
    }

    final phoneRes = IndoPhoneHelper.normalize(input);
    if (phoneRes.isValid) {
      final phone62 = phoneRes.phone62!;

      context.read<EmailVerificationBloc>().add(
        EmailVerificationTambahEvent(
          record: EmailVerificationModel(
            email: phone62,
            requestFrom: 'hp',
          ),
        ),
      );
      return;
    }

    // 3) Invalid
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(phoneRes.error ?? "Format tidak valid, masukkan email atau nomor HP"),
        backgroundColor: Colors.red,
      ),
    );
  }
}