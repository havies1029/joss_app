import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/repositories/notifevent/notif_email_setting_repository.dart';

part 'notif_email_setting_event.dart';
part 'notif_email_setting_state.dart';

class NotifEmailSettingBloc
    extends Bloc<NotifEmailSettingEvent, NotifEmailSettingState> {
  final NotifEmailSettingRepository repository;
  bool _isUpdateInFlight = false;
  bool _confirmedNotifEmail = true;
  bool? _queuedNotifEmail;

  NotifEmailSettingBloc({NotifEmailSettingRepository? repository})
      : repository = repository ?? NotifEmailSettingRepository(),
        super(const NotifEmailSettingState()) {
    on<NotifEmailSettingLihatEvent>(_onLihat);
    on<NotifEmailSettingUbahEvent>(_onUbah);
  }

  Future<void> _onLihat(
    NotifEmailSettingLihatEvent event,
    Emitter<NotifEmailSettingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasFailure: false));

    try {
      final record = await repository.read();
      _confirmedNotifEmail = record.isNotifEmail;

      emit(
        state.copyWith(
          isLoading: false,
          isNotifEmail: record.isNotifEmail,
          hasLoaded: true,
          message: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          hasFailure: true,
          message: "Gagal memuat pengaturan email notifikasi.",
        ),
      );
    }
  }

  Future<void> _onUbah(
    NotifEmailSettingUbahEvent event,
    Emitter<NotifEmailSettingState> emit,
  ) async {
    if (_isUpdateInFlight) {
      _queuedNotifEmail = event.isNotifEmail;

      emit(
        state.copyWith(
          isNotifEmail: event.isNotifEmail,
          isSaving: true,
          isSaved: false,
          hasFailure: false,
          message: '',
        ),
      );
      return;
    }

    _isUpdateInFlight = true;
    var targetValue = event.isNotifEmail;

    try {
      while (true) {
        final previousValue = _confirmedNotifEmail;

        emit(
          state.copyWith(
            isNotifEmail: targetValue,
            isSaving: true,
            isSaved: false,
            hasFailure: false,
            message: '',
          ),
        );

        bool success;
        try {
          success = await repository.update(targetValue);
        } catch (_) {
          success = false;
        }

        if (!success) {
          _queuedNotifEmail = null;

          emit(
            state.copyWith(
              isSaving: false,
              isSaved: false,
              hasFailure: true,
              isNotifEmail: previousValue,
              message: "Gagal menyimpan pengaturan email notifikasi.",
            ),
          );
          return;
        }

        _confirmedNotifEmail = targetValue;

        final queuedValue = _queuedNotifEmail;
        _queuedNotifEmail = null;

        if (queuedValue == null || queuedValue == _confirmedNotifEmail) {
          emit(
            state.copyWith(
              isSaving: false,
              isSaved: true,
              hasFailure: false,
              isNotifEmail: _confirmedNotifEmail,
              message: '',
            ),
          );
          return;
        }

        targetValue = queuedValue;
      }
    } finally {
      _isUpdateInFlight = false;
    }
  }
}
