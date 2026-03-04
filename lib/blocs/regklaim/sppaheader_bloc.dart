import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/regklaim/sppaheader_model.dart';
import 'package:joss_app/repositories/regklaim/sppaheader_repository.dart';

part 'sppaheader_event.dart';
part 'sppaheader_state.dart';

class SppaHeaderBloc extends Bloc<SppaHeaderEvents, SppaHeaderState> {
	final SppaHeaderRepository repository;
	SppaHeaderBloc({required this.repository}) : super(const SppaHeaderState()) {
		on<SppaHeaderLihatEvent>(onLihatSppaHeader);
	}

	Future<void> onLihatSppaHeader(
		SppaHeaderLihatEvent event, Emitter<SppaHeaderState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		SppaHeaderModel record = await repository.sppaHeaderLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}
}