import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/payment/mstsgroupinvcari_model.dart';
import 'package:joss_app/repositories/payment/mstsgroupinvcari_repository.dart';

part 'mstsgroupinvcari_event.dart';
part 'mstsgroupinvcari_state.dart';

class MstsgroupinvCariBloc extends Bloc<MstsgroupinvCariEvents, MstsgroupinvCariState> {
	MstsgroupinvCariBloc() : super(const MstsgroupinvCariState()) {
		on<FetchMstsgroupinvCariEvent>(onFetchMstsgroupinvCari);
		on<RefreshMstsgroupinvCariEvent>(onRefreshMstsgroupinvCari);
	}

Future<void> onRefreshMstsgroupinvCari(
		RefreshMstsgroupinvCariEvent event, Emitter<MstsgroupinvCariState> emit) async {
	emit(const MstsgroupinvCariState());

	add(FetchMstsgroupinvCariEvent());
}

Future<void> onFetchMstsgroupinvCari(
		FetchMstsgroupinvCariEvent event, Emitter<MstsgroupinvCariState> emit) async {
	if (state.hasReachedMax) return;

	MstsgroupinvCariRepository repo = MstsgroupinvCariRepository();
	if (state.status == ListStatus.initial) {
		List<MstsgroupinvCariModel> items = await repo.getMstsgroupinvCari();
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			));
	}
	List<MstsgroupinvCariModel> items = await repo.getMstsgroupinvCari();
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<MstsgroupinvCariModel> mstsgroupinvCari = List.of(state.items)..addAll(items);

		final result = mstsgroupinvCari
			.whereWithIndex((e, index) =>
				mstsgroupinvCari.indexWhere((e2) => e2.mstsgroupinv1Id == e.mstsgroupinv1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			));
		}

	}
}