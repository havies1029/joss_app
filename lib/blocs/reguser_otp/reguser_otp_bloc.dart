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
    on<RegUserOtpTargetChangedEvent>(_onTargetChanged);
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

  String _targetKey(String requestFrom, String target) {
    final cleanTarget = target.trim();
    return _isEmail(requestFrom) ? cleanTarget.toLowerCase() : cleanTarget;
  }

  RegUserOtpVerifiedTarget? _findVerifiedTarget(
    String requestFrom,
    String target,
  ) {
    final normalizedRequestFrom = requestFrom.trim().toLowerCase();
    final normalizedTarget = _targetKey(normalizedRequestFrom, target);

    for (final item in state.verifiedTargets ?? const []) {
      if (item.requestFrom == normalizedRequestFrom &&
          item.target == normalizedTarget) {
        return item;
      }
    }

    return null;
  }

  List<RegUserOtpVerifiedTarget> _upsertVerifiedTarget({
    required String requestFrom,
    required String target,
    required String requestId,
  }) {
    final normalizedRequestFrom = requestFrom.trim().toLowerCase();
    final normalizedTarget = _targetKey(normalizedRequestFrom, target);

    return [
      ...(state.verifiedTargets ?? const []).where(
        (item) =>
            item.requestFrom != normalizedRequestFrom ||
            item.target != normalizedTarget,
      ),
      RegUserOtpVerifiedTarget(
        requestFrom: normalizedRequestFrom,
        target: normalizedTarget,
        requestId: requestId,
      ),
    ];
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
      final verifiedTargets = _upsertVerifiedTarget(
        requestFrom: requestFrom,
        target: event.target,
        requestId: result.data,
      );

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
          verifiedTargets: verifiedTargets,
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

  void _onTargetChanged(
    RegUserOtpTargetChangedEvent event,
    Emitter<RegUserOtpState> emit,
  ) {
    final requestFrom = event.requestFrom.trim().toLowerCase();
    final isEmail = _isEmail(requestFrom);
    final target = _targetKey(requestFrom, event.target);
    final verifiedTarget =
        target.isEmpty ? null : _findVerifiedTarget(requestFrom, target);

    if (verifiedTarget != null) {
      emit(
        state.copyWith(
          emailRequestId:
              isEmail ? verifiedTarget.requestId : state.emailRequestId,
          hpRequestId: isEmail ? state.hpRequestId : verifiedTarget.requestId,
          isEmailSending: isEmail ? false : state.isEmailSending,
          isHpSending: isEmail ? state.isHpSending : false,
          isEmailValidating: isEmail ? false : state.isEmailValidating,
          isHpValidating: isEmail ? state.isHpValidating : false,
          isEmailVerified: isEmail ? true : state.isEmailVerified,
          isHpVerified: isEmail ? state.isHpVerified : true,
          emailError: isEmail ? _successMessage(requestFrom) : state.emailError,
          hpError: isEmail ? state.hpError : _successMessage(requestFrom),
          activeTarget: target,
          activeRequestFrom: requestFrom,
          message: '',
          hasFailure: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        emailRequestId: isEmail ? '' : state.emailRequestId,
        hpRequestId: isEmail ? state.hpRequestId : '',
        isEmailSending: isEmail ? false : state.isEmailSending,
        isHpSending: isEmail ? state.isHpSending : false,
        isEmailValidating: isEmail ? false : state.isEmailValidating,
        isHpValidating: isEmail ? state.isHpValidating : false,
        isEmailVerified: isEmail ? false : state.isEmailVerified,
        isHpVerified: isEmail ? state.isHpVerified : false,
        emailError: isEmail ? '' : state.emailError,
        hpError: isEmail ? state.hpError : '',
        activeTarget:
            state.activeRequestFrom == requestFrom ? '' : state.activeTarget,
        activeRequestFrom: state.activeRequestFrom == requestFrom
            ? ''
            : state.activeRequestFrom,
        message: '',
        hasFailure: false,
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
