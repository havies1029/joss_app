import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpic_contact_change_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpic_contact_change_repository.dart';

part 'mrekanpic_contact_change_event.dart';
part 'mrekanpic_contact_change_state.dart';

class MRekanPicContactChangeBloc
    extends Bloc<MRekanPicContactChangeEvent, MRekanPicContactChangeState> {
  final MRekanPicContactChangeRepository repository;

  MRekanPicContactChangeBloc({MRekanPicContactChangeRepository? repository})
      : repository = repository ?? MRekanPicContactChangeRepository(),
        super(const MRekanPicContactChangeState()) {
    on<MRekanPicContactChangeSendRequested>(_onSend);
    on<MRekanPicContactChangeValidateRequested>(_onValidate);
    on<MRekanPicContactChangePrepareRequested>(_onPrepare);
    on<MRekanPicContactChangeClearRequested>(_onClear);
  }

  Future<void> _onSend(
    MRekanPicContactChangeSendRequested event,
    Emitter<MRekanPicContactChangeState> emit,
  ) async {
    emit(
      MRekanPicContactChangeState(
        phase: MRekanPicContactChangePhase.sending,
        changeTypeId: event.changeTypeId,
        verifyViaId: event.verifyViaId,
      ),
    );

    final result = await repository.send(
      MRekanPicContactChangeSendModel(
        mrekanpicId: event.mrekanpicId,
        changeTypeId: event.changeTypeId,
        verifyViaId: event.verifyViaId,
      ),
    );

    if (!result.success) {
      emit(
        state.copyWith(
          phase: MRekanPicContactChangePhase.failure,
          message: result.effectiveMessage,
          result: result,
          hasFailure: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        phase: MRekanPicContactChangePhase.otpSent,
        changeRequestId: result.changeRequestId.isNotEmpty
            ? result.changeRequestId
            : result.data,
        backendStatusId: result.statusId,
        changeTypeId: result.changeTypeId ?? event.changeTypeId,
        verifyViaId: result.verifyViaId ?? event.verifyViaId,
        maskedTarget: result.maskedTarget,
        otpExpiresAt: result.otpExpiresAt,
        message: result.effectiveMessage,
        result: result,
      ),
    );
  }

  Future<void> _onValidate(
    MRekanPicContactChangeValidateRequested event,
    Emitter<MRekanPicContactChangeState> emit,
  ) async {
    final requestId = event.changeRequestId.trim().isNotEmpty
        ? event.changeRequestId.trim()
        : state.changeRequestId;

    emit(
      state.copyWith(
        phase: MRekanPicContactChangePhase.validating,
        message: '',
      ),
    );

    final result = await repository.validate(
      MRekanPicContactChangeValidateModel(
        changeRequestId: requestId,
        pin: event.pin,
      ),
    );

    if (!result.success) {
      final requiresRestart = _requiresRestart(result);
      emit(
        state.copyWith(
          phase: requiresRestart
              ? MRekanPicContactChangePhase.expired
              : MRekanPicContactChangePhase.otpSent,
          backendStatusId: result.statusId,
          remainingAttempts: result.remainingAttempts,
          message: result.effectiveMessage,
          result: result,
          hasFailure: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        phase: MRekanPicContactChangePhase.verified,
        changeRequestId: result.changeRequestId.isNotEmpty
            ? result.changeRequestId
            : requestId,
        backendStatusId: result.statusId,
        authorizationExpiresAt: result.authorizationExpiresAt,
        message: result.effectiveMessage,
        result: result,
      ),
    );
  }

  Future<void> _onPrepare(
    MRekanPicContactChangePrepareRequested event,
    Emitter<MRekanPicContactChangeState> emit,
  ) async {
    final requestId = event.changeRequestId.trim().isNotEmpty
        ? event.changeRequestId.trim()
        : state.changeRequestId;

    emit(
      state.copyWith(
        phase: MRekanPicContactChangePhase.preparing,
        message: '',
      ),
    );

    final result = await repository.prepare(
      MRekanPicContactChangePrepareModel(
        changeRequestId: requestId,
        newValue: event.newValue,
      ),
    );

    if (!result.success) {
      final requiresRestart = _requiresRestart(result);
      emit(
        state.copyWith(
          phase: requiresRestart
              ? MRekanPicContactChangePhase.expired
              : MRekanPicContactChangePhase.verified,
          backendStatusId: result.statusId,
          message: result.effectiveMessage,
          result: result,
          hasFailure: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        phase: MRekanPicContactChangePhase.prepared,
        changeRequestId: result.changeRequestId.isNotEmpty
            ? result.changeRequestId
            : requestId,
        backendStatusId: result.statusId,
        message: result.effectiveMessage,
        result: result,
      ),
    );
  }

  bool _requiresRestart(MRekanPicContactChangeResult result) {
    if (result.statusId == MRekanPicContactChangeStatus.expired ||
        result.statusId == MRekanPicContactChangeStatus.cancelled) {
      return true;
    }

    final message = result.effectiveMessage.toLowerCase();
    return message.contains('kedaluwarsa') ||
        message.contains('tidak berlaku') ||
        message.contains('sudah tidak aktif');
  }

  void _onClear(
    MRekanPicContactChangeClearRequested event,
    Emitter<MRekanPicContactChangeState> emit,
  ) {
    emit(const MRekanPicContactChangeState());
  }
}
