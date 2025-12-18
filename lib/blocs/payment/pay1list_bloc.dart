import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/pay1list_model.dart';
import 'package:joss_app/repositories/payment/pay1list_repository.dart';

part 'pay1list_event.dart';
part 'pay1list_state.dart';

class Pay1ListBloc extends Bloc<Pay1ListEvents, Pay1ListState> {
	Pay1ListBloc() : super(const Pay1ListState()) {
		on<FetchPay1ListEvent>(onFetchPay1List);
		on<RefreshPay1ListEvent>(onRefreshPay1List);
		on<UbahPay1ListEvent>(onUbahPay1List);
		on<TambahPay1ListEvent>(onTambahPay1List);
		on<HapusPay1ListEvent>(onHapusPay1List);
		on<CloseDialogPay1ListEvent>(onCloseDialogPay1List);
	}

	Future<void> onRefreshPay1List(
			RefreshPay1ListEvent event, Emitter<Pay1ListState> emit) async {
		emit(const Pay1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchPay1ListEvent());
	}

	Future<void> onFetchPay1List(
			FetchPay1ListEvent event, Emitter<Pay1ListState> emit) async {
		if (state.hasReachedMax) return;

		Pay1ListRepository repo = Pay1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Pay1ListModel> items = await repo.getPay1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Pay1ListModel> items = await repo.getPay1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Pay1ListModel> pay1List = List.of(state.items)..addAll(items);

			final result = pay1List
				.whereWithIndex((e, index) =>
					pay1List.indexWhere((e2) => e2.ar1Id == e.ar1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusPay1List(
		HapusPay1ListEvent event, Emitter<Pay1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogPay1List(
		CloseDialogPay1ListEvent event, Emitter<Pay1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahPay1List(
		TambahPay1ListEvent event, Emitter<Pay1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahPay1List(
		UbahPay1ListEvent event, Emitter<Pay1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}