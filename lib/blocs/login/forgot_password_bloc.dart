import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/authentication/reset_password_model.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/login/forgot_password_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  ForgotPasswordBloc({
    required this.repository,
  }) : super(const ForgotPasswordState()) {
    on<ForgotPswdRequestPinEvent>(_onRequestPinEvent);
    on<ForgotPswdResendOtpEvent>(_onResendOtp);
    on<ForgotPswdValidasiPinEmailEvent>(_onValidasiPinEmail);
    on<ForgotPswdResetPasswordEvent>(_onResetPassword);
    on<ForgotPswdClearMessageEvent>(_onClearMessage);
    on<ForgotPswdResetFlagsEvent>(_onResetFlags);
  }

  Future<void> _onRequestPinEvent(
    ForgotPswdRequestPinEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        requestOtpSuccess: false,
        resendOtpSuccess: false,
        verificationPinSuccess: false,
        verificationPinFailed: false,
        resetPasswordSuccess: false,
        errorMessage: "",
      ),
    );

    final ReturnDataAPI returnData = await repository.requestOtp(event.record);
    final bool hasFailure = !returnData.success;

    RequestOtpModel? updatedRecord;
    if (!hasFailure) {
      updatedRecord = event.record;
      updatedRecord.requestOtpId = returnData.data;
    }

    emit(
      state.copyWith(
        isLoading: false,
        record: updatedRecord,
        requestOtpSuccess: !hasFailure,
        errorMessage: hasFailure ? (returnData.data?.toString() ?? "") : "",
      ),
    );
  }

  Future<void> _onResendOtp(
    ForgotPswdResendOtpEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        resendOtpSuccess: false,
        verificationPinSuccess: false,
        verificationPinFailed: false,
        errorMessage: "",
      ),
    );

    final ReturnDataAPI returnData = await repository.resendOtp(event.record);
    final bool hasFailure = !returnData.success;

    RequestOtpModel? updatedRecord;
    if (!hasFailure) {
      updatedRecord = event.record;
      updatedRecord.requestOtpId = returnData.data;
    }

    emit(
      state.copyWith(
        isLoading: false,
        record: updatedRecord ?? state.record,
        resendOtpSuccess: !hasFailure,
        errorMessage: hasFailure ? (returnData.data?.toString() ?? "") : "",
      ),
    );
  }

  Future<void> _onValidasiPinEmail(
    ForgotPswdValidasiPinEmailEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        verificationPinSuccess: false,
        verificationPinFailed: false,
        errorMessage: "",
      ),
    );

    final ReturnDataAPI returnData = await repository.validasiOtp(event.record);
    final bool hasFailure = !returnData.success;

    emit(
      state.copyWith(
        isLoading: false,
        verificationPinSuccess: !hasFailure,
        verificationPinFailed: hasFailure,
        errorMessage: hasFailure ? (returnData.data?.toString() ?? "") : "",
      ),
    );
  }

  Future<void> _onResetPassword(
    ForgotPswdResetPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        resetPasswordSuccess: false,
        errorMessage: "",
      ),
    );

    final bool success = await repository.resetPassword(event.record);

    emit(
      state.copyWith(
        isLoading: false,
        resetPasswordSuccess: success,
        errorMessage: success ? "" : "Gagal mereset password",
      ),
    );
  }

  void _onClearMessage(
    ForgotPswdClearMessageEvent event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        errorMessage: "",
      ),
    );
  }

  void _onResetFlags(
    ForgotPswdResetFlagsEvent event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.resetActionFlags());
  }
}