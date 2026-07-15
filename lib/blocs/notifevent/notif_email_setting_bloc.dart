import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/repositories/notifevent/notif_email_setting_repository.dart';

part 'notif_email_setting_event.dart';
part 'notif_email_setting_state.dart';

class NotifEmailSettingBloc
    extends Bloc<NotifEmailSettingEvent, NotifEmailSettingState> {
  final NotifEmailSettingRepository repository;

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
    final previousValue = state.isNotifEmail;

    emit(
      state.copyWith(
        isNotifEmail: event.isNotifEmail,
        isSaving: true,
        hasFailure: false,
        isSaved: false,
        message: '',
      ),
    );

    try {
      final success = await repository.update(event.isNotifEmail);

      emit(
        state.copyWith(
          isSaving: false,
          isSaved: success,
          hasFailure: !success,
          isNotifEmail: success ? event.isNotifEmail : previousValue,
          message: success
              ? "Email Notifikasi ${event.isNotifEmail ? 'diaktifkan' : 'dinonaktifkan'}"
              : "Gagal menyimpan pengaturan email notifikasi.",
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSaving: false,
          hasFailure: true,
          isNotifEmail: previousValue,
          message: "Gagal menyimpan pengaturan email notifikasi.",
        ),
      );
    }
  }
}
