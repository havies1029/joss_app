import 'package:joss_app/models/authentication/reset_password_model.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/login/forgot_password_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  ForgotPasswordBloc({required this.repository})
      : super(const ForgotPasswordState()) {
    on<ForgotPswdRequestPinEvent>(onRequestPinEvent);
    on<ForgotPswdValidasiPinEmailEvent>(onValidasiPinEmail);
    on<ForgotPswdResetPasswordEvent>(onResetPassword);
  }


  Future<void> onRequestPinEvent(ForgotPswdRequestPinEvent event,
      Emitter<ForgotPasswordState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSending: true, isSent: false, hasFailure: false, verificationEmailSuccess: false));
    returnData = await repository.emailVerificationForgotPswd(event.record);
    hasFailure = !returnData.success;

    ForgotPasswordModel? record =hasFailure ? null : event.record?..requestId = returnData.data; // pastikan model kamu punya field requestId
    
    emit(state.copyWith(
      isSending: false,
      isSent: true,
      hasFailure: hasFailure,
      record: record,
      verificationEmailSuccess: !hasFailure,
    ));
  }

  Future<void> onValidasiPinEmail(
      ForgotPswdValidasiPinEmailEvent event, Emitter<ForgotPasswordState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSending: true, isSent: false, verificationPinSuccess: false));

    returnData = await repository.emailVerificationForgotPswd(event.record);

    debugPrint("onValidasiPinEmail returnData: ${returnData.data}");

    hasFailure = !returnData.success;
    emit(state.copyWith(
      isSending: false,
      isSent: true,
      hasFailure: hasFailure,
      verificationPinSuccess: !hasFailure,
    ));
  }

  Future<void> onResetPassword(ForgotPswdResetPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    bool success = false;
    emit(state.copyWith(isSending: true, isSent: false, resetPasswordSuccess: false));

    success = await repository.resetPassword(event.record);

    emit(state.copyWith(
      isSending: false,
      isSent: true,
      resetPasswordSuccess: success,
      hasFailure: !success,
    ));
  }
}
