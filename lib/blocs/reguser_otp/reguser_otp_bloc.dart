import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/reguser/reguser_otp_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/reguser/reguser_otp_repository.dart';

part 'reguser_otp_event.dart';
part 'reguser_otp_state.dart';

class RegUserOtpBloc extends Bloc<RegUserOtpEvent, RegUserOtpState> {
  final ReguserOtpRepository repository;

  RegUserOtpBloc({ReguserOtpRepository? repository})
      : repository = repository ?? ReguserOtpRepository(),
        super(const RegUserOtpState()) {
    on<RegUserOtpKirimEvent>(_onKirim);
    on<RegUserOtpValidasiEvent>(_onValidasi);
    on<RegUserOtpResetEmailEvent>(_onResetEmail);
    on<RegUserOtpResetHpEvent>(_onResetHp);
    on<RegUserOtpClearEvent>(_onClear);
  }

  bool _isEmail(String requestFrom) {
    return requestFrom.trim().toLowerCase() == 'email';
  }

  String _successMessage(String requestFrom) {
    return _isEmail(requestFrom)
        ? 'Email ini telah diverifikasi'
        : 'No. telepon ini telah diverifikasi';
  }

  Future<void> _onKirim(
    RegUserOtpKirimEvent event,
    Emitter<RegUserOtpState> emit,
  ) async {
    final requestFrom = event.requestFrom.trim().toLowerCase();
    final isEmail = _isEmail(requestFrom);

    emit(
      state.copyWith(
        isEmailSending: isEmail ? true : state.isEmailSending,
        isHpSending: isEmail ? state.isHpSending : true,
        emailError: isEmail ? '' : state.emailError,
        hpError: isEmail ? state.hpError : '',
        activeTarget: event.target,
        activeRequestFrom: requestFrom,
        message: '',
        hasFailure: false,
      ),
    );

    final ReturnDataAPI result = await repository.kirim(
      ReguserOtpSendModel(
        target: event.target,
        requestFrom: requestFrom,
      ),
    );

    if (result.success) {
      emit(
        state.copyWith(
          emailRequestId: isEmail ? result.data : state.emailRequestId,
          hpRequestId: isEmail ? state.hpRequestId : result.data,
          isEmailSending: isEmail ? false : state.isEmailSending,
          isHpSending: isEmail ? state.isHpSending : false,
          emailError: isEmail ? '' : state.emailError,
          hpError: isEmail ? state.hpError : '',
          activeTarget: event.target,
          activeRequestFrom: requestFrom,
          message: 'OTP berhasil dikirim.',
          hasFailure: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isEmailSending: isEmail ? false : state.isEmailSending,
        isHpSending: isEmail ? state.isHpSending : false,
        emailError: isEmail ? result.data : state.emailError,
        hpError: isEmail ? state.hpError : result.data,
        activeTarget: event.target,
        activeRequestFrom: requestFrom,
        message: result.data,
        hasFailure: true,
      ),
    );
  }

  Future<void> _onValidasi(
    RegUserOtpValidasiEvent event,
    Emitter<RegUserOtpState> emit,
  ) async {
    final requestFrom = event.requestFrom.trim().toLowerCase();
    final isEmail = _isEmail(requestFrom);

    emit(
      state.copyWith(
        isEmailValidating: isEmail ? true : state.isEmailValidating,
        isHpValidating: isEmail ? state.isHpValidating : true,
        emailError: isEmail ? '' : state.emailError,
        hpError: isEmail ? state.hpError : '',
        activeTarget: event.target,
        activeRequestFrom: requestFrom,
        message: '',
        hasFailure: false,
      ),
    );

    final ReturnDataAPI result = await repository.validasi(
      ReguserOtpValidateModel(
        requestId: event.requestId,
        target: event.target,
        requestFrom: requestFrom,
        pin: event.pin,
      ),
    );

    if (result.success) {
      emit(
        state.copyWith(
          emailRequestId: isEmail ? result.data : state.emailRequestId,
          hpRequestId: isEmail ? state.hpRequestId : result.data,
          isEmailValidating: isEmail ? false : state.isEmailValidating,
          isHpValidating: isEmail ? state.isHpValidating : false,
          isEmailVerified: isEmail ? true : state.isEmailVerified,
          isHpVerified: isEmail ? state.isHpVerified : true,
          emailError: isEmail ? _successMessage(requestFrom) : state.emailError,
          hpError: isEmail ? state.hpError : _successMessage(requestFrom),
          activeTarget: event.target,
          activeRequestFrom: requestFrom,
          message: _successMessage(requestFrom),
          hasFailure: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isEmailValidating: isEmail ? false : state.isEmailValidating,
        isHpValidating: isEmail ? state.isHpValidating : false,
        isEmailVerified: isEmail ? false : state.isEmailVerified,
        isHpVerified: isEmail ? state.isHpVerified : false,
        emailError: isEmail ? result.data : state.emailError,
        hpError: isEmail ? state.hpError : result.data,
        activeTarget: event.target,
        activeRequestFrom: requestFrom,
        message: result.data,
        hasFailure: true,
      ),
    );
  }

  void _onResetEmail(
    RegUserOtpResetEmailEvent event,
    Emitter<RegUserOtpState> emit,
  ) {
    emit(
      state.copyWith(
        emailRequestId: '',
        isEmailSending: false,
        isEmailValidating: false,
        isEmailVerified: false,
        emailError: '',
        activeTarget:
            state.activeRequestFrom == 'email' ? '' : state.activeTarget,
        activeRequestFrom:
            state.activeRequestFrom == 'email' ? '' : state.activeRequestFrom,
        message: '',
        hasFailure: false,
      ),
    );
  }

  void _onResetHp(
    RegUserOtpResetHpEvent event,
    Emitter<RegUserOtpState> emit,
  ) {
    emit(
      state.copyWith(
        hpRequestId: '',
        isHpSending: false,
        isHpValidating: false,
        isHpVerified: false,
        hpError: '',
        activeTarget: state.activeRequestFrom == 'hp' ? '' : state.activeTarget,
        activeRequestFrom:
            state.activeRequestFrom == 'hp' ? '' : state.activeRequestFrom,
        message: '',
        hasFailure: false,
      ),
    );
  }

  void _onClear(
    RegUserOtpClearEvent event,
    Emitter<RegUserOtpState> emit,
  ) {
    emit(const RegUserOtpState());
  }
}
