import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/calpar/calpar1list_model.dart';
import 'package:joss_app/repositories/calpar/calpar1list_repository.dart';

part 'calpar1list_event.dart';
part 'calpar1list_state.dart';

class Calpar1ListBloc extends Bloc<Calpar1ListEvents, Calpar1ListState> {
	Calpar1ListBloc() : super(const Calpar1ListState()) {
		on<FetchCalpar1ListEvent>(onFetchCalpar1List);
		on<RefreshCalpar1ListEvent>(onRefreshCalpar1List);
		on<UbahCalpar1ListEvent>(onUbahCalpar1List);
		on<TambahCalpar1ListEvent>(onTambahCalpar1List);
		on<HapusCalpar1ListEvent>(onHapusCalpar1List);
		on<CloseDialogCalpar1ListEvent>(onCloseDialogCalpar1List);
		on<CalPar2RegParEvent>(onCalPar2RegPar);
		on<ClearProcessMessageEvent>(onClearProcessMessage);
	}

	Future<void> onClearProcessMessage(
			ClearProcessMessageEvent event,
			Emitter<Calpar1ListState> emit,
			) async {
		emit(state.copyWith(
			processMessage: "",
			isProcessed: false,
			hasFailure: false,
		));
	}

	Future<void> onRefreshCalpar1List(
			RefreshCalpar1ListEvent event, Emitter<Calpar1ListState> emit) async {
		emit(const Calpar1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchCalpar1ListEvent());
	}

	Future<void> onFetchCalpar1List(
			FetchCalpar1ListEvent event, Emitter<Calpar1ListState> emit) async {
		if (state.hasReachedMax) return;

		Calpar1ListRepository repo = Calpar1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Calpar1ListModel> items = await repo.getCalpar1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Calpar1ListModel> items = await repo.getCalpar1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Calpar1ListModel> calpar1List = List.of(state.items)..addAll(items);

			final result = calpar1List
				.whereWithIndex((e, index) =>
					calpar1List.indexWhere((e2) => e2.calpar1Id == e.calpar1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusCalpar1List(
		HapusCalpar1ListEvent event, Emitter<Calpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogCalpar1List(
		CloseDialogCalpar1ListEvent event, Emitter<Calpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahCalpar1List(
		TambahCalpar1ListEvent event, Emitter<Calpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahCalpar1List(
		UbahCalpar1ListEvent event, Emitter<Calpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

	Future<void> onCalPar2RegPar(
			CalPar2RegParEvent event,
			Emitter<Calpar1ListState> emit,
			) async {
		if (state.isProcessing) return; // ✅ anti double trigger

		emit(state.copyWith(
			isProcessing: true,
			isProcessed: false,
			hasFailure: false,
			processMessage: "", // ✅ reset dulu biar listener gak ketarik nilai lama
		));

		Calpar1ListRepository repo = Calpar1ListRepository();
		final result = await repo.calpar2Regpar(event.calpar1Id);

		emit(state.copyWith(
			isProcessing: false,
			isProcessed: true,
			hasFailure: !result.success,
			processMessage: result.data.toString(),
		));
	}



}