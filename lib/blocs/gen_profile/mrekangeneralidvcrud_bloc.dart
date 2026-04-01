import 'package:joss_app/models/combobox/combomjnskel_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvcrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralidvcrud_repository.dart';

part 'mrekangeneralidvcrud_event.dart';
part 'mrekangeneralidvcrud_state.dart';

class MRekanGeneralIdvCrudBloc
    extends Bloc<MRekanGeneralIdvCrudEvents, MRekanGeneralIdvCrudState> {
  final MRekanGeneralIdvCrudRepository repository;

  MRekanGeneralIdvCrudBloc({required this.repository})
      : super(const MRekanGeneralIdvCrudState()) {
    on<MRekanGeneralIdvCrudUbahEvent>(onUbahMRekanGeneralIdvCrud);
    on<MRekanGeneralIdvCrudLihatEvent>(onLihatMRekanGeneralIdvCrud);
    on<ComboMPekerjaanChangedEvent>(onComboMPekerjaanChanged);
    on<ComboMJnskelChangedEvent>(onComboMJnskelChangedEvent);
    on<MRekanGeneralIdvCrudResetStatusEvent>((event, emit) {
      emit(state.copyWith(
        isSaved: false,
        hasFailure: false,
      ));
    });
  }

  Future<void> onUbahMRekanGeneralIdvCrud(
      MRekanGeneralIdvCrudUbahEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit,
      ) async {
    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      hasFailure: false,
    ));

    final bool result = await repository.mRekanGeneralIdvCrudUbah(event.record);
    final bool hasFailure = !result;

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      record: hasFailure ? state.record : event.record,
      comboMPekerjaan:
      hasFailure ? state.comboMPekerjaan : event.record.comboMPekerjaan,
      comboMJnskel:
      hasFailure ? state.comboMJnskel : event.record.comboMJnskel,
    ));
  }

  Future<void> onLihatMRekanGeneralIdvCrud(
      MRekanGeneralIdvCrudLihatEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      isLoaded: false,
      record: null,
      isDataComplete: false,
    ));

    try {
      final MRekanGeneralIdvCrudModel record =
      await repository.mRekanGeneralIdvCrudLihat();

      final isComplete =
          record.rekanNama.trim().isNotEmpty &&
              (record.mpekerjaanId?.trim().isNotEmpty ?? false) &&
              (record.mjnskelId?.trim().isNotEmpty ?? false);

      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        comboMJnskel: record.comboMJnskel,
        comboMPekerjaan: record.comboMPekerjaan,
        record: record,
        isDataComplete: isComplete,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        record: null,
        comboMJnskel: null,
        comboMPekerjaan: null,
        isDataComplete: false,
      ));
    }
  }

  Future<void> onComboMPekerjaanChanged(
      ComboMPekerjaanChangedEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit,
      ) async {
    emit(state.copyWith(
      comboMPekerjaan: event.comboMPekerjaan,
    ));
  }

  Future<void> onComboMJnskelChangedEvent(
      ComboMJnskelChangedEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit,
      ) async {
    emit(state.copyWith(
      comboMJnskel: event.comboMJnskel,
    ));
  }
}