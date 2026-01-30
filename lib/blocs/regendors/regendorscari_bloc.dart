import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regendors/regendorscari_model.dart';
import 'package:joss_app/repositories/regendors/regendorscari_repository.dart';

part 'regendorscari_event.dart';
part 'regendorscari_state.dart';

class RegendorsCariBloc extends Bloc<RegendorsCariEvents, RegendorsCariState> {
	RegendorsCariBloc() : super(const RegendorsCariState()) {
		on<FetchRegendorsCariEvent>(onFetchRegendorsCari);
		on<RefreshRegendorsCariEvent>(onRefreshRegendorsCari);
	}

Future<void> onRefreshRegendorsCari(
		RefreshRegendorsCariEvent event, Emitter<RegendorsCariState> emit) async {
	emit(const RegendorsCariState());
  emit(state.copyWith(searchText: event.searchText));
	add(FetchRegendorsCariEvent());
}

Future<void> onFetchRegendorsCari(
		FetchRegendorsCariEvent event, Emitter<RegendorsCariState> emit) async {
	if (state.hasReachedMax) return;

	RegendorsCariRepository repo = RegendorsCariRepository();
	if (state.status == ListStatus.initial) {
		List<RegendorsCariModel> items = await repo.getRegendorsCari(state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<RegendorsCariModel> items = await repo.getRegendorsCari(state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<RegendorsCariModel> regendorsCari = List.of(state.items)..addAll(items);

		final result = regendorsCari
			.whereWithIndex((e, index) =>
				regendorsCari.indexWhere((e2) => e2.regendors1Id == e.regendors1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1));
		}

	}
}