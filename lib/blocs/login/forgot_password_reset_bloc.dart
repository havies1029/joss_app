import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/login/forgot_password_reset_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/login/forgot_password_reset_repository.dart';

part 'forgot_password_reset_event.dart';
part 'forgot_password_reset_state.dart';

class ForgotPasswordResetBloc
    extends Bloc<ForgotPasswordResetEvent, ForgotPasswordResetState> {
  final ForgotPasswordResetRepository repository;

  ForgotPasswordResetBloc({ForgotPasswordResetRepository? repository})
      : repository = repository ?? ForgotPasswordResetRepository(),
        super(const ForgotPasswordResetState()) {
    on<ForgotPasswordResetSendOtpEvent>(_onSendOtp);
    on<ForgotPasswordResetValidateOtpEvent>(_onValidateOtp);
    on<ForgotPasswordResetSubmitEvent>(_onResetPassword);
    on<ForgotPasswordResetClearMessageEvent>(_onClearMessage);
    on<ForgotPasswordResetFlagsEvent>(_onResetFlags);
  }

  Future<void> _onSendOtp(
    ForgotPasswordResetSendOtpEvent event,
    Emitter<ForgotPasswordResetState> emit,
  ) async {
    emit(
      state.copyWith(
        isSending: true,
        sendOtpSuccess: false,
        validateOtpSuccess: false,
        validateOtpFailed: false,
        resetPasswordSuccess: false,
        errorMessage: '',
      ),
    );

    final ReturnDataAPI result = await repository.sendOtp(event.record);
    final hasFailure = !result.success;

    emit(
      state.copyWith(
        isSending: false,
        target: event.record.target,
        requestFrom: event.record.requestFrom,
        requestId: hasFailure ? state.requestId : result.data,
        sendOtpSuccess: !hasFailure,
        errorMessage: hasFailure ? result.data.toString() : '',
      ),
    );
  }

  Future<void> _onValidateOtp(
    ForgotPasswordResetValidateOtpEvent event,
    Emitter<ForgotPasswordResetState> emit,
  ) async {
    emit(
      state.copyWith(
        isValidating: true,
        validateOtpSuccess: false,
        validateOtpFailed: false,
        errorMessage: '',
      ),
    );

    final ReturnDataAPI result = await repository.validateOtp(event.record);
    final hasFailure = !result.success;

    emit(
      state.copyWith(
        isValidating: false,
        requestId: hasFailure ? state.requestId : result.data,
        target: event.record.target,
        requestFrom: event.record.requestFrom,
        validateOtpSuccess: !hasFailure,
        validateOtpFailed: hasFailure,
        errorMessage: hasFailure ? result.data.toString() : '',
      ),
    );
  }

  Future<void> _onResetPassword(
    ForgotPasswordResetSubmitEvent event,
    Emitter<ForgotPasswordResetState> emit,
  ) async {
    emit(
      state.copyWith(
        isResetting: true,
        resetPasswordSuccess: false,
        errorMessage: '',
      ),
    );

    final ReturnDataAPI result = await repository.resetPassword(event.record);
    final hasFailure = !result.success;

    emit(
      state.copyWith(
        isResetting: false,
        resetPasswordSuccess: !hasFailure,
        errorMessage: hasFailure ? result.data.toString() : '',
      ),
    );
  }

  void _onClearMessage(
    ForgotPasswordResetClearMessageEvent event,
    Emitter<ForgotPasswordResetState> emit,
  ) {
    emit(state.copyWith(errorMessage: ''));
  }

  void _onResetFlags(
    ForgotPasswordResetFlagsEvent event,
    Emitter<ForgotPasswordResetState> emit,
  ) {
    emit(state.resetActionFlags());
  }
}
