//generate from : usp_flutter_crud_bloc

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/dashboard/sumdash_model.dart';
import 'package:joss_app/repositories/dashboard/sumdash_repository.dart';

part 'sumdash_event.dart';
part 'sumdash_state.dart';

class SumdashBloc extends Bloc<SumdashEvents, SumdashState> {
  final SumdashRepository repository;
  SumdashBloc({required this.repository}) : super(const SumdashState()) {
    on<SumdashLihatEvent>(onLihatSumdash);
  }

  Future<void> onLihatSumdash(
      SumdashLihatEvent event, Emitter<SumdashState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    SumdashModel? record = await repository.sumdashLihat();
    emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
  }

}