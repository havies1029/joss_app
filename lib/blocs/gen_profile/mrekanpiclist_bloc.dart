import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_profile/mrekanpiclist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';

part 'mrekanpiclist_event.dart';
part 'mrekanpiclist_state.dart';

class MRekanPicListBloc extends Bloc<MRekanPicListEvents, MRekanPicListState> {
	final MRekanPicListRepository repository;

	MRekanPicListBloc({required this.repository})
			: super(const MRekanPicListState()) {
		on<FetchMRekanPicListEvent>(_onFetch);
		on<RefreshMRekanPicListEvent>(_onRefresh);
	}

	Future<void> _onFetch(
			FetchMRekanPicListEvent event,
			Emitter<MRekanPicListState> emit,
			) async {
		emit(state.copyWith(
			status: ListStatus.loadingMore,
			errorMessage: '',
		));

		try {
			final items = await repository.getMRekanPicList();

			emit(state.copyWith(
				status: ListStatus.success,
				items: items,
				errorMessage: '',
			));
		} catch (e) {
			emit(state.copyWith(
				status: ListStatus.failure,
				errorMessage: e.toString(),
			));
		}
	}

	Future<void> _onRefresh(
			RefreshMRekanPicListEvent event,
			Emitter<MRekanPicListState> emit,
			) async {
		add(FetchMRekanPicListEvent());
	}
}