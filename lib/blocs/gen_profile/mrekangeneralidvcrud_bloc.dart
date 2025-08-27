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
    on<MRekanGeneralIdvCrudReloadEvent>(_onReloadMRekanGeneralIdvCrud);

  }

  Future<void> onUbahMRekanGeneralIdvCrud(
      MRekanGeneralIdvCrudUbahEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit,
      ) async {
    emit(state.copyWith(isSaving: true, isSaved: false));

    bool hasFailure = !await repository.mRekanGeneralIdvCrudUbah(event.record);

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      record: event.record,
    ));

    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isSaved: false));

    add(MRekanGeneralIdvCrudReloadEvent());
  }


  Future<void> onLihatMRekanGeneralIdvCrud(MRekanGeneralIdvCrudLihatEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    MRekanGeneralIdvCrudModel record =
    await repository.mRekanGeneralIdvCrudLihat();

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      comboMJnskel: record.comboMJnskel,
      comboMPekerjaan: record.comboMPekerjaan,
      record: record,));
  }

  Future<void> onComboMPekerjaanChanged(ComboMPekerjaanChangedEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit) async {
    ComboMPekerjaanModel comboMPekerjaan = event.comboMPekerjaan;
    emit(state.copyWith(comboMPekerjaan: comboMPekerjaan));
  }

  Future<void> onComboMJnskelChangedEvent(ComboMJnskelChangedEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit) async {
    ComboMJnskelModel comboMJnskel = event.comboMJnskel;
    emit(state.copyWith(comboMJnskel: comboMJnskel));
  }

  Future<void> _onReloadMRekanGeneralIdvCrud(
      MRekanGeneralIdvCrudReloadEvent event,
      Emitter<MRekanGeneralIdvCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    final record = await repository.mRekanGeneralIdvCrudLihat();

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      comboMJnskel: record.comboMJnskel,
      comboMPekerjaan: record.comboMPekerjaan,
    ));
  }

}
