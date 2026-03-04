//generate from : usp_flutter_crud_bloc

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/klaimbatal/klaimbatalcrud_model.dart';
import 'package:joss_app/repositories/klaimbatal/klaimbatalcrud_repository.dart';

part 'klaimbatalcrud_event.dart';
part 'klaimbatalcrud_state.dart';

class KlaimbatalcrudBloc extends Bloc<KlaimbatalcrudEvents, KlaimbatalcrudState> {
	final KlaimbatalcrudRepository repository;
	KlaimbatalcrudBloc({required this.repository}) : super(const KlaimbatalcrudState()) {
		on<KlaimbatalcrudUbahEvent>(onUbahKlaimbatalcrud);
	}

	Future<void> onUbahKlaimbatalcrud(
		KlaimbatalcrudUbahEvent event, Emitter<KlaimbatalcrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.klaimbatalcrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

}