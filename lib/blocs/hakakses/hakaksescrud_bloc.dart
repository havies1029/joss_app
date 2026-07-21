import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/hakakses/hakaksescrud_model.dart';
import 'package:joss_app/repositories/hakakses/hakaksescrud_repository.dart';

part 'hakaksescrud_event.dart';
part 'hakaksescrud_state.dart';

class HakaksesCrudBloc extends Bloc<HakaksesCrudEvents, HakaksesCrudState> {
  final HakaksesCrudRepository repository;

  HakaksesCrudBloc({required this.repository})
      : super(const HakaksesCrudState()) {
    on<HakaksesCrudLihatEvent>(onLihatHakaksesCrud);
  }

  Future<void> onLihatHakaksesCrud(
    HakaksesCrudLihatEvent event,
    Emitter<HakaksesCrudState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isLoaded: false, hasFailure: false));

    try {
      final record = await repository.hakaksesCrudLihat();
      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          hasFailure: false,
          record: record,
        ),
      );
    } catch (e) {
      debugPrint('HakaksesCrudLihatEvent failed: $e');
      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: false,
          hasFailure: true,
        ),
      );
    }
  }
}
