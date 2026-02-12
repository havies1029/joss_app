import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_calmv/calmv1list_model.dart';
import 'package:joss_app/repositories/gen_calmv/calmv1list_repository.dart';

part 'calmv1list_event.dart';
part 'calmv1list_state.dart';

class Calmv1ListBloc extends Bloc<Calmv1ListEvents, Calmv1ListState> {
	Calmv1ListBloc() : super(const Calmv1ListState()) {
		on<FetchCalmv1ListEvent>(onFetchCalmv1List);
		on<RefreshCalmv1ListEvent>(onRefreshCalmv1List);
		on<UbahCalmv1ListEvent>(onUbahCalmv1List);
		on<TambahCalmv1ListEvent>(onTambahCalmv1List);
		on<HapusCalmv1ListEvent>(onHapusCalmv1List);
		on<CloseDialogCalmv1ListEvent>(onCloseDialogCalmv1List);
		on<CalMv2RegMvEvent>(onCalMv2RegMv);
		on<ClearProcessMessageEvent>(onClearProcessMessage);
	}

	Future<void> onClearProcessMessage(
			ClearProcessMessageEvent event,
			Emitter<Calmv1ListState> emit,
			) async {
		emit(state.copyWith(
			processMessage: "",
			isProcessed: false,
			hasFailure: false,
		));
	}

	Future<void> onRefreshCalmv1List(
			RefreshCalmv1ListEvent event, Emitter<Calmv1ListState> emit) async {
		emit(const Calmv1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchCalmv1ListEvent());
	}

	Future<void> onFetchCalmv1List(
			FetchCalmv1ListEvent event, Emitter<Calmv1ListState> emit) async {
		if (state.hasReachedMax) return;

		Calmv1ListRepository repo = Calmv1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Calmv1ListModel> items = await repo.getCalmv1List(state.searchText, 0);
			return emit(state.copyWith(
					items: items,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: 1));
		}
		List<Calmv1ListModel> items = await repo.getCalmv1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Calmv1ListModel> calmv1List = List.of(state.items)..addAll(items);

			final result = calmv1List
					.whereWithIndex((e, index) =>
			calmv1List.indexWhere((e2) => e2.calmv1Id == e.calmv1Id) ==
					index)
					.toList();

			return emit(state.copyWith(
					items: result,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: state.hal + 1));
		}
	}

	Future<void> onHapusCalmv1List(
			HapusCalmv1ListEvent event, Emitter<Calmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogCalmv1List(
			CloseDialogCalmv1ListEvent event, Emitter<Calmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahCalmv1List(
			TambahCalmv1ListEvent event, Emitter<Calmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahCalmv1List(
			UbahCalmv1ListEvent event, Emitter<Calmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

	Future<void> onCalMv2RegMv(
			CalMv2RegMvEvent event, Emitter<Calmv1ListState> emit) async {
		if (state.isProcessing) return;
		emit(state.copyWith(
			isProcessing: true,
			isProcessed: false,
			hasFailure: false,
			processMessage: "",
		));


		Calmv1ListRepository repo = Calmv1ListRepository();
		final result = await repo.calmv2Regmv(event.calmv1Id);


		emit(state.copyWith(
			isProcessing: false,
			isProcessed: true,
			hasFailure: !result.success,
			processMessage: result.data.toString(),
		));
	}


}