import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmpcrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralcmpcrud_repository.dart';

part 'mrekangeneralcmpcrud_event.dart';
part 'mrekangeneralcmpcrud_state.dart';

class MRekanGeneralCmpCrudBloc
    extends Bloc<MRekanGeneralCmpCrudEvents, MRekanGeneralCmpCrudState> {
  final MRekanGeneralCmpCrudRepository repository;

  MRekanGeneralCmpCrudBloc({required this.repository})
      : super(const MRekanGeneralCmpCrudState()) {
    on<MRekanGeneralCmpCrudUbahEvent>(onUbahMRekanGeneralCmpCrud);
    on<MRekanGeneralCmpCrudLihatEvent>(onLihatMRekanGeneralCmpCrud);
    on<ComboMBentukCstChangedEvent>(onComboMBentukCstChanged);
    on<ComboMBidangChangedEvent>(onComboMBidangChanged);
    on<MRekanGeneralCmpCrudResetStatusEvent>((event, emit) {
      emit(state.copyWith(
        isSaved: false,
        hasFailure: false,
      ));
    });
  }

  Future<void> onUbahMRekanGeneralCmpCrud(
      MRekanGeneralCmpCrudUbahEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit,
      ) async {
    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      hasFailure: false,
    ));

    final bool result = await repository.mRekanGeneralCmpCrudUbah(event.record);
    final bool hasFailure = !result;

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      record: hasFailure ? state.record : event.record,
      comboMBentukCst:
      hasFailure ? state.comboMBentukCst : event.record.comboMBentukCst,
      comboMBidang:
      hasFailure ? state.comboMBidang : event.record.comboMBidang,
    ));
  }

  Future<void> onLihatMRekanGeneralCmpCrud(
      MRekanGeneralCmpCrudLihatEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      isLoaded: false,
      record: null,
    ));

    try {
      final MRekanGeneralCmpCrudModel record =
      await repository.mRekanGeneralCmpCrudLihat();

      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        record: record,
        comboMBentukCst: record.comboMBentukCst,
        comboMBidang: record.comboMBidang,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        record: null,
        comboMBentukCst: null,
        comboMBidang: null,
      ));
    }
  }

  Future<void> onComboMBentukCstChanged(
      ComboMBentukCstChangedEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit,
      ) async {
    emit(state.copyWith(
      comboMBentukCst: event.comboMBentukCst,
    ));
  }

  Future<void> onComboMBidangChanged(
      ComboMBidangChangedEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit,
      ) async {
    emit(state.copyWith(
      comboMBidang: event.comboMBidang,
    ));
  }
}