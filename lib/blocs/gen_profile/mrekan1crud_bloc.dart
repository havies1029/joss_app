import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekan1crud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekan1crud_repository.dart';

part 'mrekan1crud_event.dart';
part 'mrekan1crud_state.dart';

class MRekan1CrudBloc extends Bloc<MRekan1CrudEvents, MRekan1CrudState> {
  final MRekan1CrudRepository repository;
  MRekan1CrudBloc({required this.repository})
      : super(const MRekan1CrudState()) {
    on<MRekan1CrudLihatEvent>(onLihatMRekan1Crud);
    on<MRekan1CrudResetEvent>((event, emit) {
      emit(const MRekan1CrudState());
    });
    on<MRekan1CrudSetujuTCEvent>(onSetujuTC);
    on<SetDataGroup1>(onSetDataGroup1);
    on<MRekan1CrudReloadEvent>(_onReloadMRekan1Crud);
  }

  Future<void> onLihatMRekan1Crud(
    MRekan1CrudLihatEvent event,
    Emitter<MRekan1CrudState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isLoaded: false,
      clearRecord: true,
    ));

    final record = await repository.mRekan1CrudLihat();

    final newState = state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      isSetujuTC: record.isSetujuTC,
    );

    emit(newState);
  }

  Future<void> onSetujuTC(
      MRekan1CrudSetujuTCEvent event, Emitter<MRekan1CrudState> emit) async {
    emit(state.copyWith(isSetujuTC: false));
    bool success = await repository.mRekan1SetujuTC(event.mrekanId);
    emit(state.copyWith(isSetujuTC: success));
  }

  Future<void> onSetDataGroup1(
      SetDataGroup1 event, Emitter<MRekan1CrudState> emit) async {
    emit(state.copyWith(isDataGroup1Changed: false));
    emit(state.copyWith(isDataGroup1Changed: true, record: event.record));
  }

  Future<void> _onReloadMRekan1Crud(
    MRekan1CrudReloadEvent event,
    Emitter<MRekan1CrudState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    final record = await repository.mRekan1CrudLihat();
    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      isSetujuTC: record.isSetujuTC,
    ));
  }
}
