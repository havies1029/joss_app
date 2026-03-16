import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiccrud_repository.dart';


part 'mrekanpiccrud_event.dart';
part 'mrekanpiccrud_state.dart';

class MRekanPicCrudBloc extends Bloc<MRekanPicCrudEvents, MRekanPicCrudState> {
  final MRekanPicCrudRepository repository;
  MRekanPicCrudBloc({required this.repository})
      : super(const MRekanPicCrudState()) {
    on<MRekanPicCrudUbahEvent>(onUbahMRekanPicCrud);
    on<MRekanPicCrudTambahEvent>(onTambahMRekanPicCrud);
    on<MRekanPicCrudHapusEvent>(onHapusMRekanPicCrud);
    on<MRekanPicCrudLihatEvent>(onLihatMRekanPicCrud);
    on<ComboMJabatanChangedEvent>(onComboMJabatanChanged);
    on<CheckboxIsDefaultChangedEvent>(onCheckboxIsDefaultChangedEvent);
    on<MRekanPicCrudResetEvent>((event, emit) {
      emit(state.copyWith(isSaved: false));
    });

  }

  Future<void> onTambahMRekanPicCrud(
      MRekanPicCrudTambahEvent event,
      Emitter<MRekanPicCrudState> emit,
      ) async {
    emit(
      state.copyWith(
        isSaving: true,
        isSaved: false,
        hasFailure: false,
        savedId: null,
      ),
    );

    try {
      final returnData = await repository.mRekanPicCrudTambah(event.record);

      emit(
        state.copyWith(
          isSaving: false,
          isSaved: returnData.success,
          hasFailure: !returnData.success,
          savedId: returnData.success ? returnData.data.toString() : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          isSaved: false,
          hasFailure: true,
          savedId: null,
        ),
      );
    }
  }



  Future<void> onUbahMRekanPicCrud(
      MRekanPicCrudUbahEvent event,
      Emitter<MRekanPicCrudState> emit,
      ) async {
    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      hasFailure: false,
    ));

    try {
      final result = await repository.mRekanPicCrudUbah(event.record);

      emit(state.copyWith(
        isSaving: false,
        isSaved: result,
        hasFailure: !result,
      ));

      if (result) {
        debugPrint('[✅ Bloc] Data berhasil diubah dan disimpan');
      } else {
        debugPrint('[❌ Bloc] Gagal menyimpan perubahan');
      }
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        isSaved: false,
        hasFailure: true,
      ));
    }
  }

  Future<void> onHapusMRekanPicCrud(
      MRekanPicCrudHapusEvent event, Emitter<MRekanPicCrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.mRekanPicCrudHapus(event.recordId);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatMRekanPicCrud(
      MRekanPicCrudLihatEvent event,
      Emitter<MRekanPicCrudState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      isLoaded: false,
      isSaved: false,
      hasFailure: false,
    ));

    final record = await repository.mRekanPicCrudLihat(event.recordId);

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      isSaved: false,
      hasFailure: false,
      record: record,
      comboMJabatan: record.comboMJabatan,
    ));
  }

  Future<void> onComboMJabatanChanged(
      ComboMJabatanChangedEvent event, Emitter<MRekanPicCrudState> emit) async {

    ComboMJabatanModel comboMJabatan = event.comboMJabatan;
    emit(state.copyWith(comboMJabatan: comboMJabatan));
  }

  Future<void> onCheckboxIsDefaultChangedEvent(
      CheckboxIsDefaultChangedEvent event,
      Emitter<MRekanPicCrudState> emit) async {

    debugPrint("onCheckboxIsDefaultChangedEvent");

    emit(state.copyWith(isFieldIsDefaultChanged: false));

    MRekanPicCrudModel? record = state.record ?? MRekanPicCrudModel();
    record.isDefault = event.isChecked;

    emit(state.copyWith(isFieldIsDefaultChanged: true, record: record));
  }
}
