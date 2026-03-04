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
  }

  Future<void> onUbahMRekanGeneralCmpCrud(MRekanGeneralCmpCrudUbahEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.mRekanGeneralCmpCrudUbah(event.record);
    emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: hasFailure,
        record: event.record));
  }

  Future<void> onLihatMRekanGeneralCmpCrud(MRekanGeneralCmpCrudLihatEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    MRekanGeneralCmpCrudModel record =
        await repository.mRekanGeneralCmpCrudLihat();

    ComboMBentukCstModel? comboBentuk = record.comboMBentukCst;

    ComboMBidangModel? comboBidang = record.comboMBidang;

    emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        record: record,
        comboMBentukCst: comboBentuk,
        comboMBidang: comboBidang));
  }

  Future<void> onComboMBentukCstChanged(ComboMBentukCstChangedEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit) async {

    ComboMBentukCstModel comboMBentukCst = event.comboMBentukCst;
    emit(state.copyWith(comboMBentukCst: comboMBentukCst));
  }

  Future<void> onComboMBidangChanged(ComboMBidangChangedEvent event,
      Emitter<MRekanGeneralCmpCrudState> emit) async {

    ComboMBidangModel comboMBidang = event.comboMBidang;
    emit(state.copyWith(comboMBidang: comboMBidang));
  }
}
